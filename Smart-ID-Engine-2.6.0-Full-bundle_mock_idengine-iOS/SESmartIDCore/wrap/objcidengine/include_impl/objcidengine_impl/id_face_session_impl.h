/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_FACE_SESSION_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_FACE_SESSION_H_INCLUDED

#import <objcidengine/id_face_session.h>

#import <objcidengine/id_face_feedback.h>
#import <objcidengine_impl/id_proxy_impl.h>

#include <idengine/id_face_session.h>

@interface SEIdFaceSession (Internal)

- (instancetype) initFromCreatedFaceSession:(se::id::IdFaceSession *)session_ptr
                   withCreatedProxyReporter:(ProxyFaceReporter *)reporter_ptr;
- (se::id::IdFaceSession &) getInternalFaceSession;

@end

#endif // OBJCIDENGINE_IMPL_ID_FACE_SESSION_H_INCLUDED
