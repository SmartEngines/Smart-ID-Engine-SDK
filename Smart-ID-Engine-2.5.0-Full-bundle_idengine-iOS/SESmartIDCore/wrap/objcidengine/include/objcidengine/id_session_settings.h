/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_SESSION_SETTINGS_H_INCLUDED
#define OBJCIDENGINE_ID_SESSION_SETTINGS_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcsecommon/se_common.h>
#import <objcidengine/id_document_info.h>
#import <objcidengine/id_fields.h>

@interface SEIdSessionSettings : NSObject

- (nonnull instancetype) initFromOther:(nonnull SEIdSessionSettings *)other;

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

- (int) getSupportedFieldsCountForDocument:(nonnull NSString *)doc_name;
- (BOOL) hasSupportedField:(nonnull NSString *)field_name
               forDocument:(nonnull NSString *)doc_name;
- (nonnull SECommonStringsSetIterator *) supportedFieldsBeginForDocument:(nonnull NSString *)doc_name;
- (nonnull SECommonStringsSetIterator *) supportedFieldsEndForDocument:(nonnull NSString *)doc_name;

- (SEIdFieldType) getFieldTypeForField:(nonnull NSString *)field_name
                           forDocument:(nonnull NSString *)doc_name;

- (int) getEnabledFieldsCountForDocument:(nonnull NSString *)doc_name;
- (BOOL) hasEnabledField:(nonnull NSString *)field_name
             forDocument:(nonnull NSString *)doc_name;
- (nonnull SECommonStringsSetIterator *) enabledFieldsBeginForDocument:(nonnull NSString *)doc_name;
- (nonnull SECommonStringsSetIterator *) enabledFieldsEndForDocument:(nonnull NSString *)doc_name;

- (void) enableField:(nonnull NSString *)field_name
         forDocument:(nonnull NSString *)doc_name;
- (void) disableField:(nonnull NSString *)field_name
          forDocument:(nonnull NSString *)doc_name;

- (BOOL) isForensicsEnabled;
- (void) enableForensics;
- (void) disableForensics;

- (int) getSupportedForensicFieldsCountForDocument:(nonnull NSString *)doc_name;
- (BOOL) hasSupportedForensicField:(nonnull NSString *)field_name
                       forDocument:(nonnull NSString *)doc_name;
- (nonnull SECommonStringsSetIterator *) supportedForensicFieldsBeginForDocument:(nonnull NSString *)doc_name;
- (nonnull SECommonStringsSetIterator *) supportedForensicFieldsEndForDocument:(nonnull NSString *)doc_name;

- (SEIdFieldType) getForensicFieldTypeForField:(nonnull NSString *)field_name
                                   forDocument:(nonnull NSString *)doc_name;

- (int) getEnabledForensicFieldsCountForDocument:(nonnull NSString *)doc_name;
- (BOOL) hasEnabledForensicField:(nonnull NSString *)field_name
                     forDocument:(nonnull NSString *)doc_name;
- (nonnull SECommonStringsSetIterator *) enabledForensicFieldsBeginForDocument:(nonnull NSString *)doc_name;
- (nonnull SECommonStringsSetIterator *) enabledForensicFieldsEndForDocument:(nonnull NSString *)doc_name;

- (void) enableForensicField:(nonnull NSString *)field_name
                 forDocument:(nonnull NSString *)doc_name;
- (void) disableForensicField:(nonnull NSString *)field_name
                  forDocument:(nonnull NSString *)doc_name;

- (nonnull SECommonStringsSetIterator *) permissiblePrefixDocMasksBegin;
- (nonnull SECommonStringsSetIterator *) permissiblePrefixDocMasksEnd;

@end

#endif // OBJCIDENGINE_ID_SESSION_SETTINGS_H_INCLUDED