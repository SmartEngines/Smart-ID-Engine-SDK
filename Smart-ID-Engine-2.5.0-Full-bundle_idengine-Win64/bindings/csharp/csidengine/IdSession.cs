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

public class IdSession : global::System.IDisposable {
  private global::System.Runtime.InteropServices.HandleRef swigCPtr;
  protected bool swigCMemOwn;

  public IdSession(global::System.IntPtr cPtr, bool cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = new global::System.Runtime.InteropServices.HandleRef(this, cPtr);
  }

  public static global::System.Runtime.InteropServices.HandleRef getCPtr(IdSession obj) {
    return (obj == null) ? new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero) : obj.swigCPtr;
  }

  public static global::System.Runtime.InteropServices.HandleRef swigRelease(IdSession obj) {
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

  ~IdSession() {
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
          csidenginePINVOKE.delete_IdSession(swigCPtr);
        }
        swigCPtr = new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero);
      }
    }
  }

  public virtual string GetActivationRequest() {
    string ret = csidenginePINVOKE.IdSession_GetActivationRequest(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual void Activate(string activation_response) {
    csidenginePINVOKE.IdSession_Activate(swigCPtr, activation_response);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual bool IsActivated() {
    bool ret = csidenginePINVOKE.IdSession_IsActivated(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual IdResult Process(Image image) {
    IdResult ret = new IdResult(csidenginePINVOKE.IdSession_Process__SWIG_0(swigCPtr, Image.getCPtr(image)), false);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual IdResult Process(ByteString data) {
    IdResult ret = new IdResult(csidenginePINVOKE.IdSession_Process__SWIG_1(swigCPtr, ByteString.getCPtr(data)), false);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual IdResult GetCurrentResult() {
    IdResult ret = new IdResult(csidenginePINVOKE.IdSession_GetCurrentResult(swigCPtr), false);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual bool IsResultTerminal() {
    bool ret = csidenginePINVOKE.IdSession_IsResultTerminal(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual void Reset() {
    csidenginePINVOKE.IdSession_Reset(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

}

}
