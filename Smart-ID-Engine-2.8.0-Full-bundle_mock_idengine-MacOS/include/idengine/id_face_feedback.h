/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_face_feedback.h
 * @brief id.engine face matching session feedback classes declaration
 */

#ifndef IDENGINE_ID_FACE_FEEDBACK_H_INCLUDED
#define IDENGINE_ID_FACE_FEEDBACK_H_INCLUDED

#include <secommon/se_common.h>

namespace se { namespace id {

/**
 * @brief Abstract interface for receiving Smart ID Engine face session
 *        callbacks. All callbacks must be implemented.
 */
class SE_DLL_EXPORT IdFaceFeedback {
public:
  /// Virtual dtor
  virtual ~IdFaceFeedback();

  /**
   * @brief Callback for receiving face session messages
   * @param message - message from face matching session
   */
  virtual void MessageReceived(const char* message) = 0;
};

} } // namespace se::id

#endif // IDENGINE_ID_FACE_FEEDBACK_H_INCLUDED
