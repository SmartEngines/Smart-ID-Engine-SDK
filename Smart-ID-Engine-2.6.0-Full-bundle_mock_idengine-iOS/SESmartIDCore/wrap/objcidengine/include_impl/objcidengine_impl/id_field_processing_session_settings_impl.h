/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_FIELD_PROCESSING_SESSION_SETTINGS_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_FIELD_PROCESSING_SESSION_SETTINGS_H_INCLUDED

#import <objcidengine/id_field_processing_session_settings.h>

#include <idengine/id_field_processing_session_settings.h>

@interface SEIdFieldProcessingSessionSettings (Internal)

- (instancetype) initFromInternalFieldProcessingSessionSettings:(const se::id::IdFieldProcessingSessionSettings &)settings;
- (instancetype) initFromCreatedFieldProcessingSessionSettings:(se::id::IdFieldProcessingSessionSettings *)settings_ptr;
- (const se::id::IdFieldProcessingSessionSettings &) getInternalFieldProcessingSessionSettings;

@end

#endif // OBJCIDENGINE_IMPL_ID_FIELD_PROCESSING_SESSION_SETTINGS_H_INCLUDED