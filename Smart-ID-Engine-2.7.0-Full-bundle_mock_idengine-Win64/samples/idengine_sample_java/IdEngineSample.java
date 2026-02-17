/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

import com.smartengines.id.*;

import java.util.Objects;

import com.smartengines.common.*;

public class IdEngineSample {

  static {
    System.loadLibrary("jniidengine");
  }

public static class OptionalFeedback extends IdFeedback {

    public void FeedbackReceived(IdFeedbackContainer feedback_container) {
      System.out.printf("[Feedback called]: Feedback received\n");
      System.out.flush();
    }

    public void TemplateDetectionResultReceived(IdTemplateDetectionResult result) {
      System.out.printf("[Feedback called]: Template detection result received (%s)\n",
            result.GetTemplateName());
      System.out.flush();
    }

    public void TemplateSegmentationResultReceived(IdTemplateSegmentationResult result) {
      System.out.printf("[Feedback called]: Template segmentation result received\n");
      System.out.flush();
    }

    public void ResultReceived(IdResult result) {
      System.out.printf("[Feedback called]: Result received (%s)\n", result.GetDocumentType());
      System.out.flush();
    }

    public void SessionEnded() {
      System.out.printf("[Optional callback called]: Session ended\n");
      System.out.flush();
    }
  }

  public static OptionalFeedback optional_feedback = new OptionalFeedback();

  // Here we simply output the recognized fields
  public static void OutputRecognitionResult(IdResult result, 
                                             IdSessionSettings session_settings) {
    System.out.printf("Document type: %s\n", result.GetDocumentType());

    if (!result.GetDocumentType().isEmpty()) {
      IdDocumentInfo doc_info =
          session_settings.GetDocumentInfo(result.GetDocumentType());
      System.out.printf("    Description: %s\n", doc_info.GetDocumentDescription());
      if (doc_info.GetPradoLinks().GetStringsCount() > 0) {
        System.out.printf("    PRADO links:\n");
        for (StringsSetIterator it = doc_info.GetPradoLinks().StringsBegin();
             !it.Equals(doc_info.GetPradoLinks().StringsEnd());
             it.Advance()) {
          System.out.printf("        %s\n", it.GetValue());
        }
      }
    }

    for (int i = 0; i < result.GetTemplateDetectionResultsCount(); i++) {
       System.out.printf("Template detection result %d:\n", i);
       IdTemplateDetectionResult tpl_res = result.GetTemplateDetectionResult(i);
       System.out.printf("    Template Name: %s\n", tpl_res.GetTemplateName());
       System.out.printf("    Quad = { (%f, %f), (%f, %f), (%f, %f), (%f, %f) }\n",
          tpl_res.GetQuadrangle().GetPoint(0).getX(), 
          tpl_res.GetQuadrangle().GetPoint(0).getY(),
          tpl_res.GetQuadrangle().GetPoint(1).getX(), 
          tpl_res.GetQuadrangle().GetPoint(1).getY(),
          tpl_res.GetQuadrangle().GetPoint(2).getX(), 
          tpl_res.GetQuadrangle().GetPoint(2).getY(),
          tpl_res.GetQuadrangle().GetPoint(3).getX(), 
          tpl_res.GetQuadrangle().GetPoint(3).getY());
    }

    System.out.printf("Text fields:\n");
    for (IdTextFieldsMapIterator it = result.TextFieldsBegin(); 
         !it.Equals(result.TextFieldsEnd());
         it.Advance()) {
      IdTextField field = it.GetValue();
      String is_accepted =
          field.GetBaseFieldInfo().GetIsAccepted() ? " [+] " : " [-] ";
      System.out.printf("    %-25s%s (%4.3f) %s\n",
          field.GetName(),
          is_accepted,
          field.GetBaseFieldInfo().GetConfidence(),
          field.GetValue().GetFirstString().GetCStr());
    }

    System.out.printf("Image fields:\n");
    for (IdImageFieldsMapIterator it = result.ImageFieldsBegin(); 
         !it.Equals(result.ImageFieldsEnd());
         it.Advance()) {
      IdImageField field = it.GetValue();
      String is_accepted =
          field.GetBaseFieldInfo().GetIsAccepted() ? " [+] " : " [-] ";
      System.out.printf("    %-25s%s (%4.3f) W: %d H: %d\n",
          field.GetName(),
          is_accepted,
          field.GetBaseFieldInfo().GetConfidence(),
          field.GetValue().GetWidth(),
          field.GetValue().GetHeight());
    }

    System.out.printf("Forensic check fields:\n");
    for (IdCheckFieldsMapIterator it = result.ForensicCheckFieldsBegin(); 
         !it.Equals(result.ForensicCheckFieldsEnd());
         it.Advance()) {
      IdCheckField field = it.GetValue();
      String is_accepted =
          field.GetBaseFieldInfo().GetIsAccepted() ? " [+] " : " [-] ";

      String value = "undefined";
      if (field.GetValue() == IdCheckStatus.IdCheckStatus_Passed) {
        value = "passed";
      } else if (field.GetValue() == IdCheckStatus.IdCheckStatus_Failed) {
        value = "failed";
      }
      System.out.printf("    %-25s%s (%4.3f) %s\n",
          field.GetName(),
          is_accepted,
          field.GetBaseFieldInfo().GetConfidence(),
          value);
    }

    System.out.printf("Result terminal: %s\n", 
        result.GetIsTerminal() ? " [+] " : " [-] ");
    System.out.flush();
  }

  public static void main(String[] args) {

    // 1st argument - path to the image to be recognized
    // 2nd argument - path to the configuration bundle
    // 3rd argument - document types mask, "*" by default
    if (args.length != 2 && args.length != 3) {
      System.out.printf("Version %s. Usage: IdEngineSample" + 
          " <image_path> <bundle_se_path> [document_types]\n", 
          IdEngine.GetVersion());
      System.exit(-1);
    }

    String image_path = args[0];
    String config_path = args[1];
    String document_types = args.length >= 3 ? args[2] : "*";
    if (!Objects.equals(image_path, "list")) {
      System.out.printf("Smart ID Engine version: %s\n", IdEngine.GetVersion());
      System.out.printf("image_path = %s\n", image_path);
      System.out.printf("config_path = %s\n", config_path);
      System.out.printf("document_types = %s\n", document_types);
      System.out.println();
      System.out.flush();
    }
    try {
      // Creating the recognition engine object - initializes all internal
      //     configuration structure. Second parameter to the ctor is the
      //     lazy initialization flag (true by default). If set to false,
      //     all internal objects will be initialized here, instead of
      //     waiting until some session needs them.
      IdEngine engine = IdEngine.Create(config_path, true);

      // Before creating the session we need to have a session settings
      //     object. Such object can be created only by acquiring a
      //     default session settings object from the configured engine.
      IdSessionSettings settings = engine.CreateSessionSettings();

      //Print all supported documents
      System.out.printf("Supported modes:\n");
      for (StringsSetIterator modeIterator = settings.SupportedModesBegin(); 
          !modeIterator.Equals(settings.SupportedModesEnd());
          modeIterator.Advance()) {
        String modeName = modeIterator.GetValue();
        System.out.printf("Mode name is: " + modeName + "\n");
        settings.SetCurrentMode(modeName);
        for (StringsSetIterator engineIterator = settings.InternalEngineNamesBegin(); 
            !engineIterator.Equals(settings.InternalEngineNamesEnd());
            engineIterator.Advance()) {
          String engineName = engineIterator.GetValue();
          System.out.printf("  Engine name is: " + engineName + "\n");
          for (StringsSetIterator docNameIterator = settings.SupportedDocumentTypesBegin(engineName); 
            !docNameIterator.Equals(settings.SupportedDocumentTypesEnd(engineName));
            docNameIterator.Advance()) {
              String docName = docNameIterator.GetValue();
              System.out.printf("    Document name is: " + docName + "\n");
          }
        }
      }
      if (!Objects.equals(image_path, "list")) {
        settings.SetCurrentMode("default");

        // For starting the session we need to set up the mask of document types
        //     which will be recognized.
        settings.AddEnabledDocumentTypes(document_types);

        // Creating a session object - a main handle for performing recognition.
        IdSession session = engine.SpawnSession(settings, ${put_yor_personalized_signature_from_doc_README.html}, optional_feedback); 

        // Creating an image object which will be used as an input for the session
        Image image = Image.FromFile(image_path);

        // Performing the recognition and obtaining the recognition result
        IdResult result = session.Process(image);
        
        // Printing the contents of the recognition result
        // Passing session settings object only to output document info
        OutputRecognitionResult(result, settings);

        // After the objects are no longer needed it is important to use the 
        // .delete() methods on them. It will force the associated native heap memory 
        // to be deallocated. Note that Java's GC does not care too much about the 
        // native heap and thus can delay the actual freeing of the associated memory, 
        // thus it is better to manage the internal native heap deallocation manually
        image.delete();
        result.delete();
        session.delete();
        settings.delete();
        engine.delete();
      }
    } catch (java.lang.RuntimeException e) {
      System.out.printf("Exception caught: %s\n", e.toString());
      System.out.flush();
      System.exit(-1);
    }
  }
}