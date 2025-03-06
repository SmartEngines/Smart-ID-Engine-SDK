/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_ENGINE_H_INCLUDED
#define OBJCIDENGINE_ID_ENGINE_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcidengine/id_session_settings.h>
#import <objcidengine/id_session.h>

#import <objcidengine/id_face_session_settings.h>
#import <objcidengine/id_face_session.h>

#import <objcidengine/id_field_processing_session_settings.h>
#import <objcidengine/id_field_processing_session.h>

#import <objcidengine/id_video_authentication_session_settings.h>
#import <objcidengine/id_video_authentication_session.h>
#import <objcidengine/id_video_authentication_callbacks.h>

#import <objcidengine/id_feedback.h>
#import <objcidengine/id_face_feedback.h>

@interface SEIdEngine : NSObject

+ (nonnull NSString *) getVersion;

- (nonnull instancetype) initFromFile:(nonnull NSString *)filename
                         withLazyInit:(BOOL)lazy_initialization
             withInitConcurrencyLimit:(int)init_concurrency;

- (nonnull instancetype) initFromFile:(nonnull NSString *)filename
                         withLazyInit:(BOOL)lazy_initialization
             withInitConcurrencyLimit:(int)init_concurrency
            withDelayedInitialization:(BOOL)delayed_initialization;


- (nonnull instancetype) initFromBuffer:(nonnull unsigned char *)buffer
                         withBuffersize:(int)buffer_size
                           withLazyInit:(BOOL)lazy_initialization
               withInitConcurrencyLimit:(int)init_concurrency;

- (nonnull instancetype) initFromBuffer:(nonnull unsigned char *)buffer
                         withBuffersize:(int)buffer_size
                           withLazyInit:(BOOL)lazy_initialization
               withInitConcurrencyLimit:(int)init_concurrency
              withDelayedInitialization:(BOOL)delayed_initialization;


- (nonnull instancetype) initEmbeddedWithLazyInit:(BOOL)lazy_initialization
                         withInitConcurrencyLimit:(int)init_concurrency;

- (nonnull instancetype) initEmbeddedWithLazyInit:(BOOL)lazy_initialization
                         withInitConcurrencyLimit:(int)init_concurrency
                        withDelayedInitialization:(BOOL)delayed_initialization;


- (BOOL) canCreateSessionSettings;
- (nonnull SEIdSessionSettings *) createSessionSettings;

- (nonnull SEIdSession *) spawnSessionWithSettings:(nonnull SEIdSessionSettings *)settings
                                     withSignature:(nonnull NSString *)signature
                              withFeedbackReporter:(nullable id<SEIdFeedback>)feedback_reporter;

- (BOOL) canCreateFaceSessionSettings;
- (nonnull SEIdFaceSessionSettings *) createFaceSessionSettings;

- (nonnull SEIdFaceSession *) spawnFaceSessionWithSettings:(nonnull SEIdFaceSessionSettings *)settings
                                             withSignature:(nonnull NSString *)signature
                                      withFeedbackReporter:(nullable id<SEIdFaceFeedback>)feedback_reporter;

- (BOOL) canCreateFieldProcessingSessionSettings;
- (nonnull SEIdFieldProcessingSessionSettings *) createFieldProcessingSessionSettings;

- (nonnull SEIdFieldProcessingSession *) spawnFieldProcessingSessionWithSettings:(nonnull SEIdFieldProcessingSessionSettings *)settings
                                                                   withSignature:(nonnull NSString *)signature;

- (BOOL) canCreateVideoAuthenticationSessionSettings;
- (nonnull SEIdVideoAuthenticationSessionSettings *) createVideoAuthenticationSessionSettings;

- (nonnull SEIdVideoAuthenticationSession *)
    spawnVideoAuthenticationSessionWithSettings:(nonnull SEIdVideoAuthenticationSessionSettings *)settings
                                  withSignature:(nonnull NSString *)signature
               withVideoAuthenticationCallbacks:(nullable id<SEIdVideoAuthenticationCallbacks>)video_authentication_callbacks
                           withFeedbackReporter:(nullable id<SEIdFeedback>)feedback_reporter
                       withFaceFeedbackReporter:(nullable id<SEIdFaceFeedback>)face_feedback_reporter;

@end

#endif // OBJCIDENGINE_ID_ENGINE_H_INCLUDED
