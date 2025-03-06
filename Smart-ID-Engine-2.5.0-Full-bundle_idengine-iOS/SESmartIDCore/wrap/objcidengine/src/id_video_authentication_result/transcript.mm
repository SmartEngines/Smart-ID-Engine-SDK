/*
  Copyright (c) 2016-2021, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_video_authentication_result.h>

#import <objcsecommon_impl/se_common_proxy_impl.h>

@implementation SEIdVideoAuthenticationTranscriptRef {
  se::id::IdVideoAuthenticationTranscript* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalVideoAuthenticationTranscriptPointer:(se::id::IdVideoAuthenticationTranscript *)transcript_ptr
                                                   withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = transcript_ptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdVideoAuthenticationTranscript *) getInternalVideoAuthenticationTranscriptPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (int) getFrameInfosCount {
  return ptr->GetFrameInfosCount();
}

- (SEIdVideoAuthenticationFrameInfoRef *) getFrameInfoAt:(int)index {
  try {
    return [[SEIdVideoAuthenticationFrameInfoRef alloc]
        initFromInternalVideoAuthenticationFrameInfoPointer:const_cast<se::id::IdVideoAuthenticationFrameInfo*>(&ptr->GetFrameInfo(index))
                                         withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SEIdVideoAuthenticationFrameInfoRef *) getMutableFrameInfoAt:(int)index {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      return [[SEIdVideoAuthenticationFrameInfoRef alloc]
          initFromInternalVideoAuthenticationFrameInfoPointer:&ptr->GetMutableFrameInfo(index)
                                           withMutabilityFlag:YES];
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
  return nil;
}

- (void) appendFrameInfo:(SEIdVideoAuthenticationFrameInfoRef *)frame_info {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->AppendFrameInfo(*[frame_info getInternalVideoAuthenticationFrameInfoPointer]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }  
}

- (void) setFrameInfoAt:(int)index
                     to:(SEIdVideoAuthenticationFrameInfoRef *)frame_info {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetFrameInfo(index, *[frame_info getInternalVideoAuthenticationFrameInfoPointer]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (void) resizeFrameInfosContainerTo:(int)size {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->ResizeFrameInfosContainer(size);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}


- (int) getInstructionsCount {
  return ptr->GetInstructionsCount();
}

- (SEIdVideoAuthenticationInstructionRef *) getInstructionAt:(int)index {
  try {
    return [[SEIdVideoAuthenticationInstructionRef alloc]
        initFromInternalVideoAuthenticationInstructionPointer:const_cast<se::id::IdVideoAuthenticationInstruction*>(&ptr->GetInstruction(index))
                                         withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SEIdVideoAuthenticationInstructionRef *) getMutableInstructionAt:(int)index {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      return [[SEIdVideoAuthenticationInstructionRef alloc]
          initFromInternalVideoAuthenticationInstructionPointer:&ptr->GetMutableInstruction(index)
                                           withMutabilityFlag:YES];
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
  return nil;
}

- (void) appendInstruction:(SEIdVideoAuthenticationInstructionRef *)instruction {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->AppendInstruction(*[instruction getInternalVideoAuthenticationInstructionPointer]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }  
}

- (void) setInstructionAt:(int)index
                       to:(SEIdVideoAuthenticationInstructionRef *)instruction {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetInstruction(index, *[instruction getInternalVideoAuthenticationInstructionPointer]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (void) resizeInstructionsContainerTo:(int)size {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->ResizeInstructionsContainer(size);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}


- (int) getAnomaliesCount {
  return ptr->GetAnomaliesCount();
}

- (SEIdVideoAuthenticationAnomalyRef *) getAnomalyAt:(int)index {
  try {
    return [[SEIdVideoAuthenticationAnomalyRef alloc]
        initFromInternalVideoAuthenticationAnomalyPointer:const_cast<se::id::IdVideoAuthenticationAnomaly*>(&ptr->GetAnomaly(index))
                                         withMutabilityFlag:NO];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (SEIdVideoAuthenticationAnomalyRef *) getMutableAnomalyAt:(int)index {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      return [[SEIdVideoAuthenticationAnomalyRef alloc]
          initFromInternalVideoAuthenticationAnomalyPointer:&ptr->GetMutableAnomaly(index)
                                           withMutabilityFlag:YES];
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
  return nil;
}

- (void) appendAnomaly:(SEIdVideoAuthenticationAnomalyRef *)anomaly {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->AppendAnomaly(*[anomaly getInternalVideoAuthenticationAnomalyPointer]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }  
}

- (void) setAnomalyAt:(int)index
                   to:(SEIdVideoAuthenticationAnomalyRef *)anomaly {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetAnomaly(index, *[anomaly getInternalVideoAuthenticationAnomalyPointer]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (void) resizeAnomaliesContainerTo:(int)size {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->ResizeAnomaliesContainer(size);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}


- (SEIdVideoAuthenticationInstructionRef *) getCurrentInstruction {
  return [[SEIdVideoAuthenticationInstructionRef alloc]
      initFromInternalVideoAuthenticationInstructionPointer:const_cast<se::id::IdVideoAuthenticationInstruction*>(&ptr->GetCurrentInstruction())
                                         withMutabilityFlag:NO];
}

- (SEIdVideoAuthenticationInstructionRef *) getMutableCurrentInstruction {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    return [[SEIdVideoAuthenticationInstructionRef alloc]
        initFromInternalVideoAuthenticationInstructionPointer:&ptr->GetMutableCurrentInstruction()
                                           withMutabilityFlag:YES];
  }
  return nil;
}

- (void) setCurrentInstructionTo:(SEIdVideoAuthenticationInstructionRef *)instruction {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->SetCurrentInstruction(*[instruction getInternalVideoAuthenticationInstructionPointer]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

@end
