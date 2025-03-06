/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_SESSION_H_INCLUDED
#define OBJCIDENGINE_ID_SESSION_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcsecommon/se_common.h>
#import <objcidengine/id_result.h>
#import <objcidengine/id_feedback.h>

@interface SEIdSession : NSObject

- (nonnull NSString *) getActivationRequest;
- (void) activate:(nonnull NSString *)activation_response;

- (BOOL) isActivated;

- (void) processImage:(nonnull SECommonImageRef *)image;

- (void) processData:(nonnull NSString *)dataStr;

- (nonnull SEIdResultRef *) getCurrentResult;

- (BOOL) isResultTerminal;

- (void) reset;

@end

#endif // OBJCIDENGINE_ID_SESSION_H_INCLUDED
