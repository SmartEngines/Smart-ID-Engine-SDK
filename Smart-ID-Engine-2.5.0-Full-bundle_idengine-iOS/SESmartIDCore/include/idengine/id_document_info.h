/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_doc_info.h
 * @brief Reference information about document type
 */

#ifndef IDENGINE_ID_DOC_INFO_H_INCLUDED
#define IDENGINE_ID_DOC_INFO_H_INCLUDED

#include <secommon/se_export_defs.h>
#include <secommon/se_strings_set.h>

namespace se { namespace id {


/**
 * @brief Reference information about document type
 */
class SE_DLL_EXPORT IdDocumentInfo {
public:
  /// Default dtor
  virtual ~IdDocumentInfo() = default;

  /// Returns human-readable name of the document
  virtual const char* GetDocumentName() const = 0;

  /// Returns human-readable description of the document
  virtual const char* GetDocumentDescription() const = 0;

  /// Returns RFID chip presence info (1 - presented/0 - not presented/-1 - no info)
  virtual int HasRFID() const = 0;

  /// Returns RFID chip support info (1 - supported/0 - not supported/-1 - no info)
  virtual int SupportedRFID() const = 0;

  /// Returns read-only collection of PRADO links for the document
  virtual const se::common::StringsSet& GetPradoLinks() const = 0;

  /// Returns read-only collection of template names for the document
  virtual const se::common::StringsSet& GetDocumentTemplates() const = 0;

  /// Returns field's rejection threshold
  virtual float GetDocumentFieldsRejectionThreshold(const char* field_name) const = 0;
};


} } // namespace se::id

#endif // IDENGINE_ID_DOC_INFO_H_INCLUDED
