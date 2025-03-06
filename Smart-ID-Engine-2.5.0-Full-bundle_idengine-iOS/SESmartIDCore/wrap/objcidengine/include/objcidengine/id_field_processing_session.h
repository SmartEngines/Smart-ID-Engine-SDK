/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_FIELD_PROCESSING_SESSION_H_INCLUDED
#define OBJCIDENGINE_ID_FIELD_PROCESSING_SESSION_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcidengine/id_fields.h>

@interface SEIdFieldProcessingSession : NSObject

- (nonnull NSString *) getActivationRequest;
- (void) activate:(nonnull NSString *)activation_response;

- (BOOL) isActivated;

- (void) process;

- (int) getTextFieldsCount;
- (BOOL) hasTextFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdTextFieldRef *) getTextFieldWithName:(nonnull NSString *)field_name;
- (void) setTextFieldWithName:(nonnull NSString *)field_name
                           to:(nonnull SEIdTextFieldRef *)field;
- (void) removeTextFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdTextFieldsMapIterator *) textFieldsBegin;
- (nonnull SEIdTextFieldsMapIterator *) textFieldsEnd;

- (int) getImageFieldsCount;
- (BOOL) hasImageFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdImageFieldRef *) getImageFieldWithName:(nonnull NSString *)field_name;
- (void) setImageFieldWithName:(nonnull NSString *)field_name
                            to:(nonnull SEIdImageFieldRef *)field;
- (void) removeImageFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdImageFieldsMapIterator *) imageFieldsBegin;
- (nonnull SEIdImageFieldsMapIterator *) imageFieldsEnd;

- (int) getAnimatedFieldsCount;
- (BOOL) hasAnimatedFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdAnimatedFieldRef *) getAnimatedFieldWithName:(nonnull NSString *)field_name;
- (void) setAnimatedFieldWithName:(nonnull NSString *)field_name
                               to:(nonnull SEIdAnimatedFieldRef *)field;
- (void) removeAnimatedFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdAnimatedFieldsMapIterator *) animatedFieldsBegin;
- (nonnull SEIdAnimatedFieldsMapIterator *) animatedFieldsEnd;

- (int) getCheckFieldsCount;
- (BOOL) hasCheckFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdCheckFieldRef *) getCheckFieldWithName:(nonnull NSString *)field_name;
- (void) setCheckFieldWithName:(nonnull NSString *)field_name
                            to:(nonnull SEIdCheckFieldRef *)field;
- (void) removeCheckFieldWithName:(nonnull NSString *)field_name;
- (nonnull SEIdCheckFieldsMapIterator *) checkFieldsBegin;
- (nonnull SEIdCheckFieldsMapIterator *) checkFieldsEnd;

- (void) reset;

@end

#endif // OBJCIDENGINE_ID_FIELD_PROCESSING_SESSION_H_INCLUDED