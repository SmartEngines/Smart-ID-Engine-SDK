/*
  Copyright (c) 2016-2021, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_video_authentication_callbacks.h
 * @brief id.engine video authentication session callback interface
 */

#ifndef IDENGINE_ID_VIDEO_AUTHENTICATION_CALLBACKS_H_INCLUDED
#define IDENGINE_ID_VIDEO_AUTHENTICATION_CALLBACKS_H_INCLUDED

#include <idengine/id_video_authentication_result.h>
#include <idengine/id_result.h>
#include <idengine/id_face_result.h>

namespace se { namespace id {


/**
 * @brief Abstract interface for receiving Smart ID Engine video identification
 *        & authentication session callbacks. All callbacks must be implemented.
 */
class SE_DLL_EXPORT IdVideoAuthenticationCallbacks {
public:
  /// Virtual dtor
  virtual ~IdVideoAuthenticationCallbacks();

  /**
   * @brief Called if a new instruction is generated by the session
   * @param index - index of the instruction in the transcript
   * @param instruction - updated instruction
   */
  virtual void InstructionReceived(
      int index,
      const IdVideoAuthenticationInstruction& instruction) = 0;

  /**
   * @brief Called if a new anomaly is registered
   * @param index - index of the anomaly in the transcript
   * @param anomaly - the newly registred anomaly
   */
  virtual void AnomalyRegistered(
      int index,
      const IdVideoAuthenticationAnomaly& anomaly) = 0;

  /**
   * @brief Called if internal document analysis result gets updated
   * @param document_result - new document analysis result
   */
  virtual void DocumentResultUpdated(const IdResult& document_result) = 0;

  /**
   * @brief Called if internal face matching result gets updated
   * @param face_matching_result - new face matching result
   */
  virtual void FaceMatchingResultUpdated(
      const IdFaceSimilarityResult& face_matching_result) = 0;

  /**
   * @brief Called if internal face liveness result gets updated
   * @param face_liveness_result - new face liveness result
   */
  virtual void FaceLivenessResultUpdated(
      const IdFaceLivenessResult& face_liveness_result) = 0;

  /**
   * @brief Called if internal authentication status get supdated
   * @param status - new authentication status
   */
  virtual void AuthenticationStatusUpdated(IdCheckStatus status) = 0;

  /**
   * @brief Called if global authentication timeout has been reached
   */
  virtual void GlobalTimeoutReached() = 0;

  /**
   * @brief Called if current instruction timeout has been reached
   */
  virtual void InstructionTimeoutReached() = 0;

  /**
   * @brief Callback which is called when the video authentication session ends.
   */
  virtual void SessionEnded() = 0;

  /**
   * @brief Called to provide various information
   */
  virtual void MessageReceived(const char* message) = 0;
};


} } // namespace se::id

#endif // IDENGINE_ID_VIDEO_AUTHENTICATION_CALLBACKS_H_INCLUDED
