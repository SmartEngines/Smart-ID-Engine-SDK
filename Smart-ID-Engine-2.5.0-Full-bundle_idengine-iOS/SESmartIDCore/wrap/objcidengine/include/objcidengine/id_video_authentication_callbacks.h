/*
  Copyright (c) 2016-2021, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_VIDEO_AUTHENTICATION_CALLBACKS_H_INCLUDED
#define OBJCIDENGINE_ID_VIDEO_AUTHENTICATION_CALLBACKS_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcidengine/id_video_authentication_result.h>
#import <objcidengine/id_result.h>
#import <objcidengine/id_fields.h>
#import <objcidengine/id_face_result.h>

@protocol SEIdVideoAuthenticationCallbacks <NSObject>

@optional

- (void) instructionReceived:(nonnull SEIdVideoAuthenticationInstructionRef *)instruction
                atFrameIndex:(int)index;
- (void) anomalyRegistered:(nonnull SEIdVideoAuthenticationAnomalyRef *)anomaly
              atFrameIndex:(int)index;

- (void) documentResultUpdatedTo:(nonnull SEIdResultRef *)document_result;
- (void) faceMatchingResultUpdatedTo:(nonnull SEIdFaceSimilarityResultRef *)face_matching_result;
- (void) faceLivenessResultUpdatedTo:(nonnull SEIdFaceLivenessResultRef *)face_liveness_result;

- (void) authenticationStatusUpdatedTo:(SEIdCheckStatus)status;
- (void) globalTimeoutReached;
- (void) instructionTimeoutReached;

- (void) sessionEnded;

- (void) messageReceived:(nonnull NSString *)message;

@end

#endif // OBJCIDENGINE_ID_VIDEO_AUTHENTICATION_CALLBACKS_H_INCLUDED