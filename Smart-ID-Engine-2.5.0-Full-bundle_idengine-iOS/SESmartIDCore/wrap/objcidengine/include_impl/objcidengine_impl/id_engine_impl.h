/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_ENGINE_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_ENGINE_H_INCLUDED

#import <objcidengine/id_engine.h>

#import <idengine/id_engine.h>

@interface SEIdEngine (Internal)
  
- (se::id::IdEngine &) getInternalEngine;

@end

#endif // OBJCIDENGINE_IMPL_ID_ENGINE_H_INCLUDED