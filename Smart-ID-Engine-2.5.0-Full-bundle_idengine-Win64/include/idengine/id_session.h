/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_session.h
 * @brief id.engine session declaration
 */

#ifndef IDENGINE_ID_SESSION_H_INCLUDED
#define IDENGINE_ID_SESSION_H_INCLUDED

#include <secommon/se_common.h>
#include <idengine/id_result.h>

namespace se { namespace id {


/**
 * @brief The main processing class for the Smart ID Engine documen recognition
 *        functionality
 */
class SE_DLL_EXPORT IdSession {
public:

  /// Default dtor
  virtual ~IdSession() = default;
  
  /**
   * @brief Get an activation request for this session (valid for SDK built with dynamic activation feature)
   * @return A string with activation request
   */
  virtual const char* GetActivationRequest() = 0;

  /**
   * @brief Activate current session (valid for SDK built with dynamic activation feature)
   * @param activation_response - the response from activation server
   */
  virtual void Activate(const char* activation_response) = 0;

  /**
   * @brief Check if current session was activated (valid for SDK built with dynamic activation feature)
   * @return Boolen check (true/false)
   */
  virtual bool IsActivated() const = 0;

  /**
   * @brief Processes the input image (or frame)
   * @param image - the input image (or a frame of a video sequence)
   * @return The updated document recognition result (const ref)
   */
  virtual const IdResult& Process(const se::common::Image& image) = 0;

  /**
   * @brief Processes the input byte string
   * @param data - the input json containing a description of templates and fields
   * @return The updated document recognition result (const ref)
   */
  virtual const IdResult& Process(const se::common::ByteString& data) = 0;

  /// Returns the current document recognition result (const ref)
  virtual const IdResult& GetCurrentResult() const = 0;

  /// Returns true iff the current document recognition result is terminal
  virtual bool IsResultTerminal() const = 0;

  /// Resets the session state
  virtual void Reset() = 0;
};


} } // namespace se::id

#endif // IDENGINE_ID_SESSION_H_INCLUDED
