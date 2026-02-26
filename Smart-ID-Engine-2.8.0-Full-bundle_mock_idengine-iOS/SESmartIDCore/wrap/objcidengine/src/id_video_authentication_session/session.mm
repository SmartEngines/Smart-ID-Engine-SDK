/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_video_authentication_session.h>

#import <objcidengine_impl/id_proxy_impl.h>
#import <objcidengine_impl/id_video_authentication_result.h>
#import <objcidengine_impl/id_result_impl.h>
#import <objcidengine_impl/id_fields_impl.h>
#import <objcidengine_impl/id_face_result_impl.h>
#import <objcsecommon_impl/se_image_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <memory>

@implementation SEIdVideoAuthenticationSession {
  std::unique_ptr<se::id::IdVideoAuthenticationSession> internal;
  std::unique_ptr<ProxyVideoAuthenticationCallbacks> proxyCallbacks;
  std::unique_ptr<IdProxyReporter> proxyReporter;
  std::unique_ptr<ProxyFaceReporter> proxyFaceReporter;
}

- (instancetype) initFromCreatedVideoAuthenticationSession:(se::id::IdVideoAuthenticationSession *)sessionptr
                   withCreatedVideoAuthenticationCallbacks:(ProxyVideoAuthenticationCallbacks *)proxy_callbacks
                                  withCreatedProxyReporter:(IdProxyReporter *)proxy_reporter
                              withCreatedProxyFaceReporter:(ProxyFaceReporter *)proxy_face_reporter {
  if (self = [super init]) {
    internal.reset(sessionptr);
    proxyCallbacks.reset(proxy_callbacks);
    proxyReporter.reset(proxy_reporter);
    proxyFaceReporter.reset(proxy_face_reporter);
  }
  return self;
}

- (se::id::IdVideoAuthenticationSession &) getInternalVideoAuthenticationSession {
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


- (void) processFrame:(SECommonImageRef *)frame {
  try {
    internal->ProcessFrame(*[frame getInternalImagePointer]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (void) processData:(nonnull NSString *)dataStr {
  try {
      se::common::ByteString data(reinterpret_cast<const unsigned char*>([dataStr UTF8String]), [dataStr length]);
    internal->ProcessData(data);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (SEIdVideoAuthenticationInstructionRef *) getCurrentInstruction {
  try {
    return [[SEIdVideoAuthenticationInstructionRef alloc]
        initFromInternalVideoAuthenticationInstructionPointer:const_cast<se::id::IdVideoAuthenticationInstruction*>(&internal->GetCurrentInstruction())
                                           withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}


- (BOOL) hasDocumentResult {
  return internal->HasDocumentResult()? YES : NO;
}

- (SEIdResultRef *) getDocumentResult {
  try {
    return [[SEIdResultRef alloc]
        initFromInternalResultPointer:const_cast<se::id::IdResult*>(&internal->GetDocumentResult())
                   withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (BOOL) hasFaceMatchingResult {
  return internal->HasFaceMatchingResult()? YES : NO;
}

- (SEIdFaceSimilarityResultRef *) getFaceMatchingResult {
  try {
    return [[SEIdFaceSimilarityResultRef alloc]
        initFromInternalFaceSimilarityResultPointer:const_cast<se::id::IdFaceSimilarityResult*>(&internal->GetFaceMatchingResult())
                   withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (BOOL) hasFaceLivenessResult {
  return internal->HasFaceLivenessResult()? YES : NO;
}

- (nonnull SEIdFaceLivenessResultRef *) getFaceLivenessResult {
  try {
    return [[SEIdFaceLivenessResultRef alloc]
        initFromInternalFaceLivenessResultPointer:const_cast<se::id::IdFaceLivenessResult*>(&internal->GetFaceLivenessResult())
                               withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SEIdCheckStatus) getAuthenticationStatus {
  try {
    return status_i2e(internal->GetAuthenticationStatus());
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return SEIdCheckStatus_Undefined;
}

- (SEIdVideoAuthenticationTranscriptRef *) getTranscript {
  return [[SEIdVideoAuthenticationTranscriptRef alloc]
      initFromInternalVideoAuthenticationTranscriptPointer:const_cast<se::id::IdVideoAuthenticationTranscript*>(&internal->GetTranscript())
                                        withMutabilityFlag:NO];
}

- (void) suspend {
  try {
    internal->Suspend();
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (void) resume {
  try {
    internal->Resume();
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (void) reset {
  try {
    internal->Reset();
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

@end
