//  Copyright (c) 2016-2024, Smart Engines Service LLC
//  All rights reserved.

using System;
using System.Text;

using se.id;
using se.common;

class IdEngineSampleCsReporter : IdFeedback
{
  public IdEngineSampleCsReporter() : base()
  {
  }

  public override void FeedbackReceived(IdFeedbackContainer result) {
    Console.WriteLine("[Feedback called]: Feedback received\n");
  }

  public override void TemplateDetectionResultReceived(IdTemplateDetectionResult result) {
    Console.WriteLine("[Template Detection feedback called]: Template detection result received {0}",
           result.GetTemplateName());
  }

  public override void TemplateSegmentationResultReceived(IdTemplateSegmentationResult result) {
    Console.WriteLine("[Template Segmentation feedback called]: Template segmentation result received");
  }

  public override void ResultReceived(IdResult result) {
    Console.WriteLine("[GetDocumentType feedback called]: Result received {0}",
           result.GetDocumentType());
  }

  public override void SessionEnded() {
     Console.WriteLine("[Feedback called]: Session ended");
  }

}

class IdEngineSampleCs
{
  static void OutputIdResult(IdResult recog_result, IdSessionSettings settings)
  {
    Console.OutputEncoding = System.Text.Encoding.UTF8;
    Console.WriteLine("Document type: {0}", recog_result.GetDocumentType());
    if (recog_result.GetDocumentType() != "") {
      IdDocumentInfo doc_info = settings.GetDocumentInfo(recog_result.GetDocumentType());
      Console.WriteLine("Document description: {0}", doc_info.GetDocumentDescription());
      if (doc_info.GetPradoLinks().GetStringsCount() > 0)
      {
          Console.WriteLine("    PRADO links:");
          StringsSetIterator prado_it = doc_info.GetPradoLinks().StringsBegin();
          while (prado_it.Equals(doc_info.GetPradoLinks().StringsEnd()) == false)
          {
              Console.WriteLine("        {0}", prado_it.GetValue());
              prado_it.Advance();
          }
      }
    }

    for(int i=0; i < recog_result.GetTemplateDetectionResultsCount(); ++i) {
      Console.WriteLine("Template detection result {0}\n", i);
      IdTemplateDetectionResult tpl_res = recog_result.GetTemplateDetectionResult(i);
      Console.WriteLine("    Template Name: {0}\n", tpl_res.GetTemplateName());
      Console.WriteLine("    Quad =  ({0}, {1}), ({2}, {3}), ({4}, {5}), ({6}, {7}) \n",
        tpl_res.GetQuadrangle().GetPoint(0).x, 
          tpl_res.GetQuadrangle().GetPoint(0).y,
          tpl_res.GetQuadrangle().GetPoint(1).x, 
          tpl_res.GetQuadrangle().GetPoint(1).y,
          tpl_res.GetQuadrangle().GetPoint(2).x, 
          tpl_res.GetQuadrangle().GetPoint(2).y,
          tpl_res.GetQuadrangle().GetPoint(3).x, 
          tpl_res.GetQuadrangle().GetPoint(3).y);
      if (tpl_res.GetAttributesCount() > 0) {
        Console.WriteLine("    Attributes:\n");
        for (StringsMapIterator it = tpl_res.AttributesBegin(); !it.Equals(tpl_res.AttributesEnd()); it.Advance()) {
          Console.WriteLine("        {0}: {1}\n", it.GetKey(), it.GetValue());
        }
      }
    }
    
    Console.WriteLine("String fields:");
    for (IdTextFieldsMapIterator i = recog_result.TextFieldsBegin(); !i.Equals(recog_result.TextFieldsEnd());i.Advance()) 
    {
      IdTextField field = i.GetValue();
      String field_str = field.GetValue().GetFirstString().GetCStr();

      Console.WriteLine("    {0,-15} {1}",
      field.GetName(),  field_str);
    }
    Console.WriteLine("Image fields:");
   
    for (IdImageFieldsMapIterator i = recog_result.ImageFieldsBegin(); !i.Equals(recog_result.ImageFieldsEnd());i.Advance()) 
    {
      IdImageField field = i.GetValue();

      Console.WriteLine("    {0,-15} {1}",
      field.GetName(), "");
    }

    Console.WriteLine("Forensic check fields:");
    String status = "";
    for (IdCheckFieldsMapIterator i = recog_result.ForensicCheckFieldsBegin(); !i.Equals(recog_result.ForensicCheckFieldsEnd());i.Advance()) 
    {
      IdCheckField field = i.GetValue();
      switch (field.GetValue()) {
	      case IdCheckStatus.IdCheckStatus_Undefined:
		      status = "undefined";
		      break;
	      case IdCheckStatus.IdCheckStatus_Passed:
		      status = "passed";
		      break;
	      case IdCheckStatus.IdCheckStatus_Failed:
		      status = "failed";
		      break;
	      default:
		      status = "unknown";
		      break;
      }
      Console.WriteLine("    {0,-15} {1}", field.GetName(), status); 
    }
 }

  static void Main(string[] args)
  {
    if (args.Length < 2)
    {
      Console.WriteLine("Usage: idengine_sample_cs <image_path> <bundle_se_path> [document.types]");
      Console.WriteLine(Environment.NewLine);
      return;
    }

    String image_path = args[0];
    String config_path = args[1];
    String document_types = args.Length >= 3 ? args[2] : "*";
    if (image_path != "list"){
      Console.WriteLine("image_path = {0}", image_path);
      Console.WriteLine("config_path = {0}", config_path);
      Console.WriteLine("document_types = {0}", document_types);
    }
    try
    {

      IdEngineSampleCsReporter reporter = new IdEngineSampleCsReporter();
      IdEngine engine = IdEngine.Create(config_path);
      IdSessionSettings settings = engine.CreateSessionSettings();

            //Print all supported documents
      Console.WriteLine("Supported modes:\n");
      for (StringsSetIterator modeIterator = settings.SupportedModesBegin(); 
          !modeIterator.Equals(settings.SupportedModesEnd());
          modeIterator.Advance()) {
        String modeName = modeIterator.GetValue();
        Console.WriteLine("Mode name is: {0}\n", modeName);
        settings.SetCurrentMode(modeName);
        for (StringsSetIterator engineIterator = settings.InternalEngineNamesBegin(); 
            !engineIterator.Equals(settings.InternalEngineNamesEnd());
            engineIterator.Advance()) {
          String engineName = engineIterator.GetValue();
          Console.WriteLine("  Engine name is: {0}\n", engineName);
          for (StringsSetIterator docNameIterator = settings.SupportedDocumentTypesBegin(engineName); 
            !docNameIterator.Equals(settings.SupportedDocumentTypesEnd(engineName));
            docNameIterator.Advance()) {
              String docName = docNameIterator.GetValue();
              Console.WriteLine("    Document name is: {0}\n", docName);
          }
        }
      }
      if (image_path != "list") {
        settings.SetCurrentMode("default");

        settings.AddEnabledDocumentTypes(document_types);
        IdSession session = engine.SpawnSession(settings, ${put_yor_personalized_signature_from_doc_README.html}, reporter);
        Image image;
  #if _WINDOWS
  //Fix for implicit encoding conversions in Win. Applies only to filename argument.
  //Treating encoding as Win-1251, while OS thinks it is UTF-8.
  //There is only beta-version of UTF-8 support in Win 10.

        Encoding win1251_encoding = Encoding.GetEncoding("Windows-1251");
        Encoding utf8_encoding = Encoding.GetEncoding("UTF-8");

        string imgname_input = args[0];
        byte[] win1251_as_utf8_input_bytes = utf8_encoding.GetBytes(imgname_input);
        byte[] converted_bytes = Encoding.Convert(win1251_encoding, utf8_encoding, win1251_as_utf8_input_bytes);
        string imgname_converted = System.Text.Encoding.UTF8.GetString(converted_bytes);

        image = Image.FromFileNoThrow(imgname_converted);

        IdResult recog_result = session.Process(image);
  #else
        image = Image.FromFile(image_path);
        IdResult recog_result = session.Process(image);
  #endif
        OutputIdResult(recog_result, settings);

        // this is important: GC works differently with native-heap objects
        recog_result.Dispose();
        session.Dispose();
        engine.Dispose();
      }
    }
    catch (Exception e)
    {
      Console.WriteLine("Exception caught: {0}", e);
    }

    Console.WriteLine("Processing ended");
  }

}

