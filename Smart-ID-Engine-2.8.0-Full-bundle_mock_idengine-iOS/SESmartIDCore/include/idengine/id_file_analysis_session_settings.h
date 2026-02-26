/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_file_analysis_session_settings.h
 * @brief id.engine file_analysis session settings declaration
 */

#ifndef IDENGINE_ID_FILE_ANALYSIS_SESSION_SETTINGS_H_INCLUDED
#define IDENGINE_ID_FILE_ANALYSIS_SESSION_SETTINGS_H_INCLUDED

#include <secommon/se_common.h>
#include <idengine/id_fields.h>

namespace se { namespace id {

/**
 * @brief The class representing the settings of the file_analysis processing session
 */
class SE_DLL_EXPORT IdFileAnalysisSessionSettings {
public:
  /// Default dtor
  virtual ~IdFileAnalysisSessionSettings() = default;

  /**
   * @brief Clones the settings object
   * @return A new object with the same state as the current instance. The newly
   *         created object is allocated, the caller is responsible for
   *         deleting it
   */
  virtual IdFileAnalysisSessionSettings* Clone() const = 0;

  /// Returns the number of key:value session option pairs
  virtual int GetOptionsCount() const = 0;

  /// Returns the value of an option by name
  virtual const char* GetOption(const char* option_name) const = 0;

  /// Return true if there is an option with the given name
  virtual bool HasOption(const char* option_name) const = 0;

  /// Sets the key:value session option pair
  virtual void SetOption(const char* option_name, const char* option_value) = 0;

  /// Removes the key:value session option by name
  virtual void RemoveOption(const char* option_name) = 0;

  /// Returns the 'begin' map iterator to the session options collection
  virtual se::common::StringsMapIterator OptionsBegin() const = 0;

  /// Returns the 'end' map iterator to the session options collection
  virtual se::common::StringsMapIterator OptionsEnd() const = 0;

  /// Gets the number of supported fields
  virtual int GetSupportedForensicFieldsCount() const = 0;

  /// Returns true if the field 'field_name' is supported
  virtual bool HasSupportedForensicField(const char* field_name) const = 0;

  /// Returns a 'begin' iterator to the set of supported fields
  virtual se::common::StringsSetIterator SupportedForensicFieldsBegin() const = 0;

  /// Returns an 'end' iterator to the set of supported fields
  virtual se::common::StringsSetIterator SupportedForensicFieldsEnd() const = 0;

  /// Returns the number of enabled fields
  virtual int GetEnabledForensicFieldsCount() const = 0;

  /// Returns true if the field 'field_name' is enabled
  virtual bool HasEnabledForensicField(const char* field_name) const = 0;

  /// Returns a 'begin' iterator to the set of enabled field names
  virtual se::common::StringsSetIterator EnabledForensicFieldsBegin() const = 0;

  /// Returns an 'end' iterator to the set of enabled field names
  virtual se::common::StringsSetIterator EnabledForensicFieldsEnd() const = 0;

  /// Enables field 'field_name'
  virtual void EnableForensicField(const char* field_name) = 0;

  /// Disables field 'field_name'
  virtual void DisableForensicField(const char* field_name) = 0;
};


} } // namespace se::id

#endif // IDENGINE_ID_FILE_ANALYSIS_SESSION_SETTINGS_H_INCLUDED
