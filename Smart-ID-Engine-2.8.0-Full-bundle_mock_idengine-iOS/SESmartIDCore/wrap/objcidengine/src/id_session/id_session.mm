/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_session_impl.h>

#import <objcsecommon_impl/se_image_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>
#import <objcidengine_impl/id_result_impl.h>
#import <objcidengine_impl/id_feedback_impl.h>
#import <objcidengine_impl/id_proxy_impl.h>

#include <idengine/id_session.h>
#include <idengine/id_feedback.h>

#include <memory>

@implementation SEIdSession {
  std::unique_ptr<se::id::IdSession> internal;
  std::unique_ptr<IdProxyReporter> proxyReporter;
}

- (instancetype) initFromCreatedSession:(se::id::IdSession *)session_ptr
               withCreatedProxyReporter:(IdProxyReporter *)proxy_reporter {
  if (self = [super init]) {
    internal.reset(session_ptr);
    proxyReporter.reset(proxy_reporter);
  }
  return self;
}

- (se::id::IdSession &) getInternalSession {
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



- (void) processImage:(SECommonImageRef *)image {
  try {
    internal->Process(*[image getInternalImagePointer]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (void) processData:(nonnull NSString *)dataStr {
  try {
    
    se::common::ByteString data(reinterpret_cast<const unsigned char*>([dataStr UTF8String]), [dataStr length]);
    internal->Process(data);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (SEIdResultRef *) getCurrentResult {
  try {
    return [[SEIdResultRef alloc] 
        initFromInternalResultPointer:const_cast<se::id::IdResult*>(&internal->GetCurrentResult())
                   withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil; 
}

- (BOOL) isResultTerminal {
  return internal->IsResultTerminal()? YES : NO;
}

- (void) reset {
  try {
    internal->Reset();    
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

@end
