/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIView.h>

#import "SmartIDVideoPreviewView.h"

@interface SmartIDCameraManager : NSObject

typedef enum {
  CMPhoto,
  CMVideo
} CameraMode;

@property (nonatomic, assign) AVCaptureDevicePosition position;
@property (nonatomic, assign) BOOL bestCameraDevice;
@property (nonatomic, assign) BOOL lockCamera;
@property (nonatomic, assign) CameraMode cameraMode;

@property (atomic) CGSize currentVideoSize;
@property (nonatomic, strong, nonnull) AVCaptureVideoDataOutput *captureVideoDataOutput;
@property (nonatomic, strong, nonnull) AVCapturePhotoOutput *capturePhotoOutput;

- (nonnull instancetype) initWithCaptureDevicePosition:(AVCaptureDevicePosition)position
                                        WithBestDevice:(BOOL)bestDevice
                                        WithLockCamera:(BOOL)lockCamera
                                        WithCameraMode:(CameraMode)cameraMode;

- (CGSize) videoSize;

- (void) setSampleBufferDelegate:(nonnull id<AVCaptureVideoDataOutputSampleBufferDelegate>)delegate;
- (void) configurePreview:(nonnull SmartIDVideoPreviewView *)view;

- (void) startCaptureSession:(BOOL)torchOn;
- (void) stopCaptureSession;

- (void) focusAtPoint:(CGPoint)point
    completionHandler:(nullable void(^)(void))completionHandler;
- (BOOL) isAdjustingFocus;

- (void) changeSessionPreset:(nonnull AVCaptureSessionPreset)preset;
- (void) updateSessionPreset;
//- (void) updateCaptureSessionPreset;

- (void) turnTorchOnWithLevel:(float)level;
- (void) turnTorchOff;
- (BOOL) isTorchOn;

- (void) setVideoCaptureDeviceZoom:(CGFloat)videoZoomFactor
                          animated:(BOOL) animated
                              rate:(CGFloat) rate;
- (void) switchCamera;
- (nullable AVCaptureDevice*) getCaptureDevice;

typedef enum {
  sUltrawide,
  sWide,
  sTelephoto
} ZoomState;

@end

