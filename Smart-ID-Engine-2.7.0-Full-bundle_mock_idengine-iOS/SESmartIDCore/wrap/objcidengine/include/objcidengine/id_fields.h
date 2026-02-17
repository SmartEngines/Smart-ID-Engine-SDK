/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_FIELDS_H_INCLUDED
#define OBJCIDENGINE_ID_FIELDS_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcsecommon/se_common.h>

typedef enum { 
  SEIdFieldType_Text,
  SEIdFieldType_Image,
  SEIdFieldType_Animated,
  SEIdFieldType_Check
} SEIdFieldType;


@class SEIdBaseFieldInfo;

@interface SEIdBaseFieldInfoRef : NSObject 

- (BOOL) isMutable;

- (nonnull SEIdBaseFieldInfo *) clone;

- (BOOL) getIsAccepted;
- (void) setIsAcceptedTo:(BOOL)is_accepted;
- (double) getConfidence;
- (void) setConfidenceTo:(double)confidence;

- (int) getAttributesCount;
- (nonnull NSString *) getAttributeWithName:(nonnull NSString *)attr_name;
- (BOOL) hasAttributeWithName:(nonnull NSString *)attr_name;
- (void) setAttributeWithName:(nonnull NSString *)attr_name
                           to:(nonnull NSString *)attr_value;
- (void) removeAttributeWithName:(nonnull NSString *)attr_name;

- (nonnull SECommonStringsMapIterator *) attributesBegin;
- (nonnull SECommonStringsMapIterator *) attributesEnd;

@end


@interface SEIdBaseFieldInfo : NSObject

- (nonnull instancetype) init;
- (nonnull instancetype) initWithConfidence:(double)confidence
                             withIsAccepted:(BOOL)is_accepted;

- (nonnull SEIdBaseFieldInfoRef *) getRef;
- (nonnull SEIdBaseFieldInfoRef *) getMutableRef;

@end


@class SEIdTextField;

@interface SEIdTextFieldRef : NSObject

- (BOOL) isMutable;

- (nonnull SEIdTextField *) clone;

- (nonnull NSString *) getName;
- (void) setNameTo:(nonnull NSString *)name;

- (nonnull SECommonOcrString *) getValue;
- (void) setValueTo:(nonnull SECommonOcrString *)value;

- (nonnull SEIdBaseFieldInfoRef *) getBaseFieldInfo;
- (nonnull SEIdBaseFieldInfoRef *) getMutableBaseFieldInfo;

@end


@interface SEIdTextField : NSObject

- (nonnull instancetype) init;
- (nonnull instancetype) initWithName:(nonnull NSString *)name
                        withOcrString:(nonnull SECommonOcrString *)ostr
                       withConfidence:(double)confidence
                       withIsAccepted:(BOOL)is_accepted;

- (nonnull SEIdTextFieldRef *) getRef;
- (nonnull SEIdTextFieldRef *) getMutableRef;          

@end


@interface SEIdTextFieldsMapIterator : NSObject

- (nonnull instancetype) initWithOther:(nonnull SEIdTextFieldsMapIterator *)other;
- (BOOL) isEqualToIter:(nonnull SEIdTextFieldsMapIterator *)other;

- (nonnull NSString *) getKey;
- (nonnull SEIdTextFieldRef *) getValue;
- (void) advance;

@end


@class SEIdImageField;

@interface SEIdImageFieldRef : NSObject

- (BOOL) isMutable;

- (nonnull SEIdImageField *) clone;

- (nonnull NSString *) getName;
- (void) setNameTo:(nonnull NSString *)name;

- (nonnull SECommonImageRef *) getValue;
- (void) setValueTo:(nonnull SECommonImageRef *)value;

- (nonnull SEIdBaseFieldInfoRef *) getBaseFieldInfo;
- (nonnull SEIdBaseFieldInfoRef *) getMutableBaseFieldInfo;

@end


@interface SEIdImageField : NSObject

- (nonnull instancetype) init;
- (nonnull instancetype) initWithName:(nonnull NSString *)name
                            withImage:(nonnull SECommonImageRef *)image
                       withConfidence:(double)confidence
                       withIsAccepted:(BOOL)is_accepted;

- (nonnull SEIdImageFieldRef *) getRef;
- (nonnull SEIdImageFieldRef *) getMutableRef;    

@end


@interface SEIdImageFieldsMapIterator : NSObject

- (nonnull instancetype) initWithOther:(nonnull SEIdImageFieldsMapIterator *)other;
- (BOOL) isEqualToIter:(nonnull SEIdImageFieldsMapIterator *)other;

- (nonnull NSString *) getKey;
- (nonnull SEIdImageFieldRef *) getValue;
- (void) advance;

@end


@class SEIdAnimatedField;

@interface SEIdAnimatedFieldRef : NSObject

- (BOOL) isMutable;

- (nonnull SEIdAnimatedField *) clone;

- (nonnull NSString *) getName;
- (void) setNameTo:(nonnull NSString *)name;

- (int) getFramesCount;
- (nonnull SECommonImageRef *) getFrameAt:(int)index;
- (void) appendFrame:(nonnull SECommonImageRef *)frame;
- (void) clearFrames;

- (nonnull SEIdBaseFieldInfoRef *) getBaseFieldInfo;
- (nonnull SEIdBaseFieldInfoRef *) getMutableBaseFieldInfo;

@end


@interface SEIdAnimatedField : NSObject

- (nonnull instancetype) init;
- (nonnull instancetype) initWithName:(nonnull NSString *)name
                       withConfidence:(double)confidence
                       withIsAccepted:(BOOL)is_accepted;

- (nonnull SEIdAnimatedFieldRef *) getRef;
- (nonnull SEIdAnimatedFieldRef *) getMutableRef;

@end


@interface SEIdAnimatedFieldsMapIterator : NSObject

- (nonnull instancetype) initWithOther:(nonnull SEIdAnimatedFieldsMapIterator *)other;
- (BOOL) isEqualToIter:(nonnull SEIdAnimatedFieldsMapIterator *)other;

- (nonnull NSString *) getKey;
- (nonnull SEIdAnimatedFieldRef *) getValue;
- (void) advance;

@end


typedef NS_ENUM(NSInteger, SEIdCheckStatus) {
  SEIdCheckStatus_Undefined = 0,
  SEIdCheckStatus_Passed,
  SEIdCheckStatus_Failed
} ;


@class SEIdCheckField;

@interface SEIdCheckFieldRef : NSObject

- (BOOL) isMutable;

- (nonnull SEIdCheckField *) clone;

- (nonnull NSString *) getName;
- (void) setNameTo:(nonnull NSString *)name;

- (SEIdCheckStatus) getValue;
- (void) setValueTo:(SEIdCheckStatus)value;

- (nonnull SEIdBaseFieldInfoRef *) getBaseFieldInfo;
- (nonnull SEIdBaseFieldInfoRef *) getMutableBaseFieldInfo;

@end


@interface SEIdCheckField : NSObject

- (nonnull instancetype) init;
- (nonnull instancetype) initWithName:(nonnull NSString *)name
                           withStatus:(SEIdCheckStatus)status
                       withConfidence:(double)confidence
                       withIsAccepted:(BOOL)is_accepted;

- (nonnull SEIdCheckFieldRef *) getRef;
- (nonnull SEIdCheckFieldRef *) getMutableRef;

@end


@interface SEIdCheckFieldsMapIterator : NSObject

- (nonnull instancetype) initWithOther:(nonnull SEIdCheckFieldsMapIterator *)other;
- (BOOL) isEqualToIter:(nonnull SEIdCheckFieldsMapIterator *)other;

- (nonnull NSString *) getKey;
- (nonnull SEIdCheckFieldRef *) getValue;
- (void) advance;

@end

#endif // OBJCIDENGINE_ID_FIELDS_H_INCLUDED
