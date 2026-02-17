/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_feedback_impl.h>

#import <objcsecommon_impl/se_geometry_impl.h>
#import <objcsecommon_impl/se_common_proxy_impl.h>

#include <secommon/se_exception.h>
#include <idengine/id_feedback.h>

#include <memory>

@implementation SEIdFeedbackContainerRef {
  se::id::IdFeedbackContainer* ptr;
  bool is_mutable;
}

- (instancetype) initFromInternalFeedbackContainerPointer:(se::id::IdFeedbackContainer *)feedbackptr
                                       withMutabilityFlag:(BOOL)mutabilityFlag {
  if (self = [super init]) {
    ptr = feedbackptr;
    is_mutable = (YES == mutabilityFlag);
  }
  return self;
}

- (se::id::IdFeedbackContainer *) getInternalFeedbackContainerPointer {
  return ptr;
}

- (BOOL) isMutable {
  return is_mutable? YES : NO;
}

- (nonnull SEIdFeedbackContainer *) clone {
  return [[SEIdFeedbackContainer alloc] initFromInternalFeedbackContainer:(*ptr)];
}

- (int) getQuadranglesCount {
  return ptr->GetQuadranglesCount();
}

- (BOOL) hasQuadrangleWithName:(NSString *)name {
  return ptr->HasQuadrangle([name UTF8String])? YES : NO;
}

- (SECommonQuadrangle *) getQuadrangleWithName:(NSString *)name {
  try {
    return [[SECommonQuadrangle alloc]
        initFromInternalQuadrangle:ptr->GetQuadrangle([name UTF8String])];
  } catch (const se::common::BaseException& e) {
    throwFromException(e);
  }
  return nil;
}

- (void) setQuadrangleWithName:(NSString *)name
                            to:(SECommonQuadrangle *)quad {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    ptr->SetQuadrangle([name UTF8String], [quad getInternalQuadrangle]);
  }
}

- (void) removeQuadrangleWithName:(NSString *)name {
  if (!is_mutable) {
    throwNonMutableRefException();
  } else {
    try {
      ptr->RemoveQuadrangle([name UTF8String]);
    } catch (const se::common::BaseException& e) {
      throwFromException(e);
    }
  }
}

- (SECommonQuadranglesMapIterator *) quadranglesBegin {
  return [[SECommonQuadranglesMapIterator alloc]
      initFromInternalQuadranglesMapIterator:ptr->QuadranglesBegin()];
}

- (SECommonQuadranglesMapIterator *) quadranglesEnd {
  return [[SECommonQuadranglesMapIterator alloc]
      initFromInternalQuadranglesMapIterator:ptr->QuadranglesEnd()];
}

@end

@implementation SEIdFeedbackContainer {
  std::unique_ptr<se::id::IdFeedbackContainer> internal;
}

- (instancetype) initFromInternalFeedbackContainer:(const se::id::IdFeedbackContainer &)feedback {
  if (self = [super init]) {
    internal.reset(new se::id::IdFeedbackContainer(feedback));
  }
  return self;
}

- (const se::id::IdFeedbackContainer &) getInternalFeedbackContainer {
  return *internal;
}

- (instancetype) init {
  if (self = [super init]) {
    internal.reset(new se::id::IdFeedbackContainer);
  }
  return self; 
}

- (SEIdFeedbackContainerRef *) getRef {
  return [[SEIdFeedbackContainerRef alloc] 
      initFromInternalFeedbackContainerPointer:internal.get()
                            withMutabilityFlag:NO];
}

- (SEIdFeedbackContainerRef *) getMutableRef {
  return [[SEIdFeedbackContainerRef alloc] 
      initFromInternalFeedbackContainerPointer:internal.get()
                            withMutabilityFlag:YES];
}

@end
