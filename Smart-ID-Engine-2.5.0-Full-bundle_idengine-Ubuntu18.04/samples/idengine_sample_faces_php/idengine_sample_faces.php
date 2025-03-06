<?php
//  Copyright (c) 2016-2024, Smart Engines Service LLC
//  All rights reserved.
function main($argc, $argv) {

  //print_r($argv);

  if ($argc != 4) {
    printf("Usage: idengine_sample_faces.php <image_path_lvalue> <image_path_rvalue> <bundle_se_path>\n");
    exit(-1);
  }

  $image_path_lvalue = $argv[1];
  $image_path_rvalue = $argv[2];
  $config_path = $argv[3];

  try {
    $engine = IdEngine::Create($config_path);
    $session_settings = $engine->CreateFaceSessionSettings();

    // Creating a session object - a main handle for performing recognition->
    $session = $engine->SpawnFaceSession($session_settings, "INSERT_SIGNATURE_FROM_README.html\");


    // Creating image objects which will be used for face matching
	$image_lvalue = Image::FromFile($image_path_lvalue);
	$image_rvalue = Image::FromFile($image_path_rvalue);
	// Performing face matching between two images
	$face_similarity_result = $session->GetSimilarity($image_lvalue, $image_rvalue);
	$score = $face_similarity_result->GetSimilarityEstimation();

	print_r("Face similarity: " . round($score, 3) . " \n");

  } catch (Exception $e) {
    printf("Exception caught: %s\n", $e->getMessage());
  }
}

main($argc, $argv);

?>
