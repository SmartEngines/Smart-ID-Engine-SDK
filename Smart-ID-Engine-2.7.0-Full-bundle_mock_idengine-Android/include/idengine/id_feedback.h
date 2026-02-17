/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_feedback.h
 * @brief id.engine session feedback classes declaration
 */

#ifndef IDENGINE_ID_FEEDBACK_H_INCLUDED
#define IDENGINE_ID_FEEDBACK_H_INCLUDED

#include <idengine/id_result.h>
#include <secommon/se_geometry.h>

namespace se { namespace id {

/**
 * @brief The class representing the visual feedback container - a collection
 *        of named quadrangles in an image
 */
class SE_DLL_EXPORT IdFeedbackContainer {
public:
  /// Non-trivial dtor
  ~IdFeedbackContainer();

  /// Default ctor - creates an empty container
  IdFeedbackContainer();

  /// Copy ctor
  IdFeedbackContainer(const IdFeedbackContainer& copy);

  /// Assignment operator
  IdFeedbackContainer& operator =(const IdFeedbackContainer& other);

public:

  /// Returns the number of quadrangles in the container
  int GetQuadranglesCount() const;

  /// Returns true iff there exists a quadrangle with a given name
  bool HasQuadrangle(const char* quad_name) const;

  /// Returns the quadrangle with a given name
  const se::common::Quadrangle& GetQuadrangle(const char* quad_name) const;

  /// Sets the quadrangle for a given name
  void SetQuadrangle(const char* quad_name, const se::common::Quadrangle& quad);

  /// Removes the quadrangle with a given name from the collection
  void RemoveQuadrangle(const char* quad_name);

  /// Returns the 'begin' map iterator to the quadrangles collection
  se::common::QuadranglesMapIterator QuadranglesBegin() const;

  /// Returns the 'end' map iterator to the quadrangles collection
  se::common::QuadranglesMapIterator QuadranglesEnd() const;

private:
  class IdFeedbackContainerImpl* pimpl_; ///< internal implementation
};


/**
 * @brief Abstract interface for receiving Smart ID Engine callbacks. All
 *        callbacks must be implemented.
 */
class SE_DLL_EXPORT IdFeedback {
public:
  /// Virtual dtor
  virtual ~IdFeedback();

  /**
   * @brief Callback for receiving visualization container
   * @param feedback_container - the received visualization container
   *        (a collection of named quadrangles)
   */
  virtual void FeedbackReceived(
      const IdFeedbackContainer& feedback_container) = 0;

  /**
   * @brief Callback for receiving a document page (template) detection result
   * @param detection_result - the received document page (template) detection result
   */
  virtual void TemplateDetectionResultReceived(
      const IdTemplateDetectionResult& detection_result) = 0;

  /**
   * @brief Callback for receiving a page (template) segmentation result
   * @param segmentation_result - the received document page (template) segmentation result
   */
  virtual void TemplateSegmentationResultReceived(
      const IdTemplateSegmentationResult& segmentation_result) = 0;

  /**
   * @brief Callback for receiving a full document recognition result
   * @param result_received - the received document recognition result
   */
  virtual void ResultReceived(const IdResult& result_received) = 0;

  /**
   * @brief Callback which is called when the video stream recognition session
   *        ends (the result becomes terminal).
   */
  virtual void SessionEnded() = 0;
};

} } // namespace se::id

#endif // IDENGINE_ID_FEEDBACK_H_INCLUDED
