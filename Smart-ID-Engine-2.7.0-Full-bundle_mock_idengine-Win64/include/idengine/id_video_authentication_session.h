/*
  Copyright (c) 2016-2021, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_video_authentication_session.h
 * @brief id.engine video authentication session declaration
 */

#ifndef IDENGINE_ID_VIDEO_AUTHENTICATION_SESSION_H_INCLUDED
#define IDENGINE_ID_VIDEO_AUTHENTICATION_SESSION_H_INCLUDED

#include <secommon/se_common.h>

#include <idengine/id_result.h>
#include <idengine/id_face_result.h>

#include <idengine/id_video_authentication_result.h>

namespace se { namespace id {


/**
 * @brief The main processing class for the Smart ID Engine video identification
 *        and authentification functionality
 */
class SE_DLL_EXPORT IdVideoAuthenticationSession {
public:

  /// Default dtor
  virtual ~IdVideoAuthenticationSession() = default;

  /**
   * @brief Returns a unique activation request (required for builds with
   *        dynamic activation)
   * @return an activation request string
   */
  virtual const char* GetActivationRequest() = 0;

  /**
   * @brief Activates the session with the provided dynamic activation response
   * @param activation_response - dynamic activation response string
   */
  virtual void Activate(const char* activation_response) = 0;

  /**
   * @brief Checks whether the session is activated
   * @return Returns true iff the session is activated
   */
  virtual bool IsActivated() const = 0;

  /**
   * @brief Processes the input video frame
   * @param frame - the input video frame
   */
  virtual void ProcessFrame(const se::common::Image& frame) = 0;

  /**
   * @brief Processes the input byte string
   * @param data - the input json containing a description of templates and fields
   */
  virtual void ProcessData(const se::common::ByteString& data) = 0;


  /// Returns the current instruction (const ref)
  virtual const IdVideoAuthenticationInstruction& GetCurrentInstruction() const = 0;

  /// Returns true iff the session has accumulated document analysis result
  virtual bool HasDocumentResult() const = 0;

  /// Returns the current document recognition result (const ref)
  virtual const IdResult& GetDocumentResult() const = 0;

  /// Returns true iff the session has obtained face matching result
  virtual bool HasFaceMatchingResult() const = 0;

  /// Returns the current document-selfie face matching result (const ref)
  virtual const IdFaceSimilarityResult& GetFaceMatchingResult() const = 0;

  /// Returns true iff the session has obtained face liveness result
  virtual bool HasFaceLivenessResult() const = 0;

  /// Returns the current face liveness result (const ref)
  virtual const IdFaceLivenessResult& GetFaceLivenessResult() const = 0;

  /// Returns the current authentication status
  virtual IdCheckStatus GetAuthenticationStatus() const = 0;


  /// Returns the current video authentication transcript (const ref)
  virtual const IdVideoAuthenticationTranscript& GetTranscript() const = 0;


  /**
   * @brief Suspends the internal timekeeping - the time session is suspended
   *        will not be counted in timeouts. ProcessFrame() or Reset() will
   *        resume the session.
   */
  virtual void Suspend() = 0;

  /**
   * @brief Resumes the session if it is suspended. Automatically called by
   *        ProcessFrame() and Reset().
   */
  virtual void Resume() = 0;

  /// Resets the session state
  virtual void Reset() = 0;
};


} } // namespace se::id

#endif // IDENGINE_ID_VIDEO_AUTHENTICATION_SESSION_H_INCLUDED
