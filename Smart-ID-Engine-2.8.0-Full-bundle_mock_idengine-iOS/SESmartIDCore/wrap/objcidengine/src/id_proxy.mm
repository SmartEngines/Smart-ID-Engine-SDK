/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

#import <objcidengine_impl/id_proxy_impl.h>
#import <objcidengine_impl/id_face_result_impl.h>
#import <objcidengine_impl/id_fields_impl.h>
#import <objcidengine_impl/id_video_authentication_result.h>

IdProxyReporter::IdProxyReporter(id<SEIdFeedback> feedback_reporter) {
  feedbackReporter_ = feedback_reporter;
  recalculateCache();
}

void IdProxyReporter::setReporter(id<SEIdFeedback> feedback_reporter) {
  feedbackReporter_ = feedback_reporter;
  recalculateCache();
}

void IdProxyReporter::recalculateCache() {
  responds_to_feedback_received =
      [feedbackReporter_ respondsToSelector:@selector(feedbackReceived:)];
  responds_to_template_detections = 
      [feedbackReporter_ respondsToSelector:@selector(templateDetectionResultReceived:)];
  responds_to_template_segmentations =
      [feedbackReporter_ respondsToSelector:@selector(templateSegmentationResultReceived:)];
  responds_to_results = 
      [feedbackReporter_ respondsToSelector:@selector(resultReceived:)];
  responds_to_session_ended = 
      [feedbackReporter_ respondsToSelector:@selector(sessionEnded)];
}

void IdProxyReporter::FeedbackReceived(
    const se::id::IdFeedbackContainer& feedback_container) {
  if (feedbackReporter_ && responds_to_feedback_received) {
    [feedbackReporter_ feedbackReceived:[[SEIdFeedbackContainerRef alloc] 
        initFromInternalFeedbackContainerPointer:const_cast<se::id::IdFeedbackContainer*>(&feedback_container)
                              withMutabilityFlag:NO]];
  }
}

void IdProxyReporter::TemplateDetectionResultReceived(
    const se::id::IdTemplateDetectionResult& detection_result) {
  if (feedbackReporter_ && responds_to_template_detections) {
    [feedbackReporter_ templateDetectionResultReceived:[[SEIdTemplateDetectionResultRef alloc]
        initFromInternalTemplateDetectionResultPointer:const_cast<se::id::IdTemplateDetectionResult*>(&detection_result)
                                    withMutabilityFlag:NO]];
  }
}

void IdProxyReporter::TemplateSegmentationResultReceived(
    const se::id::IdTemplateSegmentationResult& segmentation_result) {
  if (feedbackReporter_ && responds_to_template_segmentations) {
    [feedbackReporter_ templateSegmentationResultReceived:[[SEIdTemplateSegmentationResultRef alloc]
        initFromInternalTemplateSegmentationResultPointer:const_cast<se::id::IdTemplateSegmentationResult*>(&segmentation_result)
                                       withMutabilityFlag:NO]];
  }
}

void IdProxyReporter::ResultReceived(const se::id::IdResult& result) {
  if (feedbackReporter_ && responds_to_results) {
    [feedbackReporter_ resultReceived:[[SEIdResultRef alloc]
        initFromInternalResultPointer:const_cast<se::id::IdResult*>(&result)
                   withMutabilityFlag:NO]];
  }
}

void IdProxyReporter::SessionEnded() {
  if (feedbackReporter_ && responds_to_session_ended) {
    [feedbackReporter_ sessionEnded];
  }
}

ProxyFaceReporter::ProxyFaceReporter(id<SEIdFaceFeedback> feedback_reporter) {
  feedbackReporter_ = feedback_reporter;
  recalculateCache();
}

void ProxyFaceReporter::setReporter(id<SEIdFaceFeedback> feedback_reporter) {
  feedbackReporter_ = feedback_reporter;
  recalculateCache();
}

void ProxyFaceReporter::recalculateCache() {
  responds_to_message_received = 
      [feedbackReporter_ respondsToSelector:@selector(messageReceived:)];
}

void ProxyFaceReporter::MessageReceived(const char* message) {
  if (feedbackReporter_ && responds_to_message_received) {
    [feedbackReporter_ messageReceived:[NSString stringWithUTF8String:message]];
  }
}

///

ProxyVideoAuthenticationCallbacks::ProxyVideoAuthenticationCallbacks(id<SEIdVideoAuthenticationCallbacks> callbacks) {
  videoAuthenticationCallbacks_ = callbacks;
  recalculateCache();
}

void ProxyVideoAuthenticationCallbacks::setCallbacks(id<SEIdVideoAuthenticationCallbacks> callbacks) {
  videoAuthenticationCallbacks_ = callbacks;
  recalculateCache();
}

void ProxyVideoAuthenticationCallbacks::recalculateCache() {
  responds_to_instruction_received = 
      [videoAuthenticationCallbacks_ respondsToSelector:@selector(instructionReceived:atFrameIndex:)];
  responds_to_anomaly_registered = 
      [videoAuthenticationCallbacks_ respondsToSelector:@selector(anomalyRegistered:atFrameIndex:)];
  responds_to_document_result_updated = 
      [videoAuthenticationCallbacks_ respondsToSelector:@selector(documentResultUpdatedTo:)];
  responds_to_face_matching_result_updated = 
      [videoAuthenticationCallbacks_ respondsToSelector:@selector(faceMatchingResultUpdatedTo:)];
  responds_to_face_liveness_result_updated = 
      [videoAuthenticationCallbacks_ respondsToSelector:@selector(faceLivenessResultUpdatedTo:)];
  responds_to_authentication_status_updated = 
      [videoAuthenticationCallbacks_ respondsToSelector:@selector(authenticationStatusUpdatedTo:)];
  responds_to_global_timeout_reached =
      [videoAuthenticationCallbacks_ respondsToSelector:@selector(globalTimeoutReached)];
  responds_to_instruction_timeout_reached = 
      [videoAuthenticationCallbacks_ respondsToSelector:@selector(instructionTimeoutReached)];
  responds_to_session_ended = 
      [videoAuthenticationCallbacks_ respondsToSelector:@selector(sessionEnded)];
  responds_to_message_received = 
      [videoAuthenticationCallbacks_ respondsToSelector:@selector(messageReceived:)];
}

void ProxyVideoAuthenticationCallbacks::InstructionReceived(
    int index,
    const se::id::IdVideoAuthenticationInstruction& instruction) {
  if (videoAuthenticationCallbacks_ && responds_to_instruction_received) {
    [videoAuthenticationCallbacks_ instructionReceived:[[SEIdVideoAuthenticationInstructionRef alloc]
        initFromInternalVideoAuthenticationInstructionPointer:const_cast<se::id::IdVideoAuthenticationInstruction*>(&instruction)
                                           withMutabilityFlag:NO]
                                          atFrameIndex:index];
  }
}

void ProxyVideoAuthenticationCallbacks::AnomalyRegistered(
    int index,
    const se::id::IdVideoAuthenticationAnomaly& anomaly) {
  if (videoAuthenticationCallbacks_ && responds_to_anomaly_registered) {
    [videoAuthenticationCallbacks_ anomalyRegistered:[[SEIdVideoAuthenticationAnomalyRef alloc]
        initFromInternalVideoAuthenticationAnomalyPointer:const_cast<se::id::IdVideoAuthenticationAnomaly*>(&anomaly)
                                       withMutabilityFlag:NO]
                                        atFrameIndex:index];
  }
}

void ProxyVideoAuthenticationCallbacks::DocumentResultUpdated(const se::id::IdResult& document_result) {
  if (videoAuthenticationCallbacks_ && responds_to_document_result_updated) {
    [videoAuthenticationCallbacks_ documentResultUpdatedTo:[[SEIdResultRef alloc]
        initFromInternalResultPointer:const_cast<se::id::IdResult*>(&document_result)
                   withMutabilityFlag:NO]];
  }
}

void ProxyVideoAuthenticationCallbacks::FaceMatchingResultUpdated(
    const se::id::IdFaceSimilarityResult& face_matching_result) {
  if (videoAuthenticationCallbacks_ && responds_to_face_matching_result_updated) {
    [videoAuthenticationCallbacks_ faceMatchingResultUpdatedTo:[[SEIdFaceSimilarityResultRef alloc]
        initFromInternalFaceSimilarityResultPointer:const_cast<se::id::IdFaceSimilarityResult*>(&face_matching_result)
                                 withMutabilityFlag:NO]];
  }
}

void ProxyVideoAuthenticationCallbacks::FaceLivenessResultUpdated(
    const se::id::IdFaceLivenessResult& face_liveness_result) {
  if (videoAuthenticationCallbacks_ && responds_to_face_liveness_result_updated) {
    [videoAuthenticationCallbacks_ faceLivenessResultUpdatedTo:[[SEIdFaceLivenessResultRef alloc]
        initFromInternalFaceLivenessResultPointer:const_cast<se::id::IdFaceLivenessResult*>(&face_liveness_result)
                               withMutabilityFlag:NO]];
  }
}

void ProxyVideoAuthenticationCallbacks::AuthenticationStatusUpdated(
    se::id::IdCheckStatus status) {
  if (videoAuthenticationCallbacks_ && responds_to_authentication_status_updated) {
    [videoAuthenticationCallbacks_ authenticationStatusUpdatedTo:status_i2e(status)];
  }
}

void ProxyVideoAuthenticationCallbacks::GlobalTimeoutReached() {
  if (videoAuthenticationCallbacks_ && responds_to_global_timeout_reached) {
    [videoAuthenticationCallbacks_ globalTimeoutReached];
  }
}

void ProxyVideoAuthenticationCallbacks::InstructionTimeoutReached() {
  if (videoAuthenticationCallbacks_ && responds_to_instruction_timeout_reached) {
    [videoAuthenticationCallbacks_ instructionTimeoutReached];
  }
}

void ProxyVideoAuthenticationCallbacks::SessionEnded() {
  if (videoAuthenticationCallbacks_ && responds_to_session_ended) {
    [videoAuthenticationCallbacks_ sessionEnded];
  }
}

void ProxyVideoAuthenticationCallbacks::MessageReceived(const char* message) {
  if (videoAuthenticationCallbacks_ && responds_to_message_received) {
    [videoAuthenticationCallbacks_ messageReceived:[NSString stringWithUTF8String:message]];
  }
}
