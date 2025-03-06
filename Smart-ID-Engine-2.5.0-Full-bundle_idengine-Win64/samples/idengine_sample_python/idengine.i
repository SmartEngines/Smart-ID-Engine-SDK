%module pyidengine

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

%rename("%(lowercamelcase)s", %$isvariable) "";

%exception {
  try {
    $action
  } catch (const se::common::BaseException& e) {
        SWIG_exception(SWIG_RuntimeError, (std::string("CRITICAL: Base exception caught: ") + ": " + e.what()).c_str());
  } catch (const std::exception& e) {
        SWIG_exception(SWIG_RuntimeError, (std::string("CRITICAL!: STL exception caught: ") + e.what()).c_str());
  } catch (...) {
        SWIG_exception(SWIG_RuntimeError, "CRITICAL!: Unknown exception caught");
  }
}

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

%newobject se::id::IdSessionSettings::Clone;
%newobject se::id::IdFileAnalysisSessionSettings::Clone;
%newobject se::id::IdFaceSessionSettings::Clone;
%newobject se::id::IdFieldProcessingSessionSettings::Clone;
%newobject se::id::IdVideoAuthenticationSessionSettings::Clone;

%ignore ConstructFromImpl;
%ignore GetImpl;
%ignore GetMutableImpl;




%include "idengine/id_fields.h"

%include "idengine/id_document_info.h"
%include "idengine/id_face_feedback.h"
%include "idengine/id_face_result.h"
%include "idengine/id_face_session.h"
%include "idengine/id_face_session_settings.h"

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

%include "idengine/id_engine.h"
