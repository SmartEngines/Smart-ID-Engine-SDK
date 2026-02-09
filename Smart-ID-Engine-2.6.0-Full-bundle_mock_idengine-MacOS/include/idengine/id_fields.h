/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_fields.h
 * @brief id.engine field types declaration
 */

#ifndef IDENGINE_ID_FIELDS_H_INCLUDED
#define IDENGINE_ID_FIELDS_H_INCLUDED

#include <secommon/se_common.h>

namespace se { namespace id {


/**
 * @brief The enumeration to encode the Smart ID Engine field types
 */
enum SE_DLL_EXPORT IdFieldType {
  IdFieldType_Text,       ///< Text field
  IdFieldType_Image,      ///< Image field
  IdFieldType_Animated,   ///< Animated field
  IdFieldType_Check       ///< Check field
};


/**
 * @brief The class representing the basic field information, which is present
 *        in any field object
 */
class SE_DLL_EXPORT IdBaseFieldInfo {
public:
  /// Non-trivial dtor
  ~IdBaseFieldInfo();

  /**
   * @brief Main ctor of the basic field information
   * @param is_accepted - the accept flag (whether the field is accepted
   *        by the system)
   * @param confidence - the field's confidence (double in range [0.0, 1.0])
   */
  IdBaseFieldInfo(bool is_accepted = false,
                  double confidence = 0.0);

  /// Copy ctor
  IdBaseFieldInfo(const IdBaseFieldInfo& copy);

  /// Assignment operator
  IdBaseFieldInfo& operator =(const IdBaseFieldInfo& other);

public:

  /// Returns the field's accept flag
  bool GetIsAccepted() const;

  /// Sets the field's accept flag
  void SetIsAccepted(bool is_accepted);

  /// Returns the field's confidence value (double in range [0.0, 1.0])
  double GetConfidence() const;

  /// Sets the field's confidence value (must be in range [0.0, 1.0])
  void SetConfidence(double confidence);


  /// Gets the number of field's attributes
  int GetAttributesCount() const;

  /// Returns the field attribute by its name
  const char* GetAttribute(const char* attr_name) const;

  /// Returns true iff the field has the attribute with a given name
  bool HasAttribute(const char* attr_name) const;

  /// Sets the field's attribute by name
  void SetAttribute(const char* attr_name, const char* attr_value);

  /// Removes the field's attribute with a given name
  void RemoveAttribute(const char* attr_name);

  /// Returns the 'begin' iterator to the collection of the field attributes
  se::common::StringsMapIterator AttributesBegin() const;

  /// Returns the 'end' iterator to the collection of the field attributes
  se::common::StringsMapIterator AttributesEnd() const;

private:
  class IdBaseFieldInfoImpl* pimpl_; ///< internal implementation
};


/**
 * @brief The class representing the recognition result of a text field
 */
class SE_DLL_EXPORT IdTextField {
public:
  /// Non-trivial dtor
  ~IdTextField();

  /// Default ctor - creates an empty field
  IdTextField();

  /**
   * @brief Main ctor of the text field
   * @param name - name of the text field
   * @param value - the value of the text field as an OcrString object
   * @param is_accepted - the field's accept flag
   * @param confidence - the field's confidence (double in range [0.0, 1.0])
   */
  IdTextField(const char* name,
              const se::common::OcrString& value,
              bool is_accepted = false,
              double confidence = 0.0);

  /**
   * @brief Text field ctor with a simple C-string value
   * @param name - name of the field
   * @param value - the value of the text field as a C-string
   * @param is_accepted - the field's accept flag
   * @param confidence - the field's confidence (double in range [0.0, 1.0])
   */
  IdTextField(const char* name,
              const char* value,
              bool is_accepted = false,
              double confidence = 0.0);

  /// Copy ctor
  IdTextField(const IdTextField& copy);

  /// Assignment operator
  IdTextField& operator =(const IdTextField& other);

public:

  /// Returns the name of the text field
  const char* GetName() const;

  /// Sets the name of the text field
  void SetName(const char* name);


  /// Returns the stored value of the text field
  const se::common::OcrString& GetValue() const;

  /// Sets the value of the text field as an OcrString object
  void SetValue(const se::common::OcrString& value);

  /// Sets the value of the text field as a C-string
  void SetValue(const char* value);


  /// Returns the general field information (const ref)
  const IdBaseFieldInfo& GetBaseFieldInfo() const;

  /// Returns the general field information (mutable ref)
  IdBaseFieldInfo& GetMutableBaseFieldInfo();

private:
  class IdTextFieldImpl* pimpl_; ///< internal implementation
};


/// Forward-declaration for IdTextFieldsMapIterator internal implementation
class IdTextFieldsMapIteratorImpl;

/**
 * @brief A class representing the iterator for string->text field maps
 */
class SE_DLL_EXPORT IdTextFieldsMapIterator {
private:
  /// Private ctor from the internal implementation
  IdTextFieldsMapIterator(const IdTextFieldsMapIteratorImpl& pimpl);

public:

  /// Non-trivial dtor
  ~IdTextFieldsMapIterator();

  /// Copy ctor
  IdTextFieldsMapIterator(const IdTextFieldsMapIterator& other);

  /// Assignment operator
  IdTextFieldsMapIterator& operator =(const IdTextFieldsMapIterator& other);

  /// Factory method for creating the iterator from the internal implementation
  static IdTextFieldsMapIterator ConstructFromImpl(
      const IdTextFieldsMapIteratorImpl& pimpl);


  /// Returns the key
  const char* GetKey() const;

  /// Returns the value (the text field object)
  const IdTextField& GetValue() const;


  /// Returns true iff the current instance and rvalue point to the same object
  bool Equals(const IdTextFieldsMapIterator& rvalue) const;

  /// Returns true iff the current instance and rvalue point to the same object
  bool operator ==(const IdTextFieldsMapIterator& rvalue) const;

  /// Returns true iff the instance and rvalue point to different objects
  bool operator !=(const IdTextFieldsMapIterator& rvalue) const;


  /// Advances the iterator to the next object in the collection
  void Advance();

  /// Advances the iterator to the next object in the collection
  void operator ++();

private:
  IdTextFieldsMapIteratorImpl* pimpl_; ///< internal implementation
};


/**
 * @brief The class representing an image field
 */
class SE_DLL_EXPORT IdImageField {
public:

  /// Non-trivial dtor
  ~IdImageField();

  /// Default ctor - creates an empty image field
  IdImageField();

  /**
   * @brief Main ctor of an image field
   * @param name - name of the field
   * @param value - value of the field (image content)
   * @param is_accepted - the field's accept flag
   * @param confidence - the field's confidence (double in range [0.0, 1.0])
   */
  IdImageField(const char* name,
               const se::common::Image& value,
               bool is_accepted = false,
               double confidence = 0.0);

  /// Copy ctor
  IdImageField(const IdImageField& copy);

  /// Assignment operator
  IdImageField& operator =(const IdImageField& other);

public:

  /// Returns the field's name
  const char* GetName() const;

  /// Sets the field's name
  void SetName(const char* name);


  /// Returns the value of the image field (image content)
  const se::common::Image& GetValue() const;

  /// Sets the value of the image field to a new image
  void SetValue(const se::common::Image& value);


  /// Returns the general field information (const ref)
  const IdBaseFieldInfo& GetBaseFieldInfo() const;

  /// Returns the general field information (mutable ref)
  IdBaseFieldInfo& GetMutableBaseFieldInfo();

private:
  class IdImageFieldImpl* pimpl_; ///< internal implementation
};


/// Forward-declaration of the IdImageFieldsMapIterator internal implementation
class IdImageFieldsMapIteratorImpl;

/**
 * @brief The class representing the iterator to named image fields container
 */
class SE_DLL_EXPORT IdImageFieldsMapIterator {
private:

  /// Private ctor from the internal implementation
  IdImageFieldsMapIterator(const IdImageFieldsMapIteratorImpl& pimpl);

public:

  /// Non-trivial dtor
  ~IdImageFieldsMapIterator();

  /// Copy ctor
  IdImageFieldsMapIterator(const IdImageFieldsMapIterator& other);

  /// Assignment operator
  IdImageFieldsMapIterator& operator =(const IdImageFieldsMapIterator& other);

  /// Factory method for creating the iterator from the internal implementation
  static IdImageFieldsMapIterator ConstructFromImpl(
      const IdImageFieldsMapIteratorImpl& pimpl);


  /// Returns the key
  const char* GetKey() const;

  /// Returns the value (the image field object)
  const IdImageField& GetValue() const;


  /// Returns true iff the current instance and rvalue point to the same object
  bool Equals(const IdImageFieldsMapIterator& rvalue) const;

  /// Returns true iff the current instance and rvalue point to the same object
  bool operator ==(const IdImageFieldsMapIterator& rvalue) const;

  /// Returns true iff the instance and rvalue point to different objects
  bool operator !=(const IdImageFieldsMapIterator& rvalue) const;


  /// Advances the iterator to the next object in the collection
  void Advance();

  /// Advances the iterator to the next object in the collection
  void operator ++();

private:
  class IdImageFieldsMapIteratorImpl* pimpl_; ///< internal implementation
};


/**
 * @brief The class representing an animated field
 */
class SE_DLL_EXPORT IdAnimatedField {
public:

  /// Non-trivial dtor
  ~IdAnimatedField();

  /// Default ctor - creates an empty animated field
  IdAnimatedField();

  /**
   * @brief Main ctor for the animated field
   * @param name - name of the field
   * @param is_accepted - field's accept flag
   * @param confidence - field's confidence value (double in range [0.0, 1.0])
   */
  IdAnimatedField(const char* name,
                  bool is_accepted = false,
                  double confidence = 0.0);

  /// Copy ctor
  IdAnimatedField(const IdAnimatedField& copy);

  /// Assignment operator
  IdAnimatedField& operator =(const IdAnimatedField& other);

public:

  /// Returns the field's name
  const char* GetName() const;

  /// Sets the field's name
  void SetName(const char* name);


  /// Returns the number of frames in the animated field
  int GetFramesCount() const;

  /// Returns the frame of the animated field by index
  const se::common::Image& GetFrame(int frame_id) const;

  /// Appens the frame to the animated field
  void AppendFrame(const se::common::Image& frame);

  /// Removes all frames of the animated field
  void ClearFrames();


  /// Returns the general field information (const ref)
  const IdBaseFieldInfo& GetBaseFieldInfo() const;

  /// Returns the general field information (mutable ref)
  IdBaseFieldInfo& GetMutableBaseFieldInfo();

private:
  class IdAnimatedFieldImpl* pimpl_; ///< internal implementation
};


/// Forward-declaration of the IdAnimatedFieldsMapIterator implementation
class IdAnimatedFieldsMapIteratorImpl;

/**
 * @brief The class representing the iterator to named animated fields container
 */
class SE_DLL_EXPORT IdAnimatedFieldsMapIterator {
private:

  /// Private ctor from the internal implementation
  IdAnimatedFieldsMapIterator(const IdAnimatedFieldsMapIteratorImpl& pimpl);

public:

  /// Non-trivial dtor
  ~IdAnimatedFieldsMapIterator();

  /// Copy ctor
  IdAnimatedFieldsMapIterator(const IdAnimatedFieldsMapIterator& other);

  /// Assignment operator
  IdAnimatedFieldsMapIterator& operator =(const IdAnimatedFieldsMapIterator& other);

  /// Factory method for creating the iterator from the internal implementation
  static IdAnimatedFieldsMapIterator ConstructFromImpl(
      const IdAnimatedFieldsMapIteratorImpl& pimpl);


  /// Returns the key
  const char* GetKey() const;

  /// Returns the value (the animated field object)
  const IdAnimatedField& GetValue() const;


  /// Returns true iff the current instance and rvalue point to the same object
  bool Equals(const IdAnimatedFieldsMapIterator& rvalue) const;

  /// Returns true iff the current instance and rvalue point to the same object
  bool operator ==(const IdAnimatedFieldsMapIterator& rvalue) const;

  /// Returns true iff the instance and rvalue point to different objects
  bool operator !=(const IdAnimatedFieldsMapIterator& rvalue) const;


  /// Advances the iterator to the next object in the collection
  void Advance();

  /// Advances the iterator to the next object in the collection
  void operator ++();

private:
  class IdAnimatedFieldsMapIteratorImpl* pimpl_; ///< internal implementation
};


/**
 * @brief Enumeration representing the status of the check field
 */
enum SE_DLL_EXPORT IdCheckStatus {
  IdCheckStatus_Undefined,  ///< Undefined result
  IdCheckStatus_Passed,     ///< Check is passed
  IdCheckStatus_Failed      ///< Check is not passed
};


/**
 * @brief The class representing the check field
 */
class SE_DLL_EXPORT IdCheckField {
public:

  /// Non-trivial dtor
  ~IdCheckField();

  /// Default ctor - creates and empty check field
  IdCheckField();

  /**
   * @brief Main ctor of the check field
   * @param name - field's name
   * @param value - field's value (from the IdCheckStatus enumeration)
   * @param is_accepted - field's accept flag
   * @param confidence - field's confidence value (double in range [0.0, 1.0])
   */
  IdCheckField(const char* name,
               IdCheckStatus value,
               bool is_accepted = false,
               double confidence = 0.0);

  /// Copy ctor
  IdCheckField(const IdCheckField& copy);

  /// Assignment operator
  IdCheckField& operator =(const IdCheckField& other);

public:

  /// Returns the name of the field
  const char* GetName() const;

  /// Sets the name of the field
  void SetName(const char* name);


  /// Returns the field's value
  IdCheckStatus GetValue() const;

  /// Sets the field's value
  void SetValue(IdCheckStatus value);


  /// Returns the general field information (const ref)
  const IdBaseFieldInfo& GetBaseFieldInfo() const;

  /// Returns the general field information (mutable ref)
  IdBaseFieldInfo& GetMutableBaseFieldInfo();

private:
  class IdCheckFieldImpl* pimpl_; ///< internal implementation
};


/// Forward-declaration of the IdCheckFieldsMapIterator internal implementation
class IdCheckFieldsMapIteratorImpl;

/**
 * @brief The class representing the iterator to a named check fields collection
 */
class SE_DLL_EXPORT IdCheckFieldsMapIterator {
private:

  /// Private ctor from the internal implementation
  IdCheckFieldsMapIterator(const IdCheckFieldsMapIteratorImpl& pimpl);

public:

  /// Non-trivial dtor
  ~IdCheckFieldsMapIterator();

  /// Copy ctor
  IdCheckFieldsMapIterator(const IdCheckFieldsMapIterator& other);

  /// Assignment operator
  IdCheckFieldsMapIterator& operator =(const IdCheckFieldsMapIterator& other);


  /// Factory method for creating the iterator from the internal implementation
  static IdCheckFieldsMapIterator ConstructFromImpl(
      const IdCheckFieldsMapIteratorImpl& pimpl);


  /// Returns the key
  const char* GetKey() const;

  /// Returns the value (the check field object)
  const IdCheckField& GetValue() const;


  /// Returns true iff the current instance and rvalue point to the same object
  bool Equals(const IdCheckFieldsMapIterator& rvalue) const;

  /// Returns true iff the current instance and rvalue point to the same object
  bool operator ==(const IdCheckFieldsMapIterator& rvalue) const;

  /// Returns true iff the instance and rvalue point to different objects
  bool operator !=(const IdCheckFieldsMapIterator& rvalue) const;


  /// Advances the iterator to the next object in the collection
  void Advance();

  /// Advances the iterator to the next object in the collection
  void operator ++();

private:
  class IdCheckFieldsMapIteratorImpl* pimpl_; ///< internal implementation
};


} } // namespace se::id

#endif // IDENGINE_ID_FIELDS_H_INCLUDED
