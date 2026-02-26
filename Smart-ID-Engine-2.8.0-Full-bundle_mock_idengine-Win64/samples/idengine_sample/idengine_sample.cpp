/**
  Copyright (c) 2016-2026, Smart Engines Service LLC
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

// Implementing optional feedback reporter - in this way you can set up
//     callbacks for receiving the information before frame is processed
// This is not needed unless you wish to visualize some feedback info
//     during the recognition process.
class OptionalFeedback : public se::id::IdFeedback {
public:
  virtual ~OptionalFeedback() override = default;

public:
  virtual void FeedbackReceived(
      const se::id::IdFeedbackContainer& /*feedback_container*/) override {
    printf("[Feedback called]: Feedback received\n");
  }

  virtual void TemplateDetectionResultReceived(
      const se::id::IdTemplateDetectionResult& result) override {
    printf("[Feedback called]: Template detection result received (%s)\n",
           result.GetTemplateName());
  }

  virtual void TemplateSegmentationResultReceived(
      const se::id::IdTemplateSegmentationResult& /*result*/) override {
    printf("[Feedback called]: Template segmentation result received\n");
  }

  virtual void ResultReceived(const se::id::IdResult& result) override {
    printf("[Feedback called]: Result received (%s)\n",
           result.GetDocumentType());
  }

  virtual void SessionEnded() override {
     printf("[Feedback called]: Session ended\n");
  }
};

// Here we simply output the recognized fields
void OutputRecognitionResult(const se::id::IdResult& result, 
                             const se::id::IdSessionSettings& session_settings) {
  printf("Document type: %s\n", result.GetDocumentType());
  if (strlen(result.GetDocumentType()) != 0){
    const se::id::IdDocumentInfo& doc_info = 
        session_settings.GetDocumentInfo(result.GetDocumentType());
    printf("    Description: %s\n", doc_info.GetDocumentDescription());
    if (doc_info.GetPradoLinks().GetStringsCount() > 0) {
      printf("    PRADO links:\n");
      for (auto it = doc_info.GetPradoLinks().StringsBegin(); 
          it != doc_info.GetPradoLinks().StringsEnd();
          ++it) {
        printf("        %s\n", it.GetValue());
      }
    }
  }

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
    std::string check_status = (field.GetValue() == se::id::IdCheckStatus_Passed) ? "passed" :
        ((field.GetValue() == se::id::IdCheckStatus_Failed) ? "failed" : "undefined");
    printf("    %-25s  %s\n",
        field.GetName(),
        check_status.c_str());
    if (check_status == "undefined" && field.GetBaseFieldInfo().HasAttribute("reason"))
      printf("%-36sreason: %s\n", "", field.GetBaseFieldInfo().GetAttribute("reason"));
  }
  
  printf("Result terminal:             %s\n",
      result.GetIsTerminal() ? " [+] " : " [-] ");
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
  const std::string document_types = (argc >= 4 ? argv[3] : "*");
  if (image_path != "list") {
    printf("Smart ID Engine version: %s\n", se::id::IdEngine::GetVersion());
    printf("image_path = %s\n", image_path.c_str());
    printf("config_path = %s\n", config_path.c_str());
    printf("document_types = %s\n", document_types.c_str());
    printf("\n");
  }
  OptionalFeedback optional_feedback;

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
    std::unique_ptr<se::id::IdSessionSettings> settings(
          engine->CreateSessionSettings());

    // Print all supported documents
    printf("Supported modes:\n");
    for (auto modeIterator = settings->SupportedModesBegin(); 
          !modeIterator.Equals(settings->SupportedModesEnd());
          modeIterator.Advance()) {
      std::string modeName = modeIterator.GetValue();
      printf("Mode name is: %s\n", modeName.c_str());
      settings->SetCurrentMode(modeName.c_str());

      for (auto engineIterator = settings->InternalEngineNamesBegin(); 
          !engineIterator.Equals(settings->InternalEngineNamesEnd());
          engineIterator.Advance()) {
        std::string engineName = engineIterator.GetValue();
        printf("  Engine name is: %s\n", engineName.c_str());

        for (auto docNameIterator = settings->SupportedDocumentTypesBegin(engineName.c_str()); 
            !docNameIterator.Equals(settings->SupportedDocumentTypesEnd(engineName.c_str()));
            docNameIterator.Advance()) {
              std::string docName = docNameIterator.GetValue();
              printf("    Document name is: %s\n", docName.c_str());
          }
      }
    }
    if (image_path != "list") {
      settings->SetCurrentMode("default");

      // For starting the session we need to set up the mask of document types
      //     which will be recognized.
      settings->AddEnabledDocumentTypes(document_types.c_str());

      // Creating a session object - a main handle for performing recognition.
      std::unique_ptr<se::id::IdSession> session(
          engine->SpawnSession(*settings, ${put_yor_personalized_signature_from_doc_README.html}, &optional_feedback));

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
