/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (https://www.swig.org).
 * Version 4.1.1
 *
 * Do not make changes to this file unless you know what you are doing - modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.smartengines.id;

import com.smartengines.common.*;

public class IdFeedbackContainer {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  public IdFeedbackContainer(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  public static long getCPtr(IdFeedbackContainer obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  public static long swigRelease(IdFeedbackContainer obj) {
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
        jniidengineJNI.delete_IdFeedbackContainer(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public IdFeedbackContainer() {
    this(jniidengineJNI.new_IdFeedbackContainer__SWIG_0(), true);
  }

  public IdFeedbackContainer(IdFeedbackContainer copy) {
    this(jniidengineJNI.new_IdFeedbackContainer__SWIG_1(IdFeedbackContainer.getCPtr(copy), copy), true);
  }

  public int GetQuadranglesCount() {
    return jniidengineJNI.IdFeedbackContainer_GetQuadranglesCount(swigCPtr, this);
  }

  public boolean HasQuadrangle(String quad_name) {
    return jniidengineJNI.IdFeedbackContainer_HasQuadrangle(swigCPtr, this, quad_name);
  }

  public Quadrangle GetQuadrangle(String quad_name) {
    return new Quadrangle(jniidengineJNI.IdFeedbackContainer_GetQuadrangle(swigCPtr, this, quad_name), false);
  }

  public void SetQuadrangle(String quad_name, Quadrangle quad) {
    jniidengineJNI.IdFeedbackContainer_SetQuadrangle(swigCPtr, this, quad_name, Quadrangle.getCPtr(quad), quad);
  }

  public void RemoveQuadrangle(String quad_name) {
    jniidengineJNI.IdFeedbackContainer_RemoveQuadrangle(swigCPtr, this, quad_name);
  }

  public QuadranglesMapIterator QuadranglesBegin() {
    return new QuadranglesMapIterator(jniidengineJNI.IdFeedbackContainer_QuadranglesBegin(swigCPtr, this), true);
  }

  public QuadranglesMapIterator QuadranglesEnd() {
    return new QuadranglesMapIterator(jniidengineJNI.IdFeedbackContainer_QuadranglesEnd(swigCPtr, this), true);
  }

}
