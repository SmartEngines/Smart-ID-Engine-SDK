/*
  Copyright (c) 2016-2021, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_VIDEO_AUTHENTICATION_SESSION_SETTINGS_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_VIDEO_AUTHENTICATION_SESSION_SETTINGS_H_INCLUDED

#import <objcidengine/id_video_authentication_session_settings.h>

#include <idengine/id_video_authentication_session_settings.h>

@interface SEIdVideoAuthenticationSessionSettings (Internal)

- (instancetype) initFromInternalVideoAuthenticationSessionSettings:(const se::id::IdVideoAuthenticationSessionSettings &)settings;
- (instancetype) initFromCreatedVideoAuthenticationSessionSettings:(se::id::IdVideoAuthenticationSessionSettings *)settings_ptr;
- (const se::id::IdVideoAuthenticationSessionSettings &) getInternalVideoAuthenticationSessionSettings;

@end

#endif // OBJCIDENGINE_IMPL_ID_VIDEO_AUTHENTICATION_SESSION_SETTINGS_H_INCLUDED