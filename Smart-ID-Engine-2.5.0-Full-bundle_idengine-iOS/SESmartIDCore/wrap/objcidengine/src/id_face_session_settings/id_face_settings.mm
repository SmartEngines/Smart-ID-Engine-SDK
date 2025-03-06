/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_face_session_settings_impl.h>

#import <objcsecommon_impl/se_strings_iterator_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <memory>

@implementation SEIdFaceSessionSettings {
  std::unique_ptr<se::id::IdFaceSessionSettings> internal;
}

- (instancetype) initFromInternalFaceSessionSettings:(const se::id::IdFaceSessionSettings &)settings {
  if (self = [super init]) {
    internal.reset(settings.Clone());
  }
  return self;
}

- (instancetype) initFromCreatedFaceSessionSettings:(se::id::IdFaceSessionSettings *)settings_ptr {
  if (self = [super init]) {
    internal.reset(settings_ptr);
  }
  return self;
}

- (const se::id::IdFaceSessionSettings &) getInternalFaceSessionSettings {
  return *internal;
}

- (instancetype) initFromOther:(SEIdFaceSessionSettings *)other {
  if (self = [super init]) {
    internal.reset([other getInternalFaceSessionSettings].Clone());
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

- (int) getSupportedLivenessInstructionsCount {
  return internal->GetSupportedLivenessInstructionsCount();
}

- (BOOL) hasSupportedLivenessInstructionWithName:(NSString *)name {
  return internal->HasSupportedLivenessInstruction([name UTF8String])? YES : NO;
}

- (NSString *) getLivenessInstructionDescriptionFor:(NSString *)name {
  try {
    return [NSString stringWithUTF8String:internal->GetLivenessInstructionDescription([name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SECommonStringsMapIterator *) supportedLivenessInstructionsBegin {
  return [[SECommonStringsMapIterator alloc] 
      initFromInternalStringsMapIterator:internal->SupportedLivenessInstructionsBegin()];
}

- (SECommonStringsMapIterator *) supportedLivenessInstructionsEnd {
  return [[SECommonStringsMapIterator alloc] 
      initFromInternalStringsMapIterator:internal->SupportedLivenessInstructionsEnd()]; 
}

@end
