/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_RESULT_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_RESULT_H_INCLUDED

#import <objcidengine/id_result.h>

#include <idengine/id_result.h>

@interface SEIdTemplateDetectionResultRef (Internal)

- (instancetype) initFromInternalTemplateDetectionResultPointer:(se::id::IdTemplateDetectionResult *)resptr
                                             withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdTemplateDetectionResult *) getInternalTemplateDetectionResultPointer;

@end

@interface SEIdTemplateDetectionResult (Internal)

- (instancetype) initFromInternalTemplateDetectionResult:(const se::id::IdTemplateDetectionResult &)res;
- (const se::id::IdTemplateDetectionResult &) getInternalTemplateDetectionResult;

@end


@interface SEIdTemplateSegmentationResultRef (Internal)

- (instancetype) initFromInternalTemplateSegmentationResultPointer:(se::id::IdTemplateSegmentationResult *)resptr
                                                withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdTemplateSegmentationResult *) getInternalTemplateSegmentationResultPointer;

@end

@interface SEIdTemplateSegmentationResult (Internal)

- (instancetype) initFromInternalTemplateSegmentationResult:(const se::id::IdTemplateSegmentationResult &)res;
- (const se::id::IdTemplateSegmentationResult &) getInternalTemplateSegmentationResult;

@end


@interface SEIdResultRef (Internal) 

- (instancetype) initFromInternalResultPointer:(se::id::IdResult *)resptr
                            withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdResult *) getInternalResultPointer;

@end

@interface SEIdResult (Internal)

- (instancetype) initFromInternalResult:(const se::id::IdResult &)res;
- (const se::id::IdResult &) getInternalResult;

@end

#endif // OBJCIDENGINE_IMPL_ID_RESULT_H_INCLUDED