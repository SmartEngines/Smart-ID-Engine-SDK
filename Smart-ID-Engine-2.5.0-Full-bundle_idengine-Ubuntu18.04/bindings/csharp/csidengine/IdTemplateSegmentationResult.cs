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

public class IdTemplateSegmentationResult : global::System.IDisposable {
  private global::System.Runtime.InteropServices.HandleRef swigCPtr;
  protected bool swigCMemOwn;

  public IdTemplateSegmentationResult(global::System.IntPtr cPtr, bool cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = new global::System.Runtime.InteropServices.HandleRef(this, cPtr);
  }

  public static global::System.Runtime.InteropServices.HandleRef getCPtr(IdTemplateSegmentationResult obj) {
    return (obj == null) ? new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero) : obj.swigCPtr;
  }

  public static global::System.Runtime.InteropServices.HandleRef swigRelease(IdTemplateSegmentationResult obj) {
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

  ~IdTemplateSegmentationResult() {
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
          csidenginePINVOKE.delete_IdTemplateSegmentationResult(swigCPtr);
        }
        swigCPtr = new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero);
      }
    }
  }

  public IdTemplateSegmentationResult(bool is_accepted, double confidence) : this(csidenginePINVOKE.new_IdTemplateSegmentationResult__SWIG_0(is_accepted, confidence), true) {
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public IdTemplateSegmentationResult(bool is_accepted) : this(csidenginePINVOKE.new_IdTemplateSegmentationResult__SWIG_1(is_accepted), true) {
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public IdTemplateSegmentationResult() : this(csidenginePINVOKE.new_IdTemplateSegmentationResult__SWIG_2(), true) {
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public IdTemplateSegmentationResult(IdTemplateSegmentationResult copy) : this(csidenginePINVOKE.new_IdTemplateSegmentationResult__SWIG_3(IdTemplateSegmentationResult.getCPtr(copy)), true) {
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public bool GetIsAccepted() {
    bool ret = csidenginePINVOKE.IdTemplateSegmentationResult_GetIsAccepted(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public void SetIsAccepted(bool is_accepted) {
    csidenginePINVOKE.IdTemplateSegmentationResult_SetIsAccepted(swigCPtr, is_accepted);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public double GetConfidence() {
    double ret = csidenginePINVOKE.IdTemplateSegmentationResult_GetConfidence(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public void SetConfidence(double confidence) {
    csidenginePINVOKE.IdTemplateSegmentationResult_SetConfidence(swigCPtr, confidence);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public int GetRawFieldsCount() {
    int ret = csidenginePINVOKE.IdTemplateSegmentationResult_GetRawFieldsCount(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public bool HasRawField(string raw_field_name) {
    bool ret = csidenginePINVOKE.IdTemplateSegmentationResult_HasRawField(swigCPtr, raw_field_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public Quadrangle GetRawFieldQuadrangle(string raw_field_name) {
    Quadrangle ret = new Quadrangle(csidenginePINVOKE.IdTemplateSegmentationResult_GetRawFieldQuadrangle(swigCPtr, raw_field_name), false);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public Quadrangle GetRawFieldTemplateQuadrangle(string raw_field_name) {
    Quadrangle ret = new Quadrangle(csidenginePINVOKE.IdTemplateSegmentationResult_GetRawFieldTemplateQuadrangle(swigCPtr, raw_field_name), false);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public void SetRawFieldQuadrangles(string raw_field_name, Quadrangle quadrangle, Quadrangle template_quadrangle) {
    csidenginePINVOKE.IdTemplateSegmentationResult_SetRawFieldQuadrangles(swigCPtr, raw_field_name, Quadrangle.getCPtr(quadrangle), Quadrangle.getCPtr(template_quadrangle));
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public void RemoveRawField(string raw_field_name) {
    csidenginePINVOKE.IdTemplateSegmentationResult_RemoveRawField(swigCPtr, raw_field_name);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public QuadranglesMapIterator RawFieldQuadranglesBegin() {
    QuadranglesMapIterator ret = new QuadranglesMapIterator(csidenginePINVOKE.IdTemplateSegmentationResult_RawFieldQuadranglesBegin(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public QuadranglesMapIterator RawFieldQuadranglesEnd() {
    QuadranglesMapIterator ret = new QuadranglesMapIterator(csidenginePINVOKE.IdTemplateSegmentationResult_RawFieldQuadranglesEnd(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public QuadranglesMapIterator RawFieldTemplateQuadranglesBegin() {
    QuadranglesMapIterator ret = new QuadranglesMapIterator(csidenginePINVOKE.IdTemplateSegmentationResult_RawFieldTemplateQuadranglesBegin(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public QuadranglesMapIterator RawFieldTemplateQuadranglesEnd() {
    QuadranglesMapIterator ret = new QuadranglesMapIterator(csidenginePINVOKE.IdTemplateSegmentationResult_RawFieldTemplateQuadranglesEnd(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

}

}
