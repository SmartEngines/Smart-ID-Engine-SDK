/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_field_processing_session_settings.h
 * @brief id.engine field processing session settings class declaration
 */

#ifndef IDENGINE_ID_FIELD_PROCESSING_SESSION_SETTINGS_H_INCLUDED
#define IDENGINE_ID_FIELD_PROCESSING_SESSION_SETTINGS_H_INCLUDED

#include <secommon/se_common.h>

namespace se { namespace id {


/**
 * @brief The class representing the settings of the field processing session
 */
class SE_DLL_EXPORT IdFieldProcessingSessionSettings {
public:
  /// Default dtor
  virtual ~IdFieldProcessingSessionSettings() = default;

  /**
   * @brief Clones the settings object
   * @return A new object with the same state as the current instance. The newly
   *         created object is allocated, the caller is responsible for
   *         deleting it
   */
  virtual IdFieldProcessingSessionSettings* Clone() const = 0;


  /// Returns the number of available field processors
  virtual int GetSupportedFieldProcessorsCount() const = 0;

  /// Returns true iff there is an available field processor with a given name
  virtual bool HasSupportedFieldProcessor(
      const char* field_processor_name) const = 0;

  /// Returns the 'begin' set-like iterator to the collection of available
  ///     field processor names
  virtual se::common::StringsSetIterator SupportedFieldProcessorsBegin() const = 0;

  /// Returns the 'end' set-like iterator to the collection of available
  ///     field processor names
  virtual se::common::StringsSetIterator SupportedFieldProcessorsEnd() const = 0;


  /// Returns the name of the active field processor
  virtual const char* GetCurrentFieldProcessor() const = 0;

  /// Sets the name of the active field processor
  virtual void SetCurrentFieldProcessor(const char* field_processor_name) = 0;


  /// Returns the number of key:value session option pairs
  virtual int GetOptionsCount() const = 0;

  /// Returns the value of an option by name
  virtual const char* GetOption(const char* option_name) const = 0;

  /// Return true iff there is an option with the given name
  virtual bool HasOption(const char* option_name) const = 0;

  /// Sets the key:value session option pair
  virtual void SetOption(const char* option_name, const char* option_value) = 0;

  /// Removes the session option with a given name
  virtual void RemoveOption(const char* option_name) = 0;

  /// Returns the 'begin' map iterator to the session options collection
  virtual se::common::StringsMapIterator OptionsBegin() const = 0;

  /// Returns the 'end' map iterator to the session options collection
  virtual se::common::StringsMapIterator OptionsEnd() const = 0;
};


} } // namespace se::id

#endif // IDENGINE_ID_FIELD_PROCESSING_SESSION_SETTINGS_H_INCLUDED
