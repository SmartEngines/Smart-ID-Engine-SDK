/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_face_session_impl.h>

#import <objcidengine_impl/id_face_result_impl.h>
#import <objcsecommon_impl/se_image_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#import <objcidengine_impl/id_proxy_impl.h>

#include <idengine/id_face_feedback.h>

#include <memory>

@implementation SEIdFaceSession {
  std::unique_ptr<se::id::IdFaceSession> internal;
  std::unique_ptr<ProxyFaceReporter> proxyReporter;
}

- (instancetype) initFromCreatedFaceSession:(se::id::IdFaceSession *)session_ptr
                   withCreatedProxyReporter:(ProxyFaceReporter *)reporter_ptr {
  if (self = [super init]) {
    internal.reset(session_ptr);
    proxyReporter.reset(reporter_ptr);
  }
  return self;
}

- (se::id::IdFaceSession &) getInternalFaceSession {
  return *internal;
}

- (NSString *) getActivationRequest {
  try {
    return [NSString stringWithUTF8String:internal->GetActivationRequest()];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) activate:(NSString *)activation_response {
  try {
    internal->Activate([activation_response UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (BOOL) isActivated {
  try {
    return internal->IsActivated()? YES : NO;
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return false;
}

- (SEIdFaceSimilarityResult *) getSimilarityBetweenFaceImage:(SECommonImageRef *)face_image_a
                                                andFaceImage:(SECommonImageRef *)face_image_b {
  try {
    return [[SEIdFaceSimilarityResult alloc]
        initFromInternalFaceSimilarityResult:internal->GetSimilarity(
            *[face_image_a getInternalImagePointer],
            *[face_image_b getInternalImagePointer])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}


- (void) addFaceImage:(SECommonImageRef *)face_image {
  try {
    internal->AddFaceImage(*[face_image getInternalImagePointer]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (SEIdFaceSimilarityResult *) getSimilarityWithFaceImage:(SECommonImageRef *)compare_image {
  try {
    return [[SEIdFaceSimilarityResult alloc]
        initFromInternalFaceSimilarityResult:internal->GetSimilarityWith(
            *[compare_image getInternalImagePointer])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SEIdFaceLivenessResult *) getLivenessResult {
  try {
    return [[SEIdFaceLivenessResult alloc]
        initFromInternalFaceLivenessResult:internal->GetLivenessResult()];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) reset {
  try {
    internal->Reset();    
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

@end
