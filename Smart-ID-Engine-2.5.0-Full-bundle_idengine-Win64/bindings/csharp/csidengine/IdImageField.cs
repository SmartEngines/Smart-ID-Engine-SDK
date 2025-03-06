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

public class IdImageField : global::System.IDisposable {
  private global::System.Runtime.InteropServices.HandleRef swigCPtr;
  protected bool swigCMemOwn;

  public IdImageField(global::System.IntPtr cPtr, bool cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = new global::System.Runtime.InteropServices.HandleRef(this, cPtr);
  }

  public static global::System.Runtime.InteropServices.HandleRef getCPtr(IdImageField obj) {
    return (obj == null) ? new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero) : obj.swigCPtr;
  }

  public static global::System.Runtime.InteropServices.HandleRef swigRelease(IdImageField obj) {
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

  ~IdImageField() {
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
          csidenginePINVOKE.delete_IdImageField(swigCPtr);
        }
        swigCPtr = new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero);
      }
    }
  }

  public IdImageField() : this(csidenginePINVOKE.new_IdImageField__SWIG_0(), true) {
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public IdImageField(string name, Image value, bool is_accepted, double confidence) : this(csidenginePINVOKE.new_IdImageField__SWIG_1(name, Image.getCPtr(value), is_accepted, confidence), true) {
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public IdImageField(string name, Image value, bool is_accepted) : this(csidenginePINVOKE.new_IdImageField__SWIG_2(name, Image.getCPtr(value), is_accepted), true) {
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public IdImageField(string name, Image value) : this(csidenginePINVOKE.new_IdImageField__SWIG_3(name, Image.getCPtr(value)), true) {
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public IdImageField(IdImageField copy) : this(csidenginePINVOKE.new_IdImageField__SWIG_4(IdImageField.getCPtr(copy)), true) {
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public string GetName() {
    string ret = csidenginePINVOKE.IdImageField_GetName(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public void SetName(string name) {
    csidenginePINVOKE.IdImageField_SetName(swigCPtr, name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public Image GetValue() {
    Image ret = new Image(csidenginePINVOKE.IdImageField_GetValue(swigCPtr), false);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public void SetValue(Image value) {
    csidenginePINVOKE.IdImageField_SetValue(swigCPtr, Image.getCPtr(value));
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public IdBaseFieldInfo GetBaseFieldInfo() {
    IdBaseFieldInfo ret = new IdBaseFieldInfo(csidenginePINVOKE.IdImageField_GetBaseFieldInfo(swigCPtr), false);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public IdBaseFieldInfo GetMutableBaseFieldInfo() {
    IdBaseFieldInfo ret = new IdBaseFieldInfo(csidenginePINVOKE.IdImageField_GetMutableBaseFieldInfo(swigCPtr), false);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

}

}
