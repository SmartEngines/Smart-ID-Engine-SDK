/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (https://www.swig.org).
 * Version 4.1.1
 *
 * Do not make changes to this file unless you know what you are doing - modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.smartengines.id;

import com.smartengines.common.*;

public class IdFileAnalysisSession {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  public IdFileAnalysisSession(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  public static long getCPtr(IdFileAnalysisSession obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  public static long swigRelease(IdFileAnalysisSession obj) {
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
        jniidengineJNI.delete_IdFileAnalysisSession(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public String GetActivationRequest() {
    return jniidengineJNI.IdFileAnalysisSession_GetActivationRequest(swigCPtr, this);
  }

  public void Activate(String activation_response) {
    jniidengineJNI.IdFileAnalysisSession_Activate(swigCPtr, this, activation_response);
  }

  public boolean IsActivated() {
    return jniidengineJNI.IdFileAnalysisSession_IsActivated(swigCPtr, this);
  }

  public IdResult Process(Image image) {
    return new IdResult(jniidengineJNI.IdFileAnalysisSession_Process(swigCPtr, this, Image.getCPtr(image), image), false);
  }

  public IdResult GetCurrentResult() {
    return new IdResult(jniidengineJNI.IdFileAnalysisSession_GetCurrentResult(swigCPtr, this), false);
  }

  public void Reset() {
    jniidengineJNI.IdFileAnalysisSession_Reset(swigCPtr, this);
  }

}
