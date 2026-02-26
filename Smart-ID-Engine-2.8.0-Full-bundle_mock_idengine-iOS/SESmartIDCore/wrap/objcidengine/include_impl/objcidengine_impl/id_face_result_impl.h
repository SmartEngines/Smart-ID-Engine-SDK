/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_FACE_RESULT_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_FACE_RESULT_H_INCLUDED

#import <objcidengine/id_face_result.h>

#include <idengine/id_face_result.h>

@interface SEIdFaceLivenessResultRef (Internal)

- (instancetype) initFromInternalFaceLivenessResultPointer:(se::id::IdFaceLivenessResult *)resptr
                                        withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdFaceLivenessResult *) getInternalFaceLivenessResultPointer;

@end

@interface SEIdFaceLivenessResult (Internal)

- (instancetype) initFromInternalFaceLivenessResult:(const se::id::IdFaceLivenessResult &)res;
- (const se::id::IdFaceLivenessResult &) getInternalFaceLivenessResult;

@end


@interface SEIdFaceSimilarityResultRef (Internal)

- (instancetype) initFromInternalFaceSimilarityResultPointer:(se::id::IdFaceSimilarityResult *)resptr
                                          withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdFaceSimilarityResult *) getInternalFaceSimilarityResultPointer;

@end

@interface SEIdFaceSimilarityResult (Internal)

- (instancetype) initFromInternalFaceSimilarityResult:(const se::id::IdFaceSimilarityResult &)res;
- (const se::id::IdFaceSimilarityResult &) getInternalFaceSimilarityResult;

@end

#endif // OBJCIDENGINE_IMPL_ID_FACE_RESULT_H_INCLUDED
