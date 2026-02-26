/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_ID_FEEDBACK_H_INCLUDED
#define OBJCIDENGINE_ID_FEEDBACK_H_INCLUDED

#import <Foundation/Foundation.h>

#import <objcsecommon/se_geometry.h>
#import <objcidengine/id_result.h>

@class SEIdFeedbackContainer;

@interface SEIdFeedbackContainerRef : NSObject

- (BOOL) isMutable;

- (nonnull SEIdFeedbackContainer *) clone;

- (int) getQuadranglesCount;
- (BOOL) hasQuadrangleWithName:(nonnull NSString *)name;
- (nonnull SECommonQuadrangle *) getQuadrangleWithName:(nonnull NSString *)name;
- (void) setQuadrangleWithName:(nonnull NSString *)name
                            to:(nonnull SECommonQuadrangle *)quad;
- (void) removeQuadrangleWithName:(nonnull NSString *)name;

- (nonnull SECommonQuadranglesMapIterator *) quadranglesBegin;
- (nonnull SECommonQuadranglesMapIterator *) quadranglesEnd;

@end


@interface SEIdFeedbackContainer : NSObject

- (nonnull instancetype) init;

- (nonnull SEIdFeedbackContainerRef *) getRef;
- (nonnull SEIdFeedbackContainerRef *) getMutableRef;

@end


@protocol SEIdFeedback <NSObject>

@optional

- (void) feedbackReceived:(nonnull SEIdFeedbackContainerRef *)feedback;
- (void) templateDetectionResultReceived:(nonnull SEIdTemplateDetectionResultRef *)result;
- (void) templateSegmentationResultReceived:(nonnull SEIdTemplateSegmentationResultRef *)result;
- (void) resultReceived:(nonnull SEIdResultRef *)result;
- (void) sessionEnded;

@end

#endif // OBJCIDENGINE_ID_FEEDBACK_H_INCLUDED