/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_SESSION_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_SESSION_H_INCLUDED

#import <objcidengine/id_session.h>

#import <objcidengine/id_feedback.h>
#import <objcidengine_impl/id_proxy_impl.h>

#import <idengine/id_session.h>

@interface SEIdSession (Internal)
  
- (instancetype) initFromCreatedSession:(se::id::IdSession *)session_ptr
               withCreatedProxyReporter:(IdProxyReporter *)proxy_reporter;
- (se::id::IdSession &) getInternalSession;

@end

#endif // OBJCIDENGINE_IMPL_ID_SESSION_H_INCLUDED
