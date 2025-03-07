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

public class OcrString : global::System.IDisposable {
  private global::System.Runtime.InteropServices.HandleRef swigCPtr;
  protected bool swigCMemOwn;

  public OcrString(global::System.IntPtr cPtr, bool cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = new global::System.Runtime.InteropServices.HandleRef(this, cPtr);
  }

  public static global::System.Runtime.InteropServices.HandleRef getCPtr(OcrString obj) {
    return (obj == null) ? new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero) : obj.swigCPtr;
  }

  public static global::System.Runtime.InteropServices.HandleRef swigRelease(OcrString obj) {
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

  ~OcrString() {
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
          cssecommonPINVOKE.delete_OcrString(swigCPtr);
        }
        swigCPtr = new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero);
      }
    }
  }

  public OcrString() : this(cssecommonPINVOKE.new_OcrString__SWIG_0(), true) {
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public OcrString(string utf8_str) : this(cssecommonPINVOKE.new_OcrString__SWIG_1(utf8_str), true) {
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public OcrString(OcrChar chars, int chars_count) : this(cssecommonPINVOKE.new_OcrString__SWIG_2(OcrChar.getCPtr(chars), chars_count), true) {
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public OcrString(OcrString other) : this(cssecommonPINVOKE.new_OcrString__SWIG_3(OcrString.getCPtr(other)), true) {
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public int GetCharsCount() {
    int ret = cssecommonPINVOKE.OcrString_GetCharsCount(swigCPtr);
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public OcrChar GetChars() {
    global::System.IntPtr cPtr = cssecommonPINVOKE.OcrString_GetChars(swigCPtr);
    OcrChar ret = (cPtr == global::System.IntPtr.Zero) ? null : new OcrChar(cPtr, false);
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public OcrChar GetChar(int index) {
    OcrChar ret = new OcrChar(cssecommonPINVOKE.OcrString_GetChar(swigCPtr, index), false);
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public OcrChar GetMutableChar(int index) {
    OcrChar ret = new OcrChar(cssecommonPINVOKE.OcrString_GetMutableChar(swigCPtr, index), false);
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public void SetChar(int index, OcrChar chr) {
    cssecommonPINVOKE.OcrString_SetChar(swigCPtr, index, OcrChar.getCPtr(chr));
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public void AppendChar(OcrChar chr) {
    cssecommonPINVOKE.OcrString_AppendChar(swigCPtr, OcrChar.getCPtr(chr));
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public void AppendString(OcrString str) {
    cssecommonPINVOKE.OcrString_AppendString(swigCPtr, OcrString.getCPtr(str));
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public void Resize(int size) {
    cssecommonPINVOKE.OcrString_Resize(swigCPtr, size);
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public Quadrangle GetQuadrangleByIndex(int idx) {
    Quadrangle ret = new Quadrangle(cssecommonPINVOKE.OcrString_GetQuadrangleByIndex(swigCPtr, idx), true);
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public float GetBestVariantConfidenceByIndex(int idx) {
    float ret = cssecommonPINVOKE.OcrString_GetBestVariantConfidenceByIndex(swigCPtr, idx);
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public void SortVariants() {
    cssecommonPINVOKE.OcrString_SortVariants(swigCPtr);
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public MutableString GetFirstString() {
    MutableString ret = new MutableString(cssecommonPINVOKE.OcrString_GetFirstString(swigCPtr), true);
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public void UnpackChars() {
    cssecommonPINVOKE.OcrString_UnpackChars(swigCPtr);
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public void RepackChars() {
    cssecommonPINVOKE.OcrString_RepackChars(swigCPtr);
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

  public void Serialize(Serializer serializer) {
    cssecommonPINVOKE.OcrString_Serialize(swigCPtr, Serializer.getCPtr(serializer));
    if (cssecommonPINVOKE.SWIGPendingException.Pending) throw cssecommonPINVOKE.SWIGPendingException.Retrieve();
  }

}

}
