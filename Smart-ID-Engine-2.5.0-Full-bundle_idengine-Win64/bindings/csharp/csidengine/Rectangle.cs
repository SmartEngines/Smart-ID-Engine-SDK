//------------------------------------------------------------------------------
// <auto-generated />
//
// This file was automatically generated by SWIG (https://www.swig.org).
// Version 4.1.1
//
// Do not make changes to this file unless you know what you are doing - modify
// the SWIG interface file instead.
//------------------------------------------------------------------------------

namespace se.common {

public class Rectangle : global::System.IDisposable {
  private global::System.Runtime.InteropServices.HandleRef swigCPtr;
  protected bool swigCMemOwn;

  public Rectangle(global::System.IntPtr cPtr, bool cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = new global::System.Runtime.InteropServices.HandleRef(this, cPtr);
  }

  public static global::System.Runtime.InteropServices.HandleRef getCPtr(Rectangle obj) {
    return (obj == null) ? new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero) : obj.swigCPtr;
  }

  public static global::System.Runtime.InteropServices.HandleRef swigRelease(Rectangle obj) {
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

  ~Rectangle() {
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
          cssecommonPINVOKE.delete_Rectangle(swigCPtr);
        }
        swigCPtr = new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero);
      }
    }
  }

  public Rectangle() : this(cssecommonPINVOKE.new_Rectangle__SWIG_0(), true) {
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public Rectangle(int x, int y, int width, int height) : this(cssecommonPINVOKE.new_Rectangle__SWIG_1(x, y, width, height), true) {
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public void Serialize(Serializer serializer) {
    cssecommonPINVOKE.Rectangle_Serialize(swigCPtr, Serializer.getCPtr(serializer));
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public int x {
    set {
      cssecommonPINVOKE.Rectangle_x_set(swigCPtr, value);
      if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
    } 
    get {
      int ret = cssecommonPINVOKE.Rectangle_x_get(swigCPtr);
      if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
      return ret;
    } 
  }

  public int y {
    set {
      cssecommonPINVOKE.Rectangle_y_set(swigCPtr, value);
      if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
    } 
    get {
      int ret = cssecommonPINVOKE.Rectangle_y_get(swigCPtr);
      if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
      return ret;
    } 
  }

  public int width {
    set {
      cssecommonPINVOKE.Rectangle_width_set(swigCPtr, value);
      if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
    } 
    get {
      int ret = cssecommonPINVOKE.Rectangle_width_get(swigCPtr);
      if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
      return ret;
    } 
  }

  public int height {
    set {
      cssecommonPINVOKE.Rectangle_height_set(swigCPtr, value);
      if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
    } 
    get {
      int ret = cssecommonPINVOKE.Rectangle_height_get(swigCPtr);
      if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
      return ret;
    } 
  }

}

}
