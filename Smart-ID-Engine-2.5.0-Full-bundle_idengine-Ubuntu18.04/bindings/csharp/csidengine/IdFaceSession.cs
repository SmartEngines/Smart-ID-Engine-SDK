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

public class IdFaceSession : global::System.IDisposable {
  private global::System.Runtime.InteropServices.HandleRef swigCPtr;
  protected bool swigCMemOwn;

  public IdFaceSession(global::System.IntPtr cPtr, bool cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = new global::System.Runtime.InteropServices.HandleRef(this, cPtr);
  }

  public static global::System.Runtime.InteropServices.HandleRef getCPtr(IdFaceSession obj) {
    return (obj == null) ? new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero) : obj.swigCPtr;
  }

  public static global::System.Runtime.InteropServices.HandleRef swigRelease(IdFaceSession obj) {
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

  ~IdFaceSession() {
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
          csidenginePINVOKE.delete_IdFaceSession(swigCPtr);
        }
        swigCPtr = new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero);
      }
    }
  }

  public virtual string GetActivationRequest() {
    string ret = csidenginePINVOKE.IdFaceSession_GetActivationRequest(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual void Activate(string activation_response) {
    csidenginePINVOKE.IdFaceSession_Activate(swigCPtr, activation_response);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual bool IsActivated() {
    bool ret = csidenginePINVOKE.IdFaceSession_IsActivated(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual IdFaceSimilarityResult GetSimilarity(Image face_image_a, Image face_image_b) {
    IdFaceSimilarityResult ret = new IdFaceSimilarityResult(csidenginePINVOKE.IdFaceSession_GetSimilarity(swigCPtr, Image.getCPtr(face_image_a), Image.getCPtr(face_image_b)), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual void AddFaceImage(Image face_image) {
    csidenginePINVOKE.IdFaceSession_AddFaceImage(swigCPtr, Image.getCPtr(face_image));
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

  public virtual IdFaceRectsResult GetRects(Image image) {
    IdFaceRectsResult ret = new IdFaceRectsResult(csidenginePINVOKE.IdFaceSession_GetRects(swigCPtr, Image.getCPtr(image)), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual bool HasAccumulatedImage() {
    bool ret = csidenginePINVOKE.IdFaceSession_HasAccumulatedImage(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual IdFaceSimilarityResult GetSimilarityWith(Image compare_image) {
    IdFaceSimilarityResult ret = new IdFaceSimilarityResult(csidenginePINVOKE.IdFaceSession_GetSimilarityWith(swigCPtr, Image.getCPtr(compare_image)), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual IdFaceLivenessResult GetLivenessResult() {
    IdFaceLivenessResult ret = new IdFaceLivenessResult(csidenginePINVOKE.IdFaceSession_GetLivenessResult(swigCPtr), true);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
    return ret;
  }

  public virtual void Reset() {
    csidenginePINVOKE.IdFaceSession_Reset(swigCPtr);
    if (csidenginePINVOKE.SWIGPendingException.Pending) throw csidenginePINVOKE.SWIGPendingException.Retrieve();
  }

}

}
