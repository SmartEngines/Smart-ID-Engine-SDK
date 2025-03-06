/**
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

#include <cstring>
#include <memory>
#include <cstdio>
#include <string>

#ifdef _MSC_VER
#pragma warning( disable : 4290 )
#include <windows.h>
#endif // _MSC_VER

#include <idengine/id_engine.h>

// Here we simply output the recognized fields
void OutputRecognitionResult(const se::id::IdResult& result,
                             const se::id::IdFileAnalysisSessionSettings& session_settings) {
  printf("Document type: %s\n", result.GetDocumentType());

  for (int i = 0; i < result.GetTemplateDetectionResultsCount(); ++i) {
    printf("Template detection result %d:\n", i);
    const se::id::IdTemplateDetectionResult& tpl_res =
        result.GetTemplateDetectionResult(i);
    printf("    Template Name: %s\n", tpl_res.GetTemplateName());
    printf("    Quad = { (%lf, %lf), (%lf, %lf), (%lf, %lf), (%lf, %lf) }\n",
        tpl_res.GetQuadrangle()[0].x, tpl_res.GetQuadrangle()[0].y,
        tpl_res.GetQuadrangle()[1].x, tpl_res.GetQuadrangle()[1].y,
        tpl_res.GetQuadrangle()[2].x, tpl_res.GetQuadrangle()[2].y,
        tpl_res.GetQuadrangle()[3].x, tpl_res.GetQuadrangle()[3].y);
    if (tpl_res.GetAttributesCount() > 0) {
      printf("    Attributes:\n");
      for (se::common::StringsMapIterator it = tpl_res.AttributesBegin();
           it != tpl_res.AttributesEnd();
           ++it) {
        printf("        %s: %s\n", it.GetKey(), it.GetValue());
      }
    }
  }

  printf("Text fields:\n");
  for (auto it = result.TextFieldsBegin(); it != result.TextFieldsEnd(); ++it) {
    const se::id::IdTextField& field = it.GetValue();
    std::string is_accepted =
        field.GetBaseFieldInfo().GetIsAccepted() ? " [+] " : " [-] ";
    printf("    %-25s%s (%4.3lf) %s\n",
        field.GetName(),
        is_accepted.c_str(),
        field.GetBaseFieldInfo().GetConfidence(),
        field.GetValue().GetFirstString().GetCStr());
  }

  printf("Image fields:\n");
  for (auto it = result.ImageFieldsBegin(); it != result.ImageFieldsEnd(); ++it) {
    const se::id::IdImageField& field = it.GetValue();
    std::string is_accepted =
        field.GetBaseFieldInfo().GetIsAccepted() ? " [+] " : " [-] ";
    printf("    %-25s%s (%4.3lf) W: %d H: %d\n",
        field.GetName(),
        is_accepted.c_str(),
        field.GetBaseFieldInfo().GetConfidence(),
        field.GetValue().GetWidth(),
        field.GetValue().GetHeight());
  }

  printf("Forensic check fields:\n");
  for (auto it = result.ForensicCheckFieldsBegin();
       it != result.ForensicCheckFieldsEnd();
       ++it) {
    const se::id::IdCheckField& field = it.GetValue();
    std::string is_accepted =
        field.GetBaseFieldInfo().GetIsAccepted() ? " [+] " : " [-] ";
    std::string check_status = (field.GetValue() == se::id::IdCheckStatus_Passed) ? "passed" :
        ((field.GetValue() == se::id::IdCheckStatus_Failed) ? "failed" : "undefined");
    printf("    %-25s%s (%4.3lf) %s\n",
        field.GetName(),
        is_accepted.c_str(),
        field.GetBaseFieldInfo().GetConfidence(),
        check_status.c_str());
    if (check_status == "undefined" && field.GetBaseFieldInfo().HasAttribute("reason"))
      printf("%-43sreason: %s\n", "", field.GetBaseFieldInfo().GetAttribute("reason"));
  }

  printf("Result terminal:             %s\n",
      result.GetIsTerminal() ? " [+] " : " [-] ");
  printf("\n");
  printf("\n");
}

int main(int argc, char **argv) {
#ifdef _MSC_VER
  SetConsoleOutputCP(65001);
#endif // _MSC_VER

  // 1st argument - path to the image to be recognized
  // 2nd argument - path to the configuration bundle
  // 3rd argument - document types mask, "*" by default
  if (argc != 3 && argc != 4) {
    printf("Version %s. Usage: %s <image_path> <bundle_se_path> "
           "[document_types]\n",
           se::id::IdEngine::GetVersion(), argv[0]);
    return -1;
  }

  const std::string image_path = argv[1];
  const std::string config_path = argv[2];
  if (image_path != "list") {
    printf("Smart ID Engine version: %s\n", se::id::IdEngine::GetVersion());
    printf("image_path = %s\n", image_path.c_str());
    printf("config_path = %s\n", config_path.c_str());
    printf("\n");
  }

  try {
    // Creating the recognition engine object - initializes all internal
    //     configuration structure. Second parameter to the ctor is the
    //     lazy initialization flag (true by default). If set to false,
    //     all internal objects will be initialized here, instead of
    //     waiting until some session needs them.
    std::unique_ptr<se::id::IdEngine> engine(
        se::id::IdEngine::Create(config_path.c_str(), true));

    // Before creating the session we need to have a session settings
    //     object. Such object can be created only by acquiring a
    //     default session settings object from the configured engine.
    std::unique_ptr<se::id::IdFileAnalysisSessionSettings> settings(
          engine->CreateFileAnalysisSessionSettings());

    if (image_path != "list") {
      // Creating a session object - a main handle for performing recognition.
      std::unique_ptr<se::id::IdFileAnalysisSession> session(
          engine->SpawnFileAnalysisSession(*settings, ${put_yor_personalized_signature_from_doc_README.html}));

      // Creating an image object which will be used as an input for the session
      std::unique_ptr<se::common::Image> image(
          se::common::Image::FromFile(image_path.c_str()));

      // Performing the recognition and obtaining the recognition result
      const se::id::IdResult& result = session->Process(*image);

      // Printing the contents of the recognition result
      // Passing session settings object only to output document info
      OutputRecognitionResult(result, *settings);
    }
  } catch (const se::common::BaseException& e) {
    printf("Exception thrown: %s\n", e.what());
    return -1;
  }

  return 0;
}
