/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_face_result.h
 * @brief id.engine face results declaration
 */

#ifndef IDENGINE_ID_FACE_RESULT_H_INCLUDED
#define IDENGINE_ID_FACE_RESULT_H_INCLUDED

#include <secommon/se_common.h>

#include <map>
#include <string>
#include <vector>

#ifdef WITH_IDFACE_INTERNAL
#include <facerecog2/facerecog_result.h>
#endif // WITH_IDFACE_INTERNAL

namespace se { namespace id {

enum SE_DLL_EXPORT IdFaceStatus {
  IdFaceStatus_NotUsed,             ///< The status is not initialized
  IdFaceStatus_Success,             ///< The status is initialized, two face images have been compared
  IdFaceStatus_A_FaceNotFound,      ///< No face was found in image A
  IdFaceStatus_B_FaceNotFound,      ///< No face was found in image B
  IdFaceStatus_FaceNotFound,        ///< The both faces were not found in images A and B (for the "one-to-one" mode)
  IdFaceStatus_NoAccumulatedResult  ///< No reference face image was set (for the "one-to-many" mode)
};

enum SE_DLL_EXPORT IdFaceSimilarity {
  Different,   ///< Faces are totally different
  Uncertain,   ///< Faces cannot be identified as totally the same
  Same,        ///< Faces are totally the same
};

/**
 * @brief List of supported face presentation attack detections
 */
enum SE_DLL_EXPORT IdOslPadName {
  NoFacePresented,             ///< No face on image
  UnderRepresentedFace,        ///< The face is not fully represented
  ScreenRecapturedFace,        ///< Screen was recaptured
  NonUniquePersonPresented     ///< Faces corresponding to different persons are detected
};

/**
 * @brief Face presentation attack verdicts
 */
enum SE_DLL_EXPORT IdOslPadVerdict {
    NotDetected, ///< Not detected
    NotRun,      ///< Not run
    Detected     ///< Detected
};

/**
 * @brief Face presentation attack detection result
 */
struct SE_DLL_EXPORT IdOslPad {
    IdOslPadName    name;    ///< Presentation attack name
    IdOslPadVerdict verdict; ///< Presentation attack detection verdict
};

#ifdef WITH_IDFACE_INTERNAL
/**
 * @brief The enumeration to encode possible face image orientations
 */
enum SE_DLL_EXPORT IdFaceOrientation {
  IdFaceOrientation_0,    ///< Upright orientation
  IdFaceOrientation_90CW, ///< Rotated 90 degrees clockwise
  IdFaceOrientation_180,  ///< Rotated 180 degrees
  IdFaceOrientation_270CW ///< Rotated 270 degrees clockwise
};
#endif

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

/// Forward-declaration of the IdOslPadIterator internal implementation
class IdOslPadIteratorImpl;


/**
 * @brief The class representing the iterator for working with presentation attacks detections
 */
class SE_DLL_EXPORT IdOslPadIterator {
private:
    /// Private ctor from internal implementation
    IdOslPadIterator(const IdOslPadIteratorImpl& pimpl);

public:
    /// Copy ctor
    IdOslPadIterator(const IdOslPadIterator& other);

    /// Assignment operator
    IdOslPadIterator& operator =(const IdOslPadIterator& other);

    /// Non-trivial dtor
    ~IdOslPadIterator();

    /// Construction of the iterator object from internal implementation
    static IdOslPadIterator ConstructFromImpl(
        const IdOslPadIteratorImpl& pimpl);

    /// Returns the target presentation attack detection
    const IdOslPad& GetValue() const;

    /// Returns true iff the rvalue iterator points to the same object
    bool Equals(const IdOslPadIterator& rvalue) const;

    /// Returns true if the rvalue iterator points to the same object
    bool operator ==(const IdOslPadIterator& rvalue) const;

    /// Returns true if the rvalue iterator points to a different object
    bool operator !=(const IdOslPadIterator& rvalue) const;

    /// Points an iterator to the next object a the collection
    void Advance();

    /// Points an iterator to the next object a the collection
    void operator ++();

private:
    class IdOslPadIteratorImpl* pimpl_; ///< Pointer to internal implementation
};

/// Forward-declaration of the internal IdOslResult implementation
class IdOslResultImpl;

/**
 * @brief The class which represents the face one shot liveness result
 */
class SE_DLL_EXPORT IdOslResult
{
public:
    IdOslResult();

    /// Non-trivial dtor
    ~IdOslResult();

    /// Copy ctor
    IdOslResult(const IdOslResult& copy);

    /// Assignment operator
    IdOslResult& operator=(const IdOslResult& other);

public:
    /// Return true if no presentation attack was detected, false - otherwise
    bool GetVerdict() const;

    /// Set the result of face one shot liveness result
    void SetVerdict(bool verdict);

    /// Push presentation attack detection
    void PushPad(const IdOslPad& pad);

    /// Clear all presentation attack detections
    void Clear();

    /// Get number of presentation attack detections
    int32_t Size() const;

    /// Return const begin iterator for detected presentation attacks
    IdOslPadIterator OslPadBegin() const;

    /// Return const end iterator for detected presentation attacks
    IdOslPadIterator OslPadEnd() const;

private:
    IdOslResultImpl* pimpl_; ///< internal implementation
};

#ifdef WITH_IDFACE_INTERNAL

class IdFaceDescriptionImpl;

class SE_DLL_EXPORT IdFaceDescription {
public:

  IdFaceDescription();

  IdFaceDescription(const IdFaceDescription& other);

  IdFaceDescription& operator = (const IdFaceDescription& other);

  /**
   * @brief Factory method for creating an empty face description
   * @return Pointer to a created description. New object is allocated, the
   *         caller is responsible for deleting it.
   */
  static IdFaceDescription* CreateEmpty();

public:
  /// Non-trivial dtor
  ~IdFaceDescription();

  /**
   * @brief Clones a face description
   * @return  Pointer to a cloned description. New object is allocated, the
   *          caller is responsible for deleting it.
   */
  IdFaceDescription* Clone() const;

public:

  /// Returns true iff the face was detected
  bool FaceDetected() const;

  /// Gets a normalized face rectangle
  const se::common::Rectangle& GetRectangle() const;

  /// Sets a normalized face rectangle
  void SetRectangle(const se::common::Rectangle& rect);

  std::map<std::string, std::vector<float>> GetKeypoints() const;

  void SetKeypoints(std::map<std::string, std::vector<float>>& kp);

  std::vector<float> GetFeatureVector() const;

  void SetFeatureVector(std::vector<float>& features);

  facerecog2::FaceRecogResult GetInternalResult() const;

  void SetInternalResult(const facerecog2::FaceRecogResult& result);

  /// Gets face orientation
  IdFaceOrientation GetOrientation() const;

  /// Sets face orientation
  void SetOrientation(IdFaceOrientation orientation);

  /// Returns true iff the result has a visualization image
  bool HasVisualizationImage() const;

  /// Gets the visualization image (const ref)
  const se::common::Image& GetVisualizationImage() const;

  /// Gets the visualization image (mutable ref)
  se::common::Image& GetMutableVisualizationImage();

  /// Sets the visualization image
  void SetVisualizationImage(const se::common::Image& image);

  /// Gets size of the feature vector
  int GetFeatureVectorSize() const;

  /// Gets feature from the feature vector
  float GetFeature(int index) const;

  /// Sets feature in the feature vector by index
  void SetFeature(int index, float value);

  /// Resizees the feature vector to provided size
  void ResizeFeatureVector(int size);

public:
  /// Returns internal implementation (const ref)
  const IdFaceDescriptionImpl& GetImpl() const;

  /// Returns internal implementation (mutable ref)
  IdFaceDescriptionImpl& GetMutableImpl();

  /// Returns new object from implementation
  static IdFaceDescription* ConstructFromImpl(
                  IdFaceDescriptionImpl* impl);

private:
  /// Private constructor from implementation
  IdFaceDescription(IdFaceDescriptionImpl* impl);

  IdFaceDescriptionImpl* pimpl_; ///< internal implementation
};
#endif

} } // namespace se::id

#endif // IDENGINE_ID_FACE_RESULT_H_INCLUDED
