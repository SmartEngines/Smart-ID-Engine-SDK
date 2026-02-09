/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_FACE_SESSION_H_INCLUDED
#define OBJCIDENGINE_ID_FACE_SESSION_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcidengine/id_face_result.h>

#import <objcsecommon/se_image.h>

@interface SEIdFaceSession : NSObject

- (nonnull NSString *) getActivationRequest;
- (void) activate:(nonnull NSString *)activation_response;

- (BOOL) isActivated;

- (nonnull SEIdFaceSimilarityResult *) getSimilarityBetweenFaceImage:(nonnull SECommonImageRef *)face_image_a
                                                        andFaceImage:(nonnull SECommonImageRef *)face_image_b;

- (void) addFaceImage:(nonnull SECommonImageRef *)face_image;



- (nonnull SEIdFaceSimilarityResult *) getSimilarityWithFaceImage:(nonnull SECommonImageRef *)compare_image;

- (nonnull SEIdFaceLivenessResult *) getLivenessResult;

- (void) reset;

@end

#endif // OBJCIDENGINE_ID_FACE_SESSION_H_INCLUDED
