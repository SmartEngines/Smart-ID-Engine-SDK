/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_fields_impl.h>
#import <objcsecommon_impl/se_image_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <secommon/se_exception.h>

#import <memory>

@implementation SEIdImageFieldRef {
  se::id::IdImageField* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalImageFieldPointer:(se::id::IdImageField *)fieldptr
                                withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = fieldptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdImageField *) getInternalImageFieldPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (SEIdImageField *) clone {
  return [[SEIdImageField alloc] initFromInternalImageField:(*ptr)];
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

- (SECommonImageRef *) getValue {
  return [[SECommonImageRef alloc] 
      initFromInternalImagePointer:const_cast<se::common::Image*>(&ptr->GetValue())
                withMutabilityFlag:NO];
}

- (void) setValueTo:(SECommonImageRef *)value {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetValue(*[value getInternalImagePointer]);
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


@implementation SEIdImageField {
  std::unique_ptr<se::id::IdImageField> internal;
}

- (instancetype) initFromInternalImageField:(const se::id::IdImageField &)field {
  if (self = [super init]) {
    internal.reset(new se::id::IdImageField(field));
  }
  return self;
}

- (const se::id::IdImageField &) getInternalImageField {
  return *internal;
}

- (instancetype) init {
  if (self = [super init]) {
    internal.reset(new se::id::IdImageField);
  }
  return self;
}

- (instancetype) initWithName:(NSString *)name
                    withImage:(SECommonImageRef *)image
               withConfidence:(double)confidence
               withIsAccepted:(BOOL)is_accepted {
  if (self = [super init]) {
    try {
      internal.reset(new se::id::IdImageField(
          [name UTF8String],
          *[image getInternalImagePointer],
          is_accepted == true,
          confidence));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (SEIdImageFieldRef *) getRef {
  return [[SEIdImageFieldRef alloc]
      initFromInternalImageFieldPointer:internal.get()
                     withMutabilityFlag:NO];
}

- (SEIdImageFieldRef *) getMutableRef {
  return [[SEIdImageFieldRef alloc]
      initFromInternalImageFieldPointer:internal.get()
                     withMutabilityFlag:YES];
}

@end


@implementation SEIdImageFieldsMapIterator {
  std::unique_ptr<se::id::IdImageFieldsMapIterator> internal;
}

- (instancetype) initFromInternalImageFieldsMapIterator:(const se::id::IdImageFieldsMapIterator &)iter {
  if (self = [super init]) {
    internal.reset(new se::id::IdImageFieldsMapIterator(iter));
  }
  return self;
}

- (const se::id::IdImageFieldsMapIterator &) getInternalImageFieldsMapIterator {
  return *internal;
}

- (instancetype) initWithOther:(SEIdImageFieldsMapIterator *)other {
  if (self = [super init]) {
    internal.reset(new se::id::IdImageFieldsMapIterator([other getInternalImageFieldsMapIterator]));
  }
  return self;
}

- (BOOL) isEqualToIter:(SEIdImageFieldsMapIterator *)other {
  return internal->Equals([other getInternalImageFieldsMapIterator])? YES : NO;
}

- (NSString *) getKey {
  return [NSString stringWithUTF8String:internal->GetKey()];
}

- (SEIdImageFieldRef *) getValue {
  return [[SEIdImageFieldRef alloc] 
      initFromInternalImageFieldPointer:const_cast<se::id::IdImageField*>(&internal->GetValue())
                     withMutabilityFlag:NO];
}

- (void) advance {
  internal->Advance();
}

@end
