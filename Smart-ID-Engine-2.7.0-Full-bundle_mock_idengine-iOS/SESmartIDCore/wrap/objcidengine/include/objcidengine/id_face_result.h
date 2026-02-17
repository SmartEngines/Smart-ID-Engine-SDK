/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_FACE_RESULT_H_INCLUDED
#define OBJCIDENGINE_ID_FACE_RESULT_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcsecommon/se_geometry.h>
#import <objcsecommon/se_image.h>

typedef enum { 
  SEIdFaceOrientation_0,
  SEIdFaceOrientation_90CW,
  SEIdFaceOrientation_180,
  SEIdFaceOrientation_270CW
} SEIdFaceOrientation;

typedef enum { 
  SEIdFaceStatus_NotUsed,
  SEIdFaceStatus_Success,
  SEIdFaceStatus_A_FaceNotFound,
  SEIdFaceStatus_B_FaceNotFound,
  SEIdFaceStatus_FaceNotFound,
  SEIdFaceStatus_NoAccumulatedResult
} SEIdFaceStatus;

typedef enum {
  SEDifferent,
  SEUncertain,
  SESame
} SEIdFaceSimilarity;


@class SEIdFaceLivenessResult;

@interface SEIdFaceLivenessResultRef : NSObject

- (BOOL) isMutable;

- (nonnull SEIdFaceLivenessResult *) clone;

- (double) getLivenessEstimation;
- (void) setLivenessEstimationTo:(double)estimation;

- (nonnull NSString *) getLivenessInstruction;
- (void) setLivenessInstructionTo:(nonnull NSString *)instruction;

@end


@interface SEIdFaceLivenessResult : NSObject

- (nonnull instancetype) init;
- (nonnull instancetype) initWithLivenessEstimation:(double)estimation;

- (nonnull SEIdFaceLivenessResultRef *) getRef;
- (nonnull SEIdFaceLivenessResultRef *) getMutableRef;

@end


@class SEIdFaceSimilarityResult;

@interface SEIdFaceSimilarityResultRef : NSObject

- (BOOL) isMutable;

- (nonnull SEIdFaceSimilarityResult *) clone;

- (double) getSimilarityEstimation;
- (SEIdFaceSimilarity) getSimilarity;
- (void) setSimilarityEstimationTo:(double)estimation;

- (SEIdFaceStatus) getStatus;
- (void) setStatus:(SEIdFaceStatus)status;

@end

@interface SEIdFaceSimilarityResult : NSObject
  
- (nonnull instancetype) init;
- (nonnull instancetype) initWithSimilarityEstimation:(double)estimation;
- (nonnull instancetype) initWithFaceStatus:(SEIdFaceStatus)status;
- (nonnull instancetype) initWithSimilarityEstimation:(double)estimation
                         withFaceStatus:(SEIdFaceStatus)status;

- (nonnull SEIdFaceSimilarityResultRef *) getRef;
- (nonnull SEIdFaceSimilarityResultRef *) getMutableRef;

@end

#endif // OBJCIDENGINE_ID_FACE_RESULT_H_INCLUDED
