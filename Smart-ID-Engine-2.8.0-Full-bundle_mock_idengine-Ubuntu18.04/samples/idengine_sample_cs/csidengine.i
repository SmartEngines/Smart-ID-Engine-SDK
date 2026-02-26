%module(directors="1") csidengine
%feature("director") se::id::IdFeedback;
%feature("director") se::id::IdFaceFeedback;
%feature("director") se::id::IdVideoAuthenticationCallbacks;

%include typemaps.i
%include exception.i
%include std_except.i

%include "secommon_include.i"

%{
  #include "secommon/se_common.h"
  #include "secommon/se_exception.h"
  #include "secommon/se_export_defs.h"
  #include "secommon/se_geometry.h"
  #include "secommon/se_image.h"
  #include "secommon/se_serialization.h"
  #include "secommon/se_string.h"
  #include "secommon/se_strings_iterator.h"
  #include "secommon/se_strings_set.h"

  #include "idengine/id_document_info.h"
  #include "idengine/id_engine.h"
  #include "idengine/id_face_feedback.h"
  #include "idengine/id_face_result.h"
  #include "idengine/id_face_session.h"
  #include "idengine/id_face_session_settings.h"
  #include "idengine/id_feedback.h"
  #include "idengine/id_field_processing_session.h"
  #include "idengine/id_field_processing_session_settings.h"
  #include "idengine/id_fields.h"
  #include "idengine/id_result.h"
  #include "idengine/id_file_analysis_session.h"
  #include "idengine/id_file_analysis_session_settings.h"
  #include "idengine/id_session.h"
  #include "idengine/id_session_settings.h"

  #include "idengine/id_video_authentication_callbacks.h"
  #include "idengine/id_video_authentication_result.h"
  #include "idengine/id_video_authentication_session.h"
  #include "idengine/id_video_authentication_session_settings.h"
%}

%pragma(csharp) imclassimports=%{
  using se.common;
%}

%include "arrays_csharp.i"
CSHARP_ARRAYS(char, byte)

%apply unsigned char INPUT[] { unsigned char* data };
%apply unsigned char INPUT[] { unsigned char* yuv_data };
%apply unsigned char INPUT[] { unsigned char* config_data };
%apply char OUTPUT[] { char* out_buffer };

%typemap(csimports) SWIGTYPE %{
  using se.common;
%}

%pragma(csharp) imclassimports=%{
using System.Runtime.InteropServices;
using System;
using System.Text;
%}

%pragma(csharp) imclasscode=%{
public class SimpleMarshaler : ICustomMarshaler {
    static SimpleMarshaler myself = new SimpleMarshaler();

    public object MarshalNativeToManaged(IntPtr pNativeData) {
        int size_buffer = 0;
        while (Marshal.ReadByte(pNativeData, size_buffer) != 0) {
            ++size_buffer;
        }
        byte[] byte_buffer = new byte[size_buffer];
        Marshal.Copy((IntPtr)pNativeData, byte_buffer, 0, size_buffer);
        return Encoding.UTF8.GetString(byte_buffer);
    }

    public IntPtr MarshalManagedToNative( Object ManagedObj ) => throw new NotImplementedException();

    public void CleanUpNativeData( IntPtr nativeData ) {
        Marshal.FreeHGlobal(nativeData);
    }

    public void CleanUpManagedData( Object ManagedObj ) => throw new NotImplementedException();
    public int GetNativeDataSize() => throw new NotImplementedException();

    public static ICustomMarshaler GetInstance(string cookie) {
        return myself;
    }
}
%}

%exception {
  try {
    $action
  } catch (const se::common::BaseException& e) {
        SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("Base secommon exception caught: ") + e.what()).c_str());
        return $null;
  } catch (const std::exception& e) {
        SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("CRITICAL!: STL exception caught: ") + e.what()).c_str());
        return $null;
  } catch (...) {
        SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), "CRITICAL!: Unknown exception caught");
        return $null;
  }
}

// %exception se::id::IdEngine::Create {
//   try {
//     $action
//   } catch (const se::common::BaseException& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("Base secommon exception caught: ") + e.what()).c_str());
//   } catch (const std::exception& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("CRITICAL!: STL exception caught: ") + e.what()).c_str());
//   } catch (...) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), "CRITICAL!: Unknown exception caught");
//   }
// }
// %exception se::id::IdEngine::CreateSessionSettings {
//   try {
//     $action
//   } catch (const se::common::BaseException& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("Base secommon exception caught: ") + e.what()).c_str());
//   } catch (const std::exception& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("CRITICAL!: STL exception caught: ") + e.what()).c_str());
//   } catch (...) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), "CRITICAL!: Unknown exception caught");
//   }
// }
// %exception se::id::IdEngine::CreateFaceSessionSettings {
//   try {
//     $action
//   } catch (const se::common::BaseException& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("Base secommon exception caught: ") + e.what()).c_str());
//   } catch (const std::exception& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("CRITICAL!: STL exception caught: ") + e.what()).c_str());
//   } catch (...) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), "CRITICAL!: Unknown exception caught");
//   }
// }
// %exception se::id::IdEngine::CreateFieldProcessingSessionSettings {
//   try {
//     $action
//   } catch (const se::common::BaseException& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("Base secommon exception caught: ") + e.what()).c_str());
//   } catch (const std::exception& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("CRITICAL!: STL exception caught: ") + e.what()).c_str());
//   } catch (...) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), "CRITICAL!: Unknown exception caught");
//   }
// }
// %exception se::id::IdEngine::SpawnSession {
//   try {
//     $action
//   } catch (const se::common::BaseException& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("Base secommon exception caught: ") + e.what()).c_str());
//   } catch (const std::exception& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("CRITICAL!: STL exception caught: ") + e.what()).c_str());
//   } catch (...) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), "CRITICAL!: Unknown exception caught");
//   }
// }
// %exception se::id::IdEngine::SpawnFaceSession {
//   try {
//     $action
//   } catch (const se::common::BaseException& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("Base secommon exception caught: ") + e.what()).c_str());
//   } catch (const std::exception& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("CRITICAL!: STL exception caught: ") + e.what()).c_str());
//   } catch (...) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), "CRITICAL!: Unknown exception caught");
//   }
// }
// %exception se::id::IdEngine::SpawnFieldProcessingSession {
//   try {
//     $action
//   } catch (const se::common::BaseException& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("Base secommon exception caught: ") + e.what()).c_str());
//   } catch (const std::exception& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("CRITICAL!: STL exception caught: ") + e.what()).c_str());
//   } catch (...) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), "CRITICAL!: Unknown exception caught");
//   }
// }
// %exception se::id::IdFaceDescription::CreateEmpty {
//   try {
//     $action
//   } catch (const se::common::BaseException& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("Base secommon exception caught: ") + e.what()).c_str());
//   } catch (const std::exception& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("CRITICAL!: STL exception caught: ") + e.what()).c_str());
//   } catch (...) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), "CRITICAL!: Unknown exception caught");
//   }
// }
// %exception GetFaceDescription {
//   try {
//     $action
//   } catch (const se::common::BaseException& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("Base secommon exception caught: ") + e.what()).c_str());
//   } catch (const std::exception& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("CRITICAL!: STL exception caught: ") + e.what()).c_str());
//   } catch (...) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), "CRITICAL!: Unknown exception caught");
//   }
// }
// %exception Clone {
//   try {
//     $action
//   } catch (const se::common::BaseException& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("Base secommon exception caught: ") + e.what()).c_str());
//   } catch (const std::exception& e) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("CRITICAL!: STL exception caught: ") + e.what()).c_str());
//   } catch (...) {
//         SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), "CRITICAL!: Unknown exception caught");
//   }
// }

%newobject se::id::IdEngine::Create;
%newobject se::id::IdEngine::CreateSessionSettings;
%newobject se::id::IdEngine::CreateFileAnalysisSessionSettings;
%newobject se::id::IdEngine::CreateFaceSessionSettings;
%newobject se::id::IdEngine::CreateFieldProcessingSessionSettings;
%newobject se::id::IdEngine::CreateVideoAuthenticationSessionSettings;

%newobject se::id::IdEngine::SpawnSession;
%newobject se::id::IdEngine::SpawnFileAnalysisSession;
%newobject se::id::IdEngine::SpawnFaceSession;
%newobject se::id::IdEngine::SpawnFieldProcessingSession;
%newobject se::id::IdEngine::SpawnVideoAuthenticationSession;

%newobject se::id::IdFaceDescription::CreateEmpty;
%newobject se::id::IdFaceDescription::Clone;

%newobject se::id::IdFaceSession::GetFaceDescription;

%newobject se::id::IdSessionSettings::Clone;
%newobject se::id::IdFileAnalysisSessionSettings::Clone;
%newobject se::id::IdFaceSessionSettings::Clone;
%newobject se::id::IdFieldProcessingSessionSettings::Clone;
%newobject se::id::IdVideoAuthenticationSessionSettings::Clone;

%ignore ConstructFromImpl;
%ignore GetImpl;
%ignore GetMutableImpl;

%rename("%(lowercamelcase)s", %$isvariable) "";

// namespace std {
//   %template(Utf16CharVector) vector<uint16_t>;
//   %template(StringVector) vector<string>;
//   %template(StringVector2d) vector<vector<string> >;
// }

%typemap(imtype,
         outattributes="\n  [return: global::System.Runtime.InteropServices.MarshalAs(global::System.Runtime.InteropServices.UnmanagedType.CustomMarshaler, MarshalTypeRef = typeof(SimpleMarshaler))] \n ") const char * "string";
%include "idengine/id_fields.h"
%include "idengine/id_document_info.h"
%include "idengine/id_face_result.h"
%include "idengine/id_face_session.h"
%include "idengine/id_face_session_settings.h"
%include "idengine/id_face_feedback.h"

%include "idengine/id_field_processing_session.h"
%include "idengine/id_field_processing_session_settings.h"

%include "idengine/id_result.h"
%include "idengine/id_feedback.h"

%include "idengine/id_file_analysis_session.h"
%include "idengine/id_file_analysis_session_settings.h"

%include "idengine/id_session.h"
%include "idengine/id_session_settings.h"

%include "idengine/id_video_authentication_result.h"
%include "idengine/id_video_authentication_callbacks.h"
%include "idengine/id_video_authentication_session_settings.h"
%include "idengine/id_video_authentication_session.h"
%typemap(imtype) const char *;


// %include "idengine/id_fields.h"

// %include "idengine/id_document_info.h"
// %include "idengine/id_face_result.h"
// %include "idengine/id_face_session.h"
// %include "idengine/id_face_session_settings.h"
// %include "idengine/id_face_feedback.h"

// %include "idengine/id_field_processing_session.h"
// %include "idengine/id_field_processing_session_settings.h"

// %include "idengine/id_result.h"
// %include "idengine/id_feedback.h"
// %include "idengine/id_session.h"
// %include "idengine/id_session_settings.h"
%include "idengine/id_engine.h"

