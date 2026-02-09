/*
  Copyright (c) 2016-2021, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_VIDEO_AUTHENTICATION_SESSION_SETTINGS_H_INCLUDED
#define OBJCIDENGINE_ID_VIDEO_AUTHENTICATION_SESSION_SETTINGS_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcidengine/id_session_settings.h>
#import <objcsecommon/se_common.h>
#import <objcidengine/id_document_info.h>

@interface SEIdVideoAuthenticationSessionSettings : NSObject

- (nonnull instancetype) initFromOther:(nonnull SEIdVideoAuthenticationSessionSettings *)other;

- (int) getOptionsCount;
- (nonnull NSString *) getOptionWithName:(nonnull NSString *)name;
- (BOOL) hasOptionWithName:(nonnull NSString *)name;
- (void) setOptionWithName:(nonnull NSString *)name
                        to:(nonnull NSString *)value;
- (void) removeOptionWithName:(nonnull NSString *)name;
- (nonnull SECommonStringsMapIterator *) optionsBegin;
- (nonnull SECommonStringsMapIterator *) optionsEnd;

- (int) getSupportedModesCount;
- (BOOL) hasSupportedModeWithName:(nonnull NSString *)name;
- (nonnull SECommonStringsSetIterator *) supportedModesBegin;
- (nonnull SECommonStringsSetIterator *) supportedModesEnd;

- (nonnull NSString *) getCurrentMode;
- (void) setCurrentModeTo:(nonnull NSString *)mode;

- (int) getInternalEnginesCount;
- (BOOL) hasInternalEngineWithName:(nonnull NSString *)name;
- (nonnull SECommonStringsSetIterator *) internalEngineNamesBegin;
- (nonnull SECommonStringsSetIterator *) internalEngineNamesEnd;

- (int) getSupportedDocumentTypesCountForEngine:(nonnull NSString *)engine_name;
- (BOOL) hasSupportedDocumentType:(nonnull NSString *)doc_name
                         inEngine:(nonnull NSString *)engine_name;
- (nonnull SECommonStringsSetIterator *) supportedDocumentTypesBeginForEngine:(nonnull NSString *)engine_name;
- (nonnull SECommonStringsSetIterator *) supportedDocumentTypesEndForEngine:(nonnull NSString *)engine_name;

- (int) getEnabledDocumentTypesCount;
- (BOOL) hasEnabledDocumentType:(nonnull NSString *)doc_name;
- (nonnull SECommonStringsSetIterator *) enabledDocumentTypesBegin;
- (nonnull SECommonStringsSetIterator *) enabledDocumentTypesEnd;

- (void) addEnabledDocumentTypesWithMask:(nonnull NSString *)doc_type_mask;
- (void) removeEnabledDocumentTypesWithMask:(nonnull NSString *)doc_type_mask;

- (nonnull SEIdDocumentInfoRef *) getDocumentInfoForDocument:(nonnull NSString *)doc_name;

- (nonnull SECommonStringsSetIterator *) permissiblePrefixDocMasksBegin;
- (nonnull SECommonStringsSetIterator *) permissiblePrefixDocMasksEnd;

@end

#endif // OBJCIDENGINE_ID_VIDEO_AUTHENTICATION_SESSION_SETTINGS_H_INCLUDED