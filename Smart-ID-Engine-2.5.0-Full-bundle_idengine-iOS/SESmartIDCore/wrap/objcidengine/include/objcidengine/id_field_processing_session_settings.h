/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_FIELD_PROCESSING_SESSION_SETTINGS_H_INCLUDED
#define OBJCIDENGINE_ID_FIELD_PROCESSING_SESSION_SETTINGS_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcsecommon/se_strings_iterator.h>

@interface SEIdFieldProcessingSessionSettings : NSObject

- (nonnull instancetype) initFromOther:(nonnull SEIdFieldProcessingSessionSettings *)other;

- (int) getOptionsCount;
- (nonnull NSString *) getOptionWithName:(nonnull NSString *)name;
- (BOOL) hasOptionWithName:(nonnull NSString *)name;
- (void) setOptionWithName:(nonnull NSString *)name
                        to:(nonnull NSString *)value;
- (void) removeOptionWithName:(nonnull NSString *)name;
- (nonnull SECommonStringsMapIterator *) optionsBegin;
- (nonnull SECommonStringsMapIterator *) optionsEnd;

- (nonnull NSString *) getCurrentFieldProcessor;
- (void) setCurrentFieldProcessorTo:(nonnull NSString *)name;

- (int) getSupportedFieldProcessorsCount;
- (BOOL) hasSupportedFieldProcessorWithName:(nonnull NSString *)name;
- (nonnull SECommonStringsSetIterator *) supportedFieldProcessorsBegin;
- (nonnull SECommonStringsSetIterator *) supportedFieldProcessorsEnd;

@end

#endif // OBJCIDENGINE_ID_FIELD_PROCESSING_SESSION_SETTINGS_H_INCLUDED