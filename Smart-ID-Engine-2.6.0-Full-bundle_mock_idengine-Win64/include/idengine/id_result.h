/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_result.h
 * @brief id.engine result classes declaration
 */

#ifndef IDENGINE_ID_RESULT_H_INCLUDED
#define IDENGINE_ID_RESULT_H_INCLUDED

#include <idengine/id_fields.h>
#include <secommon/se_common.h>

namespace se { namespace id {


/**
 * @brief The class representing the result of page (template) detection
 */

class SE_DLL_EXPORT IdTemplateDetectionResult {
public:

  /// Non-trivial dtor
  ~IdTemplateDetectionResult();

  /**
   * @brief Main ctor of the template detection result
   * @param tpl_name - name of the detected document page (template)
   * @param quadrangle - quadrangle of the detected template in an image
   * @param is_accepted - detected template's accept flag
   * @param confidence - detected template's confidence (double in [0.0, 1.0])
   * @param standard_size - the standard size of the template in pixels
   */
  IdTemplateDetectionResult(const char* tpl_name,
                            const se::common::Quadrangle& quadrangle,
                            bool is_accepted = false,
                            double confidence = 0.0,
                            const se::common::Size& standard_size = {});

  /// Copy ctor
  IdTemplateDetectionResult(const IdTemplateDetectionResult& copy);

  /// Assignment operator
  IdTemplateDetectionResult& operator =(
      const IdTemplateDetectionResult& other);

public:

  /// Returns the template name
  const char* GetTemplateName() const;

  /// Sets the template name
  void SetTemplateName(const char* name);


  /// Returns the template quadrangle
  const se::common::Quadrangle& GetQuadrangle() const;

  /// Sets the template quadrangle
  void SetQuadrangle(const se::common::Quadrangle& quadrangle);


  /// Returns the template's accept flag
  bool GetIsAccepted() const;

  /// Sets the template's accept flag
  void SetIsAccepted(bool is_accepted);


  /// Returns the template confidence (double in range [0.0, 1.0])
  double GetConfidence() const;

  /// Sets the template confidence (must be in range [0.0, 1.0])
  void SetConfidence(double confidence);


  /// Returns the template's standard size in pixels
  const se::common::Size& GetStandardSize() const;

  /// Sets the template's standard size in pixels
  void SetStandardSize(const se::common::Size& standard_size);


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
  class IdTemplateDetectionResultImpl* pimpl_; ///< internal implementation
};


/**
 * @brief The class representing the page (template) segmentation result
 */
class SE_DLL_EXPORT IdTemplateSegmentationResult {
public:

  /// Non-trivial dtor
  ~IdTemplateSegmentationResult();

  /**
   * @brief Main ctor of the template segmentation result
   * @param is_accepted - the segmentation result's accept flag
   * @param confidence - the segmentation result's confidence (in [0.0, 1.0])
   */
  IdTemplateSegmentationResult(bool is_accepted = false,
                               double confidence = 0.0);

  /// Copy ctor
  IdTemplateSegmentationResult(const IdTemplateSegmentationResult& copy);

  /// Assignment operator
  IdTemplateSegmentationResult& operator =(
      const IdTemplateSegmentationResult& other);

public:

  /// Returns the segmentation result's accept flag
  bool GetIsAccepted() const;

  /// Sets the segmentation result's accept flag
  void SetIsAccepted(bool is_accepted);


  /// Returns the segmentation result's confidence (double in [0.0, 1.0])
  double GetConfidence() const;

  /// Sets the segmentation result's confidence (must be in range [0.0, 1.0])
  void SetConfidence(double confidence);


  /// Returns the number of raw fields in the segmentation result
  int GetRawFieldsCount() const;

  /// Returns true iff there is a raw field with a given name
  bool HasRawField(const char* raw_field_name) const;


  /// Returns the source image quadrangle of the raw field by name
  const se::common::Quadrangle& GetRawFieldQuadrangle(
      const char* raw_field_name) const;

  /// Returns the template image quadrangle of the raw field by name
  const se::common::Quadrangle& GetRawFieldTemplateQuadrangle(
      const char* raw_field_name) const;

  /// Sets the quadrangle pair of the raw field in the segmentation result
  void SetRawFieldQuadrangles(
      const char* raw_field_name,
      const se::common::Quadrangle& quadrangle,
      const se::common::Quadrangle& template_quadrangle);

  /// Removes the raw field with a given name
  void RemoveRawField(const char* raw_field_name);

  /// Returns a 'begin' iterator to the collection of raw field
  ///     source image quadrangles
  se::common::QuadranglesMapIterator RawFieldQuadranglesBegin() const;
  /// Returns an 'end' iterator to the collection of raw field
  ///     source image quadrangles
  se::common::QuadranglesMapIterator RawFieldQuadranglesEnd() const;


  /// Returns a 'begin' iterator to the collection of raw field
  ///     template image quadrangles
  se::common::QuadranglesMapIterator RawFieldTemplateQuadranglesBegin() const;

  /// Returns an 'end' iterator to the collection of raw field
  ///     template image quadrangles
  se::common::QuadranglesMapIterator RawFieldTemplateQuadranglesEnd() const;

private:
  class IdTemplateSegmentationResultImpl* pimpl_; ///< internal implementation
};


/// Forward-declaration of the IdResult internal implementation
class IdResultImpl;


/**
 * @brief The class representing the document recognition result
 */
class SE_DLL_EXPORT IdResult {
public:
  /// Non-trivial dtor
  ~IdResult();

  /// Default ctor
  IdResult(bool is_terminal = false);

  /// Copy ctor
  IdResult(const IdResult& copy);

  /// Assignment operator
  IdResult& operator =(const IdResult& other);

public:

  /// Returns the type of the recognized document
  const char* GetDocumentType() const;

  /// Sets the document type
  void SetDocumentType(const char* document_type);


  /// Returns the number of detected document pages (templates)
  int GetTemplateDetectionResultsCount() const;

  /// Returns the document page (template) detection result by index
  const IdTemplateDetectionResult& GetTemplateDetectionResult(
      int result_id) const;

  /// Appens the document page (template) detection result
  void AppendTemplateDetectionResult(
      const IdTemplateDetectionResult& result);

  /// Removes all document page (template) detection results
  void ClearTemplateDetectionResults();


  /// Returns the number of document page (templates) segmentation results
  int GetTemplateSegmentationResultsCount() const;

  /// Returns the document page (template) segmentation result by index
  const IdTemplateSegmentationResult& GetTemplateSegmentationResult(
      int result_id) const;

  /// Appends the document page (template) segmentation result
  void AppendTemplateSegmentationResult(
      const IdTemplateSegmentationResult& result);

  /// Removes all document page (template) segmentation results
  void ClearTemplateSegmentationResults();


  /// Return true iff the result can be considered terminal
  bool GetIsTerminal() const;

  /// Sets the result's terminality flag
  void SetIsTerminal(bool is_terminal);


  /// Returns a const ref to set of seen document pages (templates)
  const se::common::StringsSet& GetSeenTemplates() const;

  /// Returns a const ref to set of document pages (templates) with terminality flags
  const se::common::StringsSet& GetTerminalTemplates() const;


  /// Returns the number of text fields
  int GetTextFieldsCount() const;

  /// Returns true iff there is a text field with a given name
  bool HasTextField(const char* field_name) const;

  /// Returns the text field (const ref) with a given name
  const IdTextField& GetTextField(const char* field_name) const;

  /// Sets the text field with a given name
  void SetTextField(const char* field_name, const IdTextField& field);

  /// Removes the text field with a given name
  void RemoveTextField(const char* field_name);

  /// Returns the 'begin' iterator to the collection of text fields
  IdTextFieldsMapIterator TextFieldsBegin() const;

  /// Returns the 'end' iterator to the collection of text fields
  IdTextFieldsMapIterator TextFieldsEnd() const;


  /// Returns the number of image fields
  int GetImageFieldsCount() const;

  /// Returns true iff there is an image field with a given name
  bool HasImageField(const char* field_name) const;

  /// Returns the image field (const ref) with a given name
  const IdImageField& GetImageField(const char* field_name) const;

  /// Sets the image field with a given name
  void SetImageField(const char* field_name, const IdImageField& field);

  /// Removes the image field with a given name
  void RemoveImageField(const char* field_name);

  /// Returns the 'begin' iterator to the collection of image fields
  IdImageFieldsMapIterator ImageFieldsBegin() const;

  /// Returns the 'end' iterator to the collection of image fields
  IdImageFieldsMapIterator ImageFieldsEnd() const;


  /// Returns the number of animated fields
  int GetAnimatedFieldsCount() const;

  /// Returns true iff there is an animated field with a given name
  bool HasAnimatedField(const char* field_name) const;

  /// Returns the animated field (const ref) with a given name
  const IdAnimatedField& GetAnimatedField(const char* field_name) const;

  /// Sets the animated field with a given name
  void SetAnimatedField(const char* field_name, const IdAnimatedField& field);

  /// Removes the animated field with a given name
  void RemoveAnimatedField(const char* field_name);

  /// Returns the 'begin' iterator to the collection of animated fields
  IdAnimatedFieldsMapIterator AnimatedFieldsBegin() const;

  /// Returns the 'end' iterator to the collection of animated fields
  IdAnimatedFieldsMapIterator AnimatedFieldsEnd() const;


  /// Returns the number of check fields
  int GetCheckFieldsCount() const;

  /// Returns true iff there is a check field with a given name
  bool HasCheckField(const char* field_name) const;

  /// Returns the check field (const ref) with a given name
  const IdCheckField& GetCheckField(const char* field_name) const;

  /// Sets the check field with a given name
  void SetCheckField(const char* field_name, const IdCheckField& field);

  /// Removes the check field with a given name
  void RemoveCheckField(const char* field_name);

  /// Returns the 'begin' iterator to the collection of check fields
  IdCheckFieldsMapIterator CheckFieldsBegin() const;

  /// Returns the 'end' iterator to the collection of check fields
  IdCheckFieldsMapIterator CheckFieldsEnd() const;


  /// Returns the number of forensic text fields
  int GetForensicTextFieldsCount() const;

  /// Returns true iff there is a forensic text field with a given name
  bool HasForensicTextField(const char* field_name) const;

  /// Returns the forensic text field (const ref) with a given name
  const IdTextField& GetForensicTextField(const char* field_name) const;

  /// Sets the forensic text field with a given name
  void SetForensicTextField(const char* field_name, const IdTextField& field);

  /// Removes the forensic text field with a given name
  void RemoveForensicTextField(const char* field_name);

  /// Returns the 'begin' iterator to the collection of forensic text fields
  IdTextFieldsMapIterator ForensicTextFieldsBegin() const;

  /// Returns the 'end' iterator to the collection of forensic text fields
  IdTextFieldsMapIterator ForensicTextFieldsEnd() const;


  /// Returns the number of forensic image fields
  int GetForensicImageFieldsCount() const;

  /// Returns true iff there is a forensic image field with a given name
  bool HasForensicImageField(const char* field_name) const;

  /// Returns the forensic image field (const ref) with a given name
  const IdImageField& GetForensicImageField(const char* field_name) const;

  /// Sets the forensic image field with a given name
  void SetForensicImageField(const char* field_name, const IdImageField& field);

  /// Removes the forensic image field with a given name
  void RemoveForensicImageField(const char* field_name);

  /// Returns the 'begin' iterator to the collection of forensic image fields
  IdImageFieldsMapIterator ForensicImageFieldsBegin() const;

  /// Returns the 'end' iterator to the collection of forensic image fields
  IdImageFieldsMapIterator ForensicImageFieldsEnd() const;


  /// Returns the number of forensic animated fields
  int GetForensicAnimatedFieldsCount() const;

  /// Returns true iff there is a forensic animated field with a given name
  bool HasForensicAnimatedField(const char* field_name) const;

  /// Returns the forensic animated field (const ref) with a given name
  const IdAnimatedField& GetForensicAnimatedField(const char* field_name) const;

  /// Sets the forensic animated field with a given name
  void SetForensicAnimatedField(
      const char* field_name, const IdAnimatedField& field);

  /// Removes the forensic animated field with a given name
  void RemoveForensicAnimatedField(const char* field_name);

  /// Returns the 'begin' iterator to the collection of forensic animated fields
  IdAnimatedFieldsMapIterator ForensicAnimatedFieldsBegin() const;

  /// Returns the 'end' iterator to the collection of forensic animated fields
  IdAnimatedFieldsMapIterator ForensicAnimatedFieldsEnd() const;


  /// Returns the number of forensic check fields
  int GetForensicCheckFieldsCount() const;

  /// Returns true iff there is a forensic check field with a given name
  bool HasForensicCheckField(const char* field_name) const;

  /// Returns the forensic check field (const ref) with a given name
  const IdCheckField& GetForensicCheckField(const char* field_name) const;

  /// Sets the forensic check field with a given name
  void SetForensicCheckField(const char* field_name, const IdCheckField& field);

  /// Removes the forensic check field with a given name
  void RemoveForensicCheckField(const char* field_name);

  /// Returns the 'begin' iterator to the collection of forensic check fields
  IdCheckFieldsMapIterator ForensicCheckFieldsBegin() const;

  /// Returns the 'end' iterator to the collection of forensic check fields
  IdCheckFieldsMapIterator ForensicCheckFieldsEnd() const;


  /// Returns the number of raw text fields
  int GetRawTextFieldsCount() const;

  /// Returns true iff there is a raw text field with a given name
  bool HasRawTextField(const char* field_name) const;

  /// Returns the raw text field (const ref) with a given name
  const IdTextField& GetRawTextField(const char* field_name) const;

  /// Sets the raw text field with a given name
  void SetRawTextField(const char* field_name, const IdTextField& field);

  /// Removes the raw text field with a given name
  void RemoveRawTextField(const char* field_name);

  /// Returns the 'begin' iterator to the collection of raw text fields
  IdTextFieldsMapIterator RawTextFieldsBegin() const;

  /// Returns the 'end' iterator to the collection of raw text fields
  IdTextFieldsMapIterator RawTextFieldsEnd() const;


  /// Returns the number of raw image fields
  int GetRawImageFieldsCount() const;

  /// Returns true iff there is a raw image field with a given name
  bool HasRawImageField(const char* field_name) const;

  /// Returns the raw image field (const ref) with a given name
  const IdImageField& GetRawImageField(const char* field_name) const;

  /// Sets the raw image field with a given name
  void SetRawImageField(const char* field_name, const IdImageField& field);

  /// Removes the raw image field with a given name
  void RemoveRawImageField(const char* field_name);

  /// Returns the 'begin' iterator to the collection of raw image fields
  IdImageFieldsMapIterator RawImageFieldsBegin() const;

  /// Returns the 'end' iterator to the collection of raw image fields
  IdImageFieldsMapIterator RawImageFieldsEnd() const;


  /// Returns the number of raw fields corresponding to a given field name
  int GetCorrespondingRawFieldsCount(const char* field_name) const;

  /// Returns true if there is a raw field 'raw_field_name' corresponding
  ///     to a field 'field_name'
  bool HasCorrespondingRawField(
      const char* field_name, const char* raw_field_name) const;

  /// Returns the 'begin' iterator to the set of raw field names corresponding
  ///     to a field 'field_name'
  se::common::StringsSetIterator CorrespondingRawFieldNamesBegin(
      const char* field_name) const;

  /// Returns the 'end' iterator to the set of raw field names corresponding
  ///     to a field 'field_name'
  se::common::StringsSetIterator CorrespondingRawFieldNamesEnd(
      const char* field_name) const;


  /// Returns the number of fields corresponding to a raw field 'raw_field_name'
  int GetCorrespondingFieldsCount(const char* raw_field_name) const;

  /// Returns true iff there is a field 'field_name' corresponding to a
  ///     raw field 'raw_field_name'
  bool HasCorrespondingField(
      const char* raw_field_name, const char* field_name) const;

  /// Returns the 'begin' iterator to the set of field names corresponding to
  ///     a raw field 'raw_field_name'
  se::common::StringsSetIterator CorrespondingFieldNamesBegin(
      const char* raw_field_name) const;

  /// Returns the 'end' iterator to the set of field names corresponding to
  ///     a raw field 'raw_field_name'
  se::common::StringsSetIterator CorrespondingFieldNamesEnd(
      const char* raw_field_name) const;


  /// Returns the internal implementation (const ref)
  const IdResultImpl& GetImpl() const;

  /// Returns the internal implementation (mutable ref)
  IdResultImpl& GetMutableImpl();

private:
  IdResultImpl* pimpl_; ///< internal implementation
};


} } // namespace se::id

#endif // IDENGINE_ID_RESULT_H_INCLUDED
