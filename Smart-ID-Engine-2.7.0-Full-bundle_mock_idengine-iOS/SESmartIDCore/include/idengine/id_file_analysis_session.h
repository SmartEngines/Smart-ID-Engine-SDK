/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_file_analysis_session.h
 * @brief id.engine file_analysis session declaration
 */

#ifndef IDENGINE_ID_FILE_ANALYSIS_SESSION_H_INCLUDED
#define IDENGINE_ID_FILE_ANALYSIS_SESSION_H_INCLUDED

#include <secommon/se_common.h>
#include <idengine/id_result.h>

namespace se { namespace id {

/**
 * @brief The main processing class for the file_analysis
 *        functionality of Smart ID Engine
 */
class SE_DLL_EXPORT IdFileAnalysisSession {
public:
  /// Default dtor
  virtual ~IdFileAnalysisSession() = default;

  virtual const char* GetActivationRequest() = 0;

  virtual void Activate(const char* activation_response) = 0;

  virtual bool IsActivated() const = 0;

  /**
   * @brief Processes the input image (or frame)
   * @param image - the input image (or a frame of a video sequence)
   * @return The updated file_analysis result (const ref)
   */
  virtual const IdResult& Process(const se::common::Image& image) = 0;

  /// Returns the current file_analysis result (const ref)
  virtual const IdResult& GetCurrentResult() const = 0;

  /**
   * @brief Resets the session state
   */
  virtual void Reset() = 0;
};


} } // namespace se::id

#endif // IDENGINE_ID_FILE_ANALYSIS_SESSION_H_INCLUDED
