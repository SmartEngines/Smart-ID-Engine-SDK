/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_SESSION_SETTINGS_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_SESSION_SETTINGS_H_INCLUDED

#import <objcidengine/id_session_settings.h>

#include <idengine/id_session_settings.h>

@interface SEIdSessionSettings (Internal)

- (instancetype) initFromInternalSessionSettings:(const se::id::IdSessionSettings &)settings;
- (instancetype) initFromCreatedSessionSettings:(se::id::IdSessionSettings *)settings_ptr;
- (const se::id::IdSessionSettings &) getInternalSessionSettings;

@end

#endif // OBJCIDENGINE_IMPL_ID_SESSION_SETTINGS_H_INCLUDED