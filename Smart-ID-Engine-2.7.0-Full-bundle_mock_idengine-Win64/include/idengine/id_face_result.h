/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_face_result.h
 * @brief id.engine face results declaration
 */

#ifndef IDENGINE_ID_FACE_RESULT_H_INCLUDED
#define IDENGINE_ID_FACE_RESULT_H_INCLUDED

#include <secommon/se_common.h>

namespace se { namespace id {

enum SE_DLL_EXPORT IdFaceStatus {
  IdFaceStatus_NotUsed,            ///< Was created but not used
  IdFaceStatus_Success,            ///< Everything alright
  IdFaceStatus_A_FaceNotFound,     ///< Face was not found for image A
  IdFaceStatus_B_FaceNotFound,     ///< Face was not found for image B
  IdFaceStatus_FaceNotFound,       ///< There is no face found
  IdFaceStatus_NoAccumulatedResult ///< Face matching with session where is no Accumulated result
};

enum SE_DLL_EXPORT IdFaceSimilarity {
  Different,   ///< Faces are totally different
  Uncertain,   ///< Faces cannot be identified as totally the same
  Same,        ///< Faces are totally the same
};

/// Forward-declaration of the internal IdFaceLivenessResult implementation
class IdFaceLivenessResultImpl;

/**
 * @brief The class which represents the face liveness result
 */
class SE_DLL_EXPORT IdFaceLivenessResult {
public:
    /// Non-trivial dtor
    ~IdFaceLivenessResult();

    /// Main ctor - stores the liveness estimation value
    IdFaceLivenessResult(double liveness_estimation = 0.0);

    /// Copy ctor
    IdFaceLivenessResult(const IdFaceLivenessResult& copy);

    /// Assignment operator
    IdFaceLivenessResult& operator =(const IdFaceLivenessResult& other);

public:
    /// Returns the liveness estimation value (double in range [0.0, 1.0])
    double GetLivenessEstimation() const;

    /// Sets the liveness estimation value
    void SetLivenessEstimation(double liveness_estimation);

    /// Returns pointer to the start of the instruction char*
    const char* GetLivenessInstruction() const;

    /// Sets instruction to check liveness
    void SetLivenessInstruction(const char* instruction);

private:
    IdFaceLivenessResultImpl* pimpl_; ///< internal implementation
};

/// Forward-declaration of the IdFaceSimilarityResult internal implementation
class IdFaceSimilarityResultImpl;

/**
 * @brief The class representing the face similarity comparison result
 */
class SE_DLL_EXPORT IdFaceSimilarityResult {
public:
  /// Non-trivial dtor
  ~IdFaceSimilarityResult();

  /// Main ctor - stores the similarity estimation value
  IdFaceSimilarityResult(double distance = 0.0f, IdFaceStatus status = IdFaceStatus_NotUsed);

  /// Copy ctor
  IdFaceSimilarityResult(const IdFaceSimilarityResult& copy);

  /// Assignment operator
  IdFaceSimilarityResult& operator = (const IdFaceSimilarityResult& other);

public:
  /// Gets the faces similarity estimation value (dobule in range [0.0, 1.0])
  double GetSimilarityEstimation() const;

  /// Sets the faces similarity estimation value
  void SetSimilarityEstimation(double similarity_estimation);

  /// Get the process status
  IdFaceStatus GetStatus() const;

  /// Set the process status
  void SetStatus(const IdFaceStatus& status);

  /// Gets the faces similarity
  IdFaceSimilarity GetSimilarity() const;

private:
  IdFaceSimilarityResultImpl* pimpl_; ///< internal implementation
};

/// Forward-declaration of the IdFaceRectsResult internal implementation
class IdFaceRectsResultImpl;

/**
 * @brief The class representing the face rectangle find result
 */
class SE_DLL_EXPORT IdFaceRectsResult {
public:
  /// Non-trivial dtor
  ~IdFaceRectsResult();

  /// Main ctor
  IdFaceRectsResult();

  /// Copy ctor
  IdFaceRectsResult(const IdFaceRectsResult& copy);

  /// Assignment operator
  IdFaceRectsResult& operator = (const IdFaceRectsResult& other);

public:
  /// Add face rect to pimpl
  void AddFaceRect(const se::common::Rectangle& inp_rect);

  /// Clear all rects from class
  void Clear();

  /// get num of face rects
  int32_t Size() const;

  /// Return const begin iterator for added rectangles
  se::common::RectanglesVectorIterator RectanglesBegin() const;

  /// Return const end iterator for added rectangles
  se::common::RectanglesVectorIterator RectanglesEnd() const;

private:
  IdFaceRectsResultImpl* pimpl_; ///< internal implementation
};


} } // namespace se::id

#endif // IDENGINE_ID_FACE_RESULT_H_INCLUDED
