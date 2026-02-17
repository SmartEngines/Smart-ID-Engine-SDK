/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_FEEDBACK_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_FEEDBACK_H_INCLUDED

#import <objcidengine/id_feedback.h>

#include <idengine/id_feedback.h>

@interface SEIdFeedbackContainerRef (Internal)

- (instancetype) initFromInternalFeedbackContainerPointer:(se::id::IdFeedbackContainer *)feedbackptr
                                       withMutabilityFlag:(BOOL)mutabilityFlag;
- (se::id::IdFeedbackContainer *) getInternalFeedbackContainerPointer;

@end


@interface SEIdFeedbackContainer (Internal)

- (instancetype) initFromInternalFeedbackContainer:(const se::id::IdFeedbackContainer &)feedback;
- (const se::id::IdFeedbackContainer &) getInternalFeedbackContainer;

@end

#endif // OBJCIDENGINE_IMPL_ID_FEEDBACK_H_INCLUDED