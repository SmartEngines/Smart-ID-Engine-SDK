/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_fields_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <secommon/se_exception.h>

#import <memory>

se::id::IdCheckStatus status_e2i(SEIdCheckStatus s) {
  switch(s) {
    case SEIdCheckStatus_Undefined:
      return se::id::IdCheckStatus_Undefined;
    case SEIdCheckStatus_Passed:
      return se::id::IdCheckStatus_Passed;
    case SEIdCheckStatus_Failed:
      return se::id::IdCheckStatus_Failed;
  }
  return se::id::IdCheckStatus_Undefined;
}

SEIdCheckStatus status_i2e(se::id::IdCheckStatus s) {
  switch(s) {
    case se::id::IdCheckStatus_Undefined:
      return SEIdCheckStatus_Undefined;
    case se::id::IdCheckStatus_Passed:
      return SEIdCheckStatus_Passed;
    case se::id::IdCheckStatus_Failed:
      return SEIdCheckStatus_Failed;
  }
  return SEIdCheckStatus_Undefined;
}

@implementation SEIdCheckFieldRef {
  se::id::IdCheckField* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalCheckFieldPointer:(se::id::IdCheckField *)fieldptr
                                withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = fieldptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdCheckField *) getInternalCheckFieldPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (nonnull SEIdCheckField *) clone {
  return [[SEIdCheckField alloc] initFromInternalCheckField:(*ptr)];
}

- (NSString *) getName {
  return [NSString stringWithUTF8String:ptr->GetName()];
}

- (void) setNameTo:(NSString *)name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetName([name UTF8String]);
  }
}

- (SEIdCheckStatus) getValue {
  return status_i2e(ptr->GetValue());
}

- (void) setValueTo:(SEIdCheckStatus)value {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetValue(status_e2i(value));
  }
}

- (SEIdBaseFieldInfoRef *) getBaseFieldInfo {
  return [[SEIdBaseFieldInfoRef alloc] 
      initFromInternalBaseFieldInfoPointer:const_cast<se::id::IdBaseFieldInfo*>(&ptr->GetBaseFieldInfo())
                        withMutabilityFlag:NO];
}

- (SEIdBaseFieldInfoRef *) getMutableBaseFieldInfo {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    return [[SEIdBaseFieldInfoRef alloc] 
        initFromInternalBaseFieldInfoPointer:&ptr->GetMutableBaseFieldInfo()
                          withMutabilityFlag:YES];
  }
  return nil;
}

@end


@implementation SEIdCheckField {
  std::unique_ptr<se::id::IdCheckField> internal;
}

- (instancetype) initFromInternalCheckField:(const se::id::IdCheckField &)field {
  if (self = [super init]) {
    internal.reset(new se::id::IdCheckField(field));
  }
  return self;
}

- (const se::id::IdCheckField &) getInternalCheckField {
  return *internal;
}

- (instancetype) init {
  if (self = [super init]) {
    internal.reset(new se::id::IdCheckField);
  }
  return self;
}

- (instancetype) initWithName:(NSString *)name
                   withStatus:(SEIdCheckStatus)status
               withConfidence:(double)confidence
               withIsAccepted:(BOOL)is_accepted {
  if (self = [super init]) {
    try {
      internal.reset(new se::id::IdCheckField(
          [name UTF8String],
          status_e2i(status),
          YES == is_accepted,
          confidence));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (SEIdCheckFieldRef *) getRef {
  return [[SEIdCheckFieldRef alloc]
      initFromInternalCheckFieldPointer:internal.get()
                     withMutabilityFlag:NO];
}

- (SEIdCheckFieldRef *) getMutableRef {
  return [[SEIdCheckFieldRef alloc]
      initFromInternalCheckFieldPointer:internal.get()
                     withMutabilityFlag:YES];
}

@end


@implementation SEIdCheckFieldsMapIterator {
  std::unique_ptr<se::id::IdCheckFieldsMapIterator> internal;
}

- (instancetype) initFromInternalCheckFieldsMapIterator:(const se::id::IdCheckFieldsMapIterator &)iter {
  if (self = [super init]) {
    internal.reset(new se::id::IdCheckFieldsMapIterator(iter));
  }
  return self;
}

- (const se::id::IdCheckFieldsMapIterator &) getInternalCheckFieldsMapIterator {
  return *internal;
}

- (instancetype) initWithOther:(SEIdCheckFieldsMapIterator *)other {
  if (self = [super init]) {
    internal.reset(new se::id::IdCheckFieldsMapIterator([other getInternalCheckFieldsMapIterator]));
  }
  return self;
}


- (BOOL) isEqualToIter:(SEIdCheckFieldsMapIterator *)other {
  return internal->Equals([other getInternalCheckFieldsMapIterator])? YES : NO;
}

- (NSString *) getKey {
  return [NSString stringWithUTF8String:internal->GetKey()];
}

- (SEIdCheckFieldRef *) getValue {
  return [[SEIdCheckFieldRef alloc] 
      initFromInternalCheckFieldPointer:const_cast<se::id::IdCheckField*>(&internal->GetValue())
                     withMutabilityFlag:NO];
}

- (void) advance {
  internal->Advance();
}

@end
