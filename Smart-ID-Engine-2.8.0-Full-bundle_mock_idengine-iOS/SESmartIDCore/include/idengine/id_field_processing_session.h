/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_field_processing_session.h
 * @brief id.engine field processing session declaration
 */

#ifndef IDENGINE_ID_FIELD_PROCESSING_SESSION_H_INCLUDED
#define IDENGINE_ID_FIELD_PROCESSING_SESSION_H_INCLUDED

#include <secommon/se_common.h>
#include <idengine/id_fields.h>

namespace se { namespace id {

/**
 * @brief The main processing class for Smart ID Engine field processing
 *        functionality
 */
class SE_DLL_EXPORT IdFieldProcessingSession {
public:
  /// Default dtor
  virtual ~IdFieldProcessingSession() = default;

  virtual const char* GetActivationRequest() = 0;

  virtual void Activate(const char* activation_response) = 0;

  virtual bool IsActivated() const = 0;

  /**
   * @brief Performs fields processing for a collection of fields stored in
   *        the session instance.
   */
  virtual void Process() = 0;


  /// Gets the number of text fields stored in the session
  virtual int GetTextFieldsCount() const = 0;

  /// Returns true iff there is a stored text field with a given name
  virtual bool HasTextField(const char* field_name) const = 0;

  /// Returns the stored text field with a given name (const ref)
  virtual const IdTextField& GetTextField(const char* field_name) const = 0;

  /// Stores the text field with a given name
  virtual void SetTextField(
      const char* field_name, const IdTextField& field) = 0;

  /// Removes the stored text field with a given name
  virtual void RemoveTextField(const char* field_name) = 0;

  /// Returns the 'begin' iterator to the stored text fields collection
  virtual IdTextFieldsMapIterator TextFieldsBegin() const = 0;

  /// Returns the 'end' iterator to the stored text fields collectoin
  virtual IdTextFieldsMapIterator TextFieldsEnd() const = 0;


  /// Gets the number of image fields stored in the session
  virtual int GetImageFieldsCount() const = 0;

  /// Returns true iff there is a stored image field with a given name
  virtual bool HasImageField(const char* field_name) const = 0;

  /// Returns the stored image field with a given name (const ref)
  virtual const IdImageField& GetImageField(const char* field_name) const = 0;

  /// Stores the image field with a given name
  virtual void SetImageField(
      const char* field_name, const IdImageField& field) = 0;

  /// Removes the stored image field with a given name
  virtual void RemoveImageField(const char* field_name) = 0;

  /// Returns the 'begin' iterator to the stored image fields collection
  virtual IdImageFieldsMapIterator ImageFieldsBegin() const = 0;

  /// Returns the 'end' iterator to the stored image fields collection
  virtual IdImageFieldsMapIterator ImageFieldsEnd() const = 0;


  /// Gets the number of animated fields stored in the session
  virtual int GetAnimatedFieldsCount() const = 0;

  /// Returns true iff there is a stored animated field with a given name
  virtual bool HasAnimatedField(const char* field_name) const = 0;

  /// Returns the stored animated field with a given name (const ref)
  virtual const IdAnimatedField& GetAnimatedField(const char* field_name) const = 0;

  /// Stores the animated field with a given name
  virtual void SetAnimatedField(
      const char* field_name, const IdAnimatedField& field) = 0;

  /// Removes the stored animated field with a given name
  virtual void RemoveAnimatedField(const char* field_name) = 0;

  /// Returns the 'begin' iterator to the stored animated fields collection
  virtual IdAnimatedFieldsMapIterator AnimatedFieldsBegin() const = 0;

  /// Returns the 'end' iterator to the stored animated fields collection
  virtual IdAnimatedFieldsMapIterator AnimatedFieldsEnd() const = 0;


  /// Gets the number of check fields stored in the session
  virtual int GetCheckFieldsCount() const = 0;

  /// Returns true iff there is a stored check field with a given name
  virtual bool HasCheckField(const char* field_name) const = 0;

  /// Returns the stored check field with a given name (const ref)
  virtual const IdCheckField& GetCheckField(const char* field_name) const = 0;

  /// Stores the check field with a given name
  virtual void SetCheckField(
      const char* field_name, const IdCheckField& field) = 0;

  /// Removes the stored check field with a given name
  virtual void RemoveCheckField(const char* field_name) = 0;

  /// Returns the 'begin' iterator to the stored check fields collection
  virtual IdCheckFieldsMapIterator CheckFieldsBegin() const = 0;

  /// Returns the 'end' iterator to the stored check fields collection
  virtual IdCheckFieldsMapIterator CheckFieldsEnd() const = 0;


  /**
   * @brief Resets the internal session state, clears all stored fields
   */
  virtual void Reset() = 0;
};


} } // namespace se::id

#endif // IDENGINE_ID_FIELD_PROCESSING_SESSION_H_INCLUDED
