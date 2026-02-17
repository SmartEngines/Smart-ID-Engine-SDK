/*
  Copyright (c) 2016-2021, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBCJIDENGINE_IMPL_ID_VIDEO_AUTHENTICATION_RESULT_H_INCLUDED
#define OBCJIDENGINE_IMPL_ID_VIDEO_AUTHENTICATION_RESULT_H_INCLUDED

#import <objcidengine/id_video_authentication_result.h>

#include <idengine/id_video_authentication_result.h>

@interface SEIdVideoAuthenticationInstructionRef (Internal)

- (instancetype) initFromInternalVideoAuthenticationInstructionPointer:(se::id::IdVideoAuthenticationInstruction *)instruction_ptr
                                                    withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdVideoAuthenticationInstruction *) getInternalVideoAuthenticationInstructionPointer;

@end

@interface SEIdVideoAuthenticationInstruction (Internal)

- (instancetype) initFromInternalVideoAuthenticationInstruction:(const se::id::IdVideoAuthenticationInstruction &)instruction;
- (const se::id::IdVideoAuthenticationInstruction &) getInternalVideoAuthenticationInstruction;

@end


@interface SEIdVideoAuthenticationFrameInfoRef (Internal)

- (instancetype) initFromInternalVideoAuthenticationFrameInfoPointer:(se::id::IdVideoAuthenticationFrameInfo *)frame_info_ptr
                                               withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdVideoAuthenticationFrameInfo *) getInternalVideoAuthenticationFrameInfoPointer;

@end

@interface SEIdVideoAuthenticationFrameInfo (Internal)

- (instancetype) initFromInternalVideoAuthenticationFrameInfo:(const se::id::IdVideoAuthenticationFrameInfo &)frame_info;
- (const se::id::IdVideoAuthenticationFrameInfo &) getInternalVideoAuthenticationFrameInfo;

@end


@interface SEIdVideoAuthenticationAnomalyRef (Internal)

- (instancetype) initFromInternalVideoAuthenticationAnomalyPointer:(se::id::IdVideoAuthenticationAnomaly *)anomaly_ptr
                                               withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdVideoAuthenticationAnomaly *) getInternalVideoAuthenticationAnomalyPointer;

@end

@interface SEIdVideoAuthenticationAnomaly (Internal)

- (instancetype) initFromInternalVideoAuthenticationAnomaly:(const se::id::IdVideoAuthenticationAnomaly &)anomaly;
- (const se::id::IdVideoAuthenticationAnomaly &) getInternalVideoAuthenticationAnomaly;

@end


@interface SEIdVideoAuthenticationTranscriptRef (Internal)

- (instancetype) initFromInternalVideoAuthenticationTranscriptPointer:(se::id::IdVideoAuthenticationTranscript *)transcript_ptr
                                                   withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdVideoAuthenticationTranscript *) getInternalVideoAuthenticationTranscriptPointer;

@end

#endif // OBCJIDENGINE_IMPL_ID_VIDEO_AUTHENTICATION_RESULT_H_INCLUDED