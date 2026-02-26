/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_video_authentication_result.h>

#import <objcidengine_impl/id_fields_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <memory>

@implementation SEIdVideoAuthenticationAnomalyRef {
  se::id::IdVideoAuthenticationAnomaly* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalVideoAuthenticationAnomalyPointer:(se::id::IdVideoAuthenticationAnomaly *)anomaly_ptr
                                               withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = anomaly_ptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdVideoAuthenticationAnomaly *) getInternalVideoAuthenticationAnomalyPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (SEIdVideoAuthenticationAnomaly *) clone {
  return [[SEIdVideoAuthenticationAnomaly alloc]
      initFromInternalVideoAuthenticationAnomaly:(*ptr)];
}

- (NSString *) getName {
  return [NSString stringWithUTF8String:ptr->GetName()];
}

- (void) setNameTo:(NSString *)name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetName([name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (int) getStartFrame {
  return ptr->GetStartFrame();
}

- (void) setStartFrameTo:(int)start_frame {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetStartFrame(start_frame);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (int) getEndFrame {
  return ptr->GetEndFrame();
}

- (void) setEndFrameTo:(int)end_frame {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetEndFrame(end_frame);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SEIdBaseFieldInfoRef *) getBaseFieldInfo {
  return [[SEIdBaseFieldInfoRef alloc]
      initFromInternalBaseFieldInfoPointer:const_cast<se::id::IdBaseFieldInfo*>(&ptr->GetBaseFieldInfo())
                        withMutabilityFlag:NO];
}

- (SEIdBaseFieldInfoRef *) getMutableBaseFieldInfo {
  return [[SEIdBaseFieldInfoRef alloc]
      initFromInternalBaseFieldInfoPointer:&ptr->GetMutableBaseFieldInfo()
                        withMutabilityFlag:YES];
}

@end


@implementation SEIdVideoAuthenticationAnomaly {
  std::unique_ptr<se::id::IdVideoAuthenticationAnomaly> internal;
}

- (instancetype) initFromInternalVideoAuthenticationAnomaly:(const se::id::IdVideoAuthenticationAnomaly &)anomaly {
  if (self = [super init]) {
    internal.reset(new se::id::IdVideoAuthenticationAnomaly(anomaly));
  }
  return self;
}

- (const se::id::IdVideoAuthenticationAnomaly &) getInternalVideoAuthenticationAnomaly {
  return *internal;
}

- (instancetype) initWithName:(NSString *)name
               withStartFrame:(int)start_frame
                 withEndFrame:(int)end_frame
               withIsAccepted:(BOOL)is_accepted
               withConfidence:(double)confidence {
  if (self = [super init]) {
    try {
      internal.reset(new se::id::IdVideoAuthenticationAnomaly(
          [name UTF8String], start_frame, end_frame, YES == is_accepted, confidence));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (SEIdVideoAuthenticationAnomalyRef *) getRef {
  return [[SEIdVideoAuthenticationAnomalyRef alloc]
      initFromInternalVideoAuthenticationAnomalyPointer:internal.get()
                                     withMutabilityFlag:NO];
}

- (SEIdVideoAuthenticationAnomalyRef *) getMutableRef {
  return [[SEIdVideoAuthenticationAnomalyRef alloc]
      initFromInternalVideoAuthenticationAnomalyPointer:internal.get()
                                     withMutabilityFlag:YES];
}

@end
