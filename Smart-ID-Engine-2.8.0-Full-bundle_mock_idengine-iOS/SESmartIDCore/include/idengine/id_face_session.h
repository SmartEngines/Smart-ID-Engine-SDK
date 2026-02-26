/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_face_session.h
 * @brief id.engine face session declaration
 */

#ifndef IDENGINE_ID_FACE_SESSION_H_INCLUDED
#define IDENGINE_ID_FACE_SESSION_H_INCLUDED

#include <secommon/se_common.h>
#include <idengine/id_face_result.h>

namespace se { namespace id {

/**
 * @brief The main processing class for the face matching and analysis
 *        functionality of Smart ID Engine
 */
class SE_DLL_EXPORT IdFaceSession {
public:
  /// Default dtor
  virtual ~IdFaceSession() = default;

  virtual const char* GetActivationRequest() = 0;

  virtual void Activate(const char* activation_response) = 0;

  virtual bool IsActivated() const = 0;

  /**
   * @brief Returns the similarity result for the two provided face images
   *        (independent from session state)
   * @param face_image_a - lvalue image for comparison
   * @param face_image_b - rvalue image for comparison
   * @return A similarity comparison result object
   */
  virtual IdFaceSimilarityResult GetSimilarity(
      const se::common::Image& face_image_a,
      const se::common::Image& face_image_b) const = 0;

  /**
   * @brief Returns the similarity result for the stream of images stored in the
   *        session state (lvalue) with an passed rvalue image
   * @param compare_image - the rvalue image to compare the state with
   * @return A similarity comparison result object
   */
  virtual IdFaceSimilarityResult GetSimilarityWith(
      const se::common::Image& compare_image) const = 0;

  /**
   * @brief Adds a new face image to the current liveness session object
   * @param face_image - the image of a face to be added
   */
  virtual void AddFaceImage(const se::common::Image& face_image) = 0;

  /**
   * @brief Adds a new face image to the current face similarity session object
   * @param face_image - the image of a face to be added
   */
  virtual void SetFaceToMatchWith(const se::common::Image& face_image) = 0;

  /**
   * @brief Gets rectangles for all faces presented within the given image
   * @param image - the source image
   * @return Found face rectangles
   */
  virtual IdFaceRectsResult GetRects(const common::Image& image) const = 0;

  /**
   * @brief Checks whether the session has an accumulated face description
   * @return Returns true if the session has an accumulated face description
   */
  virtual bool HasAccumulatedImage() const = 0;

  /**
   * @brief Returns the liveness estimation result for the stream of images
   *        passed through the session
   * @return A liveness estimation result object
   */
  virtual IdFaceLivenessResult GetLivenessResult() const = 0;

  /**
   * @brief Returns the number of instructions that user needs to pass liveness.
   * @return A number of instructions that user needs to pass liveness.
   */
  virtual unsigned int GetInstructionsCount() const = 0;

  /**
   * @brief Returns number of images pushed to session.
   * @return Number of pushed images.
   */
  virtual unsigned int GetPushedImagesCount() const = 0;

  /**
   * @brief Returns number of instructions, that can be failed to pass liveness successfully.
   * @return Number of instructions that can be failed.
   */
  virtual unsigned int GetAllowedNumberOfFailedInstructions() const = 0;

  /**
   * @brief Returns time of the first instruction, where face is initialized.
   * @return Time of the first instruction in milliseconds.
   */
  virtual unsigned int GetInitializerInstructionTime() const = 0;

  /**
   * @brief Returns status of option that allows passing all instruction even if they are failed.
   * @return True(0) if oprion is on (allow) and false (0) if off (forbiden).
   */
  virtual unsigned int GetPassAllInstruction() const = 0;

#ifdef WITH_IDFACE_INTERNAL
  /**
   * @brief Returns number of images pushed to liveness queue.
   * @return Number of pushed to liveness queue images.
   */
  virtual unsigned int GetInternallyAcceptedImagesCount() const = 0;

  virtual IdFaceDescription Process(const se::common::Image& data) = 0;
#endif
  /**
   * @brief Resets the session state
   */
  virtual void Reset() = 0;
};


} } // namespace se::id

#endif // IDENGINE_ID_FACE_SESSION_H_INCLUDED
