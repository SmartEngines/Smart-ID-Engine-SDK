/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

#ifndef OBJCIDENGINE_IMPL_ID_PROXY_H_INCLUDED
#define OBJCIDENGINE_IMPL_ID_PROXY_H_INCLUDED

#import <objcidengine_impl/id_feedback_impl.h>
#import <objcidengine_impl/id_result_impl.h>

#import <objcidengine/id_face_feedback.h>
#import <objcidengine_impl/id_video_authentication_callbacks.h>
#import <objcidengine_impl/id_video_authentication_result.h>

#include <idengine/id_feedback.h>
#include <idengine/id_face_feedback.h>
#include <idengine/id_video_authentication_callbacks.h>

class IdProxyReporter : public se::id::IdFeedback {
public:
  IdProxyReporter(id<SEIdFeedback> feedback_reporter);

  void setReporter(id<SEIdFeedback> feedback_reporter);

  virtual void FeedbackReceived(
      const se::id::IdFeedbackContainer& feedback_container) override final;

  virtual void TemplateDetectionResultReceived(
      const se::id::IdTemplateDetectionResult& detection_result) override final;

  virtual void TemplateSegmentationResultReceived(
      const se::id::IdTemplateSegmentationResult& segmentation_result) override final;

  virtual void ResultReceived(const se::id::IdResult& result) override final;

  virtual void SessionEnded() override final;

private:
  void recalculateCache();

  id<SEIdFeedback> feedbackReporter_; // should be weak, no refcounts

  bool responds_to_feedback_received = false;
  bool responds_to_template_detections = false;
  bool responds_to_template_segmentations = false;
  bool responds_to_results = false;
  bool responds_to_session_ended = false;
};

class ProxyFaceReporter : public se::id::IdFaceFeedback {
public:
  ProxyFaceReporter(id<SEIdFaceFeedback> feedback_reporter);

  void setReporter(id<SEIdFaceFeedback> feedback_reporter);

  virtual void MessageReceived(const char* message) override final;

private:
  void recalculateCache();

  id<SEIdFaceFeedback> feedbackReporter_; // should be weak, no refcounts

  bool responds_to_message_received = false;
};

class ProxyVideoAuthenticationCallbacks : public se::id::IdVideoAuthenticationCallbacks {
public:
  ProxyVideoAuthenticationCallbacks(id<SEIdVideoAuthenticationCallbacks> callbacks);

  void setCallbacks(id<SEIdVideoAuthenticationCallbacks> callbacks);

  virtual void InstructionReceived(
      int index,
      const se::id::IdVideoAuthenticationInstruction& instruction) override final;

  virtual void AnomalyRegistered(
      int index,
      const se::id::IdVideoAuthenticationAnomaly& anomaly) override final;

  virtual void DocumentResultUpdated(const se::id::IdResult& document_result) override final;

  virtual void FaceMatchingResultUpdated(
      const se::id::IdFaceSimilarityResult& face_matching_result) override final;

  virtual void FaceLivenessResultUpdated(
      const se::id::IdFaceLivenessResult& face_liveness_result) override final;

  virtual void AuthenticationStatusUpdated(se::id::IdCheckStatus status) override final;

  virtual void GlobalTimeoutReached() override final;

  virtual void InstructionTimeoutReached() override final;

  virtual void SessionEnded() override final;

  virtual void MessageReceived(const char* message) override final;

private:
  void recalculateCache();

  id<SEIdVideoAuthenticationCallbacks> videoAuthenticationCallbacks_; // should be weak, no refcounts

  bool responds_to_instruction_received = false;
  bool responds_to_anomaly_registered = false;
  bool responds_to_document_result_updated = false;
  bool responds_to_face_matching_result_updated = false;
  bool responds_to_face_liveness_result_updated = false;
  bool responds_to_authentication_status_updated = false;
  bool responds_to_global_timeout_reached = false;
  bool responds_to_instruction_timeout_reached = false;
  bool responds_to_session_ended = false;
  bool responds_to_message_received = false;
};

#endif // OBJCIDENGINE_IMPL_ID_PROXY_H_INCLUDED
