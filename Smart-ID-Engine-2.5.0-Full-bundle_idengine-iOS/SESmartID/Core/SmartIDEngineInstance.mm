/*
 Copyright (c) 2016-2024, Smart Engines Service LLC
 All rights reserved.
 */

#import "SmartIDEngineInstance.h"

@interface ProxyFeedbackReporter : NSObject <SEIdFeedback>
@property (weak) SmartIDEngineInstance* governor;

- (instancetype) initWithGovernor:(__weak SmartIDEngineInstance *)initGovernor;

- (void) feedbackReceived:(SEIdFeedbackContainerRef *)feedback;
- (void) templateDetectionResultReceived:(SEIdTemplateDetectionResultRef *)result;
- (void) templateSegmentationResultReceived:(SEIdTemplateSegmentationResultRef *)result;
- (void) resultReceived:(SEIdResultRef *)result;
- (void) sessionEnded;

@end

@implementation ProxyFeedbackReporter {
  BOOL transferFeedback;
  BOOL transferDetectionResults;
  BOOL transferSegmentationResults;
  
  BOOL transferVauthDetectionResults;
  BOOL transferVauthSegmentationResults;
}

@synthesize governor;

- (instancetype) initWithGovernor:(__weak SmartIDEngineInstance *)initGovernor {
    if (self = [super init]) {
        governor = initGovernor;
        [self updateResponceFlags];
    }
    return self;
}

- (void) updateResponceFlags {
  transferFeedback = NO;
  transferDetectionResults = NO;
  transferSegmentationResults = NO;
  
  transferVauthDetectionResults = NO;
  transferVauthSegmentationResults = NO;
  if (self.governor.engineDelegate) {
    // transferFeedback = [self.governor.engineDelegate respondsToSelector:@selector(SmartIDEngineObtainedFeedback:)];
    transferDetectionResults = [self.governor.engineDelegate respondsToSelector:@selector(SmartIDEngineObtainedDetectionResult:)];
    transferSegmentationResults = [self.governor.engineDelegate respondsToSelector:@selector(SmartIDEngineObtainedSegmentationResult:)];
  }
  if (self.governor.vauthDelegate) {
    transferVauthDetectionResults = [self.governor.vauthDelegate respondsToSelector:@selector(SmartIDVauthObtainedDetectionResult:)];
    transferVauthSegmentationResults = [self.governor.vauthDelegate respondsToSelector:@selector(SmartIDVauthObtainedSegmentationResult:)];
  }
}

- (void) feedbackReceived:(SEIdFeedbackContainerRef *)feedback {
    if (transferFeedback) {
        SEIdFeedbackContainer* feedbackCopy = [feedback clone];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.governor.engineDelegate SmartIDEngineObtainedFeedback:feedbackCopy];
        });
    }
}

- (void) templateDetectionResultReceived:(SEIdTemplateDetectionResultRef *)result {
  if (transferDetectionResults) {
    SEIdTemplateDetectionResult* resultCopy = [result clone];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.governor.engineDelegate SmartIDEngineObtainedDetectionResult:resultCopy];
    });
  } else if (transferVauthDetectionResults) {
    SEIdTemplateDetectionResult* resultCopy = [result clone];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.governor.vauthDelegate SmartIDVauthObtainedDetectionResult:resultCopy];
    });
  }
}

- (void) templateSegmentationResultReceived:(SEIdTemplateSegmentationResultRef *)result {
  if (transferSegmentationResults) {
    SEIdTemplateSegmentationResult* resultCopy = [result clone];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.governor.engineDelegate SmartIDEngineObtainedSegmentationResult:resultCopy];
    });
  } else if (transferVauthDetectionResults) {
    SEIdTemplateSegmentationResult* resultCopy = [result clone];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.governor.vauthDelegate SmartIDVauthObtainedSegmentationResult:resultCopy];
    });
  }
}

- (void) resultReceived:(SEIdResultRef *)result {
    // noop
}

- (void) sessionEnded {
    // noop
}

@end

@interface LivenessFeedbackReporter : NSObject <SEIdFaceFeedback>
@property (weak) SmartIDEngineInstance* governor;

- (instancetype) initWithGovernor:(__weak SmartIDEngineInstance *)initGovernor;

- (void) messageReceived:(NSString *)message;

@end

@implementation LivenessFeedbackReporter {
    BOOL transferFeedback;
}

@synthesize governor;

- (instancetype) initWithGovernor:(__weak SmartIDEngineInstance *)initGovernor {
    if (self = [super init]) {
        governor = initGovernor;
        [self updateResponceFlags];
    }
    return self;
}

- (void) updateResponceFlags {
    transferFeedback = NO;
    if (self.governor.livenessDelegate) {
        transferFeedback = [self.governor.livenessDelegate respondsToSelector:@selector(SmartLivenessObtainedMessage:)];
    }
}

- (void) messageReceived:(NSString *)message {
    if (transferFeedback) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.governor.livenessDelegate SmartLivenessObtainedMessage:message];
        });
    }
}

@end

@interface VauthFeedbackReporter : NSObject <SEIdVideoAuthenticationCallbacks>
@property (weak) SmartIDEngineInstance* governor;

- (instancetype) initWithGovernor:(__weak SmartIDEngineInstance *)initGovernor;

- (void) instructionReceived:(SEIdVideoAuthenticationInstructionRef *)instruction
                atFrameIndex:(int)index;
- (void) anomalyRegistered:(SEIdVideoAuthenticationAnomalyRef *)anomaly
              atFrameIndex:(int)index;
- (void) documentResultUpdatedTo:(SEIdResultRef *)document_result;
- (void) faceMatchingResultUpdatedTo:(SEIdFaceSimilarityResultRef *)face_matching_result;
- (void) faceLivenessResultUpdatedTo:(SEIdFaceLivenessResultRef *)face_liveness_result;
- (void) authenticationStatusUpdatedTo:(SEIdCheckStatus)status;
- (void) globalTimeoutReached;
- (void) instructionTimeoutReached;
- (void) sessionEnded;
- (void) messageReceived:(nonnull NSString *)message;

@end

@implementation VauthFeedbackReporter {
  BOOL transferInstruction;
}

@synthesize governor;

- (instancetype) initWithGovernor:(__weak SmartIDEngineInstance *)initGovernor {
    if (self = [super init]) {
        governor = initGovernor;
        [self updateResponceFlags];
    }
    return self;
}

- (void) updateResponceFlags {
  transferInstruction = NO;
  if (self.governor.vauthDelegate) {
    transferInstruction = [self.governor.vauthDelegate respondsToSelector:@selector(SmartVauthObtainedInstruction:)];
  }
}

- (void)instructionReceived:(SEIdVideoAuthenticationInstructionRef *)instruction
               atFrameIndex:(int)index {
  NSString* instructionCode = instruction.getInstructionCode;
  NSLog(@"🕵🏻‍♀️Instruction received: %@ at index: %d", instructionCode, index);
  if (transferInstruction) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.governor.vauthDelegate SmartVauthObtainedInstruction:instructionCode];
    });
  }
}

- (void)anomalyRegistered:(SEIdVideoAuthenticationAnomalyRef *)anomaly
             atFrameIndex:(int)index {
  NSLog(@"🕵🏻‍♀️Anomaly registered: %@ at index: %d", anomaly.getName, index);
}

- (void)documentResultUpdatedTo:(SEIdResultRef *)document_result {
  NSLog(@"🕵🏻‍♀️Document result updated");
}

- (void)faceMatchingResultUpdatedTo:(SEIdFaceSimilarityResultRef *)face_matching_result {
  NSLog(@"🕵🏻‍♀️Face matching result updated");
}

- (void)faceLivenessResultUpdatedTo:(SEIdFaceLivenessResultRef *)face_liveness_result {
  NSLog(@"🕵🏻‍♀️Face liveness result updated");
}

- (void)authenticationStatusUpdatedTo:(SEIdCheckStatus)status {
  NSLog(@"🕵🏻‍♀️Authentication status updated");
}

- (void)globalTimeoutReached {
  NSLog(@"🕵🏻‍♀️Global timeout reached");
}

- (void)instructionTimeoutReached {
  NSLog(@"🕵🏻‍♀️Instruction timeout reached");
}

- (void)sessionEnded {
  NSLog(@"🕵🏻‍♀️Session ended");
}

- (void) messageReceived:(NSString *)message {
  NSLog(@"🕵🏻‍♀️Message received: %@", message);
}

@end

@interface SmartIDEngineInstance () {
  ProxyFeedbackReporter* proxyReporter;
  LivenessFeedbackReporter* livenessReporter;
  VauthFeedbackReporter* vauthReporter;
}

@property NSString* signature;


@property (weak, nonatomic, nullable, readwrite) id<SmartIDEngineDelegate> engineDelegate;
@property (weak, nonatomic, nullable, readwrite) id<SmartLivenessDelegate> livenessDelegate;
@property (weak, nonatomic, nullable, readwrite) id<SmartIDVauthDelegate> vauthDelegate;
@property (weak, nonatomic, nullable, readwrite) id<SmartIDEngineInitializationDelegate> initializationDelegate;

@property (strong, nullable, readwrite) SEIdEngine* engine; // main configuration of Smart ID Engine
@property (strong, nullable, readwrite) SEIdSession* videoSession; // current video recognition session
@property (strong, nullable, readwrite) SEIdFaceSession* livenessSession; // current video recognition session
@property (strong, nullable, readwrite) SEIdVideoAuthenticationSession* vauthSession; // current vauth recognition session


// Best Image Frame section
@property (nonatomic, assign, readwrite) BOOL isBestImageFrameEnabled; // if enabled Best Image frame
@property (nonnull, readwrite) NSString* bestImageFrame;
@property NSMutableDictionary *frameImageTemplatesInfo;

// For measurements
@property (readwrite) BOOL isFirstFrame;
@end

@implementation SmartIDEngineInstance {
    BOOL delegateReceivesResults;
    BOOL delegateReceivesSingleImageResults;
    
    BOOL delegateReceivesInit;
    BOOL delegateReceivesSessionStarted;
    BOOL delegateReceivesSessionDismissed;
  
    BOOL delegateReceivesProcessTime;
}

@synthesize engine, vauthSession, videoSession, sessionSettings, livenessSession, faceSessionSettings, vauthSessionSettings;

- (instancetype) init {
    NSException* exc = [NSException
                        exceptionWithName:@"SignatureError"
                        reason:@"SmartIDEngineInstance must be created with signature (use initWithSignature:)"
                        userInfo:nil];
    @throw exc;
}

- (instancetype) initWithSignature:(NSString *)inputSignature {
  if (self = [super init]) {
    // Storing signature
    self.signature = inputSignature;
    
    self.engineInitialized = NO;
    self.videoSessionRunning = NO;
    
    // For measurements
    self.isFirstFrame = YES;
    
    // Initializing proxy reporter
    __weak __typeof(self) weakSelf = self;
    proxyReporter = [[ProxyFeedbackReporter alloc] initWithGovernor:weakSelf];
    livenessReporter = [[LivenessFeedbackReporter alloc] initWithGovernor:weakSelf];
    vauthReporter = [[VauthFeedbackReporter alloc] initWithGovernor:weakSelf];
    
    // Initializing delegates cache
    delegateReceivesResults = NO;
    delegateReceivesSingleImageResults = NO;
    
    delegateReceivesInit = NO;
    delegateReceivesSessionStarted = NO;
    delegateReceivesSessionDismissed = NO;
    delegateReceivesProcessTime = NO;
    
    
  }
  
  return self;
}

- (void) setEngineDelegate:(nullable __weak id<SmartIDEngineDelegate>)delegate {
  _engineDelegate = delegate;
  delegateReceivesResults = NO;
  delegateReceivesSingleImageResults = NO;
  delegateReceivesProcessTime = NO;
  if (self.engineDelegate) {
    delegateReceivesResults =
    [self.engineDelegate respondsToSelector:@selector(SmartIDEngineObtainedResult:fromFrameWithBuffer:)];
    delegateReceivesSingleImageResults =
    [self.engineDelegate respondsToSelector:@selector(SmartIDEngineObtainedSingleImageResult:)];
    delegateReceivesProcessTime =
    [self.engineDelegate respondsToSelector:@selector(SmartIDEngineDidProcessTime:)];
    
    [proxyReporter updateResponceFlags];
  }
}

- (void) setLivenessDelegate:(nullable __weak id<SmartLivenessDelegate>)delegate {
  _livenessDelegate = delegate;
  delegateReceivesResults = NO;
  delegateReceivesSingleImageResults = NO;
  if (self.livenessDelegate) {
    delegateReceivesResults =
    [self.livenessDelegate respondsToSelector:@selector(SmartLivenessObtainedResult:)];
    
    [livenessReporter updateResponceFlags];
  }
}

- (void) setVauthDelegate:(nullable __weak id<SmartIDVauthDelegate>)delegate {
  _vauthDelegate = delegate;
  delegateReceivesResults = NO;
  if (self.vauthDelegate) {
    delegateReceivesResults =
    [self.vauthDelegate respondsToSelector:@selector(SmartIDVauthObtainedResult:fromFrameWithBuffer:)];
    
    [proxyReporter updateResponceFlags];
    [vauthReporter updateResponceFlags];
  }
}

- (void) setInitializationDelegate:(nullable __weak id<SmartIDEngineInitializationDelegate>)delegate {
    _initializationDelegate = delegate;
    delegateReceivesInit = NO;
    delegateReceivesSessionStarted = NO;
    delegateReceivesSessionDismissed = NO;
    delegateReceivesProcessTime = YES;
    if (self.initializationDelegate) {
        delegateReceivesInit =
        [self.initializationDelegate respondsToSelector:@selector(SmartIDEngineInitialized)];
        delegateReceivesSessionStarted =
        [self.initializationDelegate respondsToSelector:@selector(SmartIDEngineVideoSessionStarted)];
        delegateReceivesSessionDismissed =
        [self.initializationDelegate respondsToSelector:@selector(SmartIDEngineVideoSessionDismissed)];
    }
}

- (void) resetSessionSettings {
  self.sessionSettings = [self.engine createSessionSettings];
}


- (void) initializeEngine:(nonnull NSString*) bundlePath {
  self.engine = [[SEIdEngine alloc] initFromFile:bundlePath
                                    withLazyInit:YES
                        withInitConcurrencyLimit:0
                       withDelayedInitialization:YES];
  [self resetSessionSettings];
  
  if ([self.engine canCreateFaceSessionSettings]) {
    self.faceSessionSettings = [self.engine createFaceSessionSettings];
  }
  
  if ([self.engine canCreateVideoAuthenticationSessionSettings]) {
    self.vauthSessionSettings = [self.engine createVideoAuthenticationSessionSettings];
  }
  
  // Logging supported document types
  NSLog(@"Supported modes for configured engine:");
  SECommonStringsSetIterator* modesEnd = [self.sessionSettings supportedModesEnd];
  for (SECommonStringsSetIterator* it = [self.sessionSettings supportedModesBegin];
       ![it isEqualToIter:modesEnd];
       [it advance]) {
    NSLog(@" --> %@", [it getValue]);
  }
  NSLog(@"Supported document types for configured engine:");
  SECommonStringsSetIterator* enginesEnd = [self.sessionSettings internalEngineNamesEnd];
  for (SECommonStringsSetIterator* itEngine = [self.sessionSettings internalEngineNamesBegin];
       ![itEngine isEqualToIter:enginesEnd];
       [itEngine advance]) {
    NSString* internalEngineName = [itEngine getValue];
    NSLog(@"  Engine %@:", internalEngineName);
    SECommonStringsSetIterator* docsEnd = [self.sessionSettings supportedDocumentTypesEndForEngine:internalEngineName];
    for (SECommonStringsSetIterator* it =
         [self.sessionSettings supportedDocumentTypesBeginForEngine:internalEngineName];
         ![it isEqualToIter:docsEnd];
         [it advance]) {
      NSLog(@"   --> %@", [it getValue]);
    }
  }
  
  self.videoSession = nil;
  self.videoSessionRunning = NO;
  self.livenessSession = nil;
  self.vauthSession = nil;
  
  self.engineInitialized = YES;
  
  if (delegateReceivesInit) {
    [self.initializationDelegate SmartIDEngineInitialized];
  }
}

- (void) initVideoSession {
  if (!self.engineInitialized) {
    NSException* exc = [NSException
                        exceptionWithName:@"SmartIDEngineInstanceError"
                        reason:@"SmartIDEngineInstance cannot initialize video session while engine is not yet initialized"
                        userInfo:nil];
    @throw exc;
  }
  
  
  NSLog(@"Enabled document types for recognition session to be created:");
  SECommonStringsSetIterator* docsEnd = [self.sessionSettings enabledDocumentTypesEnd];
  for (SECommonStringsSetIterator* it = [self.sessionSettings enabledDocumentTypesBegin];
       ![it isEqualToIter:docsEnd];
       [it advance]) {
    NSLog(@" --> %@", [it getValue]);
  }
  
  @synchronized (self.videoSession) {
    
    self.videoSession = [self.engine spawnSessionWithSettings:self.sessionSettings
                                                withSignature:self.signature
                                         withFeedbackReporter:proxyReporter];
    self.videoSessionRunning = YES;
  }
  
  if (delegateReceivesSessionStarted) {
    [self.initializationDelegate SmartIDEngineVideoSessionStarted];
  }
}

- (void) initLivenessSession {
  if (!self.engineInitialized) {
    NSException* exc = [NSException
                        exceptionWithName:@"SmartIDEngineInstanceError"
                        reason:@"SmartIDEngineInstance cannot initialize liveness session while engine is not yet initialized"
                        userInfo:nil];
    @throw exc;
  }
  
  @synchronized (self.livenessSession) {
    self.livenessSession = [self.engine spawnFaceSessionWithSettings:self.faceSessionSettings withSignature:self.signature withFeedbackReporter:livenessReporter];
    self.videoSessionRunning = YES;
  }
  
  if (delegateReceivesSessionStarted) {
    [self.initializationDelegate SmartIDEngineVideoSessionStarted];
  }
}

- (void) initVauthSession {
  if (!self.engineInitialized) {
    NSException* exc = [NSException
                        exceptionWithName:@"SmartIDEngineInstanceError"
                        reason:@"SmartIDEngineInstance cannot initialize video session while engine is not yet initialized"
                        userInfo:nil];
    @throw exc;
  }
  
  @synchronized (self.vauthSession) {
    self.vauthSession = [self.engine spawnVideoAuthenticationSessionWithSettings:self.vauthSessionSettings
                                                                   withSignature:self.signature
                                                withVideoAuthenticationCallbacks:vauthReporter
                                                            withFeedbackReporter:proxyReporter
                                                        withFaceFeedbackReporter:nil];
    self.videoSessionRunning = YES;
  }
  
  if (delegateReceivesSessionStarted) {
    [self.initializationDelegate SmartIDEngineVideoSessionStarted];
  }
}

- (void) dismissVideoSession {
  @synchronized (self.videoSession) {
    self.videoSessionRunning = NO;
//    self.videoSession = nil;
    self.isFirstFrame = YES;
  }
  
  if (delegateReceivesSessionDismissed) {
    [self.initializationDelegate SmartIDEngineVideoSessionDismissed];
  }
}

- (void) dismissLivenessSession {
  @synchronized (self.livenessSession) {
    self.videoSessionRunning = NO;
    self.livenessSession = nil;
  }
  
  if (delegateReceivesSessionDismissed) {
    [self.initializationDelegate SmartIDEngineVideoSessionDismissed];
  }
}

- (void) dismissVauthSession {
  @synchronized (self.vauthSession) {
//    self.vauthSession = nil;
  }
  
  if (delegateReceivesSessionDismissed) {
    [self.initializationDelegate SmartIDEngineVideoSessionDismissed];
  }
}


- (void) dismissVideoSessionRunning {
  self.videoSessionRunning = NO;
  self.isFirstFrame = YES;
}

#pragma mark - frame processing

int getRotationsByOrientation(UIDeviceOrientation orientation) {
    int rotations = 0;
    if (orientation == UIDeviceOrientationPortrait) {
        rotations = 1;
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        rotations = 2;
    } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        rotations = 3;
    }
    return rotations;
}

- (void) processFrameImage:(SECommonImageRef *)image
                fromBuffer:(CMSampleBufferRef)buffer {
  
  if (self.videoSessionRunning) {
    SEIdResult* result = nil;
    @synchronized (self.videoSession) {
      NSDate *start = [NSDate date];
      [self.videoSession processImage:image];
      NSDate *end = [NSDate date];
      SEIdResultRef* currentResult = [self.videoSession getCurrentResult];
      
      // For measurement purposes
      if ([currentResult getDocumentType] != nil and self.isFirstFrame == YES) {
        self.isFirstFrame = NO;
        NSTimeInterval processFirstFrameTime = [end timeIntervalSinceDate:start];
        if (delegateReceivesProcessTime) {
          [self.engineDelegate SmartIDEngineDidProcessTime:processFirstFrameTime];
        }
        if ([self.engineDelegate respondsToSelector:@selector(SmartIDEngineDidProcessTime:)]) {
          [self.engineDelegate SmartIDEngineDidProcessTime:processFirstFrameTime];
        }
      }
      
      result = [currentResult clone];
      // Image frame
      if(_isBestImageFrameEnabled) {
        [self bestDocumentFrameFinder:result i:image];
      }
    }
    
    //    if (self.videoSessionRunning) { // sending callbacks only if the session is still running here
    // processing is performed on video queue so forcing main queue
    if ([NSThread isMainThread]) {
      if (delegateReceivesResults) {
        [self.engineDelegate SmartIDEngineObtainedResult:result fromFrameWithBuffer:buffer];
      }
    } else {
      dispatch_sync(dispatch_get_main_queue(), ^{
        if (delegateReceivesResults) {
          [self.engineDelegate SmartIDEngineObtainedResult:result fromFrameWithBuffer:buffer];
        }
      });
    }
    //    }
  }
}

- (void) processLivenessFrameImage:(SECommonImageRef *)image
                        fromBuffer:(CMSampleBufferRef)buffer {
  if (self.videoSessionRunning) {
    SEIdFaceLivenessResult *faceResult = nil;
    
    @synchronized (self.videoSession) {
      [self.livenessSession addFaceImage:image];
      
      SEIdFaceLivenessResult* currentFaceResult = [self.livenessSession getLivenessResult];
      faceResult = currentFaceResult;
    }
    
    //    if (self.videoSessionRunning) { // sending callbacks only if the session is still running here
    // processing is performed on video queue so forcing main queue
    if ([NSThread isMainThread]) {
      if (delegateReceivesResults) {
        [self.livenessDelegate SmartLivenessObtainedResult:faceResult];
      }
    } else {
      dispatch_sync(dispatch_get_main_queue(), ^{
        if (delegateReceivesResults) {
          [self.livenessDelegate SmartLivenessObtainedResult:faceResult];
        }
      });
    }
    //    }
  }
}



- (void) processFrame:(CMSampleBufferRef)sampleBuffer
      withOrientation:(UIDeviceOrientation)deviceOrientation {
  if (self.videoSessionRunning) {
    int rotations = getRotationsByOrientation(deviceOrientation);
    
    SECommonImage* imageSource = [[SECommonImage alloc] initFromSampleBuffer:sampleBuffer];
    
    SECommonImageRef* image = [imageSource getMutableRef];
    if (rotations > 0) {
      [image rotate90:rotations];
    }
    [self processFrameImage:image fromBuffer:sampleBuffer];
  }
}

- (void) processFrame:(CMSampleBufferRef)sampleBuffer
      withOrientation:(UIDeviceOrientation)deviceOrientation
               andRoi:(CGRect)roi {
  if (self.videoSessionRunning) {
    int rotations = getRotationsByOrientation(deviceOrientation);
    
    SECommonImage* imageSource = [[SECommonImage alloc] initFromSampleBuffer:sampleBuffer];
    
    SECommonImageRef* image = [imageSource getMutableRef];
    if (rotations > 0) {
      [image rotate90:rotations];
    }
    
    SECommonRectangle* proxyRoi = [[SECommonRectangle alloc] initWithX:roi.origin.x
                                                                 withY:roi.origin.y
                                                             withWidth:roi.size.width
                                                            withHeight:roi.size.height];
    SECommonImage* croppedImage = [image cloneCroppedToRectangleShallow:proxyRoi];
    [self processFrameImage:[croppedImage getRef] fromBuffer:sampleBuffer];
  }
}

- (void) processLivenessFrame:(CMSampleBufferRef)sampleBuffer
              withOrientation:(UIDeviceOrientation)deviceOrientation {
    if (self.videoSessionRunning) {
        int rotations = getRotationsByOrientation(deviceOrientation);
        
        SECommonImage* imageSource = [[SECommonImage alloc] initFromSampleBuffer:sampleBuffer];
        
        SECommonImageRef* image = [imageSource getMutableRef];
        if (rotations > 0) {
            [image rotate90:rotations];
        }
        
        [self processLivenessFrameImage:image fromBuffer:sampleBuffer];
    }
}

- (void) processVauthFrameImage:(SECommonImageRef *)image
                     fromBuffer:(CMSampleBufferRef)buffer {
  
  if (self.videoSessionRunning) {
    SEIdResult* result = [[SEIdResult alloc] init];
    @synchronized (self.vauthSession) {
      NSDate *start = [NSDate date];
      [self.vauthSession processFrame:image];
      NSDate *end = [NSDate date];
      if ([self.vauthSession hasDocumentResult]) {
        SEIdResultRef* currentResult = [self.vauthSession getDocumentResult];
        
        // For measurement purposes
        if ([currentResult getDocumentType] != nil and self.isFirstFrame == YES) {
          self.isFirstFrame = NO;
          NSTimeInterval processFirstFrameTime = [end timeIntervalSinceDate:start];
          if (delegateReceivesProcessTime) {
            [self.engineDelegate SmartIDEngineDidProcessTime:processFirstFrameTime];
          }
          if ([self.engineDelegate respondsToSelector:@selector(SmartIDEngineDidProcessTime:)]) {
            [self.engineDelegate SmartIDEngineDidProcessTime:processFirstFrameTime];
          }
        }
        
        result = [currentResult clone];
        
        // Image frame
        if(_isBestImageFrameEnabled) {
          [self bestDocumentFrameFinder:result i:image];
        }
      }
      if ([[[self.vauthSession getCurrentInstruction] getInstructionCode] isEqualToString:@"finish"]) {
        [[result getMutableRef] setIsTerminalTo:YES];
      }
      
    }
    //    if (self.videoSessionRunning) { // sending callbacks only if the session is still running here
    // processing is performed on video queue so forcing main queue
    if ([NSThread isMainThread]) {
      if (delegateReceivesResults) {
        [self.vauthDelegate SmartIDVauthObtainedResult:result fromFrameWithBuffer:buffer];
      }
    } else {
      dispatch_sync(dispatch_get_main_queue(), ^{
        if (delegateReceivesResults) {
          [self.vauthDelegate SmartIDVauthObtainedResult:result fromFrameWithBuffer:buffer];
        }
      });
    }
    //    }
  }
}

- (void) processVauthFrame:(CMSampleBufferRef)sampleBuffer
      withOrientation:(UIDeviceOrientation)deviceOrientation
                    andRoi:(CGRect)roi {
  if (self.videoSessionRunning) {
    int rotations = getRotationsByOrientation(deviceOrientation);
    
    SECommonImage* imageSource = [[SECommonImage alloc] initFromSampleBuffer:sampleBuffer];
    
    SECommonImageRef* image = [imageSource getMutableRef];
    if (rotations > 0) {
      [image rotate90:rotations];
    }
    
    SECommonRectangle* proxyRoi = [[SECommonRectangle alloc] initWithX:roi.origin.x
                                                                 withY:roi.origin.y
                                                             withWidth:roi.size.width
                                                            withHeight:roi.size.height];
    SECommonImage* croppedImage = [image cloneCroppedToRectangleShallow:proxyRoi];
    [self processVauthFrameImage:[croppedImage getRef] fromBuffer:sampleBuffer];
  }
}


- (nonnull SEIdResult *) processSingleImage:(nonnull SECommonImageRef *)image {
  SEIdSession* imageSession = [self.engine spawnSessionWithSettings:self.sessionSettings
                                                      withSignature:self.signature
                                               withFeedbackReporter:nil];
  
  NSDate *start = [NSDate date];
  [imageSession processImage:image];
  NSDate *end = [NSDate date];
  NSTimeInterval processSingleImageTime = [end timeIntervalSinceDate:start];
  
  SEIdResultRef* currentResult = [imageSession getCurrentResult];
  SEIdResult* result = [currentResult clone];
  
  // for measurement purposes
  if (delegateReceivesProcessTime) {
    [self.engineDelegate SmartIDEngineDidProcessTime:processSingleImageTime];
  }
  if ([self.engineDelegate respondsToSelector:@selector(SmartIDEngineDidProcessTime:)]) {
    [self.engineDelegate SmartIDEngineDidProcessTime:processSingleImageTime];
  }
  
  // processing is performed on video queue so forcing main queue
  if ([NSThread isMainThread]) {
    if (delegateReceivesSingleImageResults) {
      [self.engineDelegate SmartIDEngineObtainedSingleImageResult:result];
    }
  } else {
    dispatch_sync(dispatch_get_main_queue(), ^{
      if (delegateReceivesResults) {
        [self.engineDelegate SmartIDEngineObtainedSingleImageResult:result];
      }
    });
  }
  return result;
}



- (nonnull SEIdResult *) processSingleImageFromFile:(nonnull NSString *)filePath {
  SECommonImage* image = [[SECommonImage alloc] initFromFile:filePath
                                                 withMaxSize:nil];
  return [self processSingleImage:[image getRef]];
}

- (nonnull SEIdResult*) processSingleImageFromUIImage:(nonnull UIImage *)image {
  SECommonImage* proxyImage = [[SECommonImage alloc] initFromUIImage:image];
  return [self processSingleImage:[proxyImage getRef]];
}

- (nonnull SEIdResult*) processData:(nonnull NSString *)data {
  [self.videoSession processData:data];
  SEIdResultRef* currentResult = [self.videoSession getCurrentResult];
  SEIdResult* result = [currentResult clone];
  return result;
}

- (SEIdFaceSimilarityResult *) compareFacesFromDocument:(nonnull SECommonImageRef *)photo
                                              andSelfie:(nonnull SECommonImageRef *)image {
  @try {
    SEIdFaceSessionSettings* face_settings = [engine createFaceSessionSettings];
    SEIdFaceSession* face_session = [engine spawnFaceSessionWithSettings:face_settings
                                                           withSignature:self.signature
                                                    withFeedbackReporter:nil];
    return [face_session getSimilarityBetweenFaceImage:photo andFaceImage:image];
  } @catch (NSException *exception) {
    NSLog(@"Exception thrown while comparing faces: %@", exception);
    return nil;
  };
}

- (nonnull SEIdResult*) processVauthData:(nonnull NSString *)data {
  [self.vauthSession processData:data];
  SEIdResultRef* currentResult = [self.vauthSession getDocumentResult];
  SEIdResult* result = [currentResult clone];
  return result;
}


#pragma mark - find best image frame

- (NSString*) getBestImageFrame {
  // reset
  _isBestImageFrameEnabled=NO;
  return _bestImageFrame;
}

- (void) findBestImageFrame {
  // reset the image frame string.
  // It may not be overridden in the current session?
  _bestImageFrame = @"";
  _frameImageTemplatesInfo = [[NSMutableDictionary alloc] init];
  _isBestImageFrameEnabled = YES;
}

- (void)bestDocumentFrameFinder:(SEIdResult *)result i:image {
  
  // This code checking that document template situated inside camera viewport
  // and save input preview image.
  
  // If template not found
  if([[result getRef] getTemplateDetectionResultsCount] == 0 ){
    @throw[NSException exceptionWithName:@"viewport" reason:@"The document not found" userInfo:nil];
  }
  
  Boolean isNewConfidenceBetter = true;
  
  // Check document templates
  for (int i = 0; i < [[result getRef] getTemplateDetectionResultsCount]; i++) {
    
    Boolean not_fully_presented = false;
    
    // Get template name
    NSString* templateName = [[[result getRef] getTemplateDetectionResultAt:i] getTemplateName];
    // Get template confidence - quality of the document detection
    double confidence = [[[result getRef] getTemplateDetectionResultAt:i] getConfidence];
    
    // Checking that document template outside viewport, not fully presented on image frame
    NSString* fully_presented = [[[result getRef] getTemplateDetectionResultAt:i]  getAttributeWithName:@"fully_presented"];
    if([fully_presented isEqualToString:@"false"]) {
      not_fully_presented = true;
    }
    
    // Set confidence to 0.0 if the points of a document quadrangle outside the viewport.
    if (not_fully_presented) {
      confidence = 0.0;
    }
    
    // Add new template to store if not exist.
    // Every new template will be update frameImage
    if ([_frameImageTemplatesInfo objectForKey:templateName]) {
      [_frameImageTemplatesInfo setValue:[NSNumber numberWithDouble: confidence] forKey:templateName];
      _bestImageFrame = [image getBase64String];
    }
    
    // Checking new confidence. We must update imageFrame if any confidence
    // from all templates will be higher than saved before.
    if (isNewConfidenceBetter) {
      double old_confidence = [[_frameImageTemplatesInfo objectForKey:templateName] doubleValue];
      
      if (old_confidence >= confidence) {
        isNewConfidenceBetter = false;
      }
    }
  }
  
  // Update imageFrame if confidence from all templates better than previous
  if (isNewConfidenceBetter) {
    
    // Update template confidences
    for (int i = 0; i < [[result getRef] getTemplateDetectionResultsCount]; i++) {
      
      NSString* templateName = [[[result getRef] getTemplateDetectionResultAt:i] getTemplateName];
      // Get template confidence - quality of the document detection
      double confidence = [[[result getRef] getTemplateDetectionResultAt:i] getConfidence];
      [_frameImageTemplatesInfo setValue:[NSNumber numberWithDouble: confidence] forKey:templateName];
      
    }
    // Update document_frame
    _bestImageFrame = [image getBase64String];
  }
}

@end

