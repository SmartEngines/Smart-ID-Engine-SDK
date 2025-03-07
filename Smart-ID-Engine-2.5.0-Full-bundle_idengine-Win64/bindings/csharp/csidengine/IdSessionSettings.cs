//------------------------------------------------------------------------------
// <auto-generated />
//
// This file was automatically generated by SWIG (https://www.swig.org).
// Version 4.1.1
//
// Do not make changes to this file unless you know what you are doing - modify
// the SWIG interface file instead.
//------------------------------------------------------------------------------

namespace se.id {

  using se.common;

public class IdSessionSettings : global::System.IDisposable {
  private global::System.Runtime.InteropServices.HandleRef swigCPtr;
  protected bool swigCMemOwn;

  public IdSessionSettings(global::System.IntPtr cPtr, bool cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = new global::System.Runtime.InteropServices.HandleRef(this, cPtr);
  }

  public static global::System.Runtime.InteropServices.HandleRef getCPtr(IdSessionSettings obj) {
    return (obj == null) ? new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero) : obj.swigCPtr;
  }

  public static global::System.Runtime.InteropServices.HandleRef swigRelease(IdSessionSettings obj) {
    if (obj != null) {
      if (!obj.swigCMemOwn)
        throw new global::System.ApplicationException("Cannot release ownership as memory is not owned");
      global::System.Runtime.InteropServices.HandleRef ptr = obj.swigCPtr;
      obj.swigCMemOwn = false;
      obj.Dispose();
      return ptr;
    } else {
      return new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero);
    }
  }

  ~IdSessionSettings() {
    Dispose(false);
  }

  public void Dispose() {
    Dispose(true);
    global::System.GC.SuppressFinalize(this);
  }

  protected virtual void Dispose(bool disposing) {
    lock(this) {
      if (swigCPtr.Handle != global::System.IntPtr.Zero) {
        if (swigCMemOwn) {
          swigCMemOwn = false;
          csidenginePINVOKE.delete_IdSessionSettings(swigCPtr);
        }
        swigCPtr = new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero);
      }
    }
  }

  public virtual IdSessionSettings Clone() {
    global::System.IntPtr cPtr = csidenginePINVOKE.IdSessionSettings_Clone(swigCPtr);
    IdSessionSettings ret = (cPtr == global::System.IntPtr.Zero) ? null : new IdSessionSettings(cPtr, true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual int GetOptionsCount() {
    int ret = csidenginePINVOKE.IdSessionSettings_GetOptionsCount(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual string GetOption(string option_name) {
    string ret = csidenginePINVOKE.IdSessionSettings_GetOption(swigCPtr, option_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual bool HasOption(string option_name) {
    bool ret = csidenginePINVOKE.IdSessionSettings_HasOption(swigCPtr, option_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual void SetOption(string option_name, string option_value) {
    csidenginePINVOKE.IdSessionSettings_SetOption(swigCPtr, option_name, option_value);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual void RemoveOption(string option_name) {
    csidenginePINVOKE.IdSessionSettings_RemoveOption(swigCPtr, option_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual StringsMapIterator OptionsBegin() {
    StringsMapIterator ret = new StringsMapIterator(csidenginePINVOKE.IdSessionSettings_OptionsBegin(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsMapIterator OptionsEnd() {
    StringsMapIterator ret = new StringsMapIterator(csidenginePINVOKE.IdSessionSettings_OptionsEnd(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual int GetSupportedModesCount() {
    int ret = csidenginePINVOKE.IdSessionSettings_GetSupportedModesCount(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual bool HasSupportedMode(string mode_name) {
    bool ret = csidenginePINVOKE.IdSessionSettings_HasSupportedMode(swigCPtr, mode_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator SupportedModesBegin() {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_SupportedModesBegin(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator SupportedModesEnd() {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_SupportedModesEnd(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual string GetCurrentMode() {
    string ret = csidenginePINVOKE.IdSessionSettings_GetCurrentMode(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual void SetCurrentMode(string mode_name) {
    csidenginePINVOKE.IdSessionSettings_SetCurrentMode(swigCPtr, mode_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual int GetInternalEnginesCount() {
    int ret = csidenginePINVOKE.IdSessionSettings_GetInternalEnginesCount(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual bool HasInternalEngine(string engine_name) {
    bool ret = csidenginePINVOKE.IdSessionSettings_HasInternalEngine(swigCPtr, engine_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator InternalEngineNamesBegin() {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_InternalEngineNamesBegin(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator InternalEngineNamesEnd() {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_InternalEngineNamesEnd(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual int GetSupportedDocumentTypesCount(string engine_name) {
    int ret = csidenginePINVOKE.IdSessionSettings_GetSupportedDocumentTypesCount(swigCPtr, engine_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual bool HasSupportedDocumentType(string engine_name, string doc_name) {
    bool ret = csidenginePINVOKE.IdSessionSettings_HasSupportedDocumentType(swigCPtr, engine_name, doc_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator SupportedDocumentTypesBegin(string engine_name) {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_SupportedDocumentTypesBegin(swigCPtr, engine_name), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator SupportedDocumentTypesEnd(string engine_name) {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_SupportedDocumentTypesEnd(swigCPtr, engine_name), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual int GetEnabledDocumentTypesCount() {
    int ret = csidenginePINVOKE.IdSessionSettings_GetEnabledDocumentTypesCount(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual bool HasEnabledDocumentType(string doc_name) {
    bool ret = csidenginePINVOKE.IdSessionSettings_HasEnabledDocumentType(swigCPtr, doc_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator EnabledDocumentTypesBegin() {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_EnabledDocumentTypesBegin(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator EnabledDocumentTypesEnd() {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_EnabledDocumentTypesEnd(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual void AddEnabledDocumentTypes(string doc_type_mask) {
    csidenginePINVOKE.IdSessionSettings_AddEnabledDocumentTypes(swigCPtr, doc_type_mask);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual void RemoveEnabledDocumentTypes(string doc_type_mask) {
    csidenginePINVOKE.IdSessionSettings_RemoveEnabledDocumentTypes(swigCPtr, doc_type_mask);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual IdDocumentInfo GetDocumentInfo(string doc_name) {
    IdDocumentInfo ret = new IdDocumentInfo(csidenginePINVOKE.IdSessionSettings_GetDocumentInfo(swigCPtr, doc_name), false);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual int GetSupportedFieldsCount(string doc_name) {
    int ret = csidenginePINVOKE.IdSessionSettings_GetSupportedFieldsCount(swigCPtr, doc_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual bool HasSupportedField(string doc_name, string field_name) {
    bool ret = csidenginePINVOKE.IdSessionSettings_HasSupportedField(swigCPtr, doc_name, field_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator SupportedFieldsBegin(string doc_name) {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_SupportedFieldsBegin(swigCPtr, doc_name), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator SupportedFieldsEnd(string doc_name) {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_SupportedFieldsEnd(swigCPtr, doc_name), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual IdFieldType GetFieldType(string doc_name, string field_name) {
    IdFieldType ret = (IdFieldType)csidenginePINVOKE.IdSessionSettings_GetFieldType(swigCPtr, doc_name, field_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual int GetEnabledFieldsCount(string doc_name) {
    int ret = csidenginePINVOKE.IdSessionSettings_GetEnabledFieldsCount(swigCPtr, doc_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual bool HasEnabledField(string doc_name, string field_name) {
    bool ret = csidenginePINVOKE.IdSessionSettings_HasEnabledField(swigCPtr, doc_name, field_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator EnabledFieldsBegin(string doc_name) {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_EnabledFieldsBegin(swigCPtr, doc_name), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator EnabledFieldsEnd(string doc_name) {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_EnabledFieldsEnd(swigCPtr, doc_name), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual void EnableField(string doc_name, string field_name) {
    csidenginePINVOKE.IdSessionSettings_EnableField(swigCPtr, doc_name, field_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual void DisableField(string doc_name, string field_name) {
    csidenginePINVOKE.IdSessionSettings_DisableField(swigCPtr, doc_name, field_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual bool IsForensicsEnabled() {
    bool ret = csidenginePINVOKE.IdSessionSettings_IsForensicsEnabled(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual void EnableForensics() {
    csidenginePINVOKE.IdSessionSettings_EnableForensics(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual void DisableForensics() {
    csidenginePINVOKE.IdSessionSettings_DisableForensics(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual int GetSupportedForensicFieldsCount(string doc_name) {
    int ret = csidenginePINVOKE.IdSessionSettings_GetSupportedForensicFieldsCount(swigCPtr, doc_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual bool HasSupportedForensicField(string doc_name, string field_name) {
    bool ret = csidenginePINVOKE.IdSessionSettings_HasSupportedForensicField(swigCPtr, doc_name, field_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator SupportedForensicFieldsBegin(string doc_name) {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_SupportedForensicFieldsBegin(swigCPtr, doc_name), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator SupportedForensicFieldsEnd(string doc_name) {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_SupportedForensicFieldsEnd(swigCPtr, doc_name), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual IdFieldType GetForensicFieldType(string doc_name, string field_name) {
    IdFieldType ret = (IdFieldType)csidenginePINVOKE.IdSessionSettings_GetForensicFieldType(swigCPtr, doc_name, field_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual int GetEnabledForensicFieldsCount(string doc_name) {
    int ret = csidenginePINVOKE.IdSessionSettings_GetEnabledForensicFieldsCount(swigCPtr, doc_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual bool HasEnabledForensicField(string doc_name, string field_name) {
    bool ret = csidenginePINVOKE.IdSessionSettings_HasEnabledForensicField(swigCPtr, doc_name, field_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator EnabledForensicFieldsBegin(string doc_name) {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_EnabledForensicFieldsBegin(swigCPtr, doc_name), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator EnabledForensicFieldsEnd(string doc_name) {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_EnabledForensicFieldsEnd(swigCPtr, doc_name), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual void EnableForensicField(string doc_name, string field_name) {
    csidenginePINVOKE.IdSessionSettings_EnableForensicField(swigCPtr, doc_name, field_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual void DisableForensicField(string doc_name, string field_name) {
    csidenginePINVOKE.IdSessionSettings_DisableForensicField(swigCPtr, doc_name, field_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual StringsSetIterator PermissiblePrefixDocMasksBegin() {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_PermissiblePrefixDocMasksBegin(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual StringsSetIterator PermissiblePrefixDocMasksEnd() {
    StringsSetIterator ret = new StringsSetIterator(csidenginePINVOKE.IdSessionSettings_PermissiblePrefixDocMasksEnd(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

}

}
