/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_FACE_SESSION_SETTINGS_H_INCLUDED
#define OBJCIDENGINE_ID_FACE_SESSION_SETTINGS_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcsecommon/se_strings_iterator.h>

@interface SEIdFaceSessionSettings : NSObject

- (nonnull instancetype) initFromOther:(nonnull SEIdFaceSessionSettings *)other;

- (int) getOptionsCount;
- (nonnull NSString *) getOptionWithName:(nonnull NSString *)name;
- (BOOL) hasOptionWithName:(nonnull NSString *)name;
- (void) setOptionWithName:(nonnull NSString *)name
                        to:(nonnull NSString *)value;
- (void) removeOptionWithName:(nonnull NSString *)name;
- (nonnull SECommonStringsMapIterator *) optionsBegin;
- (nonnull SECommonStringsMapIterator *) optionsEnd;

- (int) getSupportedLivenessInstructionsCount;
- (BOOL) hasSupportedLivenessInstructionWithName:(nonnull NSString *)name;
- (nonnull NSString *) getLivenessInstructionDescriptionFor:(nonnull NSString *)name;
- (nonnull SECommonStringsMapIterator *) supportedLivenessInstructionsBegin;
- (nonnull SECommonStringsMapIterator *) supportedLivenessInstructionsEnd; 

@end

#endif // OBJCIDENGINE_ID_FACE_SESSION_SETTINGS_H_INCLUDED