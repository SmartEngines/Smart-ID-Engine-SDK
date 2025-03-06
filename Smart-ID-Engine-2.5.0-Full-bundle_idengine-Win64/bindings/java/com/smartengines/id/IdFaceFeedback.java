/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (https://www.swig.org).
 * Version 4.1.1
 *
 * Do not make changes to this file unless you know what you are doing - modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.smartengines.id;

import com.smartengines.common.*;

public class IdFaceFeedback {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  public IdFaceFeedback(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  public static long getCPtr(IdFaceFeedback obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  public static long swigRelease(IdFaceFeedback obj) {
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
        jniidengineJNI.delete_IdFaceFeedback(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  protected void swigDirectorDisconnect() {
    swigCMemOwn = false;
    delete();
  }

  public void swigReleaseOwnership() {
    swigCMemOwn = false;
    jniidengineJNI.IdFaceFeedback_change_ownership(this, swigCPtr, false);
  }

  public void swigTakeOwnership() {
    swigCMemOwn = true;
    jniidengineJNI.IdFaceFeedback_change_ownership(this, swigCPtr, true);
  }

  public void MessageReceived(String message) {
    jniidengineJNI.IdFaceFeedback_MessageReceived(swigCPtr, this, message);
  }

  public IdFaceFeedback() {
    this(jniidengineJNI.new_IdFaceFeedback(), true);
    jniidengineJNI.IdFaceFeedback_director_connect(this, swigCPtr, true, true);
  }

}
