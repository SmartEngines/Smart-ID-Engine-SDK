/*
  Copyright (c) 2016-2021, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_video_authentication_result.h
 * @brief id.engine video authentication specific result structures declaration
 */

#ifndef IDENGINE_ID_VIDEO_AUTHENTICATION_RESULT_H_INCLUDED
#define IDENGINE_ID_VIDEO_AUTHENTICATION_RESULT_H_INCLUDED

#include <secommon/se_common.h>
#include <idengine/id_fields.h>

namespace se { namespace id {

/// Forward-declaration of the internal instruction implementation
class IdVideoAuthenticationInstructionImpl;

/**
 * @brief The class representing a current instruction for the
 *        video authentication process
 */
class SE_DLL_EXPORT IdVideoAuthenticationInstruction {
public:
  /// Non-trivial dtor
  ~IdVideoAuthenticationInstruction();

  /// Main ctor - stores an instruction with given frame index and code
  IdVideoAuthenticationInstruction(int frame_index, const char* code);

  /// Copy ctor
  IdVideoAuthenticationInstruction(
      const IdVideoAuthenticationInstruction& copy);

  /// Assignment operator
  IdVideoAuthenticationInstruction& operator =(
      const IdVideoAuthenticationInstruction& other);

public:
  /// Returns the index of the expected frame when the instruction was issued
  int GetFrameIndex() const;

  /// Sets the index of the expected frame when the instruction was issued
  void SetFrameIndex(int frame_index);

  /// Returns the instruction code
  const char* GetInstructionCode() const;

  /// Sets the instruction code
  void SetInstructionCode(const char* code);

  /// Returns the number of instruction parameters
  int GetParametersCount() const;

  /// Returns the value of the parameter by its name
  const char* GetParameter(const char* par_name) const;

  /// Returns true iff there is a parameter with a given name
  bool HasParameter(const char* par_name) const;

  /// Sets a parameter with name 'par_name' to value 'par_value'
  void SetParameter(const char* par_name, const char* par_value);

  /// Removes the parameter with the given name
  void RemoveParameter(const char* par_name);

  /// Returns the 'begin' map iterator to the collection of parameters
  se::common::StringsMapIterator ParametersBegin() const;

  /// Returns the 'end' map iterator to the collection of parameters
  se::common::StringsMapIterator ParametersEnd() const;

private:
  IdVideoAuthenticationInstructionImpl* pimpl_; ///< internal implementation
};

/// Forward-declaraction of the IdVideoAuthenticationFrameInfo implementation
class IdVideoAuthenticationFrameInfoImpl;

/**
 * @brief The class representing the information about an input frame to the
 *        video identification & authentication session
 */
class SE_DLL_EXPORT IdVideoAuthenticationFrameInfo {
public:
  /// Non-trivial dtor
  ~IdVideoAuthenticationFrameInfo();

  /// Default dtor - initializes fully empty frame info
  IdVideoAuthenticationFrameInfo();

  /// Main ctor - creates a frame info with given frame prototype and timestamp
  IdVideoAuthenticationFrameInfo(const se::common::Image& prototype,
                                 int timestamp);

  /// Copy ctor
  IdVideoAuthenticationFrameInfo(const IdVideoAuthenticationFrameInfo& copy);

  /// Assignment operator
  IdVideoAuthenticationFrameInfo& operator =(
      const IdVideoAuthenticationFrameInfo& other);

public:
  /// Returns width of frame
  int GetWidth();

  /// Sets the frame width
  void SetWidth(int width);

  /// Returns height of frame
  int GetHeight();

  /// Sets the frame height
  void SetHeight(int height);

  /// Returns stride of frame
  int GetStride();

  /// Sets the frame stride
  void SetStride(int stride);

  /// Returns channels of frame
  int GetChannels();

  /// Sets the frame channels
  void SetChannels(int channels);

  /// Returns channels of frame
  se::common::Size GetSize();

  /// Sets the frame channels
  void SetSize(const se::common::Size& size);

  /// Returns the frame input timestamp in milliseconds
  int GetTimestamp() const;

  /// Sets the frame input timestamp in milliseconds
  void SetTimestamp(int timestamp);

private:
  IdVideoAuthenticationFrameInfoImpl* pimpl_; ///< internal implementation
};

/// Forward-declaration of the IdVideoAuthenticationAnomaly implementation
class IdVideoAuthenticationAnomalyImpl;

/**
 * @brief The class representing a detected video anomaly
 */
class SE_DLL_EXPORT IdVideoAuthenticationAnomaly {
public:
  /// Non-trivial dtor
  ~IdVideoAuthenticationAnomaly();

  /**
   * @brief Main ctor for the anomaly
   * @param name - name of the anomaly
   * @param start_frame - frame index where the anomaly was first registered
   * @param end_frame - frame index where the anomaly disappeared
   * @param is_accepted - the anomaly's accept flag
   * @param confidence - the anomaly's confidence (double in range [0.0, 1.0])
   */
  IdVideoAuthenticationAnomaly(const char* name,
                               int start_frame,
                               int end_frame,
                               bool is_accepted = false,
                               double confidence = 0.0);

  /// Copy ctor
  IdVideoAuthenticationAnomaly(const IdVideoAuthenticationAnomaly& copy);

  /// Assignment operator
  IdVideoAuthenticationAnomaly& operator =(
      const IdVideoAuthenticationAnomaly& other);

public:
  /// Returns the anomaly name
  const char* GetName() const;

  /// Sets the new anomaly name
  void SetName(const char* name);


  /// Gets the frame where the anomaly started (-1 if not set)
  int GetStartFrame() const;

  /// Sets the frame where the anomaly started (-1 to unset)
  void SetStartFrame(int start_frame);

  /// Gets the frame where the anomaly ended (-1 if not set)
  int GetEndFrame() const;

  /// Sets the frame where the anomaly ended (-1 to unset)
  void SetEndFrame(int end_frame);


  /// Returns the general field information (const ref)
  const IdBaseFieldInfo& GetBaseFieldInfo() const;

  /// Returns the general field information (mutable ref)
  IdBaseFieldInfo& GetMutableBaseFieldInfo();

private:
  IdVideoAuthenticationAnomalyImpl* pimpl_; ///< internal implementation
};

/// Forward-declaration of the IdVideoAuthenticationTranscript implementation
class IdVideoAuthenticationTranscriptImpl;

/**
 * @brief The class which represents the video authentication transcript - the
 *        history of video status changes throughout the session
 */
class SE_DLL_EXPORT IdVideoAuthenticationTranscript {
public:
  /// Non-trivial dtor
  ~IdVideoAuthenticationTranscript();

  /// Main ctor - creates a transcript with given current instruction and status
  IdVideoAuthenticationTranscript(
      const IdVideoAuthenticationInstruction& initial_instruction);

  /// Copy ctor
  IdVideoAuthenticationTranscript(const IdVideoAuthenticationTranscript& copy);

  /// Assignment operator
  IdVideoAuthenticationTranscript& operator =(
      const IdVideoAuthenticationTranscript& other);

public:
  /// Returns the number of input video frames registered in the transcript
  int GetFrameInfosCount() const;
  /// Returns the frame info by its index (const ref)
  const IdVideoAuthenticationFrameInfo& GetFrameInfo(int index) const;

  /// Returns the frame info by its index (mutable ref)
  IdVideoAuthenticationFrameInfo& GetMutableFrameInfo(int index);
  /// Appends a new frame info to the transcript
  void AppendFrameInfo(const IdVideoAuthenticationFrameInfo& frame_info);
  /// Sets a frame info to the transcript by index
  void SetFrameInfo(
      int index, const IdVideoAuthenticationFrameInfo& frame_info);
  /// Resizes the list of frame infos to a given size
  void ResizeFrameInfosContainer(int size);


  /// Returns the number of instructions recorded in the transcript
  int GetInstructionsCount() const;
  /// Returns the recorded instruction by its index (const ref)
  const IdVideoAuthenticationInstruction& GetInstruction(int index) const;

  /// Returns the recorded instruction by its index (mutable ref)
  IdVideoAuthenticationInstruction& GetMutableInstruction(int index);
  /// Appends a new instruction to the transcript
  void AppendInstruction(const IdVideoAuthenticationInstruction& instruction);
  /// Sets an instruction to the transcript by index
  void SetInstruction(int index,
                      const IdVideoAuthenticationInstruction& instruction);
  /// Resizes the list of instructions to a given size
  void ResizeInstructionsContainer(int size);


  /// Returns the number of anomalies recorded in the transcript
  int GetAnomaliesCount() const;
  /// Returns the recorded anomaly by its index (const ref)
  const IdVideoAuthenticationAnomaly& GetAnomaly(int index) const;

  /// Returns the recorded anomaly by its index (mutable ref)
  IdVideoAuthenticationAnomaly& GetMutableAnomaly(int index);
  /// Appends a new anomaly to the transcript
  void AppendAnomaly(const IdVideoAuthenticationAnomaly& anomaly);
  /// Sets an anomaly to the transcript by index
  void SetAnomaly(int index, const IdVideoAuthenticationAnomaly& anomaly);
  /// Resizes the list of anomalies to a given size
  void ResizeAnomaliesContainer(int size);


  /// Returns the currently standing instruction (const ref)
  const IdVideoAuthenticationInstruction& GetCurrentInstruction() const;

  /// Returns the currently standing instruction (mutable ref)
  IdVideoAuthenticationInstruction& GetMutableCurrentInstruction();
  /// Sets the currently standing instruction
  void SetCurrentInstruction(const IdVideoAuthenticationInstruction& instruction);

private:
  IdVideoAuthenticationTranscriptImpl* pimpl_; ///< internal implementation
};


} } // namespace se::id

#endif // IDENGINE_ID_VIDEO_AUTHENTICATION_RESULT_H_INCLUDED
