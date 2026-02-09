/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_result_impl.h>

#import <objcsecommon_impl/se_geometry_impl.h>
#import <objcsecommon_impl/se_strings_set_impl.h>
#import <objcsecommon_impl/se_strings_iterator_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>
#import <objcidengine_impl/id_fields_impl.h>

#include <secommon/se_exception.h>
#include <idengine/id_result.h>

#include <memory>

@implementation SEIdResultRef {
  se::id::IdResult* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalResultPointer:(se::id::IdResult *)resptr
                            withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = resptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdResult *) getInternalResultPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (SEIdResult *) clone {
  return [[SEIdResult alloc] initFromInternalResult:(*ptr)];
}

- (NSString *) getDocumentType {
  return [NSString stringWithUTF8String:ptr->GetDocumentType()];
}

- (void) setDocumentTypeTo:(NSString *)document_type {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetDocumentType([document_type UTF8String]);
  }
}

- (int) getTemplateDetectionResultsCount {
  return ptr->GetTemplateDetectionResultsCount();
}

- (SEIdTemplateDetectionResultRef *) getTemplateDetectionResultAt:(int)index {
  try {
    return [[SEIdTemplateDetectionResultRef alloc] 
        initFromInternalTemplateDetectionResultPointer:const_cast<se::id::IdTemplateDetectionResult*>(&ptr->GetTemplateDetectionResult(index))
                                    withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) appendTemplateDetectionResult:(SEIdTemplateDetectionResultRef *)result {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->AppendTemplateDetectionResult(
        *[result getInternalTemplateDetectionResultPointer]);
  }
}

- (void) clearTemplateDetectionResults {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->ClearTemplateDetectionResults();
  }
}

- (int) getTemplateSegmentationResultsCount {
  return ptr->GetTemplateSegmentationResultsCount();
}

- (SEIdTemplateSegmentationResultRef *) getTemplateSegmentationResultAt:(int)index {
  try {
    return [[SEIdTemplateSegmentationResultRef alloc] 
        initFromInternalTemplateSegmentationResultPointer:const_cast<se::id::IdTemplateSegmentationResult*>(&ptr->GetTemplateSegmentationResult(index))
                                       withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) appendTemplateSegmentationResult:(SEIdTemplateSegmentationResultRef *)result {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->AppendTemplateSegmentationResult(
        *[result getInternalTemplateSegmentationResultPointer]);
  }
}

- (void) clearTemplateSegmentationResults {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->ClearTemplateSegmentationResults();
  }
}

- (BOOL) getIsTerminal {
  return ptr->GetIsTerminal()? YES : NO;
}

- (void) setIsTerminalTo:(BOOL)is_terminal {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetIsTerminal(YES == is_terminal);
  }
}

- (SECommonStringsSetRef *) getSeenTemplates {
  return [[SECommonStringsSetRef alloc] 
      initFromInternalStringsSetPointer:const_cast<se::common::StringsSet*>(&ptr->GetSeenTemplates())
                     withMutabilityFlag:NO];
}

- (SECommonStringsSetRef *) getTerminalTemplates {
  return [[SECommonStringsSetRef alloc] 
      initFromInternalStringsSetPointer:const_cast<se::common::StringsSet*>(&ptr->GetTerminalTemplates())
                     withMutabilityFlag:NO];
}

- (int) getTextFieldsCount {
  return ptr->GetTextFieldsCount();
}

- (BOOL) hasTextFieldWithName:(NSString *)field_name {
  return ptr->HasTextField([field_name UTF8String])? YES : NO;
}

- (SEIdTextFieldRef *) getTextFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdTextFieldRef alloc] 
        initFromInternalTextFieldPointer:const_cast<se::id::IdTextField*>(&ptr->GetTextField([field_name UTF8String]))
                      withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setTextFieldWithName:(NSString *)field_name
                           to:(SEIdTextFieldRef *)field {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetTextField([field_name UTF8String], *[field getInternalTextFieldPointer]);
  }
}

- (void) removeTextFieldWithName:(NSString *)field_name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveTextField([field_name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SEIdTextFieldsMapIterator *) textFieldsBegin {
  return [[SEIdTextFieldsMapIterator alloc] 
      initFromInternalTextFieldsMapIterator:ptr->TextFieldsBegin()];
}

- (SEIdTextFieldsMapIterator *) textFieldsEnd {
  return [[SEIdTextFieldsMapIterator alloc] 
      initFromInternalTextFieldsMapIterator:ptr->TextFieldsEnd()];
}




- (int) getImageFieldsCount {
  return ptr->GetImageFieldsCount();
}

- (BOOL) hasImageFieldWithName:(NSString *)field_name {
  return ptr->HasImageField([field_name UTF8String])? YES : NO;
}

- (SEIdImageFieldRef *) getImageFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdImageFieldRef alloc] 
        initFromInternalImageFieldPointer:const_cast<se::id::IdImageField*>(&ptr->GetImageField([field_name UTF8String]))
                       withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setImageFieldWithName:(NSString *)field_name
                            to:(SEIdImageFieldRef *)field {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetImageField([field_name UTF8String], *[field getInternalImageFieldPointer]);
  }
}

- (void) removeImageFieldWithName:(NSString *)field_name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveImageField([field_name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SEIdImageFieldsMapIterator *) imageFieldsBegin {
  return [[SEIdImageFieldsMapIterator alloc] 
      initFromInternalImageFieldsMapIterator:ptr->ImageFieldsBegin()];
}

- (SEIdImageFieldsMapIterator *) imageFieldsEnd {
  return [[SEIdImageFieldsMapIterator alloc] 
      initFromInternalImageFieldsMapIterator:ptr->ImageFieldsEnd()];
}




- (int) getAnimatedFieldsCount {
  return ptr->GetAnimatedFieldsCount();
}

- (BOOL) hasAnimatedFieldWithName:(NSString *)field_name {
  return ptr->HasAnimatedField([field_name UTF8String])? YES : NO;
}

- (SEIdAnimatedFieldRef *) getAnimatedFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdAnimatedFieldRef alloc] 
        initFromInternalAnimatedFieldPointer:const_cast<se::id::IdAnimatedField*>(&ptr->GetAnimatedField([field_name UTF8String]))
                          withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setAnimatedFieldWithName:(NSString *)field_name
                               to:(SEIdAnimatedFieldRef *)field {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetAnimatedField([field_name UTF8String], *[field getInternalAnimatedFieldPointer]);
  }
}

- (void) removeAnimatedFieldWithName:(NSString *)field_name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveAnimatedField([field_name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SEIdAnimatedFieldsMapIterator *) animatedFieldsBegin {
  return [[SEIdAnimatedFieldsMapIterator alloc] 
      initFromInternalAnimatedFieldsMapIterator:ptr->AnimatedFieldsBegin()];
}

- (SEIdAnimatedFieldsMapIterator *) animatedFieldsEnd {
  return [[SEIdAnimatedFieldsMapIterator alloc] 
      initFromInternalAnimatedFieldsMapIterator:ptr->AnimatedFieldsEnd()];
}




- (int) getCheckFieldsCount {
  return ptr->GetCheckFieldsCount();
}

- (BOOL) hasCheckFieldWithName:(NSString *)field_name {
  return ptr->HasCheckField([field_name UTF8String])? YES : NO;
}

- (SEIdCheckFieldRef *) getCheckFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdCheckFieldRef alloc] 
        initFromInternalCheckFieldPointer:const_cast<se::id::IdCheckField*>(&ptr->GetCheckField([field_name UTF8String]))
                       withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setCheckFieldWithName:(NSString *)field_name
                            to:(SEIdCheckFieldRef *)field {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetCheckField([field_name UTF8String], *[field getInternalCheckFieldPointer]);
  }
}

- (void) removeCheckFieldWithName:(NSString *)field_name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveCheckField([field_name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SEIdCheckFieldsMapIterator *) checkFieldsBegin {
  return [[SEIdCheckFieldsMapIterator alloc] 
      initFromInternalCheckFieldsMapIterator:ptr->CheckFieldsBegin()];
}

- (SEIdCheckFieldsMapIterator *) checkFieldsEnd {
  return [[SEIdCheckFieldsMapIterator alloc] 
      initFromInternalCheckFieldsMapIterator:ptr->CheckFieldsEnd()];
}




- (int) getForensicTextFieldsCount {
  return ptr->GetForensicTextFieldsCount();
}

- (BOOL) hasForensicTextFieldWithName:(NSString *)field_name {
  return ptr->HasForensicTextField([field_name UTF8String])? YES : NO;
}

- (SEIdTextFieldRef *) getForensicTextFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdTextFieldRef alloc] 
        initFromInternalTextFieldPointer:const_cast<se::id::IdTextField*>(&ptr->GetForensicTextField([field_name UTF8String]))
                      withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setForensicTextFieldWithName:(NSString *)field_name
                                   to:(SEIdTextFieldRef *)field {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetForensicTextField([field_name UTF8String], *[field getInternalTextFieldPointer]);
  }
}

- (void) removeForensicTextFieldWithName:(NSString *)field_name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveForensicTextField([field_name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SEIdTextFieldsMapIterator *) forensicTextFieldsBegin {
  return [[SEIdTextFieldsMapIterator alloc] 
      initFromInternalTextFieldsMapIterator:ptr->ForensicTextFieldsBegin()];
}

- (SEIdTextFieldsMapIterator *) forensicTextFieldsEnd {
  return [[SEIdTextFieldsMapIterator alloc] 
      initFromInternalTextFieldsMapIterator:ptr->ForensicTextFieldsEnd()];
}




- (int) getForensicImageFieldsCount {
  return ptr->GetForensicImageFieldsCount();
}

- (BOOL) hasForensicImageFieldWithName:(NSString *)field_name {
  return ptr->HasForensicImageField([field_name UTF8String])? YES : NO;
}

- (SEIdImageFieldRef *) getForensicImageFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdImageFieldRef alloc] 
        initFromInternalImageFieldPointer:const_cast<se::id::IdImageField*>(&ptr->GetForensicImageField([field_name UTF8String]))
                       withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setForensicImageFieldWithName:(NSString *)field_name
                                    to:(SEIdImageFieldRef *)field {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetForensicImageField([field_name UTF8String], *[field getInternalImageFieldPointer]);
  }
}

- (void) removeForensicImageFieldWithName:(NSString *)field_name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveForensicImageField([field_name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SEIdImageFieldsMapIterator *) forensicImageFieldsBegin {
  return [[SEIdImageFieldsMapIterator alloc] 
      initFromInternalImageFieldsMapIterator:ptr->ForensicImageFieldsBegin()];
}

- (SEIdImageFieldsMapIterator *) forensicImageFieldsEnd {
  return [[SEIdImageFieldsMapIterator alloc] 
      initFromInternalImageFieldsMapIterator:ptr->ForensicImageFieldsEnd()];
}




- (int) getForensicAnimatedFieldsCount {
  return ptr->GetForensicAnimatedFieldsCount();
}

- (BOOL) hasForensicAnimatedFieldWithName:(NSString *)field_name {
  return ptr->HasForensicAnimatedField([field_name UTF8String])? YES : NO;
}

- (SEIdAnimatedFieldRef *) getForensicAnimatedFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdAnimatedFieldRef alloc] 
        initFromInternalAnimatedFieldPointer:const_cast<se::id::IdAnimatedField*>(&ptr->GetForensicAnimatedField([field_name UTF8String]))
                          withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setForensicAnimatedFieldWithName:(NSString *)field_name
                                       to:(SEIdAnimatedFieldRef *)field {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetForensicAnimatedField([field_name UTF8String], *[field getInternalAnimatedFieldPointer]);
  }
}

- (void) removeForensicAnimatedFieldWithName:(NSString *)field_name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveForensicAnimatedField([field_name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SEIdAnimatedFieldsMapIterator *) forensicAnimatedFieldsBegin {
  return [[SEIdAnimatedFieldsMapIterator alloc] 
      initFromInternalAnimatedFieldsMapIterator:ptr->ForensicAnimatedFieldsBegin()];
}

- (SEIdAnimatedFieldsMapIterator *) forensicAnimatedFieldsEnd {
  return [[SEIdAnimatedFieldsMapIterator alloc] 
      initFromInternalAnimatedFieldsMapIterator:ptr->ForensicAnimatedFieldsEnd()];
}





- (int) getForensicCheckFieldsCount {
  return ptr->GetForensicCheckFieldsCount();
}

- (BOOL) hasForensicCheckFieldWithName:(NSString *)field_name {
  return ptr->HasForensicCheckField([field_name UTF8String])? YES : NO;
}

- (SEIdCheckFieldRef *) getForensicCheckFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdCheckFieldRef alloc] 
        initFromInternalCheckFieldPointer:const_cast<se::id::IdCheckField*>(&ptr->GetForensicCheckField([field_name UTF8String]))
                       withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setForensicCheckFieldWithName:(NSString *)field_name
                                    to:(SEIdCheckFieldRef *)field {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetForensicCheckField([field_name UTF8String], *[field getInternalCheckFieldPointer]);
  }
}

- (void) removeForensicCheckFieldWithName:(NSString *)field_name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveForensicCheckField([field_name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SEIdCheckFieldsMapIterator *) forensicCheckFieldsBegin {
  return [[SEIdCheckFieldsMapIterator alloc] 
      initFromInternalCheckFieldsMapIterator:ptr->ForensicCheckFieldsBegin()];
}

- (SEIdCheckFieldsMapIterator *) forensicCheckFieldsEnd {
  return [[SEIdCheckFieldsMapIterator alloc] 
      initFromInternalCheckFieldsMapIterator:ptr->ForensicCheckFieldsEnd()];
}





- (int) getRawTextFieldsCount {
  return ptr->GetRawTextFieldsCount();
}

- (BOOL) hasRawTextFieldWithName:(NSString *)field_name {
  return ptr->HasRawTextField([field_name UTF8String])? YES : NO;
}

- (SEIdTextFieldRef *) getRawTextFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdTextFieldRef alloc] 
        initFromInternalTextFieldPointer:const_cast<se::id::IdTextField*>(&ptr->GetRawTextField([field_name UTF8String]))
                      withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setRawTextFieldWithName:(NSString *)field_name
                              to:(SEIdTextFieldRef *)field {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetRawTextField([field_name UTF8String], *[field getInternalTextFieldPointer]);
  }
}

- (void) removeRawTextFieldWithName:(NSString *)field_name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveRawTextField([field_name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SEIdTextFieldsMapIterator *) rawTextFieldsBegin {
  return [[SEIdTextFieldsMapIterator alloc] 
      initFromInternalTextFieldsMapIterator:ptr->RawTextFieldsBegin()];
}

- (SEIdTextFieldsMapIterator *) rawTextFieldsEnd {
  return [[SEIdTextFieldsMapIterator alloc] 
      initFromInternalTextFieldsMapIterator:ptr->RawTextFieldsEnd()];
}




- (int) getRawImageFieldsCount {
  return ptr->GetRawImageFieldsCount();
}

- (BOOL) hasRawImageFieldWithName:(NSString *)field_name {
  return ptr->HasRawImageField([field_name UTF8String])? YES : NO;
}

- (SEIdImageFieldRef *) getRawImageFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdImageFieldRef alloc] 
        initFromInternalImageFieldPointer:const_cast<se::id::IdImageField*>(&ptr->GetRawImageField([field_name UTF8String]))
                       withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setRawImageFieldWithName:(NSString *)field_name
                               to:(SEIdImageFieldRef *)field {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetRawImageField([field_name UTF8String], *[field getInternalImageFieldPointer]);
  }
}

- (void) removeRawImageFieldWithName:(NSString *)field_name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveRawImageField([field_name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SEIdImageFieldsMapIterator *) rawImageFieldsBegin {
  return [[SEIdImageFieldsMapIterator alloc] 
      initFromInternalImageFieldsMapIterator:ptr->RawImageFieldsBegin()];
}

- (SEIdImageFieldsMapIterator *) rawImageFieldsEnd {
  return [[SEIdImageFieldsMapIterator alloc] 
      initFromInternalImageFieldsMapIterator:ptr->RawImageFieldsEnd()];
}




- (int) getCorrespondingRawFieldsCountForField:(NSString *)field_name {
  return ptr->GetCorrespondingRawFieldsCount([field_name UTF8String]);
}

- (BOOL) hasCorrespondingRawFieldForField:(NSString *)field_name
                         withRawFieldName:(NSString *)raw_field_name {
  return ptr->HasCorrespondingRawField(
      [field_name UTF8String], [raw_field_name UTF8String])? YES : NO;
}

- (SECommonStringsSetIterator *) correspondingRawFieldNamesBeginForField:(NSString *)field_name {
  return [[SECommonStringsSetIterator alloc] 
      initFromInternalStringsSetIterator:ptr->CorrespondingRawFieldNamesBegin([field_name UTF8String])];
}

- (SECommonStringsSetIterator *) correspondingRawFieldNamesEndForField:(NSString *)field_name {
  return [[SECommonStringsSetIterator alloc] 
      initFromInternalStringsSetIterator:ptr->CorrespondingRawFieldNamesEnd([field_name UTF8String])];
}


- (int) getCorrespondingFieldsCountForRawField:(NSString *)raw_field_name {
  return ptr->GetCorrespondingFieldsCount([raw_field_name UTF8String]);
}

- (BOOL) hasCorrespondingFieldForRawField:(NSString *)raw_field_name
                            withFieldName:(NSString *)field_name {
  return ptr->HasCorrespondingField(
      [raw_field_name UTF8String], [field_name UTF8String])? YES : NO;
}

- (SECommonStringsSetIterator *) correspondingFieldNamesBeginForRawField:(NSString *)raw_field_name {
  return [[SECommonStringsSetIterator alloc] 
      initFromInternalStringsSetIterator:ptr->CorrespondingFieldNamesBegin([raw_field_name UTF8String])];
}

- (SECommonStringsSetIterator *) correspondingFieldNamesEndForRawField:(NSString *)raw_field_name {
  return [[SECommonStringsSetIterator alloc] 
      initFromInternalStringsSetIterator:ptr->CorrespondingFieldNamesEnd([raw_field_name UTF8String])];
}

@end

@implementation SEIdResult {
  std::unique_ptr<se::id::IdResult> internal;
}

- (instancetype) initFromInternalResult:(const se::id::IdResult &)res {
  if (self = [super init]) {
    internal.reset(new se::id::IdResult(res));
  }
  return self;
}

- (const se::id::IdResult &) getInternalResult {
  return *internal;
}

- (instancetype) init {
  if (self = [super init]) {
    internal.reset(new se::id::IdResult);
  }
  return self;
}

- (instancetype) initWithIsTerminal:(BOOL)is_terminal {
  if (self = [super init]) {
    internal.reset(new se::id::IdResult(YES == is_terminal));
  }
  return self;
}

- (SEIdResultRef *) getRef {
  return [[SEIdResultRef alloc]
      initFromInternalResultPointer:internal.get()
                 withMutabilityFlag:NO];
}

- (SEIdResultRef *) getMutableRef {
  return [[SEIdResultRef alloc]
      initFromInternalResultPointer:internal.get()
                 withMutabilityFlag:YES];
}

@end
