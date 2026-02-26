/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_session_settings_impl.h>

#import <objcsecommon_impl/se_strings_iterator_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>
#import <objcidengine_impl/id_fields_impl.h>
#import <objcidengine_impl/id_document_info_impl.h>

#include <idengine/id_session_settings.h>
#include <secommon/se_exception.h>

#import <memory>

se::id::IdFieldType ft_e2i(SEIdFieldType ft) {
  switch(ft) {
    case SEIdFieldType_Text:
      return se::id::IdFieldType_Text;
    case SEIdFieldType_Image:
      return se::id::IdFieldType_Image;
    case SEIdFieldType_Animated:
      return se::id::IdFieldType_Animated;
    case SEIdFieldType_Check:
      return se::id::IdFieldType_Check;
  }
  return se::id::IdFieldType_Text;
}

SEIdFieldType ft_i2e(se::id::IdFieldType ft) {
  switch(ft) {
    case se::id::IdFieldType_Text:
      return SEIdFieldType_Text;
    case se::id::IdFieldType_Image:
      return SEIdFieldType_Image;
    case se::id::IdFieldType_Animated:
      return SEIdFieldType_Animated;
    case se::id::IdFieldType_Check:
      return SEIdFieldType_Check;
  }
  return SEIdFieldType_Text;
}

@implementation SEIdSessionSettings {
  std::unique_ptr<se::id::IdSessionSettings> internal;
}

- (instancetype) initFromInternalSessionSettings:(const se::id::IdSessionSettings &)settings {
  if (self = [super init]) {
    internal.reset(settings.Clone());
  }
  return self;
}

- (instancetype) initFromCreatedSessionSettings:(se::id::IdSessionSettings *)settings_ptr {
  if (self = [super init]) {
    internal.reset(settings_ptr);
  }
  return self;
}

- (const se::id::IdSessionSettings &) getInternalSessionSettings {
  return *internal;
}

- (instancetype) initFromOther:(SEIdSessionSettings *)other {
  if (self = [super init]) {
    internal.reset([other getInternalSessionSettings].Clone());
  }
  return self;
}

- (int) getOptionsCount {
  return internal->GetOptionsCount();
}

- (NSString *) getOptionWithName:(NSString *)name {
  try {
    return [NSString stringWithUTF8String:internal->GetOption([name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (BOOL) hasOptionWithName:(NSString *)name {
  return internal->HasOption([name UTF8String])? YES : NO;
}

- (void) setOptionWithName:(NSString *)name
                        to:(NSString *)value {
  internal->SetOption([name UTF8String], [value UTF8String]);
}

- (void) removeOptionWithName:(NSString *)name {
  try {
    internal->RemoveOption([name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (SECommonStringsMapIterator *) optionsBegin {
  return [[SECommonStringsMapIterator alloc] 
      initFromInternalStringsMapIterator:internal->OptionsBegin()];
}

- (SECommonStringsMapIterator *) optionsEnd {
  return [[SECommonStringsMapIterator alloc] 
      initFromInternalStringsMapIterator:internal->OptionsEnd()];
}


- (int) getSupportedModesCount {
  return internal->GetSupportedModesCount();
}

- (BOOL) hasSupportedModeWithName:(NSString *)name {
  return internal->HasSupportedMode([name UTF8String])? YES : NO;
}

- (SECommonStringsSetIterator *) supportedModesBegin {
  return [[SECommonStringsSetIterator alloc] 
      initFromInternalStringsSetIterator:internal->SupportedModesBegin()];
}

- (SECommonStringsSetIterator *) supportedModesEnd {
  return [[SECommonStringsSetIterator alloc] 
      initFromInternalStringsSetIterator:internal->SupportedModesEnd()];
}


- (NSString *) getCurrentMode {
  return [NSString stringWithUTF8String:internal->GetCurrentMode()];
}

- (void) setCurrentModeTo:(NSString *)mode {
  try {
    internal->SetCurrentMode([mode UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}


- (int) getInternalEnginesCount {
  return internal->GetInternalEnginesCount();
}

- (BOOL) hasInternalEngineWithName:(NSString *)name {
  return internal->HasInternalEngine([name UTF8String])? YES : NO;
}

- (SECommonStringsSetIterator *) internalEngineNamesBegin {
  return [[SECommonStringsSetIterator alloc] 
      initFromInternalStringsSetIterator:internal->InternalEngineNamesBegin()];
}

- (SECommonStringsSetIterator *) internalEngineNamesEnd {
  return [[SECommonStringsSetIterator alloc] 
      initFromInternalStringsSetIterator:internal->InternalEngineNamesEnd()];
}





- (int) getSupportedDocumentTypesCountForEngine:(NSString *)engine_name {
  try {
    return internal->GetSupportedDocumentTypesCount([engine_name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return -1;
}

- (BOOL) hasSupportedDocumentType:(NSString *)doc_name
                         inEngine:(NSString *)engine_name {
  try {
    return internal->HasSupportedDocumentType(
        [engine_name UTF8String], [doc_name UTF8String])? YES : NO;
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return false;
}

- (SECommonStringsSetIterator *) supportedDocumentTypesBeginForEngine:(NSString *)engine_name {
  try {
    return [[SECommonStringsSetIterator alloc]
        initFromInternalStringsSetIterator:
        internal->SupportedDocumentTypesBegin([engine_name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SECommonStringsSetIterator *) supportedDocumentTypesEndForEngine:(NSString *)engine_name {
  try {
    return [[SECommonStringsSetIterator alloc]
        initFromInternalStringsSetIterator:
        internal->SupportedDocumentTypesEnd([engine_name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}



- (int) getEnabledDocumentTypesCount {
  return internal->GetEnabledDocumentTypesCount();
}

- (BOOL) hasEnabledDocumentType:(NSString *)doc_name {
  return internal->HasEnabledDocumentType([doc_name UTF8String])? YES : NO;
}

- (SECommonStringsSetIterator *) enabledDocumentTypesBegin {
  return [[SECommonStringsSetIterator alloc]
      initFromInternalStringsSetIterator:internal->EnabledDocumentTypesBegin()];
}

- (SECommonStringsSetIterator *) enabledDocumentTypesEnd {
  return [[SECommonStringsSetIterator alloc]
      initFromInternalStringsSetIterator:internal->EnabledDocumentTypesEnd()];  
}



- (void) addEnabledDocumentTypesWithMask:(NSString *)doc_type_mask {
  internal->AddEnabledDocumentTypes([doc_type_mask UTF8String]);
}

- (void) removeEnabledDocumentTypesWithMask:(NSString *)doc_type_mask {
  internal->RemoveEnabledDocumentTypes([doc_type_mask UTF8String]);
}



- (SEIdDocumentInfoRef *) getDocumentInfoForDocument:(NSString *)doc_name {
  try {
    return [[SEIdDocumentInfoRef alloc]
        initFromInternalDocumentInfoPointer:const_cast<se::id::IdDocumentInfo*>(&internal->GetDocumentInfo([doc_name UTF8String]))
                         withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}



- (int) getSupportedFieldsCountForDocument:(NSString *)doc_name {
  try {
    return internal->GetSupportedFieldsCount([doc_name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return -1;
}

- (BOOL) hasSupportedField:(NSString *)field_name
               forDocument:(NSString *)doc_name {
  try {
    return internal->HasSupportedField(
        [doc_name UTF8String], [field_name UTF8String])? YES : NO;
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return false;
}

- (SECommonStringsSetIterator *) supportedFieldsBeginForDocument:(NSString *)doc_name {
  try {
    return [[SECommonStringsSetIterator alloc]
        initFromInternalStringsSetIterator:internal->SupportedFieldsBegin([doc_name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SECommonStringsSetIterator *) supportedFieldsEndForDocument:(NSString *)doc_name {
  try {
    return [[SECommonStringsSetIterator alloc]
        initFromInternalStringsSetIterator:internal->SupportedFieldsEnd([doc_name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}



- (SEIdFieldType) getFieldTypeForField:(NSString *)field_name
                           forDocument:(NSString *)doc_name {
  try {
    return ft_i2e(internal->GetFieldType(
        [doc_name UTF8String], [field_name UTF8String]));
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return SEIdFieldType_Text;
}



- (int) getEnabledFieldsCountForDocument:(NSString *)doc_name {
  try {
    return internal->GetEnabledFieldsCount([doc_name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return -1;
}

- (BOOL) hasEnabledField:(NSString *)field_name
             forDocument:(NSString *)doc_name {
  try {
    return internal->HasEnabledField(
        [doc_name UTF8String], [field_name UTF8String])? YES : NO;
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return false;
}

- (SECommonStringsSetIterator *) enabledFieldsBeginForDocument:(NSString *)doc_name {
  try {
    return [[SECommonStringsSetIterator alloc]
        initFromInternalStringsSetIterator:internal->EnabledFieldsBegin([doc_name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SECommonStringsSetIterator *) enabledFieldsEndForDocument:(NSString *)doc_name {
  try {
    return [[SECommonStringsSetIterator alloc]
        initFromInternalStringsSetIterator:internal->EnabledFieldsEnd([doc_name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}




- (void) enableField:(NSString *)field_name
         forDocument:(NSString *)doc_name {
  try {
    return internal->EnableField([doc_name UTF8String], [field_name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (void) disableField:(NSString *)field_name
         forDocument:(NSString *)doc_name {
  try {
    return internal->DisableField([doc_name UTF8String], [field_name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}



- (BOOL) isForensicsEnabled {
  return internal->IsForensicsEnabled()? YES : NO;
}

- (void) enableForensics {
  try {
    internal->EnableForensics();
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (void) disableForensics {
  try {
    internal->DisableForensics();
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}




- (int) getSupportedForensicFieldsCountForDocument:(NSString *)doc_name {
  try {
    return internal->GetSupportedForensicFieldsCount([doc_name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return -1;
}

- (BOOL) hasSupportedForensicField:(NSString *)field_name
                       forDocument:(NSString *)doc_name {
  try {
    return internal->HasSupportedForensicField(
        [doc_name UTF8String], [field_name UTF8String])? YES : NO;
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return false;
}

- (SECommonStringsSetIterator *) supportedForensicFieldsBeginForDocument:(NSString *)doc_name {
  try {
    return [[SECommonStringsSetIterator alloc]
        initFromInternalStringsSetIterator:internal->SupportedForensicFieldsBegin([doc_name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SECommonStringsSetIterator *) supportedForensicFieldsEndForDocument:(NSString *)doc_name {
  try {
    return [[SECommonStringsSetIterator alloc]
        initFromInternalStringsSetIterator:internal->SupportedForensicFieldsEnd([doc_name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SEIdFieldType) getForensicFieldTypeForField:(NSString *)field_name
                                   forDocument:(NSString *)doc_name {
  try {
    return ft_i2e(internal->GetForensicFieldType(
        [doc_name UTF8String], [field_name UTF8String]));
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return SEIdFieldType_Text;
}



- (int) getEnabledForensicFieldsCountForDocument:(NSString *)doc_name {
  try {
    return internal->GetEnabledForensicFieldsCount([doc_name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return -1;
}

- (BOOL) hasEnabledForensicField:(NSString *)field_name
                     forDocument:(NSString *)doc_name {
  try {
    return internal->HasEnabledForensicField(
        [doc_name UTF8String], [field_name UTF8String])? YES : NO;
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return false;
}

- (SECommonStringsSetIterator *) enabledForensicFieldsBeginForDocument:(NSString *)doc_name {
  try {
    return [[SECommonStringsSetIterator alloc]
        initFromInternalStringsSetIterator:internal->EnabledForensicFieldsBegin([doc_name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;  
}

- (SECommonStringsSetIterator *) enabledForensicFieldsEndForDocument:(NSString *)doc_name {
  try {
    return [[SECommonStringsSetIterator alloc]
        initFromInternalStringsSetIterator:internal->EnabledForensicFieldsEnd([doc_name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;    
}


- (void) enableForensicField:(NSString *)field_name
                 forDocument:(NSString *)doc_name {
  try {
    internal->EnableForensicField([doc_name UTF8String], [field_name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (void) disableForensicField:(NSString *)field_name
                  forDocument:(NSString *)doc_name {
  try {
    internal->DisableForensicField([doc_name UTF8String], [field_name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}


- (SECommonStringsSetIterator *) permissiblePrefixDocMasksBegin {
  try {
    return [[SECommonStringsSetIterator alloc]
        initFromInternalStringsSetIterator:internal->PermissiblePrefixDocMasksBegin()];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;  
}

- (SECommonStringsSetIterator *) permissiblePrefixDocMasksEnd {
  try {
    return [[SECommonStringsSetIterator alloc]
        initFromInternalStringsSetIterator:internal->PermissiblePrefixDocMasksEnd()];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;  
}

@end
