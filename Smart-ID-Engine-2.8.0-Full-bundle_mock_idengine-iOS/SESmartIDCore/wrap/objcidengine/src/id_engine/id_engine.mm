/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_engine_impl.h>

#import <objcidengine_impl/id_session_settings_impl.h>
#import <objcidengine_impl/id_session_impl.h>
#import <objcidengine_impl/id_feedback_impl.h>
#import <objcidengine_impl/id_proxy_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#import <objcidengine_impl/id_face_session_settings_impl.h>
#import <objcidengine_impl/id_face_session_impl.h>

#import <objcidengine_impl/id_field_processing_session_settings_impl.h>
#import <objcidengine_impl/id_field_processing_session_impl.h>

#import <objcidengine_impl/id_video_authentication_session_settings.h>
#import <objcidengine_impl/id_video_authentication_session.h>
#import <objcidengine_impl/id_video_authentication_callbacks.h>

#include <idengine/id_engine.h>

#include <memory>

@implementation SEIdEngine {
  std::unique_ptr<se::id::IdEngine> internal;
}

+ (NSString *) getVersion {
  return [NSString stringWithUTF8String:se::id::IdEngine::GetVersion()];
}

- (se::id::IdEngine &) getInternalEngine {
  return *internal;
}

- (instancetype) initFromFile:(NSString *)filename
                 withLazyInit:(BOOL)lazy_initialization
     withInitConcurrencyLimit:(int)init_concurrency {
  if (self = [super init]) {
    try {
      internal.reset(se::id::IdEngine::Create(
          [filename UTF8String], 
          YES == lazy_initialization, 
          init_concurrency));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (instancetype) initFromFile:(NSString *)filename
                 withLazyInit:(BOOL)lazy_initialization
     withInitConcurrencyLimit:(int)init_concurrency
    withDelayedInitialization:(BOOL)delayed_initialization {
  if (self = [super init]) {
    try {
      internal.reset(se::id::IdEngine::Create(
          [filename UTF8String], 
          YES == lazy_initialization, 
          init_concurrency,
          YES == delayed_initialization));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (instancetype) initFromFile:(NSString *)filename
                 withLazyInit:(BOOL)lazy_initialization
     withInitConcurrencyLimit:(int)init_concurrency
    withDelayedInitialization:(BOOL)delayed_initialization
                        error:(NSError **)error {
  if (self = [super init]) {
    try {
      internal.reset(se::id::IdEngine::Create(
          [filename UTF8String],
          YES == lazy_initialization,
          init_concurrency,
          YES == delayed_initialization));
    } catch (const se::common::BaseException& e) {
      if (error) {
        *error = getErrorFromException(e);
      }
      return nil;
    }
  }
  return self;
}

- (instancetype) initFromBuffer:(unsigned char *)buffer
                 withBuffersize:(int)buffer_size
                   withLazyInit:(BOOL)lazy_initialization
       withInitConcurrencyLimit:(int)init_concurrency {
  if (self = [super init]) {
    try {
      internal.reset(se::id::IdEngine::Create(
          buffer, 
          buffer_size, 
          YES == lazy_initialization, 
          init_concurrency));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (instancetype) initFromBuffer:(unsigned char *)buffer
                 withBuffersize:(int)buffer_size
                   withLazyInit:(BOOL)lazy_initialization
       withInitConcurrencyLimit:(int)init_concurrency
      withDelayedInitialization:(BOOL)delayed_initialization {
  if (self = [super init]) {
    try {
      internal.reset(se::id::IdEngine::Create(
          buffer, 
          buffer_size, 
          YES == lazy_initialization, 
          init_concurrency,
          YES == delayed_initialization));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (instancetype) initEmbeddedWithLazyInit:(BOOL)lazy_initialization
                 withInitConcurrencyLimit:(int)init_concurrency {
  if (self = [super init]) {
    try {
      internal.reset(se::id::IdEngine::CreateFromEmbeddedBundle(
          YES == lazy_initialization, 
          init_concurrency));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (instancetype) initEmbeddedWithLazyInit:(BOOL)lazy_initialization
                 withInitConcurrencyLimit:(int)init_concurrency 
                withDelayedInitialization:(BOOL)delayed_initialization {
  if (self = [super init]) {
    try {
      internal.reset(se::id::IdEngine::CreateFromEmbeddedBundle(
          YES == lazy_initialization, 
          init_concurrency,
          YES == delayed_initialization));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (BOOL) canCreateSessionSettings {
  try {
    std::unique_ptr<se::id::IdSessionSettings> try_settings(
        internal->CreateSessionSettings());
    return (try_settings.get() != nullptr)? YES: NO;
  } catch (...) {
    return NO;
  }
  return NO;
}

- (SEIdSessionSettings *) createSessionSettings {
  try {
    return [[SEIdSessionSettings alloc]
        initFromCreatedSessionSettings:internal->CreateSessionSettings()];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SEIdSession *) spawnSessionWithSettings:(SEIdSessionSettings *)settings
                             withSignature:(NSString *)signature
                      withFeedbackReporter:(id<SEIdFeedback>)feedback_reporter {
  try {
    std::unique_ptr<IdProxyReporter> proxy_reporter(
        new IdProxyReporter(feedback_reporter));
    IdProxyReporter* proxy_reporter_ptr = proxy_reporter.get();
    return [[SEIdSession alloc]
        initFromCreatedSession:internal->SpawnSession(
            [settings getInternalSessionSettings],
            [signature UTF8String],
            proxy_reporter_ptr)
        withCreatedProxyReporter:proxy_reporter.release()];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (BOOL) canCreateFaceSessionSettings {
  try {
    std::unique_ptr<se::id::IdFaceSessionSettings> try_settings(
        internal->CreateFaceSessionSettings());
    return (try_settings.get() != nullptr)? YES: NO;
  } catch (...) {
    return NO;
  }
  return NO;
}

- (SEIdFaceSessionSettings *) createFaceSessionSettings {
  try {
    return [[SEIdFaceSessionSettings alloc]
        initFromCreatedFaceSessionSettings:internal->CreateFaceSessionSettings()];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SEIdFaceSession *) spawnFaceSessionWithSettings:(SEIdFaceSessionSettings *)settings
                                     withSignature:(NSString *)signature
                              withFeedbackReporter:(id<SEIdFaceFeedback>)feedback_reporter {
  try {
    std::unique_ptr<ProxyFaceReporter> proxy_reporter(
        new ProxyFaceReporter(feedback_reporter));
    ProxyFaceReporter* proxy_reporter_ptr = proxy_reporter.get();
    return [[SEIdFaceSession alloc]
        initFromCreatedFaceSession:internal->SpawnFaceSession(
            [settings getInternalFaceSessionSettings],
            [signature UTF8String],
            proxy_reporter_ptr)
        withCreatedProxyReporter:proxy_reporter.release()];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (BOOL) canCreateFieldProcessingSessionSettings {
  try {
    std::unique_ptr<se::id::IdFieldProcessingSessionSettings> try_settings(
        internal->CreateFieldProcessingSessionSettings());
    return (try_settings.get() != nullptr)? YES: NO;
  } catch (...) {
    return NO;
  }
  return NO;
}

- (SEIdFieldProcessingSessionSettings *) createFieldProcessingSessionSettings {
  try {
    return [[SEIdFieldProcessingSessionSettings alloc]
        initFromCreatedFieldProcessingSessionSettings:internal->CreateFieldProcessingSessionSettings()];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SEIdFieldProcessingSession *) spawnFieldProcessingSessionWithSettings:(SEIdFieldProcessingSessionSettings *)settings
                                                           withSignature:(NSString *)signature {
  try {
    return [[SEIdFieldProcessingSession alloc]
        initFromCreatedFieldProcessingSession:internal->SpawnFieldProcessingSession(
            [settings getInternalFieldProcessingSessionSettings],
            [signature UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (BOOL) canCreateVideoAuthenticationSessionSettings {
  try {
    std::unique_ptr<se::id::IdVideoAuthenticationSessionSettings> try_settings(
        internal->CreateVideoAuthenticationSessionSettings());
    return (try_settings.get() != nullptr)? YES: NO;
  } catch (...) {
    return NO;
  }
  return NO;
}

- (SEIdVideoAuthenticationSessionSettings *) createVideoAuthenticationSessionSettings {
  try {
    return [[SEIdVideoAuthenticationSessionSettings alloc]
        initFromCreatedVideoAuthenticationSessionSettings:internal->CreateVideoAuthenticationSessionSettings()];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SEIdVideoAuthenticationSession *)
    spawnVideoAuthenticationSessionWithSettings:(SEIdVideoAuthenticationSessionSettings *)settings
                                  withSignature:(NSString *)signature
               withVideoAuthenticationCallbacks:(id<SEIdVideoAuthenticationCallbacks>)video_authentication_callbacks
                           withFeedbackReporter:(id<SEIdFeedback>)feedback_reporter
                       withFaceFeedbackReporter:(id<SEIdFaceFeedback>)face_feedback_reporter {
  try {
    std::unique_ptr<IdProxyReporter> proxy_reporter(
        new IdProxyReporter(feedback_reporter));
    IdProxyReporter* proxy_reporter_ptr = proxy_reporter.get();

    std::unique_ptr<ProxyFaceReporter> proxy_face_reporter(
        new ProxyFaceReporter(face_feedback_reporter));
    ProxyFaceReporter* proxy_face_reporter_ptr = proxy_face_reporter.get();

    std::unique_ptr<ProxyVideoAuthenticationCallbacks> proxy_callbacks(
        new ProxyVideoAuthenticationCallbacks(video_authentication_callbacks));
    ProxyVideoAuthenticationCallbacks* proxy_callbacks_ptr = proxy_callbacks.get();

    return [[SEIdVideoAuthenticationSession alloc]
        initFromCreatedVideoAuthenticationSession:internal->SpawnVideoAuthenticationSession(
            [settings getInternalVideoAuthenticationSessionSettings],
            [signature UTF8String],
            proxy_callbacks_ptr,
            proxy_reporter_ptr,
            proxy_face_reporter_ptr)
        withCreatedVideoAuthenticationCallbacks:proxy_callbacks.release()
        withCreatedProxyReporter:proxy_reporter.release()
        withCreatedProxyFaceReporter:proxy_face_reporter.release()];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

@end
