/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_face_session_settings.h
 * @brief id.engine face session settings class declaration
 */

#ifndef IDENGINE_ID_FACE_SESSION_SETTINGS_H_INCLUDED
#define IDENGINE_ID_FACE_SESSION_SETTINGS_H_INCLUDED

#include <secommon/se_common.h>

namespace se { namespace id {


/**
 * @brief The class representing the settings of the face matching session
 */
class SE_DLL_EXPORT IdFaceSessionSettings {
public:
  /// Default dtor
  virtual ~IdFaceSessionSettings() = default;

  /**
   * @brief Clones the settings object.
   * @return A newly created object with the same contents as the current
   *         instance. The object is allocated, the caller is responsible
   *         for deleting it.
   */
  virtual IdFaceSessionSettings* Clone() const = 0;


  /// Returns the number of key:value session option pairs
  virtual int GetOptionsCount() const = 0;

  /// Returns the value of an option by name
  virtual const char* GetOption(const char* option_name) const = 0;

  /// Return true if there is an option with the given name
  virtual bool HasOption(const char* option_name) const = 0;

  /// Sets the key:value session option pair
  virtual void SetOption(const char* option_name, const char* option_value) = 0;

  /// Removes the session option with a given name
  virtual void RemoveOption(const char* option_name) = 0;

  /// Returns the 'begin' map iterator to the session options collection
  virtual se::common::StringsMapIterator OptionsBegin() const = 0;

  /// Returns the 'end' map iterator to the session options collection
  virtual se::common::StringsMapIterator OptionsEnd() const = 0;

  /// Return the number of key:value liveness instruction pairs
  virtual int GetSupportedLivenessInstructionsCount() const = 0;

  /// Return true if there is an liveness instruction with the given name
  virtual bool HasSupportedLivenessInstruction(const char* instruction) const = 0;

  /// Return the description of an liveness instruction by the given name
  virtual const char* GetLivenessInstructionDescription(const char* instruction) const = 0;

  /// Returns the 'begin' map iterator to the liveness instruction collection
  virtual se::common::StringsMapIterator SupportedLivenessInstructionsBegin() const = 0;

  /// Returns the 'end' map iterator to the liveness instruction collection
  virtual se::common::StringsMapIterator SupportedLivenessInstructionsEnd() const = 0;
};


} } // namespace se::id

#endif // IDENGINE_ID_FACE_SESSION_SETTINGS_H_INCLUDED
