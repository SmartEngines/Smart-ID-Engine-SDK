/*
  Copyright (c) 2016-2021, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_video_authentication_result.h>

#import <objcsecommon_impl/se_strings_iterator_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <memory>

@implementation SEIdVideoAuthenticationInstructionRef {
  se::id::IdVideoAuthenticationInstruction* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalVideoAuthenticationInstructionPointer:(se::id::IdVideoAuthenticationInstruction *)instruction_ptr
                                                    withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = instruction_ptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdVideoAuthenticationInstruction *) getInternalVideoAuthenticationInstructionPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (SEIdVideoAuthenticationInstruction *) clone {
  return [[SEIdVideoAuthenticationInstruction alloc]
      initFromInternalVideoAuthenticationInstruction:(*ptr)];
}

- (int) getFrameIndex {
  return ptr->GetFrameIndex();
}

- (void) setFrameIndexTo:(int)frame_index {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetFrameIndex(frame_index);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (NSString *) getInstructionCode {
  return [NSString stringWithUTF8String:ptr->GetInstructionCode()];
}

- (void) setInstructionCodeTo:(NSString *)code {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetInstructionCode([code UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (int) getParametersCount {
  return ptr->GetParametersCount();
}

- (NSString *) getParameterWithName:(NSString *)name {
  try {
    return [NSString stringWithUTF8String:ptr->GetParameter([name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (BOOL) hasParameterWithName:(NSString *)name {
  return ptr->HasParameter([name UTF8String])? YES : NO;
}

- (void) setParameterWithName:(NSString *)name
                           to:(NSString *)value {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetParameter([name UTF8String], [value UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (void) removeParameterWithName:(NSString *)name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveParameter([name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SECommonStringsMapIterator *) parametersBegin {
  return [[SECommonStringsMapIterator alloc]
      initFromInternalStringsMapIterator:ptr->ParametersBegin()];
}

- (SECommonStringsMapIterator *) parametersEnd {
  return [[SECommonStringsMapIterator alloc]
      initFromInternalStringsMapIterator:ptr->ParametersEnd()];
}

@end


@implementation SEIdVideoAuthenticationInstruction {
  std::unique_ptr<se::id::IdVideoAuthenticationInstruction> internal;
}

- (instancetype) initFromInternalVideoAuthenticationInstruction:(const se::id::IdVideoAuthenticationInstruction &)instruction {
  if (self = [super init]) {
    internal.reset(new se::id::IdVideoAuthenticationInstruction(instruction));
  }
  return self;
}

- (const se::id::IdVideoAuthenticationInstruction &) getInternalVideoAuthenticationInstruction {
  return *internal;
}

- (instancetype) initWithFrameIndex:(int)frame_index
                withInstructionCode:(NSString *)code {
  if (self = [super init]) {
    try {
      internal.reset(new se::id::IdVideoAuthenticationInstruction(frame_index, [code UTF8String]));
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
      return nil;
    }
  }
  return self;
}

- (SEIdVideoAuthenticationInstructionRef *) getRef {
  return [[SEIdVideoAuthenticationInstructionRef alloc]
      initFromInternalVideoAuthenticationInstructionPointer:internal.get()
                                         withMutabilityFlag:NO];
}

- (SEIdVideoAuthenticationInstructionRef *) getMutableRef {
  return [[SEIdVideoAuthenticationInstructionRef alloc]
      initFromInternalVideoAuthenticationInstructionPointer:internal.get()
                                         withMutabilityFlag:YES];
}

@end
