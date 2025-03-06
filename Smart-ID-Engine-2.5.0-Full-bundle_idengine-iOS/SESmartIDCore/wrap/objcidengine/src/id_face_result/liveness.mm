/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_face_result_impl.h>

#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <memory>

@implementation SEIdFaceLivenessResultRef {
  se::id::IdFaceLivenessResult* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalFaceLivenessResultPointer:(se::id::IdFaceLivenessResult *)resptr
                                        withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = resptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdFaceLivenessResult *) getInternalFaceLivenessResultPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (SEIdFaceLivenessResult *) clone {
  return [[SEIdFaceLivenessResult alloc] initFromInternalFaceLivenessResult:(*ptr)];
}

- (double) getLivenessEstimation {
  return ptr->GetLivenessEstimation();
}

- (void) setLivenessEstimationTo:(double)estimation {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetLivenessEstimation(estimation);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (NSString *) getLivenessInstruction {
  return [NSString stringWithUTF8String:ptr->GetLivenessInstruction()];
}

- (void) setLivenessInstructionTo:(NSString *)instruction {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetLivenessInstruction([instruction UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

@end


@implementation SEIdFaceLivenessResult {
  std::unique_ptr<se::id::IdFaceLivenessResult> internal;
}

- (instancetype) initFromInternalFaceLivenessResult:(const se::id::IdFaceLivenessResult &)res {
  if (self = [super init]) {
    internal.reset(new se::id::IdFaceLivenessResult(res));
  }
  return self;
}

- (const se::id::IdFaceLivenessResult &) getInternalFaceLivenessResult {
  return *internal;
}

- (instancetype) init {
  if (self = [super init]) {
    internal.reset(new se::id::IdFaceLivenessResult);
  }
  return self;
}

- (instancetype) initWithLivenessEstimation:(double)estimation {
  if (self = [super init]) {
    try {
      internal.reset(new se::id::IdFaceLivenessResult(estimation));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (SEIdFaceLivenessResultRef *) getRef {
  return [[SEIdFaceLivenessResultRef alloc] initFromInternalFaceLivenessResultPointer:internal.get()
                                                                   withMutabilityFlag:NO];
}

- (SEIdFaceLivenessResultRef *) getMutableRef {
  return [[SEIdFaceLivenessResultRef alloc] initFromInternalFaceLivenessResultPointer:internal.get()
                                                                   withMutabilityFlag:YES];
}

@end
