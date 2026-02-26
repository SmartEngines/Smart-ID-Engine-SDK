/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import "SmartIDCameraManager.h"

#import <UIKit/UIKit.h>

@interface SmartIDCameraManager ()

@property (nonatomic) AVCaptureDevice* captureDevice;
@property (nonatomic) AVCaptureDeviceInput* captureDeviceInput;
@property (nonatomic) AVCaptureSession* captureSession;
@property (nonatomic) CGFloat zoomState;

@end

@implementation SmartIDCameraManager

- (instancetype)init {
  return [self initWithCaptureDevicePosition:AVCaptureDevicePositionBack
                              WithBestDevice:NO
                              WithLockCamera:NO
                              WithCameraMode:CMVideo];
}

- (instancetype)initWithCaptureDevicePosition:(AVCaptureDevicePosition)position
                               WithBestDevice:(BOOL)bestDevice
                               WithLockCamera:(BOOL)lockCamera
                               WithCameraMode:(CameraMode)cameraMode {
  if (self = [super init]) {
    _position = position;
    _bestCameraDevice = bestDevice;
    _lockCamera = lockCamera;
    _cameraMode = cameraMode;
    [self configureVideoCaptureWithPosition];
  }
  return self;
}

- (void) configureVideoCaptureWithPosition {
  
  [self updateCaptureDeviceWithPosition];
  
  // capture video data output
  self.captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
  self.captureVideoDataOutput.videoSettings =
  @{(NSString*)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
  self.captureVideoDataOutput.alwaysDiscardsLateVideoFrames = YES;
  
  // capture photo data output
  self.capturePhotoOutput = [[AVCapturePhotoOutput alloc] init];
  
  // capture device input
  self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice
                                                                  error:nil];
  
  // capture session
  self.captureSession = [[AVCaptureSession alloc] init];
//  [self updateCaptureSessionPreset];
//  [self changeSessionPreset:AVCaptureSessionPresetHigh];
  
  if ([self.captureSession canAddInput:self.captureDeviceInput]) {
    [self.captureSession addInput:self.captureDeviceInput];
  }
  
  // adding outputs to capture session
  if ([self.captureSession canAddOutput:self.captureVideoDataOutput]) {
    [self.captureSession addOutput:self.captureVideoDataOutput];
  } else {
    NSLog(@"Could not add video output to the session");
  }
  
  if ([self.captureSession canAddOutput:self.capturePhotoOutput]) {
    [self.captureSession addOutput:self.capturePhotoOutput];
  } else {
    NSLog(@"Could not add photo output to the session");
  }
}

- (void) updateCaptureDeviceWithPosition {
  // capture device
  NSArray* captureDevices;
  AVCaptureDeviceDiscoverySession* captureDeviceDiscoverySession;
  if (_bestCameraDevice) {
    captureDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[
      AVCaptureDeviceTypeBuiltInTripleCamera,
      AVCaptureDeviceTypeBuiltInDualWideCamera,
      AVCaptureDeviceTypeBuiltInDualCamera,
      AVCaptureDeviceTypeBuiltInUltraWideCamera,
      AVCaptureDeviceTypeBuiltInWideAngleCamera]
                                                                                           mediaType:AVMediaTypeVideo position:_position];
  } else {
    captureDeviceDiscoverySession =
    [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
                                                           mediaType:AVMediaTypeVideo
                                                            position:_position];
  }
  
  captureDevices = [captureDeviceDiscoverySession devices];
  
  if (captureDevices.count != 0) {
    for (AVCaptureDevice* device in captureDevices) {
      if (device.position == _position) {
        self.captureDevice = device;
        NSLog(@"Selected device: %@: %@", device.localizedName, device.deviceType);
        break;
      }
    }
  } else {
    NSLog(@"No available back camera devices");
  }
  
  //Set switching behavior if possible
  if (!_lockCamera) {
    if ([@[AVCaptureDeviceTypeBuiltInTripleCamera,AVCaptureDeviceTypeBuiltInDualWideCamera, AVCaptureDeviceTypeBuiltInDualCamera]
         containsObject:self.captureDevice.deviceType]) {
      self.zoomState = sWide; //choose sUltrawide, sWide or sTelephoto for switching behavior
      [self.captureDevice setPrimaryConstituentDeviceSwitchingBehavior:AVCapturePrimaryConstituentDeviceSwitchingBehaviorAuto restrictedSwitchingBehaviorConditions:AVCapturePrimaryConstituentDeviceRestrictedSwitchingBehaviorConditionNone];
    }
  }
  
  if ([self.captureDevice lockForConfiguration:nil]) {
    if ([self.captureDevice isSmoothAutoFocusSupported]) {
      self.captureDevice.smoothAutoFocusEnabled = YES;
    }
    
    // Auto exposure by default
    if ([self.captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
      self.captureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    }
    
    // Remove or modify the range restriction
    if ([self.captureDevice isAutoFocusRangeRestrictionSupported]) {
      self.captureDevice.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNone;
    }
    
    // Continuous autofocus by default
    if ([self.captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
      self.captureDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    }
    
    // Enable subject area change monitoring
    self.captureDevice.subjectAreaChangeMonitoringEnabled = YES;
    
    [self.captureDevice unlockForConfiguration];
  }
}

- (CGSize) videoSize {
  return self.currentVideoSize;
}

- (void) setSampleBufferDelegate:(id<AVCaptureVideoDataOutputSampleBufferDelegate>)delegate {
  dispatch_queue_t videoQueue = dispatch_queue_create("biz.smartengines.video-queue", 0);
  [self.captureVideoDataOutput setSampleBufferDelegate:delegate
                                                 queue:videoQueue];
}

- (void) configurePreview:(SmartIDVideoPreviewView *)view {
  [view setSession:[self captureSession]];
  [[view videoPreviewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void) startCaptureSession:(BOOL)torchOn {
  dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(backgroundQueue, ^{
    [self.captureSession startRunning];
    [self setVideoZoomFactor];
    if (torchOn) [self turnTorchOnWithLevel:1.0];
  });
}

- (void) stopCaptureSession {
  [self.captureSession stopRunning];
}

- (void) focusAtPoint:(CGPoint)point
    completionHandler:(void(^)(void))completionHandler {
  AVCaptureDevice *device = self.captureDevice;
  CGPoint pointOfInterest = CGPointZero;
  CGSize frameSize = [[UIScreen mainScreen] bounds].size;
  pointOfInterest = CGPointMake(point.y / frameSize.height, 1.f - (point.x / frameSize.width));
  
    if ([device isFocusPointOfInterestSupported] &&
        [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
      
      //Lock camera for configuration if possible
      NSError* error;
      if ([device lockForConfiguration:&error]) {
        if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
          [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        [device setFocusMode:AVCaptureFocusModeAutoFocus];
        [device setFocusPointOfInterest:pointOfInterest];
        [device unlockForConfiguration];
        
      }
    } else {
      if (completionHandler) {
        completionHandler();
      }
    }
}

- (BOOL) isAdjustingFocus {
  if ([self.captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
    return [self.captureDevice isAdjustingFocus];
  }
  return NO;
}

- (void) changeSessionPreset:(AVCaptureSessionPreset)preset {
  if ([self.captureSession canSetSessionPreset:preset]) {
    [self.captureSession setSessionPreset:preset];
    if (preset == AVCaptureSessionPresetHigh) {
      self.currentVideoSize = CGSizeMake(1920, 1080);
    } else if (preset == AVCaptureSessionPresetPhoto) {
      self.currentVideoSize = CGSizeMake(4032, 3024);
    } else if (preset == AVCaptureSessionPreset3840x2160) {
      self.currentVideoSize = CGSizeMake(3840, 2160);
    }
  }
  [self setVideoZoomFactor];
}

-(void) updateSessionPreset {
  if (_cameraMode == CMVideo) {
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset3840x2160]) {
      [self changeSessionPreset:AVCaptureSessionPreset3840x2160];
    } else {
      [self changeSessionPreset:AVCaptureSessionPresetHigh];
    }
  } else {
    [self changeSessionPreset:AVCaptureSessionPresetPhoto];
  }
}

- (void) turnTorchOnWithLevel:(float)level {
  if ([self.captureDevice hasTorch] && [self.captureDevice isTorchAvailable]) {
    [self.captureDevice lockForConfiguration:nil];
    [self.captureDevice setTorchModeOnWithLevel:level error:nil];
    [self.captureDevice unlockForConfiguration];
  }
}

- (void) turnTorchOff {
  if ([self.captureDevice hasTorch]) {
    [self.captureDevice lockForConfiguration:nil];
    [self.captureDevice setTorchMode:AVCaptureTorchModeOff];
    [self.captureDevice unlockForConfiguration];
  }
}

- (BOOL) isTorchOn {
  if ([self.captureDevice hasTorch]) {
    return [self.captureDevice torchMode] == AVCaptureTorchModeOn;
  }
  return false;
}

- (AVCaptureDevice*) getCaptureDevice {
  return self.captureDevice;
}

- (void) setVideoZoomFactor {
  CGFloat videoZoomFactor = [self getVideoZoomFactor];
  [self setVideoCaptureDeviceZoom:videoZoomFactor animated:NO rate:0];
}

- (void) setVideoCaptureDeviceZoom:(CGFloat)videoZoomFactor
                          animated:(BOOL) animated
                              rate:(CGFloat) rate {
  if (self.captureDevice == nil) {
    return;
  }
  [self.captureDevice lockForConfiguration:nil];
  if (animated) {
    [self.captureDevice rampToVideoZoomFactor:videoZoomFactor withRate:rate];
  } else {
    self.captureDevice.videoZoomFactor = videoZoomFactor;
  }
  [self.captureDevice unlockForConfiguration];
}

- (CGFloat) getVideoZoomFactor {
  if (self.zoomState == sUltrawide){
    return 1;
  } else if (self.zoomState == sWide){
    return [self getWideVideoZoomFactor];
  } else {
    return [self getTelephotoVideoZoomFactor];
  }
}

- (CGFloat) getWideVideoZoomFactor {
  if (self.captureDevice.deviceType == AVCaptureDeviceTypeBuiltInTripleCamera) {
    return 2; // switch to 3 when so far
  } else if (self.captureDevice.deviceType == AVCaptureDeviceTypeBuiltInDualWideCamera) {
    return 2;
  } else {
    return 1;
  }
}

-(CGFloat) getTelephotoVideoZoomFactor {
  if (self.captureDevice.deviceType == AVCaptureDeviceTypeBuiltInTripleCamera) {
    return 3;
  } else {
    return 2;
  }
}

- (void) switchCamera {
  AVCaptureDevicePosition currentPosition = self.captureDevice.position;
  AVCaptureDevicePosition newPosition =  (currentPosition == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
  
  [self.captureSession beginConfiguration];
  AVCaptureDeviceInput *oldInput = self.captureDeviceInput;
  [self.captureSession removeInput:self.captureDeviceInput];
  
  _position = newPosition;
  [self updateCaptureDeviceWithPosition];
  
  // capture device input
  self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice
                                                                  error:nil];
  
  if ([self.captureSession canAddInput:self.captureDeviceInput]) {
    [self.captureSession addInput:self.captureDeviceInput];
    [self.captureSession commitConfiguration];
  } else {
    [self.captureSession addInput:oldInput];
  }
  
  [self setVideoZoomFactor];
}

@end

