/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_FACE_SESSION_SETTINGS_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_FACE_SESSION_SETTINGS_H_INCLUDED

#import <objcidengine/id_face_session_settings.h>

#include <idengine/id_face_session_settings.h>

@interface SEIdFaceSessionSettings (Internal)

- (instancetype) initFromInternalFaceSessionSettings:(const se::id::IdFaceSessionSettings &)settings;
- (instancetype) initFromCreatedFaceSessionSettings:(se::id::IdFaceSessionSettings *)settings_ptr;
- (const se::id::IdFaceSessionSettings &) getInternalFaceSessionSettings;

@end

#endif // OBJCIDENGINE_IMPL_ID_FACE_SESSION_SETTINGS_H_INCLUDED