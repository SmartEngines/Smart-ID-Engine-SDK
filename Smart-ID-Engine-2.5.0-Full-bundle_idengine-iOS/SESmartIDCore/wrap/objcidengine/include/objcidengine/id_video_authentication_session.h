/*
  Copyright (c) 2016-2021, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_VIDEO_AUTHENTICATION_SESSION_H_INCLUDED
#define OBJCIDENGINE_ID_VIDEO_AUTHENTICATION_SESSION_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcidengine/id_video_authentication_result.h>
#import <objcidengine/id_result.h>
#import <objcidengine/id_fields.h>
#import <objcidengine/id_face_result.h>

#import <objcsecommon/se_image.h>

@interface SEIdVideoAuthenticationSession : NSObject

- (nonnull NSString *) getActivationRequest;
- (void) activate:(nonnull NSString *)activation_response;

- (BOOL) isActivated;

- (void) processFrame:(nonnull SECommonImageRef *)frame;

- (void) processData:(nonnull NSString *)dataStr;

- (nonnull SEIdVideoAuthenticationInstructionRef *) getCurrentInstruction;

- (BOOL) hasDocumentResult;
- (nonnull SEIdResultRef *) getDocumentResult;

- (BOOL) hasFaceMatchingResult;
- (nonnull SEIdFaceSimilarityResultRef *) getFaceMatchingResult;

- (BOOL) hasFaceLivenessResult;
- (nonnull SEIdFaceLivenessResultRef *) getFaceLivenessResult;

- (SEIdCheckStatus) getAuthenticationStatus;

- (nonnull SEIdVideoAuthenticationTranscriptRef *) getTranscript;

- (void) suspend;
- (void) resume;
- (void) reset;

@end

#endif // OBJCIDENGINE_ID_VIDEO_AUTHENTICATION_SESSION_H_INCLUDED