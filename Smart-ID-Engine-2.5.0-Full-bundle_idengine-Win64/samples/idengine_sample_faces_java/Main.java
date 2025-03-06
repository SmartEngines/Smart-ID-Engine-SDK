/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

import com.smartengines.id.*;
import com.smartengines.common.*;

public class Main {

  static {
    System.loadLibrary("jniidengine");
  }
  
  public static void main(String[] args) {

    // 1st argument - path to the first image for face comparison
    // 2nd argument - path to the second image for face comparison
    // 3rd argument - path to configuration bundle
    if (args.length != 3) {
      System.out.printf("Version %s. Usage: idengine_sample_faces_java" + 
          " <image_path_lvalue> <image_path_rvalue> <bundle_se_path>\n", 
          IdEngine.GetVersion());
      System.exit(-1);
    }

    String image_path_lvalue = args[0];
    String image_path_rvalue = args[1];
    String config_path = args[2];
    
    System.out.printf("Smart ID Engine version: %s\n", IdEngine.GetVersion());
    System.out.printf("image_path_lvalue = %s\n", image_path_lvalue);
    System.out.printf("image_path_rvalue = %s\n", image_path_rvalue);
    System.out.printf("config_path = %s\n", config_path);
    System.out.println();
    System.out.flush();

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
      IdFaceSessionSettings settings = engine.CreateFaceSessionSettings();

      // Creating a face matching session object - a main handle for performing
      //     face matching. Note the second parameter as nullptr, this parameter
      //     is reserved for SDK signature verification in future versions.  
      IdFaceSession session = engine.SpawnFaceSession(settings, ${put_yor_personalized_signature_from_doc_README.html}); 

      // Creating image objects which will be used for face matching
      Image image_lvalue = Image.FromFile(image_path_lvalue);
      Image image_rvalue = Image.FromFile(image_path_rvalue);

      // Performing face matching between two images
      IdFaceSimilarityResult face_similarity_result = 
          session.GetSimilarity(image_lvalue, image_rvalue);
      
      System.out.printf("Face similarity: %f\n",
           face_similarity_result.GetSimilarityEstimation());
      System.out.flush();

      // After the objects are no longer needed it is important to use the 
      // .delete() methods on them. It will force the associated native heap memory 
      // to be deallocated. Note that Java's GC does not care too much about the 
      // native heap and thus can delay the actual freeing of the associated memory, 
      // thus it is better to manage the internal native heap deallocation manually
      face_similarity_result.delete();
      image_lvalue.delete();
      image_rvalue.delete();
      session.delete();
      settings.delete();
      engine.delete();

    } catch (java.lang.RuntimeException e) {
      System.out.printf("Exception caught: %s\n", e.toString());
      System.out.flush();
      System.exit(-1);
    }
  }
}
