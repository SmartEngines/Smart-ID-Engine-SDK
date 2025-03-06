/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_FACE_FEEDBACK_H_INCLUDED
#define OBJCIDENGINE_ID_FACE_FEEDBACK_H_INCLUDED

#import <Foundation/Foundation.h>

@protocol SEIdFaceFeedback <NSObject>

@optional

- (void) messageReceived:(nonnull NSString *)message;

@end

#endif // OBJCIDENGINE_ID_FACE_FEEDBACK_H_INCLUDED