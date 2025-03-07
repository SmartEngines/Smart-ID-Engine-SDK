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

public class IdBaseFieldInfo : global::System.IDisposable {
  private global::System.Runtime.InteropServices.HandleRef swigCPtr;
  protected bool swigCMemOwn;

  public IdBaseFieldInfo(global::System.IntPtr cPtr, bool cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = new global::System.Runtime.InteropServices.HandleRef(this, cPtr);
  }

  public static global::System.Runtime.InteropServices.HandleRef getCPtr(IdBaseFieldInfo obj) {
    return (obj == null) ? new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero) : obj.swigCPtr;
  }

  public static global::System.Runtime.InteropServices.HandleRef swigRelease(IdBaseFieldInfo obj) {
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

  ~IdBaseFieldInfo() {
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
          csidenginePINVOKE.delete_IdBaseFieldInfo(swigCPtr);
        }
        swigCPtr = new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero);
      }
    }
  }

  public IdBaseFieldInfo(bool is_accepted, double confidence) : this(csidenginePINVOKE.new_IdBaseFieldInfo__SWIG_0(is_accepted, confidence), true) {
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public IdBaseFieldInfo(bool is_accepted) : this(csidenginePINVOKE.new_IdBaseFieldInfo__SWIG_1(is_accepted), true) {
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public IdBaseFieldInfo() : this(csidenginePINVOKE.new_IdBaseFieldInfo__SWIG_2(), true) {
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public IdBaseFieldInfo(IdBaseFieldInfo copy) : this(csidenginePINVOKE.new_IdBaseFieldInfo__SWIG_3(IdBaseFieldInfo.getCPtr(copy)), true) {
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public bool GetIsAccepted() {
    bool ret = csidenginePINVOKE.IdBaseFieldInfo_GetIsAccepted(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public void SetIsAccepted(bool is_accepted) {
    csidenginePINVOKE.IdBaseFieldInfo_SetIsAccepted(swigCPtr, is_accepted);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public double GetConfidence() {
    double ret = csidenginePINVOKE.IdBaseFieldInfo_GetConfidence(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public void SetConfidence(double confidence) {
    csidenginePINVOKE.IdBaseFieldInfo_SetConfidence(swigCPtr, confidence);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public int GetAttributesCount() {
    int ret = csidenginePINVOKE.IdBaseFieldInfo_GetAttributesCount(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public string GetAttribute(string attr_name) {
    string ret = csidenginePINVOKE.IdBaseFieldInfo_GetAttribute(swigCPtr, attr_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public bool HasAttribute(string attr_name) {
    bool ret = csidenginePINVOKE.IdBaseFieldInfo_HasAttribute(swigCPtr, attr_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public void SetAttribute(string attr_name, string attr_value) {
    csidenginePINVOKE.IdBaseFieldInfo_SetAttribute(swigCPtr, attr_name, attr_value);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public void RemoveAttribute(string attr_name) {
    csidenginePINVOKE.IdBaseFieldInfo_RemoveAttribute(swigCPtr, attr_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public StringsMapIterator AttributesBegin() {
    StringsMapIterator ret = new StringsMapIterator(csidenginePINVOKE.IdBaseFieldInfo_AttributesBegin(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public StringsMapIterator AttributesEnd() {
    StringsMapIterator ret = new StringsMapIterator(csidenginePINVOKE.IdBaseFieldInfo_AttributesEnd(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

}

}
