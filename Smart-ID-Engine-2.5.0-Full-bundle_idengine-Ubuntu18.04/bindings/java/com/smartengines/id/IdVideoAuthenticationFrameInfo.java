/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (https://www.swig.org).
 * Version 4.1.1
 *
 * Do not make changes to this file unless you know what you are doing - modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.smartengines.id;

import com.smartengines.common.*;

public class IdVideoAuthenticationFrameInfo {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  public IdVideoAuthenticationFrameInfo(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  public static long getCPtr(IdVideoAuthenticationFrameInfo obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  public static long swigRelease(IdVideoAuthenticationFrameInfo obj) {
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
        jniidengineJNI.delete_IdVideoAuthenticationFrameInfo(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public IdVideoAuthenticationFrameInfo() {
    this(jniidengineJNI.new_IdVideoAuthenticationFrameInfo__SWIG_0(), true);
  }

  public IdVideoAuthenticationFrameInfo(Image prototype, int timestamp) {
    this(jniidengineJNI.new_IdVideoAuthenticationFrameInfo__SWIG_1(Image.getCPtr(prototype), prototype, timestamp), true);
  }

  public IdVideoAuthenticationFrameInfo(IdVideoAuthenticationFrameInfo copy) {
    this(jniidengineJNI.new_IdVideoAuthenticationFrameInfo__SWIG_2(IdVideoAuthenticationFrameInfo.getCPtr(copy), copy), true);
  }

  public int GetWidth() {
    return jniidengineJNI.IdVideoAuthenticationFrameInfo_GetWidth(swigCPtr, this);
  }

  public void SetWidth(int width) {
    jniidengineJNI.IdVideoAuthenticationFrameInfo_SetWidth(swigCPtr, this, width);
  }

  public int GetHeight() {
    return jniidengineJNI.IdVideoAuthenticationFrameInfo_GetHeight(swigCPtr, this);
  }

  public void SetHeight(int height) {
    jniidengineJNI.IdVideoAuthenticationFrameInfo_SetHeight(swigCPtr, this, height);
  }

  public int GetStride() {
    return jniidengineJNI.IdVideoAuthenticationFrameInfo_GetStride(swigCPtr, this);
  }

  public void SetStride(int stride) {
    jniidengineJNI.IdVideoAuthenticationFrameInfo_SetStride(swigCPtr, this, stride);
  }

  public int GetChannels() {
    return jniidengineJNI.IdVideoAuthenticationFrameInfo_GetChannels(swigCPtr, this);
  }

  public void SetChannels(int channels) {
    jniidengineJNI.IdVideoAuthenticationFrameInfo_SetChannels(swigCPtr, this, channels);
  }

  public Size GetSize() {
    return new Size(jniidengineJNI.IdVideoAuthenticationFrameInfo_GetSize(swigCPtr, this), true);
  }

  public void SetSize(Size size) {
    jniidengineJNI.IdVideoAuthenticationFrameInfo_SetSize(swigCPtr, this, Size.getCPtr(size), size);
  }

  public int GetTimestamp() {
    return jniidengineJNI.IdVideoAuthenticationFrameInfo_GetTimestamp(swigCPtr, this);
  }

  public void SetTimestamp(int timestamp) {
    jniidengineJNI.IdVideoAuthenticationFrameInfo_SetTimestamp(swigCPtr, this, timestamp);
  }

}
