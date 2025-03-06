/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_session_settings.h
 * @brief id.engine session settings class declaration
 */

#ifndef IDENGINE_ID_SESSION_SETTINGS_H_INCLUDED
#define IDENGINE_ID_SESSION_SETTINGS_H_INCLUDED

#include <secommon/se_common.h>
#include <idengine/id_document_info.h>
#include <idengine/id_fields.h>

namespace se { namespace id {


/**
 * @brief The class representing the session settings for the Smart ID Engine
 *        document recognition functionality
 */
class SE_DLL_EXPORT IdSessionSettings {
public:

  /// Default dtor
  virtual ~IdSessionSettings() = default;

  /**
   * @brief Clones the session settings object
   * @return A new object of session settings with an identical state. A newly
   *         created object is allocated, the caller is responsible for
   *         deleting it
   */
  virtual IdSessionSettings* Clone() const = 0;


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


  /// Gets the number of supported modes
  virtual int GetSupportedModesCount() const = 0;

  /// Returns true iff there is a supported mode with a given name
  virtual bool HasSupportedMode(const char* mode_name) const = 0;

  /// Returns a 'begin' iterator to the set of supported mode names
  virtual se::common::StringsSetIterator SupportedModesBegin() const = 0;

  /// Returns an 'end' iterator to the set of supported mode names
  virtual se::common::StringsSetIterator SupportedModesEnd() const = 0;

  /// Gets the name of the currently active mode
  virtual const char* GetCurrentMode() const = 0;

  /// Sets the active mode
  virtual void SetCurrentMode(const char* mode_name) = 0;


  /// Gets the number of internal engines within the current mode
  virtual int GetInternalEnginesCount() const = 0;

  /// Returns true iff there is an internla engine with a given name within
  ///     the current mode
  virtual bool HasInternalEngine(const char* engine_name) const = 0;

  /// Returns a 'begin' iterator to the set of internal engine names for the
  ///     current mode
  virtual se::common::StringsSetIterator InternalEngineNamesBegin() const = 0;

  /// Returns an 'end' iterator to the set of internal engine names for the
  ///     current mode
  virtual se::common::StringsSetIterator InternalEngineNamesEnd() const = 0;

  /// Returns the number of supported document types for the internal engine
  ///     with the given name
  virtual int GetSupportedDocumentTypesCount(const char* engine_name) const = 0;

  /// Returns true iff there is a supported document type 'doc_name' in the
  ///     internal engine with name 'engine_name'
  virtual bool HasSupportedDocumentType(
      const char* engine_name, const char* doc_name) const = 0;

  /// Returns a 'begin' iterator to the set of supported document types for
  ///     the engine with name 'engine_name'
  virtual se::common::StringsSetIterator SupportedDocumentTypesBegin(
      const char* engine_name) const = 0;

  /// Returns an 'end' iterator to the set of supported document types for
  ///     the engine with name 'engine_name'
  virtual se::common::StringsSetIterator SupportedDocumentTypesEnd(
      const char* engine_name) const = 0;


  /// Gets the number of enabled document types for a currently active mode
  virtual int GetEnabledDocumentTypesCount() const = 0;

  /// Returns true iff the document type 'doc_name' is enabled in a current mode
  virtual bool HasEnabledDocumentType(const char* doc_name) const = 0;

  /// Returns a 'begin' iterator to the set of enabled document types
  ///     within a currently active mode
  virtual se::common::StringsSetIterator EnabledDocumentTypesBegin() const = 0;
  /// Returns an 'end' iterator to the set of enabled document types
  ///     within a currently active mode
  virtual se::common::StringsSetIterator EnabledDocumentTypesEnd() const = 0;


  /**
   * @brief Adds enabled document types to the session settings, within the
   *        currently active mode
   * @param doc_type_mask - a document type, or a mask with wildcards ('*'). The
   *        wildcard symbol will match any sequence of characters, and the
   *        lookup dictionary for matched document types are taken from the set
   *        of supported document types within the currently active mode.
   *
   * @details NB: the set of matched document types must belong to a single
   *          internal engine.
   */
  virtual void AddEnabledDocumentTypes(const char* doc_type_mask) = 0;

  /**
   * @brief Removes the document types from the set of enabled ones
   * @param doc_type_mask - a document type, or a mask with wildcards ('*'). The
   *        wildcard symbol will match any sequence of characters, and the
   *        lookup dictionary for matched document types are taken from the set
   *        of supported document types within the currently active mode.
   */
  virtual void RemoveEnabledDocumentTypes(const char* doc_type_mask) = 0;


  /// Gets reference information about document type
  virtual const IdDocumentInfo& GetDocumentInfo(const char* doc_name) const = 0;


  /// Gets the number of supported fields for a document type 'doc_name'
  ///     within a currently active mode
  virtual int GetSupportedFieldsCount(const char* doc_name) const = 0;

  /// Returns true iff the field 'field_name' is supported for document type
  ///     'doc_name' within a curently active mode
  virtual bool HasSupportedField(const char* doc_name,
                                 const char* field_name) const = 0;

  /// Returns a 'begin' iterator to the set of fields supported for a
  ///     document type 'doc_name' within a currently active mode
  virtual se::common::StringsSetIterator SupportedFieldsBegin(
      const char* doc_name) const = 0;

  /// Returns an 'end' iterator to the set of fields supported for a
  ///     document type 'doc_name' within a currently active mode
  virtual se::common::StringsSetIterator SupportedFieldsEnd(
      const char* doc_name) const = 0;

  /// Returns the field type of the field 'field_name' within a document
  ///     'doc_name' within a currently active mode
  virtual IdFieldType GetFieldType(const char* doc_name,
                                   const char* field_name) const = 0;


  /// Returns the number of enabled fields for document 'doc_name' within
  ///     a currently active mode
  virtual int GetEnabledFieldsCount(const char* doc_name) const = 0;

  /// Returns true iff the field 'field_name' is enabled for document type
  ///     'doc_name' within a currently active mode
  virtual bool HasEnabledField(const char* doc_name,
                               const char* field_name) const = 0;

  /// Returns a 'begin' iterator to the set of enabled field names for the
  ///     document 'doc_name' within a currently active mode
  virtual se::common::StringsSetIterator EnabledFieldsBegin(
      const char* doc_name) const = 0;

  /// Returns an 'end' iterator to the set of enabled field names for the
  ///     document 'doc_name' within a currently active mode
  virtual se::common::StringsSetIterator EnabledFieldsEnd(
      const char* doc_name) const = 0;

  /// Enables field 'field_name' for the document 'doc_name' within current mode
  virtual void EnableField(const char* doc_name,
                           const char* field_name) = 0;

  /// Disables field 'field_name' for document 'doc_name' within current mode
  virtual void DisableField(const char* doc_name,
                            const char* field_name) = 0;


  /// Returns true iff the document forensics functionality is enabled
  virtual bool IsForensicsEnabled() const = 0;

  /// Enables the document forensics functionality
  virtual void EnableForensics() = 0;

  /// Disables the document forensics functionality
  virtual void DisableForensics() = 0;


  /// Gets the number of supported forensic fields for a document
  ///     type 'doc_name' within a currently active mode
  /// UPD: this method is deprecated
  virtual int GetSupportedForensicFieldsCount(const char* doc_name) const = 0;

  /// Returns true iff the forensic field 'field_name' is supported for document
  ///     type 'doc_name' within a curently active mode
  /// UPD: this method is deprecated
  virtual bool HasSupportedForensicField(
      const char* doc_name, const char* field_name) const = 0;

  /// Returns a 'begin' iterator to the set of forensic fields supported for a
  ///     document type 'doc_name' within a currently active mode
  /// UPD: this method is deprecated
  virtual se::common::StringsSetIterator SupportedForensicFieldsBegin(
      const char* doc_name) const = 0;

  /// Returns an 'end' iterator to the set of forensic fields supported for a
  ///     document type 'doc_name' within a currently active mode
  /// UPD: this method is deprecated
  virtual se::common::StringsSetIterator SupportedForensicFieldsEnd(
      const char* doc_name) const = 0;


  /// Returns the field type of the forebsuc field 'field_name' within a
  ///     document 'doc_name' within a currently active mode
  virtual IdFieldType GetForensicFieldType(
      const char* doc_name, const char* field_name) const = 0;


  /// Returns the number of enabled forensic fields for document 'doc_name'
  ///     within a currently active mode
  /// UPD: this method is deprecated
  virtual int GetEnabledForensicFieldsCount(const char* doc_name) const = 0;

  /// Returns true iff the forensic field 'field_name' is enabled for document
  ///     type 'doc_name' within a currently active mode
  /// UPD: this method is deprecated
  virtual bool HasEnabledForensicField(
      const char* doc_name, const char* field_name) const = 0;

  /// Returns a 'begin' iterator to the set of enabled forensic field names for
  ///     the document 'doc_name' within a currently active mode
  /// UPD: this method is deprecated
  virtual se::common::StringsSetIterator EnabledForensicFieldsBegin(
      const char* doc_name) const = 0;

  /// Returns an 'end' iterator to the set of enabled forensic field names for
  ///     the document 'doc_name' within a currently active mode
  /// UPD: this method is deprecated
  virtual se::common::StringsSetIterator EnabledForensicFieldsEnd(
      const char* doc_name) const = 0;

  /// Enables forensic field 'field_name' for the document 'doc_name' within
  ///     the currently active current mode
  /// UPD: this method is deprecated
  virtual void EnableForensicField(
      const char* doc_name, const char* field_name) = 0;

  /// Disables forensic field 'field_name' for document 'doc_name' within
  ///     the currently active mode
  /// UPD: this method is deprecated
  virtual void DisableForensicField(
      const char* doc_name, const char* field_name) = 0;


  /// Returns a 'begin' iterator to the set of permissible prefix document masks
  ///     for the current mode
  virtual se::common::StringsSetIterator PermissiblePrefixDocMasksBegin() = 0;
  /// Returns an 'end' iterator to the set of permissible prefix document masks
  ///     for the current mode
  virtual se::common::StringsSetIterator PermissiblePrefixDocMasksEnd() = 0;
};


} } // namespace se::id

#endif // IDENGINE_ID_SESSION_SETTINGS_H_INCLUDED
