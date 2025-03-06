//  Copyright (c) 2016-2024, Smart Engines Service LLC
//  All rights reserved.

using System;
using System.Text;

using se.id;
using se.common;

class SmartIdSampleCs
{
  static void OutputIdResult(IdResult recog_result)
  {
    Console.OutputEncoding = System.Text.Encoding.UTF8;
    Console.WriteLine("Document type: {0}", recog_result.GetDocumentType());

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
      Console.WriteLine("Usage: idengine_sample_faces_cs <image_path_lvalue> <image_path_rvalue> <bundle_se_path>");
      Console.WriteLine(Environment.NewLine);
      return;
    }

    String image_path = args[0];
    String image2_path = args[1];
    String config_path = args[2];

    Console.WriteLine("image_path = {0}", image_path);
    Console.WriteLine("image2_path = {0}", image2_path);
    Console.WriteLine("bundle_path = {0}", config_path);

    try
    {
      IdEngine engine = IdEngine.Create(config_path);
      IdFaceSessionSettings settings = engine.CreateFaceSessionSettings();
      IdFaceSession session = engine.SpawnFaceSession(settings, ${put_yor_personalized_signature_from_doc_README.html});
      Image image;
      Image image2;
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
#else
      image = Image.FromFile(image_path);
      image2 = Image.FromFile(image2_path);
#endif
      IdFaceSimilarityResult face_similarity_result =
        session.GetSimilarity(image, image2);

      Console.WriteLine("similarity: {0}", face_similarity_result.GetSimilarityEstimation());
      // this is important: GC works differently with native-heap objects
      session.Dispose();
      engine.Dispose();
    }
    catch (Exception e)
    {
      Console.WriteLine("Exception caught: {0}", e);
    }

    Console.WriteLine("Processing ended");
  }

}

