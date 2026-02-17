/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_DOCUMENT_INFO_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_DOCUMENT_INFO_H_INCLUDED

#import <objcidengine/id_document_info.h>

#include <idengine/id_document_info.h>

@interface SEIdDocumentInfoRef (Internal)

- (instancetype) initFromInternalDocumentInfoPointer:(se::id::IdDocumentInfo *)infoptr 
                                  withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdDocumentInfo *) getInternalDocumentInfoPointer;

@end

#endif // OBJCIDENGINE_IMPL_ID_DOCUMENT_INFO_H_INCLUDED