/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_VIDEO_AUTHENTICATION_SESSION_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_VIDEO_AUTHENTICATION_SESSION_H_INCLUDED

#import <objcidengine/id_video_authentication_session.h>

#import <objcidengine/id_video_authentication_callbacks.h>
#import <objcidengine/id_feedback.h>
#import <objcidengine/id_face_feedback.h>
#import <objcidengine_impl/id_proxy_impl.h>

#include <idengine/id_video_authentication_session.h>

@interface SEIdVideoAuthenticationSession (Internal)

- (instancetype) initFromCreatedVideoAuthenticationSession:(se::id::IdVideoAuthenticationSession *)sessionptr
                   withCreatedVideoAuthenticationCallbacks:(ProxyVideoAuthenticationCallbacks *)proxy_callbacks
                                  withCreatedProxyReporter:(IdProxyReporter *)proxy_reporter
                              withCreatedProxyFaceReporter:(ProxyFaceReporter *)proxy_face_reporter;
- (se::id::IdVideoAuthenticationSession &) getInternalVideoAuthenticationSession;

@end

#endif // OBJCIDENGINE_IMPL_ID_VIDEO_AUTHENTICATION_SESSION_H_INCLUDED
