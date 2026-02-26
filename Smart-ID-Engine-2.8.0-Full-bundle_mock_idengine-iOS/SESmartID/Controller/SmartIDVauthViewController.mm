/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import "SmartIDVauthViewController.h"
#import "SmartIDVideoPreviewView.h"
#import "SmartIDRoiView.h"
#import "SmartIDQuadrangleView.h"
#import "SmartIDCameraManager.h"
#import "CameraFocusSquare.h"

#import <objcidengine/id_feedback.h>
#import <objcsecommon/se_geometry.h>

#define MIN_ZOOM 1.0f
#define MAX_ZOOM 10.0f

@interface SmartIDVauthViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate>

@property (nonatomic, strong) SmartIDVideoPreviewView* videoPreview;
@property (nonatomic, strong) SmartIDRoiView* roiView;
@property (nonatomic, assign) UIDeviceOrientation lastOrientation;
@property (nonatomic, assign) BOOL displayroi;
@property (nonatomic, assign) BOOL guiInitialized;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSArray *>* rois;
@property (nonatomic, assign) CGRect currentRoi;
@property (nonatomic, assign) UIDeviceOrientation defaultOrientation;

@property (nonatomic, strong) SmartIDCameraManager* camera;
@property (nonatomic, strong) SmartIDQuadrangleView* quadrangleView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
@property (nonatomic, strong) CameraFocusSquare* camFocus;
@property (nonatomic, assign) BOOL obsIsAdjustingFocus;
@property (nonatomic, strong) AVCaptureDevice* camDevice;
@property (nonatomic, assign) BOOL torchOnByDefault;
@property (nonatomic, assign) CGFloat currentZoomLevel;
@property (nonatomic, assign) CGFloat lastZoomFactor;

@property (nonatomic, weak) SmartIDEngineInstance* engineInstance;

@property (nonatomic, assign) BOOL lockOrientation;

@end

@implementation SmartIDVauthViewController {
  BOOL structureInitialized;
}

@synthesize engineInstance, camera, quadrangleView, previewLayer;

- (void) commonInitialize {
  structureInitialized = NO;
  
  self.rois = [[NSMutableDictionary alloc] init];
  
  [[self rois] setObject:@[@0, @0] forKey:@(UIDeviceOrientationPortrait)];
  [[self rois] setObject:@[@0, @0] forKey:@(UIDeviceOrientationLandscapeLeft)];
  [[self rois] setObject:@[@0, @0] forKey:@(UIDeviceOrientationLandscapeRight)];
  [[self rois] setObject:@[@0, @0] forKey:@(UIDeviceOrientationPortraitUpsideDown)];
  
  [self setQuadranglesAlpha:1.0];
  [self setQuadranglesWidth:1.5];
  [self setQuadranglesColor:[UIColor greenColor]];\
  
  self.docTypeLabel = [[UILabel alloc] init];
  self.docTypeLabel.textAlignment = NSTextAlignmentCenter;
  self.docTypeLabel.textColor = [UIColor whiteColor];
  self.docTypeLabel.translatesAutoresizingMaskIntoConstraints = false;
  self.docTypeLabel.numberOfLines = 0;
  
  self.captureButton = [[SmartIDCaptureButton alloc] init];
  [[self captureButton] setAnimationDuration:0.3];
  
  self.instructionLabel = [[UILabel alloc] init];
  self.instructionLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
  self.instructionLabel.textAlignment = NSTextAlignmentCenter;
  self.instructionLabel.textColor = [UIColor whiteColor];
  self.instructionLabel.translatesAutoresizingMaskIntoConstraints = false;
  self.instructionLabel.font=[self.instructionLabel.font fontWithSize:30];
  self.instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
  self.instructionLabel.numberOfLines = 0;
  self.instructionLabel.text = NSLocalizedString(@"press_start", "");
  
  self.camera = [[SmartIDCameraManager alloc] initWithCaptureDevicePosition:AVCaptureDevicePositionBack
                                                             WithBestDevice:self.bestCameraDevice
                                                             WithLockCamera:self.lockCamera
                                                             WithCameraMode:CMVideo];
  
  self.videoPreview = [[SmartIDVideoPreviewView alloc] init];
  self.videoPreview.backgroundColor = [UIColor blackColor];
  self.quadrangleView = [[SmartIDQuadrangleView alloc] init];
  [self.quadrangleView configureWithMode:QuadrangleAnimationModeDefault];
  self.roiView = [[SmartIDRoiView alloc] init];
  
  self.currentZoomLevel = 1.0f;
  self.lastZoomFactor = 1.0f;
  
  [[self camera] configurePreview:[self videoPreview]];
  _camDevice = [self.camera getCaptureDevice];
  
  structureInitialized = YES;
}

- (instancetype) init {
  if (self = [super init]) {
    _lockOrientation = NO;
    _torchOnByDefault = NO;
    _displayroi = NO;
    if (!structureInitialized) {
      [self commonInitialize];
    }
  }
  return self;
}

- (instancetype) initWithLockedOrientation:(BOOL)lockOrientation  {
  if (self = [super init]) {
    _lockOrientation = lockOrientation;
    _torchOnByDefault = NO;
    _bestCameraDevice = NO;
    _lockCamera = NO;
    if (!structureInitialized) {
      [self commonInitialize];
    }
  }
  return self;
}

- (instancetype) initWithLockedOrientation:(BOOL)lockOrientation WithTorch:(BOOL)torchOnByDefault  {
  if (self = [super init]) {
    _lockOrientation = lockOrientation;
    _torchOnByDefault = torchOnByDefault;
    _bestCameraDevice = NO;
    _lockCamera = NO;
    if (!structureInitialized) {
      [self commonInitialize];
    }
  }
  return self;
}

- (instancetype) initWithLockedOrientation:(BOOL)lockOrientation
                                 WithTorch:(BOOL)torchOnByDefault
                            WithBestDevice:(BOOL)bestDevice{
   if (self = [super init]) {
     _lockOrientation = lockOrientation;
     _torchOnByDefault = torchOnByDefault;
     _bestCameraDevice = bestDevice;
     _lockCamera = NO;
    if (!structureInitialized) {
      [self commonInitialize];
    }
  }
  return self;
}

- (instancetype) initWithLockedOrientation:(BOOL)lockOrientation
                                 WithTorch:(BOOL)torchOnByDefault
                            WithBestDevice:(BOOL)bestDevice
                            WithLockCamera:(BOOL)lockCamera{
   if (self = [super init]) {
     _lockOrientation = lockOrientation;
     _torchOnByDefault = torchOnByDefault;
     _bestCameraDevice = bestDevice;
     _lockCamera = lockCamera;
    if (!structureInitialized) {
      [self commonInitialize];
    }
  }
  return self;
}

- (void) attachEngineInstance:(nonnull __weak SmartIDEngineInstance *)instance {
  self.engineInstance = instance;
  __weak __typeof(self) weakSelf = self;
  [self.engineInstance setVauthDelegate:weakSelf];
}

- (void) makeLayout {
  self.videoPreview.translatesAutoresizingMaskIntoConstraints = NO;
  self.quadrangleView.translatesAutoresizingMaskIntoConstraints = NO;
  self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
  self.roiView.translatesAutoresizingMaskIntoConstraints = NO;
  self.captureButton.translatesAutoresizingMaskIntoConstraints = NO;
  self.camFocus.translatesAutoresizingMaskIntoConstraints = NO;
  self.switchCameraButton.translatesAutoresizingMaskIntoConstraints = NO;
  self.galleryButton.translatesAutoresizingMaskIntoConstraints = NO;
  self.torchButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  NSArray *videoPreviewLayout = @[[NSLayoutConstraint
                                   constraintWithItem:self.videoPreview
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.videoPreview
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.videoPreview
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeBottom
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.videoPreview
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTop
                                   multiplier:1.0f
                                   constant:0.f]
                                  ];
  
  NSArray *roiLayout = @[[NSLayoutConstraint
                                   constraintWithItem:self.roiView
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.roiView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.roiView
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeBottom
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.roiView
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTop
                                   multiplier:1.0f
                                   constant:0.f]
                                  ];
  
  NSArray *quadrangleViewLayout = @[[NSLayoutConstraint
                                   constraintWithItem:self.quadrangleView
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.quadrangleView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.quadrangleView
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeBottom
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.quadrangleView
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTop
                                   multiplier:1.0f
                                   constant:0.f]
                                  ];
  
  
  NSArray *captureButtonLayout = @[
                                  [NSLayoutConstraint
                                   constraintWithItem:self.captureButton
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeCenterX
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.captureButton
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeBottom
                                   multiplier:1.0f
                                   constant:-25.f]
                                  ];
  
  NSArray *captureButtonConstants = @[
                                     [NSLayoutConstraint
                                      constraintWithItem:self.captureButton
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1.0f
                                      constant:60.f],
                                     [NSLayoutConstraint
                                      constraintWithItem:self.captureButton
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1.0f
                                      constant:60.f]
                                     ];
  
  NSArray *cancelButtonLayout = @[[NSLayoutConstraint
                                   constraintWithItem:self.cancelButton
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:15.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.cancelButton
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTop
                                   multiplier:1.0f
                                   constant:50.f]
  ];
  
  NSArray *cancelButtonConstants = @[[NSLayoutConstraint
                                      constraintWithItem:self.cancelButton
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1.0f
                                      constant:50.f],
                                     [NSLayoutConstraint
                                      constraintWithItem:self.cancelButton
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1.0f
                                      constant:50.f]
  ];
  
  NSArray *docTypeLabelLayout = @[[NSLayoutConstraint
                                   constraintWithItem:self.docTypeLabel
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.torchButton
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.docTypeLabel
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.cancelButton
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.docTypeLabel
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTop
                                   multiplier:1.0f
                                   constant:50.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.docTypeLabel
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:1.0f
                                   constant:50.f]
                                  ];
  
  NSArray *torchButtonLayout = @[[NSLayoutConstraint
                                   constraintWithItem:self.torchButton
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:-15.f],
                                 [NSLayoutConstraint
                                  constraintWithItem:self.torchButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                                  attribute:NSLayoutAttributeTop
                                  multiplier:1.0f
                                  constant:50.f]
  ];
  
  NSArray *torchButtonConstants = @[[NSLayoutConstraint
                                       constraintWithItem:self.torchButton
                                       attribute:NSLayoutAttributeWidth
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                       attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.0f
                                       constant:50.f],
                                      [NSLayoutConstraint
                                       constraintWithItem:self.torchButton
                                       attribute:NSLayoutAttributeHeight
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                       attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.0f
                                       constant:50.f]
  ];
  
  NSArray *switchCameraButtonLayout = @[
                                  [NSLayoutConstraint
                                   constraintWithItem:self.switchCameraButton
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.captureButton
                                   attribute:NSLayoutAttributeCenterY
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.switchCameraButton
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:-50.f]
                                    ];

  NSArray *switchCameraButtonConstants = @[
                                     [NSLayoutConstraint
                                      constraintWithItem:self.switchCameraButton
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1.0f
                                      constant:50.f],
                                     [NSLayoutConstraint
                                      constraintWithItem:self.switchCameraButton
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1.0f
                                      constant:50.f]
                                      ];
#if __DEMO__
  NSArray *galleryButtonLayout = @[
                                  [NSLayoutConstraint
                                   constraintWithItem:self.galleryButton
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:50.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.galleryButton
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.captureButton
                                   attribute:NSLayoutAttributeCenterY
                                   multiplier:1.0f
                                   constant:0.f]
                                    ];

  NSArray *galleryButtonConstants = @[
                                     [NSLayoutConstraint
                                      constraintWithItem:self.galleryButton
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1.0f
                                      constant:50.f],
                                     [NSLayoutConstraint
                                      constraintWithItem:self.galleryButton
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1.0f
                                      constant:50.f]
                                     ];
#endif
  
  NSArray *instructionLabelLayout = @[[NSLayoutConstraint
                                   constraintWithItem:self.instructionLabel
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.instructionLabel
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.instructionLabel
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.docTypeLabel
                                   attribute:NSLayoutAttributeTop
                                   multiplier:1.0f
                                   constant:70.f],
                                  [NSLayoutConstraint
                                   constraintWithItem:self.instructionLabel
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:1.0f
                                   constant:100.f]
  ];

  [[self view] addConstraints:videoPreviewLayout];
  [[self view] addConstraints:quadrangleViewLayout];
  [[self view] addConstraints:cancelButtonLayout];
  [[self view] addConstraints:roiLayout];
  [[self view] addConstraints:captureButtonLayout];
  [[self view] addConstraints:docTypeLabelLayout];
  [[self view] addConstraints:torchButtonLayout];
  [[self view] addConstraints:switchCameraButtonLayout];
#if __DEMO__
  [[self view] addConstraints:galleryButtonLayout];
#endif
  [[self view] addConstraints:instructionLabelLayout];
  
  [[self captureButton] addConstraints:captureButtonConstants];
  [[self cancelButton] addConstraints:cancelButtonConstants];
  [[self torchButton] addConstraints:torchButtonConstants];
  [[self switchCameraButton] addConstraints:switchCameraButtonConstants];
#if __DEMO__
  [[self galleryButton] addConstraints:galleryButtonConstants];
#endif
}

- (void) setShouldDisplayRoi:(BOOL)shouldDisplayRoi {
  _shouldDisplayRoi = shouldDisplayRoi;
  [[self roiView] setHidden:!_shouldDisplayRoi];
}
        
- (void) viewDidLoad {
  [super viewDidLoad];
  __weak __typeof(self) weakSelf = self;
  [[self camera] setSampleBufferDelegate:weakSelf];
  if (!_lockOrientation){
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(rotated:)
                                                   name:UIDeviceOrientationDidChangeNotification
                                                 object:nil];
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(subjectAreaDidChange:)
                                               name:AVCaptureDeviceSubjectAreaDidChangeNotification
                                             object:nil];

  [[self view] addSubview:[self videoPreview]];
  [[self view] addSubview:[self quadrangleView]];
  [[self view] addSubview:[self roiView]];
  [[self view] addSubview:[self captureButton]];
  [[self view] addSubview:[self docTypeLabel]];
  [[self view] addSubview:[self cancelButton]];
  [[self view] addSubview:[self torchButton]];
  [[self view] addSubview:[self switchCameraButton]];
  [[self view] addSubview:[self instructionLabel]];
#if __DEMO__
  [[self view] addSubview:[self galleryButton]];
#endif
  
  [self makeLayout];
  
  UITapGestureRecognizer* gestureRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(focusButtonTapped:)];
  gestureRecognizer.numberOfTapsRequired = 1;
  [[self view] addGestureRecognizer:gestureRecognizer];
  
#if __DEMO__
  [self setupModeSegmentedPicker];
#endif
  [self setupZoomButton];
  [self setupZoomGesture];
}

- (void)subjectAreaDidChange:(NSNotification *)notification {
  if (self.camDevice) {
    NSError *error;
    if ([self.camDevice lockForConfiguration:&error]) {

      if ([self.camDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [self.camDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
      }
      
      if ([self.camDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        [self.camDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
      }
      
      [self.camDevice unlockForConfiguration];
    }
  }
}

- (void)setupModeSegmentedPicker {
  self.modeSegmentedPicker = [[ModeSegmentedPicker alloc] init];
  self.modeSegmentedPicker.delegate = self;
  self.modeSegmentedPicker.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.modeSegmentedPicker];
  
  // Constraints
  [NSLayoutConstraint activateConstraints:@[
    [self.modeSegmentedPicker.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    [self.modeSegmentedPicker.bottomAnchor constraintEqualToAnchor:self.captureButton.topAnchor constant:-20],
    [self.modeSegmentedPicker.widthAnchor constraintEqualToConstant:200], // Adjust width as needed
    [self.modeSegmentedPicker.heightAnchor constraintEqualToConstant:40]  // Adjust height as needed
  ]];
}

- (void) configureDocumentTypeLabel:(NSString*) label {
  self.docTypeLabel.text = label;
}

- (void) configurePreviewView {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIInterfaceOrientation statusBarOrientation = self.view.window.windowScene.interfaceOrientation;

    AVCaptureVideoOrientation initialVideoOrientation = AVCaptureVideoOrientationPortrait;
    if (!self.lockOrientation) {
      if ( statusBarOrientation != UIInterfaceOrientationUnknown ) {
        initialVideoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
      }
    } else {
      self.lastOrientation = UIDeviceOrientationPortrait;
      [self interfaceOrDeviceOrientationDidChange];
    }
    self.videoPreview.videoPreviewLayer.connection.videoOrientation = initialVideoOrientation;
  });
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self rotated:nil];
  [[self captureButton] restoreState];
  if (!UIDeviceOrientationIsPortrait(self.lastOrientation) &&
      !UIDeviceOrientationIsLandscape(self.lastOrientation)) {
    self.lastOrientation = UIDeviceOrientationPortrait;
  }
  if ([self enableOnTapFocus]) {
    int flags = NSKeyValueObservingOptionNew;
    [_camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
  }
  
  [self.camera updateSessionPreset];
  
  [self updateRoi];
  [self configurePreviewView];
  [self.camera startCaptureSession:self.torchOnByDefault];
//  if (self.torchOnByDefault)
//    [self.camera turnTorchOnWithLevel:1.0];
  
  // RestrictionNear. Fix: Autofocus issue for iPad 6-th and below. Reset autoFocusRangeRestriction after closing camera preview.
  if ([_camDevice lockForConfiguration:nil]) {
    if ([_camDevice isAutoFocusRangeRestrictionSupported]) {
      if ([[[UIDevice currentDevice] model] containsString:@"iPad"] &&
          [[[UIDevice currentDevice] model] containsString:@"6"]) {
        _camDevice.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
      } else {
        _camDevice.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNone;
      }
    }
    [_camDevice unlockForConfiguration];
  }
}

- (void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[self engineInstance] dismissVauthSession];
  
  [self.camera stopCaptureSession];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
  if ([self enableOnTapFocus] && self.camDevice) {
    @try {
      [self.camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    } @catch (NSException *exception) {
      NSLog(@"Exception removing observer: %@", exception);
    }
  }
    
  // RestrictionNone. Fix: Autofocus issue for iPad 6-th and below. Reset autoFocusRangeRestriction after closing camera preview.
  if ([_camDevice lockForConfiguration:nil]) {
    if ([_camDevice isAutoFocusRangeRestrictionSupported]) {
        _camDevice.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNone;
    }
    [_camDevice unlockForConfiguration];
  }
}

- (void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
//  [[self camera] stopCaptureSession];
}

// callback
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([self enableOnTapFocus]) {
    if( [keyPath isEqualToString:@"adjustingFocus"] ){
      _obsIsAdjustingFocus = [ [change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
      if (!_obsIsAdjustingFocus) {
        [_camFocus removeFromSuperview];
      }
      //Focus information
      //NSLog(@"Is adjusting focus? %@", _obsIsAdjustingFocus ? @"YES" : @"NO" );
      //NSLog(@"Change dictionary: %@", change);
    }
  }
}

#pragma mark - roi

- (void) setRoiWithOffsetX:(CGFloat)offsetX
                      andY:(CGFloat)offsetY
               orientation:(UIDeviceOrientation)orientation
                displayRoi:(BOOL)displayroi {
  [[self rois] setObject:@[@(offsetX), @(offsetY)] forKey:@(orientation)];
  _displayroi = displayroi;
  [self updateRoi];
}

- (void) updateRoi {
  NSArray *offsets = [[self rois] objectForKey:@(self.lastOrientation)];
  UIInterfaceOrientation currentUIIO = self.view.window.windowScene.interfaceOrientation;
  
  if (UIInterfaceOrientationIsLandscape(currentUIIO)) {
    self.roiView.offsetY = [[offsets objectAtIndex:0] floatValue];
    self.roiView.offsetX = [[offsets objectAtIndex:1] floatValue];
  } else {
    self.roiView.offsetX = [[offsets objectAtIndex:0] floatValue];
    self.roiView.offsetY = [[offsets objectAtIndex:1] floatValue];
  }
  self.roiView.displayRoi = _displayroi;
  [self.roiView setNeedsDisplay];
  self.currentRoi = [SmartIDRoiView calculateRoiWith:self.lastOrientation
                                            viewSize:self.view.frame.size
                                         orientation:currentUIIO
                                          cameraSize:[[self camera] videoSize]
                                          andOffsets:CGSizeMake([[offsets objectAtIndex:0] floatValue],
                                                                [[offsets objectAtIndex:1] floatValue])
                                          displayRoi:_displayroi];
}

#pragma mark - video processing

- (void) startRecognition {
  [self stopRecognition];
  [[self engineInstance] initVauthSession];
}

- (void) stopRecognition {
  [self stopSessionRunning];
  [[self engineInstance] dismissVauthSession];
}

- (void) stopSessionRunning {
  [[self engineInstance] dismissVideoSessionRunning];
  self.instructionLabel.text = NSLocalizedString(@"press_start", "");
}

- (void) captureOutput:(AVCaptureOutput *)output
 didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
        fromConnection:(AVCaptureConnection *)connection {
  if (self.engineInstance.videoSessionRunning) {
    if (self.smartIDVauthDelegate) {
      if ([[self smartIDVauthDelegate] respondsToSelector:@selector(smartIDVauthViewControllerDidReceiveBuffer:)]) {
        [[self smartIDVauthDelegate] smartIDVauthViewControllerDidReceiveBuffer:sampleBuffer];
      }
    }
    [[self engineInstance] processVauthFrame:sampleBuffer
                             withOrientation:self.lastOrientation
                                      andRoi:self.currentRoi];
  }
}

- (void)captureOutput:(AVCapturePhotoOutput *)output
didFinishProcessingPhoto:(AVCapturePhoto *)photo
                error:(NSError *)error {
  
  if (error) {
    NSLog(@"Error capturing photo: %@", error.localizedDescription);
    return;
  }
  
  NSData *imageData = [photo fileDataRepresentation];
  if (imageData) {
    UIImage *image = [UIImage imageWithData:imageData];
    
    PhotoPreviewViewController *photoPreviewVC = [[PhotoPreviewViewController alloc] init];
    photoPreviewVC.photo = image;
    photoPreviewVC.delegate = self;
    photoPreviewVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:photoPreviewVC animated:YES completion:nil];
  }
}

- (void) SmartVauthObtainedInstruction:(NSString *)instruction {
  dispatch_async(dispatch_get_main_queue(), ^{
//    if (![instruction isEqualToString:@"finish"]) {
//      [self.instructionLabel setText: NSLocalizedString(instruction, "")];
//    }
    if ([instruction isEqualToString:@"show_other_side"]) {
      [self.instructionLabel setText: NSLocalizedString(instruction, "")];
      [self.instructionLabel setHidden:NO];
    } else {
      [self.instructionLabel setHidden:YES];
    }
  });
}

- (void) SmartIDVauthObtainedResult:(SEIdResult *)result
                 fromFrameWithBuffer:(CMSampleBufferRef)buffer {
  if (self.smartIDVauthDelegate) {
      if ([self.smartIDVauthDelegate respondsToSelector:@selector(smartIDVauthViewControllerDidRecognize:fromBuffer:)]) {
      [self.smartIDVauthDelegate smartIDVauthViewControllerDidRecognize:result fromBuffer:buffer];
    }
  }
  if ([[result getRef] getIsTerminal]) {
    [self stopRecognition];
  }
}

- (void) SmartIDVauthObtainedSegmentationResult:(SEIdTemplateSegmentationResult *)result {
  if ([self displayDocumentQuadrangle]) {
    SECommonQuadranglesMapIterator* quadsEnd = [[result getRef] rawFieldQuadranglesEnd];
    for (SECommonQuadranglesMapIterator* it = [[result getRef] rawFieldQuadranglesBegin];
         ![it isEqualToIter:quadsEnd];
         [it advance]) {
      SECommonQuadrangle* quad = [it getValue];
      UIInterfaceOrientation ifaceOrientation = self.view.window.windowScene.interfaceOrientation;
      dispatch_async(dispatch_get_main_queue(), ^{
        [[self quadrangleView] animateQuadrangle:quad
                                           color:[self quadranglesColor]
                                           width:[self quadranglesWidth]
                                           alpha:[self quadranglesAlpha]
                                         offsetX:[self currentRoi].origin.x
                                         offsetY:[self currentRoi].origin.y
                               deviceOrientation:[self lastOrientation]
                            interfaceOrientation:ifaceOrientation
                                      sourceSize:[[self camera] videoSize]
                                         isFront:self.camera.getCaptureDevice.position == AVCaptureDevicePositionFront];
      });
    }
  }
}

- (void) SmartIDVauthObtainedDetectionResult:(SEIdTemplateDetectionResult *)result {
  if ([self displayZonesQuadrangles]) {
    UIColor* display_color = [self quadranglesColor];
    if ([[[result getRef] getTemplateName] containsString:@"_tracked"]) {
      display_color = [UIColor yellowColor];
    }
    UIInterfaceOrientation ifaceOrientation = self.view.window.windowScene.interfaceOrientation;
    dispatch_async(dispatch_get_main_queue(), ^{
      [[self quadrangleView] animateQuadrangle:[[result getRef] getQuadrangle]
                                         color:display_color
                                         width:[self quadranglesWidth]
                                         alpha:[self quadranglesAlpha]
                                       offsetX:[self currentRoi].origin.x
                                       offsetY:[self currentRoi].origin.y
                             deviceOrientation:[self lastOrientation]
                          interfaceOrientation:ifaceOrientation
                                    sourceSize:[[self camera] videoSize]
                                       isFront:self.camera.getCaptureDevice.position == AVCaptureDevicePositionFront];
    });
  }
}

- (void)photoPreviewViewControllerDidUsePhoto:(UIImage *)photo {
  if (self.smartIDVauthDelegate && [self.smartIDVauthDelegate respondsToSelector:@selector(smartIDVauthViewControllerDidPhotoPick:)]) {
    [self.smartIDVauthDelegate smartIDVauthViewControllerDidPhotoPick:photo];
  }
}


#pragma mark - capture button

- (void) setCaptureButtonDelegate:(id<SmartIDCameraButtonDelegate>)captureButtonDelegate {
  _captureButtonDelegate = captureButtonDelegate;
  [[self captureButton] setDelegate:_captureButtonDelegate];
}

- (void) SmartIDCameraButtonTapped:(SmartIDCaptureButton *)sender {
  if ([sender mode] == SECameraButtonModePhoto) {
    AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings photoSettings];
    [self.camera.capturePhotoOutput capturePhotoWithSettings:photoSettings delegate:self];
  } else {
    if (!self.engineInstance.videoSessionRunning) {
      [self startRecognition];
      self.modeSegmentedPicker.userInteractionEnabled = NO;
    } else {
      if ([self.smartIDVauthDelegate respondsToSelector:@selector(smartIDVauthViewControllerDidStop:)]) {
        [self stopSessionRunning];
        SEIdResult * result = [[SEIdResult alloc] init];
        if ([self.engineInstance.vauthSession hasDocumentResult]) {
          result = [[self.engineInstance.vauthSession getDocumentResult] clone];
        }
        [self.smartIDVauthDelegate smartIDVauthViewControllerDidStop:result];
      }
      [self stopRecognition];
    }
  }
}

#pragma mark - cancel button

- (UIButton *) cancelButton {
  if (!_cancelButton) {
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *btnImage = [UIImage systemImageNamed:@"chevron.left"];
    [_cancelButton setImage:btnImage forState:UIControlStateNormal];
    [_cancelButton setTintColor:[UIColor whiteColor]];
    [_cancelButton addTarget:self
                      action:@selector(cancelButtonTapped)
            forControlEvents:UIControlEventTouchUpInside];
  }
  return _cancelButton;
}

- (void) cancelButtonTapped {
  if (self.engineInstance.videoSessionRunning) {
    [self stopRecognition];
  }
  if (self.smartIDVauthDelegate) {
    if ([self.smartIDVauthDelegate respondsToSelector:@selector(smartIDVauthViewControllerDidCancel)]) {
      [self.smartIDVauthDelegate smartIDVauthViewControllerDidCancel];
    }
  }
}

#pragma mark - torch button

- (void) tourchButtonUpdate {
  UIImage *btnImage = ([self.camera isTorchOn]) ? [UIImage systemImageNamed:@"bolt.slash.circle"] : [UIImage systemImageNamed:@"bolt.circle"] ;
  [_torchButton setImage:btnImage forState:UIControlStateNormal];
}

- (UIButton *) torchButton {
  if (!_torchButton) {
    _torchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_torchButton addTarget:self
                     action:@selector(torchButtonTapped)
            forControlEvents:UIControlEventTouchUpInside];
    [_torchButton setTintColor:[UIColor whiteColor]];
    [self tourchButtonUpdate];
  }
  return _torchButton;
}

- (void) torchButtonTapped {
  if ([self.camera isTorchOn]) {
    [self.camera turnTorchOff];
  } else {
    [self.camera turnTorchOnWithLevel:1.0];
  }
  [self tourchButtonUpdate];
}

#pragma mark - switch camera button

- (UIButton *) switchCameraButton {
  if (!_switchCameraButton) {
    _switchCameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_switchCameraButton addTarget:self
                      action:@selector(switchCametaButtonTapped)
            forControlEvents:UIControlEventTouchUpInside];
    [_switchCameraButton setTintColor:[UIColor whiteColor]];
    UIImage *btnImage = [UIImage systemImageNamed:@"arrow.triangle.2.circlepath"];
    [_switchCameraButton setImage:btnImage forState:UIControlStateNormal];

  }
  return _switchCameraButton;
}

- (void) switchCametaButtonTapped {
  [self.camera switchCamera];
  
  //Hiding torch while front camera
  if (self.camera.position == AVCaptureDevicePositionFront) {
    _torchButton.hidden = YES;
  } else {
    _torchButton.hidden = NO;
  }
  [self tourchButtonUpdate];
}

#pragma mark - gallery button

- (UIButton *) galleryButton {
  if (!_galleryButton) {
    _galleryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *btnImage = [UIImage systemImageNamed:@"photo"];
    [_galleryButton setImage:btnImage forState:UIControlStateNormal];
    [_galleryButton setTintColor:[UIColor whiteColor]];
    [_galleryButton addTarget:self
                       action:@selector(galleryButtonTapped)
             forControlEvents:UIControlEventTouchUpInside];
  }
  return _galleryButton;
}

- (void) galleryButtonTapped {
  if (self.engineInstance.videoSessionRunning) {
    [self stopRecognition];
  }
  if (self.smartIDVauthDelegate) {
    if ([self.smartIDVauthDelegate respondsToSelector:@selector(smartIDVauthViewControllerDidGalleryPick)]) {
      [self.smartIDVauthDelegate smartIDVauthViewControllerDidGalleryPick];
    }
  }
}


#pragma mark - focus button

- (void)focusButtonTapped:(id)sender {
  if (![self enableOnTapFocus] || !self.camDevice) {
    return;
  }
  
  if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
    UITapGestureRecognizer* senderAsGesture = (UITapGestureRecognizer *)sender;
    CGPoint location = [senderAsGesture locationInView:[self view]];
    
    if (_camFocus) {
      [_camFocus removeFromSuperview];
      _camFocus = nil;
    }
    
    if (![self.camDevice isFocusPointOfInterestSupported] ||
        ![self.camDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
      return;
    }
    
    NSError *error;
    if ([self.camDevice lockForConfiguration:&error]) {
      CGPoint pointOfInterest = [self convertToPointOfInterestFromViewCoordinates:location];
      
      if ([self.camDevice isFocusPointOfInterestSupported]) {
        [self.camDevice setFocusPointOfInterest:pointOfInterest];
        [self.camDevice setFocusMode:AVCaptureFocusModeAutoFocus];
      }
      
      if ([self.camDevice isExposurePointOfInterestSupported]) {
        [self.camDevice setExposurePointOfInterest:pointOfInterest];
        [self.camDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
      }
      
      [self.camDevice unlockForConfiguration];
      
      _camFocus = [[CameraFocusSquare alloc] initWithFrame:CGRectMake(location.x-40, location.y-40, 80, 80)];
      [_camFocus setBackgroundColor:[UIColor clearColor]];
      [[self view] addSubview:[self camFocus]];
      
      [UIView animateWithDuration:0.3 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.camFocus.alpha = 0.0;
      } completion:^(BOOL finished) {
        [self.camFocus removeFromSuperview];
        self.camFocus = nil;
      }];
    } else {
      NSLog(@"Could not lock device for configuration: %@", error);
    }
  }
}

- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates {
  CGSize frameSize = self.view.bounds.size;
  
  CGPoint pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height,
                                        1.0f - (viewCoordinates.x / frameSize.width));
  
  UIInterfaceOrientation orientation = self.view.window.windowScene.interfaceOrientation;
  if (orientation == UIInterfaceOrientationLandscapeLeft) {
    pointOfInterest = CGPointMake(pointOfInterest.y, 1.0f - pointOfInterest.x);
  } else if (orientation == UIInterfaceOrientationLandscapeRight) {
    pointOfInterest = CGPointMake(1.0f - pointOfInterest.y, pointOfInterest.x);
  } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
    pointOfInterest = CGPointMake(1.0f - pointOfInterest.x, pointOfInterest.y);
  }
  
  return pointOfInterest;
}

#pragma mark - ModeSegmentedPicker

- (void)modeSegmentedPickerDidSelectMode:(BOOL)isPhotoMode {
  if (isPhotoMode) {
    [self.captureButton setNewMode:SECameraButtonModePhoto];
    self.camera.cameraMode = CMPhoto;
    [self.camera updateSessionPreset];
    [self.videoPreview.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
  } else {
    [self.captureButton setNewMode:SECameraButtonModeVideo];
    self.camera.cameraMode = CMVideo;
    [self.camera updateSessionPreset];
    [self.videoPreview.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
  }
  [self updateRoi];
}

#pragma mark - zoom

- (void)setupZoomButton {
  self.zoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.zoomButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.zoomButton setTitle:@"1x" forState:UIControlStateNormal];
  [self.zoomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.zoomButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
  self.zoomButton.layer.cornerRadius = 20.0f;
  self.zoomButton.layer.masksToBounds = YES;
  self.zoomButton.titleLabel.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightMedium];
  [self.zoomButton addTarget:self action:@selector(zoomButtonTapped) forControlEvents:UIControlEventTouchUpInside];
  self.zoomButton.hidden = YES;
  
  [self.view addSubview:self.zoomButton];
  
  [NSLayoutConstraint activateConstraints:@[
    [self.zoomButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    [self.zoomButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-150],
    [self.zoomButton.widthAnchor constraintEqualToConstant:40],
    [self.zoomButton.heightAnchor constraintEqualToConstant:40]
  ]];
}

- (void)zoomButtonTapped {
  [self setZoomLevel:MIN_ZOOM];
}

- (void)setupZoomGesture {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchToZoom:)];
    [self.view addGestureRecognizer:pinchGesture];
}

- (void)handlePinchToZoom:(UIPinchGestureRecognizer *)gesture {
  if (gesture.state == UIGestureRecognizerStateBegan) {
    self.lastZoomFactor = self.currentZoomLevel;
  }
  
  CGFloat minAvailableZoom = MIN_ZOOM;
  CGFloat maxAvailableZoom = MAX_ZOOM;
  
  CGFloat newZoom = self.lastZoomFactor * gesture.scale;
  newZoom = MAX(MIN(newZoom, maxAvailableZoom), minAvailableZoom);
  
  [self setZoomLevel:newZoom];
  
  if (gesture.state == UIGestureRecognizerStateEnded ||
      gesture.state == UIGestureRecognizerStateCancelled ||
      gesture.state == UIGestureRecognizerStateFailed) {
    self.lastZoomFactor = self.currentZoomLevel;
  }
}

- (void)setZoomLevel:(CGFloat)zoomLevel {
    self.currentZoomLevel = zoomLevel;
    
    [self.camera setVideoCaptureDeviceZoom:zoomLevel animated:NO rate:0];
    
    [self updateZoomButton];
}

- (void)updateZoomButton {
    if (self.currentZoomLevel > MIN_ZOOM + 0.1f) {
        self.zoomButton.hidden = NO;
        NSString *zoomText = [NSString stringWithFormat:@"%.1fx", self.currentZoomLevel];
        [self.zoomButton setTitle:zoomText forState:UIControlStateNormal];
        [self.zoomButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    } else {
        self.zoomButton.hidden = YES;
    }
}

#pragma mark - orientation handling

- (void) viewWillTransitionToSize:(CGSize)size
        withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
  if (UIDeviceOrientationIsPortrait(deviceOrientation) ||
      UIDeviceOrientationIsLandscape(deviceOrientation)) {
    self.lastOrientation = deviceOrientation;
    [self interfaceOrDeviceOrientationDidChange];
    self.videoPreview.videoPreviewLayer.connection.videoOrientation =
        (AVCaptureVideoOrientation)deviceOrientation;
  }
}

- (void) rotated:(NSNotification *)notification {
  UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
  if (UIDeviceOrientationIsPortrait(deviceOrientation) ||
      UIDeviceOrientationIsLandscape(deviceOrientation)) {
    self.lastOrientation = deviceOrientation;
    [self interfaceOrDeviceOrientationDidChange];
  }
}

- (void) interfaceOrDeviceOrientationDidChange {
  [self updateRoi];
}

- (CGSize) cameraSize {
  return [[self camera] videoSize];
}

- (CGRect) getCurrentRoi {
  return [self currentRoi];
}

- (void) setDefaultOrientation:(UIDeviceOrientation)orientation {
  _defaultOrientation = orientation;
}

- (UIDeviceOrientation) lastOrientation {
  if (_defaultOrientation != UIDeviceOrientationUnknown) {
    return _defaultOrientation;
  } else {
    return _lastOrientation;
  }
}

- (nonnull SEIdVideoAuthenticationSessionSettings *) sessionSettings {
  return [self.engineInstance vauthSessionSettings];
}

@end
