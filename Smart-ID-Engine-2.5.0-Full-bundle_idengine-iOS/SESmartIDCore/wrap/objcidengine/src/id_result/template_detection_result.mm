/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_result_impl.h>

#import <objcsecommon_impl/se_geometry_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>
#import <objcsecommon_impl/se_strings_iterator_impl.h>

#include <idengine/id_result.h>

#include <memory>

@implementation SEIdTemplateDetectionResultRef {
  se::id::IdTemplateDetectionResult* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalTemplateDetectionResultPointer:(se::id::IdTemplateDetectionResult *)resptr
                                             withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = resptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdTemplateDetectionResult *) getInternalTemplateDetectionResultPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (SEIdTemplateDetectionResult *) clone {
  return [[SEIdTemplateDetectionResult alloc] initFromInternalTemplateDetectionResult:(*ptr)];
}

- (NSString *) getTemplateName {
  return [NSString stringWithUTF8String:ptr->GetTemplateName()];
}

- (void) setTemplateNameTo:(NSString *)name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetTemplateName([name UTF8String]);
  }
}

- (SECommonQuadrangle *) getQuadrangle {
  return [[SECommonQuadrangle alloc] 
      initFromInternalQuadrangle:ptr->GetQuadrangle()];
}

- (void) setQuadrangleTo:(SECommonQuadrangle *)quadrangle {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetQuadrangle([quadrangle getInternalQuadrangle]);  
  }
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

- (SECommonSize *) getStandardSize {
  return [[SECommonSize alloc] 
      initFromInternalSize:ptr->GetStandardSize()];
}

- (void) setStandardSizeTo:(SECommonSize *)standard_size {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetStandardSize([standard_size getInternalSize]);
  }
}

- (int) getAttributesCount {
  return ptr->GetAttributesCount();
}

- (NSString *) getAttributeWithName:(NSString *)attr_name {
  try {
    return [NSString stringWithUTF8String:ptr->GetAttribute([attr_name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (BOOL) hasAttributeWithName:(NSString *)attr_name {
  return ptr->HasAttribute([attr_name UTF8String])? YES : NO;
}

- (void) setAttributeWithName:(NSString *)attr_name
                           to:(NSString *)attr_value {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetAttribute([attr_name UTF8String], [attr_value UTF8String]);
  }
}

- (void) removeAttributeWithName:(NSString *)attr_name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveAttribute([attr_name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SECommonStringsMapIterator *) attributesBegin {
  return [[SECommonStringsMapIterator alloc]
      initFromInternalStringsMapIterator:ptr->AttributesBegin()];
}

- (SECommonStringsMapIterator *) attributesEnd {
  return [[SECommonStringsMapIterator alloc]
      initFromInternalStringsMapIterator:ptr->AttributesEnd()];
}

@end

@implementation SEIdTemplateDetectionResult {
  std::unique_ptr<se::id::IdTemplateDetectionResult> internal;
}

- (instancetype) initFromInternalTemplateDetectionResult:(const se::id::IdTemplateDetectionResult &)res {
  if (self = [super init]) {
    internal.reset(new se::id::IdTemplateDetectionResult(res));
  }
  return self;
}

- (const se::id::IdTemplateDetectionResult &) getInternalTemplateDetectionResult {
  return *internal;
}

- (instancetype) initWithName:(NSString *)name 
               withQuadrangle:(SECommonQuadrangle *)quadrangle
               withConfidence:(double)confidence
               withIsAccepted:(BOOL)is_accepted
             withStandardSize:(SECommonSize *)standard_size {
  if (self = [super init]) {
    se::common::Size internal_standard_size;
    if (standard_size) {
      internal_standard_size = [standard_size getInternalSize];
    }
    internal.reset(new se::id::IdTemplateDetectionResult(
        [name UTF8String],
        [quadrangle getInternalQuadrangle],
        YES == is_accepted,
        confidence,
        internal_standard_size));
  }
  return self;
}

- (SEIdTemplateDetectionResultRef *) getRef {
  return [[SEIdTemplateDetectionResultRef alloc]
      initFromInternalTemplateDetectionResultPointer:internal.get()
                                  withMutabilityFlag:NO];
}

- (SEIdTemplateDetectionResultRef *) getMutableRef {
  return [[SEIdTemplateDetectionResultRef alloc]
      initFromInternalTemplateDetectionResultPointer:internal.get()
                                  withMutabilityFlag:YES];
}

@end
