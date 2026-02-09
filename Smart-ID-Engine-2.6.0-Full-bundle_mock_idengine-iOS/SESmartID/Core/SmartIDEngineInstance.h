/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#import <objcidengine/id_result.h>
#import <objcidengine/id_engine.h>

#import <objcsecommon/se_image.h>

@protocol SmartIDEngineInitializationDelegate <NSObject>
@optional
- (void) SmartIDEngineInitialized;
- (void) SmartIDEngineVideoSessionStarted;
- (void) SmartIDEngineVideoSessionDismissed;
- (void) SmartIDEngineDidActivationRequest:(nonnull NSString *)dynKey withCompletionHandler:(void (^_Nullable)(NSString* _Nullable  actKey))completion;
@end

@protocol SmartIDEngineDelegate <NSObject>
@optional
- (void) SmartIDEngineObtainedResult:(nonnull SEIdResult *)result;
- (void) SmartIDEngineObtainedDetectionResult:(nonnull SEIdTemplateDetectionResult *)result;
- (void) SmartIDEngineObtainedSegmentationResult:(nonnull SEIdTemplateSegmentationResult *)result;
- (void) SmartIDEngineObtainedFeedback:(nonnull SEIdFeedbackContainer *)feedback;

- (void) SmartIDEngineObtainedResult:(nonnull SEIdResult *)result
                 fromFrameWithBuffer:(nonnull CMSampleBufferRef)buffer;

- (void) SmartIDEngineObtainedSingleImageResult:(nonnull SEIdResult *)result;
- (void) SmartIDEngineDidProcessTime:(NSTimeInterval)processTime;
@end

@protocol SmartLivenessDelegate <NSObject>
@optional
- (void) SmartLivenessObtainedMessage:(nonnull NSString *)message;
- (void) SmartLivenessObtainedResult:(nonnull SEIdFaceLivenessResult *)result;
@end

@protocol SmartIDVauthDelegate <NSObject>
@optional
- (void) SmartIDVauthObtainedResult:(nullable SEIdResult *)result
                fromFrameWithBuffer:(nonnull CMSampleBufferRef)buffer;
- (void) SmartIDVauthObtainedDetectionResult:(nonnull SEIdTemplateDetectionResult *)result;
- (void) SmartIDVauthObtainedSegmentationResult:(nonnull SEIdTemplateSegmentationResult *)result;
- (void) SmartVauthObtainedInstruction:(nonnull NSString *)instruction;
- (void) SmartVauthSessionEnded;
@end


@interface SmartIDEngineInstance : NSObject

@property (weak, nonatomic, nullable, readonly) id<SmartIDEngineInitializationDelegate> initializationDelegate;
@property (weak, nonatomic, nullable, readonly) id<SmartIDEngineDelegate> engineDelegate;
@property (weak, nonatomic, nullable, readonly) id<SmartLivenessDelegate> livenessDelegate;
@property (weak, nonatomic, nullable, readonly) id<SmartIDVauthDelegate> vauthDelegate;

@property (strong, nullable, readonly) SEIdEngine* engine; // main configuration of Smart ID Engine
@property (strong, nullable, readonly) SEIdSession* videoSession; // current video recognition session
@property (strong, nullable, readonly) SEIdFaceSession* livenessSession; // current liveness recognition session
@property (strong, nullable, readonly) SEIdVideoAuthenticationSession* vauthSession; // current vauth recognition session
@property (strong, nullable) SEIdSessionSettings* sessionSettings; // current session settings
@property (strong, nullable) SEIdFaceSessionSettings* faceSessionSettings; // current face session settings
@property (strong, nullable) SEIdVideoAuthenticationSessionSettings* vauthSessionSettings; // current vauth session settings

// Best frame image finder section
@property (nonatomic, assign, readonly) BOOL isBestImageFrameEnabled;
@property (nonnull,readonly) NSString* bestImageFrame; // current image frame
@property (nonnull,readonly) NSMutableDictionary* frameImageTemplatesInfo;

- (nonnull NSString*) bestImageFrame;
- (void) findBestImageFrame;
- (nonnull NSString*) getBestImageFrame;

@property BOOL engineInitialized;
@property BOOL videoSessionRunning;

- (nonnull instancetype) initWithSignature:(nonnull NSString *)signature;
- (void) setInitializationDelegate:(nullable __weak id<SmartIDEngineInitializationDelegate>)delegate;
- (void) setEngineDelegate:(nullable __weak id<SmartIDEngineDelegate>)delegate;
- (void) setLivenessDelegate:(nullable __weak id<SmartLivenessDelegate>)delegate;
- (void) setVauthDelegate:(nullable __weak id<SmartIDVauthDelegate>)delegate;

- (void) resetSessionSettings;
- (void) initializeEngine:(nonnull NSString *)bundlePath;

- (void) initVideoSession;
- (void) initLivenessSession;
- (void) initVauthSession;

- (void) dismissVideoSession;
- (void) dismissLivenessSession;
- (void) dismissVauthSession;

- (void) dismissVideoSessionRunning;

- (void) processFrame:(nonnull CMSampleBufferRef)sampleBuffer
      withOrientation:(UIDeviceOrientation)deviceOrientation;

- (void) processFrame:(nonnull CMSampleBufferRef)sampleBuffer
      withOrientation:(UIDeviceOrientation)deviceOrientation
               andRoi:(CGRect)roi;

- (void) processLivenessFrame:(nonnull CMSampleBufferRef)sampleBuffer
      withOrientation:(UIDeviceOrientation)deviceOrientation;

- (void) processVauthFrame:(nonnull CMSampleBufferRef)sampleBuffer
      withOrientation:(UIDeviceOrientation)deviceOrientation
               andRoi:(CGRect)roi;

- (nonnull SEIdResult*) processSingleImage:(nonnull SECommonImageRef *)image;
- (nonnull SEIdResult*) processSingleImageFromFile:(nonnull NSString *)filePath;
- (nonnull SEIdResult*) processSingleImageFromUIImage:(nonnull UIImage *)image;

- (nonnull SEIdResult*) processData:(nonnull NSString *)data;
- (nonnull SEIdResult*) processVauthData:(nonnull NSString *)data;

- (nonnull SEIdFaceSimilarityResult *) compareFacesFromDocument:(nonnull SECommonImageRef *)photo
                                                      andSelfie:(nonnull SECommonImageRef *)image;
  
- (void) compareFacesAsyncFromDocument:(nonnull SECommonImage *)photo
                             andSelfie:(nonnull SECommonImage *)image
                 withCompletionHandler:(nullable void(^)(SEIdFaceSimilarityResult *_Nonnull))callback;

- (void) processSingleImageAsync:(nonnull UIImage *)image withCompletionHandler:(nullable void(^)(SEIdResult *_Nonnull))callback;

@end

