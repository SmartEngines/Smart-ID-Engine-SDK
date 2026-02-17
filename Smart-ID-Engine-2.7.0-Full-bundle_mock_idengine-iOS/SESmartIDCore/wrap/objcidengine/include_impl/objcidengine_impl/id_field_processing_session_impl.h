/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_FIELD_PROCESSING_SESSION_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_FIELD_PROCESSING_SESSION_H_INCLUDED

#import <objcidengine/id_field_processing_session.h>

#include <idengine/id_field_processing_session.h>

@interface SEIdFieldProcessingSession (Internal)

- (instancetype) initFromCreatedFieldProcessingSession:(se::id::IdFieldProcessingSession *)session_ptr;
- (se::id::IdFieldProcessingSession &) getInternalFieldProcessingSession;

@end

#endif // OBJCIDENGINE_IMPL_ID_FIELD_PROCESSING_SESSION_H_INCLUDED