/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_DOCUMENT_INFO_H_INCLUDED
#define OBJCIDENGINE_ID_DOCUMENT_INFO_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcsecommon/se_strings_set.h>

@interface SEIdDocumentInfoRef : NSObject 

- (nonnull NSString *) getDocumentName;
- (nonnull NSString *) getDocumentDescription;

- (nonnull SECommonStringsSetRef *) getPradoLinks;
- (nonnull SECommonStringsSetRef *) getDocumentTemplates;
- (int) hasRFID;
- (int) supportedRFID;

@end

#endif // OBJCIDENGINE_ID_DOCUMENT_INFO_H_INCLUDED
