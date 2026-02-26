/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_fields_impl.h>
#import <objcsecommon_impl/se_string_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <secommon/se_exception.h>

#import <memory>

@implementation SEIdTextFieldRef {
  se::id::IdTextField* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalTextFieldPointer:(se::id::IdTextField *)fieldptr
                               withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = fieldptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdTextField *) getInternalTextFieldPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (SEIdTextField *) clone {
  return [[SEIdTextField alloc] initFromInternalTextField:(*ptr)];
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

- (SECommonOcrString *) getValue {
  return [[SECommonOcrString alloc] 
      initFromInternalOcrString:ptr->GetValue()];
}

- (void) setValueTo:(SECommonOcrString *)value {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetValue([value getInternalOcrString]);
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


@implementation SEIdTextField {
  std::unique_ptr<se::id::IdTextField> internal;
}

- (instancetype) initFromInternalTextField:(const se::id::IdTextField &)field {
  if (self = [super init]) {
    internal.reset(new se::id::IdTextField(field));
  }
  return self;
}

- (const se::id::IdTextField &) getInternalTextField {
  return *internal;
}

- (instancetype) init {
  if (self = [super init]) {
    internal.reset(new se::id::IdTextField);
  }
  return self;
}

- (instancetype) initWithName:(NSString *)name
                withOcrString:(SECommonOcrString *)ostr
               withConfidence:(double)confidence
               withIsAccepted:(BOOL)is_accepted {
  if (self = [super init]) {
    try {
      internal.reset(new se::id::IdTextField(
          [name UTF8String],
          [ostr getInternalOcrString],
          YES == is_accepted,
          confidence));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (SEIdTextFieldRef *) getRef {
  return [[SEIdTextFieldRef alloc] 
      initFromInternalTextFieldPointer:internal.get()
                    withMutabilityFlag:NO];
}

- (SEIdTextFieldRef *) getMutableRef {
  return [[SEIdTextFieldRef alloc] 
      initFromInternalTextFieldPointer:internal.get()
                    withMutabilityFlag:YES];
}

@end


@implementation SEIdTextFieldsMapIterator {
  std::unique_ptr<se::id::IdTextFieldsMapIterator> internal;
}

- (instancetype) initFromInternalTextFieldsMapIterator:(const se::id::IdTextFieldsMapIterator &)iter {
  if (self = [super init]) {
    internal.reset(new se::id::IdTextFieldsMapIterator(iter));
  }
  return self;
}

- (const se::id::IdTextFieldsMapIterator &) getInternalTextFieldsMapIterator {
  return *internal;
}

- (instancetype) initWithOther:(SEIdTextFieldsMapIterator *)other {
  if (self = [super init]) {
    internal.reset(new se::id::IdTextFieldsMapIterator([other getInternalTextFieldsMapIterator]));
  }
  return self;
}


- (BOOL) isEqualToIter:(SEIdTextFieldsMapIterator *)other {
  return internal->Equals([other getInternalTextFieldsMapIterator])? YES : NO;
}

- (NSString *) getKey {
  return [NSString stringWithUTF8String:internal->GetKey()];
}

- (SEIdTextFieldRef *) getValue {
  return [[SEIdTextFieldRef alloc] 
      initFromInternalTextFieldPointer:const_cast<se::id::IdTextField*>(&internal->GetValue())
                    withMutabilityFlag:NO];
}

- (void) advance {
  internal->Advance();
}

@end
