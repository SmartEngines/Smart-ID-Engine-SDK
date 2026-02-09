/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_fields_impl.h>
#import <objcsecommon_impl/se_strings_iterator_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <secommon/se_exception.h>

#include <memory>

@implementation SEIdBaseFieldInfoRef {
  se::id::IdBaseFieldInfo* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalBaseFieldInfoPointer:(se::id::IdBaseFieldInfo *)infoptr
                                   withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = infoptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdBaseFieldInfo *) getInternalBaseFieldInfoPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (SEIdBaseFieldInfo *) clone {
  return [[SEIdBaseFieldInfo alloc] initFromInternalBaseFieldInfo:(*ptr)];
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
    try {
      ptr->SetConfidence(confidence);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
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


@implementation SEIdBaseFieldInfo {
  std::unique_ptr<se::id::IdBaseFieldInfo> internal;
}

- (instancetype) initFromInternalBaseFieldInfo:(const se::id::IdBaseFieldInfo &)info {
  if (self = [super init]) {
    internal.reset(new se::id::IdBaseFieldInfo(info));
  }
  return self;
}

- (const se::id::IdBaseFieldInfo &) getInternalBaseFieldInfo {
  return *internal;
}

- (instancetype) init {
  if (self = [super init]) {
    internal.reset(new se::id::IdBaseFieldInfo);
  }
  return self;
}

- (instancetype) initWithConfidence:(double)confidence
                     withIsAccepted:(BOOL)is_accepted {
  if (self = [super init]) {
    try {
      internal.reset(new se::id::IdBaseFieldInfo(confidence, is_accepted == true));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (SEIdBaseFieldInfoRef *) getRef {
  return [[SEIdBaseFieldInfoRef alloc] 
      initFromInternalBaseFieldInfoPointer:internal.get() 
                        withMutabilityFlag:NO];
}

- (SEIdBaseFieldInfoRef *) getMutableRef {
  return [[SEIdBaseFieldInfoRef alloc] 
      initFromInternalBaseFieldInfoPointer:internal.get() 
                        withMutabilityFlag:YES];
}

@end
