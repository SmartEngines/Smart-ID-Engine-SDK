/*
  Copyright (c) 2016-2021, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_VIDEO_AUTHENTICATION_RESULT_H_INCLUDED
#define OBJCIDENGINE_ID_VIDEO_AUTHENTICATION_RESULT_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcsecommon/se_strings_iterator.h>
#import <objcsecommon/se_geometry.h>
#import <objcsecommon/se_image.h>
#import <objcidengine/id_fields.h>

@class SEIdVideoAuthenticationInstruction;

@interface SEIdVideoAuthenticationInstructionRef : NSObject

- (BOOL) isMutable;

- (nonnull SEIdVideoAuthenticationInstruction *) clone;

- (int) getFrameIndex;
- (void) setFrameIndexTo:(int)frame_index;

- (nonnull NSString *) getInstructionCode;
- (void) setInstructionCodeTo:(nonnull NSString *)code;

- (int) getParametersCount;
- (nonnull NSString *) getParameterWithName:(nonnull NSString *)name;
- (BOOL) hasParameterWithName:(nonnull NSString *)name;
- (void) setParameterWithName:(nonnull NSString *)name
                           to:(nonnull NSString *)value;
- (void) removeParameterWithName:(nonnull NSString *)name;
- (nonnull SECommonStringsMapIterator *) parametersBegin;
- (nonnull SECommonStringsMapIterator *) parametersEnd;

@end


@interface SEIdVideoAuthenticationInstruction : NSObject

- (nonnull instancetype) initWithFrameIndex:(int)frame_index
                        withInstructionCode:(nonnull NSString *)code;

- (nonnull SEIdVideoAuthenticationInstructionRef *) getRef; 
- (nonnull SEIdVideoAuthenticationInstructionRef *) getMutableRef;

@end


@class SEIdVideoAuthenticationFrameInfo;

@interface SEIdVideoAuthenticationFrameInfoRef : NSObject

- (BOOL) isMutable;

- (nonnull SEIdVideoAuthenticationFrameInfo *) clone;

- (int) getWidth;
- (void) setWidthTo:(int)width;

- (int) getHeight;
- (void) setHeightTo:(int)height;

- (int) getStride;
- (void) setStrideTo:(int)stride;

- (int) getChannels;
- (void) setChannelsTo:(int)channels;

- (nonnull SECommonSize *) getSize;
- (void) setSizeTo:(nonnull SECommonSize *)size;

- (int) getTimestamp;
- (void) setTimestampTo:(int)timestamp;

@end


@interface SEIdVideoAuthenticationFrameInfo : NSObject

- (nonnull instancetype) init;
- (nonnull instancetype) initFromImage:(nonnull SECommonImageRef *)image
                         withTimestamp:(int)timestamp;

- (nonnull SEIdVideoAuthenticationFrameInfoRef *) getRef;
- (nonnull SEIdVideoAuthenticationFrameInfoRef *) getMutableRef;

@end


@class SEIdVideoAuthenticationAnomaly;

@interface SEIdVideoAuthenticationAnomalyRef : NSObject

- (BOOL) isMutable;

- (nonnull SEIdVideoAuthenticationAnomaly *) clone;

- (nonnull NSString *) getName;
- (void) setNameTo:(nonnull NSString *)name;

- (int) getStartFrame;
- (void) setStartFrameTo:(int)start_frame;

- (int) getEndFrame;
- (void) setEndFrameTo:(int)end_frame;

- (nonnull SEIdBaseFieldInfoRef *) getBaseFieldInfo;
- (nonnull SEIdBaseFieldInfoRef *) getMutableBaseFieldInfo;

@end


@interface SEIdVideoAuthenticationAnomaly : NSObject

- (nonnull instancetype) initWithName:(nonnull NSString *)name
                       withStartFrame:(int)start_frame
                         withEndFrame:(int)end_frame
                       withIsAccepted:(BOOL)is_accepted
                       withConfidence:(double)confidence;

- (nonnull SEIdVideoAuthenticationAnomalyRef *) getRef;
- (nonnull SEIdVideoAuthenticationAnomalyRef *) getMutableRef;

@end


@interface SEIdVideoAuthenticationTranscriptRef : NSObject 

- (BOOL) isMutable;

- (int) getFrameInfosCount;
- (nonnull SEIdVideoAuthenticationFrameInfoRef *) getFrameInfoAt:(int)index;
- (nonnull SEIdVideoAuthenticationFrameInfoRef *) getMutableFrameInfoAt:(int)index;
- (void) appendFrameInfo:(nonnull SEIdVideoAuthenticationFrameInfoRef *)frame_info;
- (void) setFrameInfoAt:(int)index
                     to:(nonnull SEIdVideoAuthenticationFrameInfoRef *)frame_info;
- (void) resizeFrameInfosContainerTo:(int)size;

- (int) getInstructionsCount;
- (nonnull SEIdVideoAuthenticationInstructionRef *) getInstructionAt:(int)index;
- (nonnull SEIdVideoAuthenticationInstructionRef *) getMutableInstructionAt:(int)index;
- (void) appendInstruction:(nonnull SEIdVideoAuthenticationInstructionRef *)instruction;
- (void) setInstructionAt:(int)index
                       to:(nonnull SEIdVideoAuthenticationInstructionRef *)instruction;
- (void) resizeInstructionsContainerTo:(int)size;

- (int) getAnomaliesCount;
- (nonnull SEIdVideoAuthenticationAnomalyRef *) getAnomalyAt:(int)index;
- (nonnull SEIdVideoAuthenticationAnomalyRef *) getMutableAnomalyAt:(int)index;
- (void) appendAnomaly:(nonnull SEIdVideoAuthenticationAnomalyRef *)anomaly;
- (void) setAnomalyAt:(int)index
                   to:(nonnull SEIdVideoAuthenticationAnomalyRef *)anomaly;
- (void) resizeAnomaliesContainerTo:(int)size;

- (nonnull SEIdVideoAuthenticationInstructionRef *) getCurrentInstruction;
- (nonnull SEIdVideoAuthenticationInstructionRef *) getMutableCurrentInstruction;
- (void) setCurrentInstructionTo:(nonnull SEIdVideoAuthenticationInstructionRef *)instruction;

@end

#endif // OBJCIDENGINE_ID_VIDEO_AUTHENTICATION_RESULT_H_INCLUDED