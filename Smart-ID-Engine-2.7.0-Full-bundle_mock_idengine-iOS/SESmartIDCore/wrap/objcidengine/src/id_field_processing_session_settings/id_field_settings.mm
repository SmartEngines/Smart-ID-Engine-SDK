/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_field_processing_session_settings_impl.h>

#import <objcsecommon_impl/se_strings_iterator_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <memory>

@implementation SEIdFieldProcessingSessionSettings {
  std::unique_ptr<se::id::IdFieldProcessingSessionSettings> internal;
}

- (instancetype) initFromInternalFieldProcessingSessionSettings:(const se::id::IdFieldProcessingSessionSettings &)settings {
  if (self = [super init]) {
    internal.reset(settings.Clone());
  }
  return self;
}

- (instancetype) initFromCreatedFieldProcessingSessionSettings:(se::id::IdFieldProcessingSessionSettings *)settings_ptr {
  if (self = [super init]) {
    internal.reset(settings_ptr);
  }
  return self;
}

- (const se::id::IdFieldProcessingSessionSettings &) getInternalFieldProcessingSessionSettings {
  return *internal;
}

- (instancetype) initFromOther:(SEIdFieldProcessingSessionSettings *)other {
  if (self = [super init]) {
    internal.reset([other getInternalFieldProcessingSessionSettings].Clone());
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

- (NSString *) getCurrentFieldProcessor {
  return [NSString stringWithUTF8String:internal->GetCurrentFieldProcessor()];
}

- (void) setCurrentFieldProcessorTo:(NSString *)name {
  try {
    internal->SetCurrentFieldProcessor([name UTF8String]);
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
}

- (int) getSupportedFieldProcessorsCount {
  return internal->GetSupportedFieldProcessorsCount();
}

- (BOOL) hasSupportedFieldProcessorWithName:(NSString *)name {
  return internal->HasSupportedFieldProcessor([name UTF8String])? YES : NO;
}

- (SECommonStringsSetIterator *) supportedFieldProcessorsBegin {
  return [[SECommonStringsSetIterator alloc]
      initFromInternalStringsSetIterator:internal->SupportedFieldProcessorsBegin()];
}

- (SECommonStringsSetIterator *) supportedFieldProcessorsEnd {
  return [[SECommonStringsSetIterator alloc]
      initFromInternalStringsSetIterator:internal->SupportedFieldProcessorsEnd()];
}

@end
