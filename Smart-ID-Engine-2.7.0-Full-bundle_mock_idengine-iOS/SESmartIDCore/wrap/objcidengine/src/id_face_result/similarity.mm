/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_face_result_impl.h>

#import <objcsecommon_impl/se_common_proxy_impl.h>
#import <objcsecommon_impl/se_geometry_impl.h>
#import <objcsecommon_impl/se_image_impl.h>

#include <memory>

se::id::IdFaceStatus fs_e2i(SEIdFaceStatus fs) {
  switch(fs) {
    case SEIdFaceStatus_NotUsed:
      return se::id::IdFaceStatus_NotUsed;
    case SEIdFaceStatus_Success:
      return se::id::IdFaceStatus_Success;
    case SEIdFaceStatus_A_FaceNotFound:
      return se::id::IdFaceStatus_A_FaceNotFound;
    case SEIdFaceStatus_B_FaceNotFound:
      return se::id::IdFaceStatus_B_FaceNotFound;
    case SEIdFaceStatus_FaceNotFound:
      return se::id::IdFaceStatus_FaceNotFound;
    case SEIdFaceStatus_NoAccumulatedResult:
      return se::id::IdFaceStatus_NoAccumulatedResult;
  }
  return se::id::IdFaceStatus_NotUsed;
}

SEIdFaceStatus fs_i2e(se::id::IdFaceStatus fs) {
  switch(fs) {
    case se::id::IdFaceStatus_NotUsed:
      return SEIdFaceStatus_NotUsed;
    case se::id::IdFaceStatus_Success:
      return SEIdFaceStatus_Success;
    case se::id::IdFaceStatus_A_FaceNotFound:
      return SEIdFaceStatus_A_FaceNotFound;
    case se::id::IdFaceStatus_B_FaceNotFound:
      return SEIdFaceStatus_B_FaceNotFound;
    case se::id::IdFaceStatus_FaceNotFound:
      return SEIdFaceStatus_FaceNotFound;
    case se::id::IdFaceStatus_NoAccumulatedResult:
      return SEIdFaceStatus_NoAccumulatedResult;
  }
  return SEIdFaceStatus_NotUsed;
}

se::id::IdFaceSimilarity fsim_e2i(SEIdFaceSimilarity fsim) {
  switch (fsim) {
    case SEDifferent:
      return se::id::Different;
    case SEUncertain:
      return se::id::Uncertain;
    case SESame:
      return se::id::Same;
  }
}

SEIdFaceSimilarity fsim_i2e(se::id::IdFaceSimilarity fsim) {
  switch (fsim) {
    case se::id::Different:
      return  SEDifferent;
    case se::id::Uncertain:
      return  SEUncertain;
    case se::id::Same:
      return SESame;
  }
}

@implementation SEIdFaceSimilarityResultRef {
  se::id::IdFaceSimilarityResult* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalFaceSimilarityResultPointer:(se::id::IdFaceSimilarityResult *)resptr
                                          withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = resptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdFaceSimilarityResult *) getInternalFaceSimilarityResultPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (SEIdFaceSimilarityResult *) clone {
  return [[SEIdFaceSimilarityResult alloc] initFromInternalFaceSimilarityResult:(*ptr)];
}

- (double) getSimilarityEstimation {
  return ptr->GetSimilarityEstimation();
}

- (SEIdFaceSimilarity)getSimilarity {
  return fsim_i2e(ptr->GetSimilarity());
}

- (void) setSimilarityEstimationTo:(double)estimation {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetSimilarityEstimation(estimation);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SEIdFaceStatus) getStatus{
  return fs_i2e(ptr->GetStatus());
}

- (void) setStatus:(SEIdFaceStatus)status{
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetStatus(fs_e2i(status));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

@end


@implementation SEIdFaceSimilarityResult {
  std::unique_ptr<se::id::IdFaceSimilarityResult> internal;
}

- (instancetype) initFromInternalFaceSimilarityResult:(const se::id::IdFaceSimilarityResult &)res {
  if (self = [super init]) {
    internal.reset(new se::id::IdFaceSimilarityResult(res));
  }
  return self;
}

- (const se::id::IdFaceSimilarityResult &) getInternalFaceSimilarityResult {
  return *internal;
}

- (instancetype) init {
  if (self = [super init]) {
    internal.reset(new se::id::IdFaceSimilarityResult);
  }
  return self;
}

- (instancetype) initWithSimilarityEstimation:(double)estimation {
  if (self = [super init]) {
    try {
      internal.reset(new se::id::IdFaceSimilarityResult(estimation, fs_e2i(SEIdFaceStatus_NotUsed)));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (instancetype) initWithFaceStatus:(SEIdFaceStatus)status{
  if (self = [super init]) {
    try {
      internal.reset(new se::id::IdFaceSimilarityResult(0.0, fs_e2i(status)));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (instancetype) initWithSimilarityEstimation:(double)estimation 
                 withFaceStatus:(SEIdFaceStatus)status{
  if (self = [super init]) {
    try {
      internal.reset(new se::id::IdFaceSimilarityResult(estimation, fs_e2i(status)));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (SEIdFaceSimilarityResultRef *) getRef {
  return [[SEIdFaceSimilarityResultRef alloc]
      initFromInternalFaceSimilarityResultPointer:internal.get()
                               withMutabilityFlag:NO];
}

- (SEIdFaceSimilarityResultRef *) getMutableRef {
  return [[SEIdFaceSimilarityResultRef alloc]
      initFromInternalFaceSimilarityResultPointer:internal.get()
                               withMutabilityFlag:YES];
}

@end
