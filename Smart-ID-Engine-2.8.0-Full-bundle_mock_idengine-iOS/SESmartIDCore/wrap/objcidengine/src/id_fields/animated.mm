/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_fields_impl.h>
#import <objcsecommon_impl/se_image_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <secommon/se_exception.h>

#import <memory>

@implementation SEIdAnimatedFieldRef {
  se::id::IdAnimatedField* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalAnimatedFieldPointer:(se::id::IdAnimatedField *)fieldptr
                                   withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = fieldptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdAnimatedField *) getInternalAnimatedFieldPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (SEIdAnimatedField *) clone {
  return [[SEIdAnimatedField alloc] initFromInternalAnimatedField:(*ptr)];
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

- (int) getFramesCount {
  return ptr->GetFramesCount();
}

- (SECommonImageRef *) getFrameAt:(int)index {
  try {
    return [[SECommonImageRef alloc] 
        initFromInternalImagePointer:const_cast<se::common::Image*>(&ptr->GetFrame(index))
                  withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) appendFrame:(SECommonImageRef *)frame {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->AppendFrame(*[frame getInternalImagePointer]);
  }
}

- (void) clearFrames {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->ClearFrames();
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


@implementation SEIdAnimatedField {
  std::unique_ptr<se::id::IdAnimatedField> internal;
}

- (instancetype) initFromInternalAnimatedField:(const se::id::IdAnimatedField &)field {
  if (self = [super init]) {
    internal.reset(new se::id::IdAnimatedField(field));
  }
  return self;
}

- (const se::id::IdAnimatedField &) getInternalAnimatedField {
  return *internal;
}

- (instancetype) init {
  if (self = [super init]) {
    internal.reset(new se::id::IdAnimatedField);
  }
  return self;
}

- (instancetype) initWithName:(NSString *)name
               withConfidence:(double)confidence
               withIsAccepted:(BOOL)is_accepted {
  if (self = [super init]) {
    try {
      internal.reset(new se::id::IdAnimatedField(
          [name UTF8String],
          YES == is_accepted,
          confidence));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (SEIdAnimatedFieldRef *) getRef {
  return [[SEIdAnimatedFieldRef alloc]
      initFromInternalAnimatedFieldPointer:internal.get()
                        withMutabilityFlag:NO];
}

- (SEIdAnimatedFieldRef *) getMutableRef {
  return [[SEIdAnimatedFieldRef alloc]
      initFromInternalAnimatedFieldPointer:internal.get()
                        withMutabilityFlag:YES];
}

@end


@implementation SEIdAnimatedFieldsMapIterator {
  std::unique_ptr<se::id::IdAnimatedFieldsMapIterator> internal;
}

- (instancetype) initFromInternalAnimatedFieldsMapIterator:(const se::id::IdAnimatedFieldsMapIterator &)iter {
  if (self = [super init]) {
    internal.reset(new se::id::IdAnimatedFieldsMapIterator(iter));
  }
  return self;
}

- (const se::id::IdAnimatedFieldsMapIterator &) getInternalAnimatedFieldsMapIterator {
  return *internal;
}

- (instancetype) initWithOther:(SEIdAnimatedFieldsMapIterator *)other {
  if (self = [super init]) {
    internal.reset(new se::id::IdAnimatedFieldsMapIterator([other getInternalAnimatedFieldsMapIterator]));
  }
  return self;
}


- (BOOL) isEqualToIter:(SEIdAnimatedFieldsMapIterator *)other {
  return internal->Equals([other getInternalAnimatedFieldsMapIterator])? YES : NO;
}

- (NSString *) getKey {
  return [NSString stringWithUTF8String:internal->GetKey()];
}

- (SEIdAnimatedFieldRef *) getValue {
  return [[SEIdAnimatedFieldRef alloc] 
      initFromInternalAnimatedFieldPointer:const_cast<se::id::IdAnimatedField*>(&internal->GetValue())
                        withMutabilityFlag:NO];
}

- (void) advance {
  internal->Advance();
}

@end
