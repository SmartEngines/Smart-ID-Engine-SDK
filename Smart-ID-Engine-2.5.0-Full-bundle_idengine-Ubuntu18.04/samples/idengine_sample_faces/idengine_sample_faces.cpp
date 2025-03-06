/*
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

int main(int argc, char **argv) {

#ifdef _MSC_VER
  SetConsoleOutputCP(65001);
#endif // _MSC_VER

  // 1st argument - path to the first image for face comparison
  // 2nd argument - path to the second image for face comparison
  // 3rd argument - path to configuration bundle
  if (argc != 4) {
    printf("Version %s. Usage: %s <image_path_lvalue> <image_path_rvalue> "
           "<bundle_se_path>\n",
           se::id::IdEngine::GetVersion(), argv[0]);
    return -1;
  }

  const std::string image_path_lvalue = argv[1];
  const std::string image_path_rvalue = argv[2];
  const std::string config_path = argv[3];

  printf("Smart ID Engine version: %s\n", se::id::IdEngine::GetVersion());
  printf("image_path_lvalue = %s\n", image_path_lvalue.c_str());
  printf("image_path_rvalue = %s\n", image_path_rvalue.c_str());
  printf("config_path = %s\n", config_path.c_str());
  printf("\n");

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
    std::unique_ptr<se::id::IdFaceSessionSettings> settings(
        engine->CreateFaceSessionSettings());

    // Creating a face matching session object - a main handle for performing
    //     face matching. Note the second parameter as nullptr, this parameter
    //     is reserved for SDK signature verification in future versions.
    std::unique_ptr<se::id::IdFaceSession> session(
        engine->SpawnFaceSession(*settings, ${put_yor_personalized_signature_from_doc_README.html}));

    // Creating image objects which will be used for face matching
    std::unique_ptr<se::common::Image> image_lvalue(
        se::common::Image::FromFile(image_path_lvalue.c_str()));
    std::unique_ptr<se::common::Image> image_rvalue(
        se::common::Image::FromFile(image_path_rvalue.c_str()));

    // Performing face matching between two images
    se::id::IdFaceSimilarityResult face_similarity_result =
        session->GetSimilarity(*image_lvalue, *image_rvalue);

    printf("Face similarity: %f\n",
           face_similarity_result.GetSimilarityEstimation());
    session->Reset();
  } catch (const se::common::BaseException& e) {
    printf("Exception thrown: %s\n", e.what());
    return -1;
  }

  return 0;
}

