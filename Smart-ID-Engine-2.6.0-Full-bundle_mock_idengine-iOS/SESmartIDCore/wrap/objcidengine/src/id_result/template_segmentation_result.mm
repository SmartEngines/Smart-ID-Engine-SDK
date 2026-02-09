/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_result_impl.h>

#import <objcsecommon_impl/se_geometry_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <secommon/se_exception.h>
#include <idengine/id_result.h>

#include <memory>

@implementation SEIdTemplateSegmentationResultRef {
  se::id::IdTemplateSegmentationResult* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalTemplateSegmentationResultPointer:(se::id::IdTemplateSegmentationResult *)resptr
                                                withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = resptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdTemplateSegmentationResult *) getInternalTemplateSegmentationResultPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (SEIdTemplateSegmentationResult *) clone {
  return [[SEIdTemplateSegmentationResult alloc] initFromInternalTemplateSegmentationResult:(*ptr)];
}

- (BOOL) getIsAccepted {
  return ptr->GetIsAccepted()? YES : NO;
}

- (void) setIsAcceptedTo:(BOOL)is_accepted {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetIsAccepted(YES == is_accepted);
  }
}

- (double) getConfidence {
  return ptr->GetConfidence();
}

- (void) setConfidenceTo:(double)confidence {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetConfidence(confidence);
  }
}

- (int) getRawFieldsCount {
  return ptr->GetRawFieldsCount();
}

- (BOOL) hasRawFieldWithName:(NSString *)raw_field_name {
  return ptr->HasRawField([raw_field_name UTF8String])? YES : NO;
}

- (SECommonQuadrangle *) getRawFieldQuadrangleWithName:(NSString *)raw_field_name {
  try {
    return [[SECommonQuadrangle alloc] 
        initFromInternalQuadrangle:ptr->GetRawFieldQuadrangle([raw_field_name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SECommonQuadrangle *) getRawFieldTemplateQuadrangleWithName:(NSString *)raw_field_name {
  try {
    return [[SECommonQuadrangle alloc] 
        initFromInternalQuadrangle:ptr->GetRawFieldTemplateQuadrangle([raw_field_name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;  
}

- (void) setRawFieldQuadranglesForFieldWithName:(NSString *)raw_field_name
                                 withQuadrangle:(SECommonQuadrangle *)quadrangle
                         withTemplateQuadrangle:(SECommonQuadrangle *)template_quadrangle {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetRawFieldQuadrangles(
        [raw_field_name UTF8String],
        [quadrangle getInternalQuadrangle],
        [template_quadrangle getInternalQuadrangle]);
  }
}

- (void) removeRawFieldWithName:(NSString *)raw_field_name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveRawField([raw_field_name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SECommonQuadranglesMapIterator *) rawFieldQuadranglesBegin {
  return [[SECommonQuadranglesMapIterator alloc] 
      initFromInternalQuadranglesMapIterator:ptr->RawFieldQuadranglesBegin()];
}

- (SECommonQuadranglesMapIterator *) rawFieldQuadranglesEnd {
  return [[SECommonQuadranglesMapIterator alloc] 
      initFromInternalQuadranglesMapIterator:ptr->RawFieldQuadranglesEnd()];
}

- (SECommonQuadranglesMapIterator *) rawFieldTemplateQuadranglesBegin {
  return [[SECommonQuadranglesMapIterator alloc] 
      initFromInternalQuadranglesMapIterator:ptr->RawFieldTemplateQuadranglesBegin()];
}

- (SECommonQuadranglesMapIterator *) rawFieldTemplateQuadranglesEnd {
  return [[SECommonQuadranglesMapIterator alloc] 
      initFromInternalQuadranglesMapIterator:ptr->RawFieldTemplateQuadranglesEnd()];
}

@end

@implementation SEIdTemplateSegmentationResult {
  std::unique_ptr<se::id::IdTemplateSegmentationResult> internal;
}

- (instancetype) initFromInternalTemplateSegmentationResult:(const se::id::IdTemplateSegmentationResult &)res {
  if (self = [super init]) {
    internal.reset(new se::id::IdTemplateSegmentationResult(res));
  }
  return self;
}

- (const se::id::IdTemplateSegmentationResult &) getInternalTemplateSegmentationResult {
  return *internal;
}

- (instancetype) initWithConfidence:(double)confidence
                     withIsAccepted:(BOOL)is_accepted {
  if (self = [super init]) {
    internal.reset(new se::id::IdTemplateSegmentationResult(
        YES == is_accepted,
        confidence));
  }
  return self;
}

- (SEIdTemplateSegmentationResultRef *) getRef {
  return [[SEIdTemplateSegmentationResultRef alloc]
      initFromInternalTemplateSegmentationResultPointer:internal.get()
                                     withMutabilityFlag:NO];
}

- (SEIdTemplateSegmentationResultRef *) getMutableRef {
  return [[SEIdTemplateSegmentationResultRef alloc]
      initFromInternalTemplateSegmentationResultPointer:internal.get()
                                     withMutabilityFlag:YES];
}

@end
