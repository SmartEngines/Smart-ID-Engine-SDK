/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (https://www.swig.org).
 * Version 4.1.1
 *
 * Do not make changes to this file unless you know what you are doing - modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.smartengines.id;

import com.smartengines.common.*;

public class IdDocumentInfo {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  public IdDocumentInfo(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  public static long getCPtr(IdDocumentInfo obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  public static long swigRelease(IdDocumentInfo obj) {
    long ptr = 0;
    if (obj != null) {
      if (!obj.swigCMemOwn)
        throw new RuntimeException("Cannot release ownership as memory is not owned");
      ptr = obj.swigCPtr;
      obj.swigCMemOwn = false;
      obj.delete();
    }
    return ptr;
  }

  @SuppressWarnings("deprecation")
  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        jniidengineJNI.delete_IdDocumentInfo(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public String GetDocumentName() {
    return jniidengineJNI.IdDocumentInfo_GetDocumentName(swigCPtr, this);
  }

  public String GetDocumentDescription() {
    return jniidengineJNI.IdDocumentInfo_GetDocumentDescription(swigCPtr, this);
  }

  public int HasRFID() {
    return jniidengineJNI.IdDocumentInfo_HasRFID(swigCPtr, this);
  }

  public int SupportedRFID() {
    return jniidengineJNI.IdDocumentInfo_SupportedRFID(swigCPtr, this);
  }

  public StringsSet GetPradoLinks() {
    return new StringsSet(jniidengineJNI.IdDocumentInfo_GetPradoLinks(swigCPtr, this), false);
  }

  public StringsSet GetDocumentTemplates() {
    return new StringsSet(jniidengineJNI.IdDocumentInfo_GetDocumentTemplates(swigCPtr, this), false);
  }

  public float GetDocumentFieldsRejectionThreshold(String field_name) {
    return jniidengineJNI.IdDocumentInfo_GetDocumentFieldsRejectionThreshold(swigCPtr, this, field_name);
  }

}
