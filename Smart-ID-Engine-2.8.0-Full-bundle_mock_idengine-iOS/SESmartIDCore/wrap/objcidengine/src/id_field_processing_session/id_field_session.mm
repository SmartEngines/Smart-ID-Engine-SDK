/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_field_processing_session_impl.h>

#import <objcidengine_impl/id_fields_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#import <memory>

@implementation SEIdFieldProcessingSession {
  std::unique_ptr<se::id::IdFieldProcessingSession> internal;
}

- (instancetype) initFromCreatedFieldProcessingSession:(se::id::IdFieldProcessingSession *)session_ptr {
  if (self = [super init]) {
    internal.reset(session_ptr);
  }
  return self;
}

- (se::id::IdFieldProcessingSession &) getInternalFieldProcessingSession {
  return *internal;
}

- (NSString *) getActivationRequest {
  try {
    return [NSString stringWithUTF8String:internal->GetActivationRequest()];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) activate:(NSString *)activation_response {
  try {
    internal->Activate([activation_response UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (BOOL) isActivated {
  try {
    return internal->IsActivated()? YES : NO;
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return false;
}

- (void) process {
  try {
    internal->Process();
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (int) getTextFieldsCount {
  return internal->GetTextFieldsCount();
}

- (BOOL) hasTextFieldWithName:(NSString *)field_name {
  return internal->HasTextField([field_name UTF8String])? YES : NO;
}

- (SEIdTextFieldRef *) getTextFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdTextFieldRef alloc] 
        initFromInternalTextFieldPointer:const_cast<se::id::IdTextField*>(&internal->GetTextField([field_name UTF8String]))
                      withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setTextFieldWithName:(NSString *)field_name
                           to:(SEIdTextFieldRef *)field {
  internal->SetTextField([field_name UTF8String], *[field getInternalTextFieldPointer]);
}

- (void) removeTextFieldWithName:(NSString *)field_name {
  try {
    internal->RemoveTextField([field_name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (SEIdTextFieldsMapIterator *) textFieldsBegin {
  return [[SEIdTextFieldsMapIterator alloc] 
      initFromInternalTextFieldsMapIterator:internal->TextFieldsBegin()];
}

- (SEIdTextFieldsMapIterator *) textFieldsEnd {
  return [[SEIdTextFieldsMapIterator alloc] 
      initFromInternalTextFieldsMapIterator:internal->TextFieldsEnd()];
}




- (int) getImageFieldsCount {
  return internal->GetImageFieldsCount();
}

- (BOOL) hasImageFieldWithName:(NSString *)field_name {
  return internal->HasImageField([field_name UTF8String])? YES : NO;
}

- (SEIdImageFieldRef *) getImageFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdImageFieldRef alloc] 
        initFromInternalImageFieldPointer:const_cast<se::id::IdImageField*>(&internal->GetImageField([field_name UTF8String]))
                       withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setImageFieldWithName:(NSString *)field_name
                            to:(SEIdImageFieldRef *)field {
  internal->SetImageField([field_name UTF8String], *[field getInternalImageFieldPointer]);
}

- (void) removeImageFieldWithName:(NSString *)field_name {
  try {
    internal->RemoveImageField([field_name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (SEIdImageFieldsMapIterator *) imageFieldsBegin {
  return [[SEIdImageFieldsMapIterator alloc] 
      initFromInternalImageFieldsMapIterator:internal->ImageFieldsBegin()];
}

- (SEIdImageFieldsMapIterator *) imageFieldsEnd {
  return [[SEIdImageFieldsMapIterator alloc] 
      initFromInternalImageFieldsMapIterator:internal->ImageFieldsEnd()];
}




- (int) getAnimatedFieldsCount {
  return internal->GetAnimatedFieldsCount();
}

- (BOOL) hasAnimatedFieldWithName:(NSString *)field_name {
  return internal->HasAnimatedField([field_name UTF8String])? YES : NO;
}

- (SEIdAnimatedFieldRef *) getAnimatedFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdAnimatedFieldRef alloc] 
        initFromInternalAnimatedFieldPointer:const_cast<se::id::IdAnimatedField*>(&internal->GetAnimatedField([field_name UTF8String]))
                          withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setAnimatedFieldWithName:(NSString *)field_name
                               to:(SEIdAnimatedFieldRef *)field {
  internal->SetAnimatedField([field_name UTF8String], *[field getInternalAnimatedFieldPointer]);
}

- (void) removeAnimatedFieldWithName:(NSString *)field_name {
  try {
    internal->RemoveAnimatedField([field_name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (SEIdAnimatedFieldsMapIterator *) animatedFieldsBegin {
  return [[SEIdAnimatedFieldsMapIterator alloc] 
      initFromInternalAnimatedFieldsMapIterator:internal->AnimatedFieldsBegin()];
}

- (SEIdAnimatedFieldsMapIterator *) animatedFieldsEnd {
  return [[SEIdAnimatedFieldsMapIterator alloc] 
      initFromInternalAnimatedFieldsMapIterator:internal->AnimatedFieldsEnd()];
}




- (int) getCheckFieldsCount {
  return internal->GetCheckFieldsCount();
}

- (BOOL) hasCheckFieldWithName:(NSString *)field_name {
  return internal->HasCheckField([field_name UTF8String])? YES : NO;
}

- (SEIdCheckFieldRef *) getCheckFieldWithName:(NSString *)field_name {
  try {
    return [[SEIdCheckFieldRef alloc] 
        initFromInternalCheckFieldPointer:const_cast<se::id::IdCheckField*>(&internal->GetCheckField([field_name UTF8String]))
                       withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setCheckFieldWithName:(NSString *)field_name
                            to:(SEIdCheckFieldRef *)field {
  internal->SetCheckField([field_name UTF8String], *[field getInternalCheckFieldPointer]);
}

- (void) removeCheckFieldWithName:(NSString *)field_name {
  try {
    internal->RemoveCheckField([field_name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (SEIdCheckFieldsMapIterator *) checkFieldsBegin {
  return [[SEIdCheckFieldsMapIterator alloc] 
      initFromInternalCheckFieldsMapIterator:internal->CheckFieldsBegin()];
}

- (SEIdCheckFieldsMapIterator *) checkFieldsEnd {
  return [[SEIdCheckFieldsMapIterator alloc] 
      initFromInternalCheckFieldsMapIterator:internal->CheckFieldsEnd()];
}

- (void) reset {
  try {
    internal->Reset();
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

@end
