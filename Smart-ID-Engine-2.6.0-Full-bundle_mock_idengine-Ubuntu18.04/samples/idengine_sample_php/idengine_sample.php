<?php
//  Copyright (c) 2016-2025, Smart Engines Service LLC
//  All rights reserved.
 
// For SWIG 3.0.12
// require(realpath(dirname(__FILE__)).DIRECTORY_SEPARATOR."../../bindings/php/phpidengine.php");

// Here we simply output the recognized fields
function OutputRecognitionResult($recog_result, $session_settings) {
  printf("Document type: %s\n",$recog_result->GetDocumentType());
  if (!empty($recog_result->GetDocumentType())){
    $doc_info =$session_settings->GetDocumentInfo($recog_result->GetDocumentType());
    printf("    Description: %s\n",$doc_info->GetDocumentDescription());
    if ($doc_info->GetPradoLinks()->GetStringsCount() > 0) {
      printf("    PRADO links:\n");
      for ($it =$doc_info->GetPradoLinks()->StringsBegin(); 
        !$it->Equals($doc_info->GetPradoLinks()->StringsEnd());
        $it->Advance()) {
          printf("        %s\n",$it->GetValue());
        }
    }
  }

for ($i = 0; $i < $recog_result->GetTemplateDetectionResultsCount(); $i++) {
  printf("Template detection result %d:\n", $i);
  $tpl_res = $recog_result->GetTemplateDetectionResult($i);
  printf("    Template Name: %s\n", $tpl_res->GetTemplateName());
  printf("    Quad = { (%lf, %lf), (%lf, %lf), (%lf, %lf), (%lf, %lf) }\n",
  $tpl_res->GetQuadrangle()->GetPoint(0)->x, $tpl_res->GetQuadrangle()->GetPoint(0)->y,
  $tpl_res->GetQuadrangle()->GetPoint(1)->x, $tpl_res->GetQuadrangle()->GetPoint(1)->y,
  $tpl_res->GetQuadrangle()->GetPoint(2)->x, $tpl_res->GetQuadrangle()->GetPoint(2)->y,
  $tpl_res->GetQuadrangle()->GetPoint(3)->x, $tpl_res->GetQuadrangle()->GetPoint(3)->y);
  if ($tpl_res->GetAttributesCount() > 0) {
    printf("    Attributes:\n");
    for ($it = $tpl_res->AttributesBegin(); !$it->Equals($tpl_res->AttributesEnd()); $it->Advance()) {
      printf("        %s: %s\n",$it->GetKey(), $it->GetValue());
    }
  }
}

printf("Text fields:\n");
for ($it =$recog_result->TextFieldsBegin(); !$it->Equals($recog_result->TextFieldsEnd()); $it->Advance()) {
  $field =$it->GetValue();
  $is_accepted = $field->GetBaseFieldInfo()->GetIsAccepted() ? " [+] " : " [-] ";
  printf("    %-25s%s (%4.3lf) %s\n",
    $field->GetName(),
    $is_accepted,
    $field->GetBaseFieldInfo()->GetConfidence(),
    $field->GetValue()->GetFirstString()->GetCStr());
}

printf("Image fields:\n");
for ($it =$recog_result->ImageFieldsBegin(); !$it->Equals($recog_result->ImageFieldsEnd()); $it->Advance()) {
  $field =$it->GetValue();
  $is_accepted = $field->GetBaseFieldInfo()->GetIsAccepted() ? " [+] " : " [-] ";
  printf("    %-25s%s (%4.3lf) W: %d H: %d\n",
    $field->GetName(),
    $is_accepted,
    $field->GetBaseFieldInfo()->GetConfidence(),
    $field->GetValue()->GetWidth(),
    $field->GetValue()->GetHeight());
}

printf("Forensic check fields:\n");
for ($it =$recog_result->ForensicCheckFieldsBegin(); !$it->Equals($recog_result->ForensicCheckFieldsEnd()); $it->Advance()) {
  $field =$it->GetValue();
  $is_accepted = $field->GetBaseFieldInfo()->GetIsAccepted() ? " [+] " : " [-] ";
  $check_status = ($field->GetValue() == IdCheckStatus_Passed) ? "passed" :
  (($field->GetValue() == IdCheckStatus_Failed) ? "failed" : "undefined");
  printf("    %-25s%s (%4.3lf) %s\n",
    $field->GetName(),
    $is_accepted,
    $field->GetBaseFieldInfo()->GetConfidence(),
    $check_status);
  if ($check_status == "undefined" && $field->GetBaseFieldInfo()->HasAttribute("reason"))
    printf("%-43sreason: %s\n", "", $field->GetBaseFieldInfo()->GetAttribute("reason"));
}

printf("Result terminal:             %s\n",
  $recog_result->GetIsTerminal() ? " [+] " : " [-] ");
}

function main($argc, $argv) {
  if ($argc != 4 and $argc != 3) {
    printf("Usage: %s %s <image_path> <bundle_se_path> <document_type>\n", PHP_BINARY, $argv[0]);
    exit(-1);
  }

  $image_path = $argv[1];
  $config_path = $argv[2];
  $document_types = ($argc >= 4 ? $argv[3] : "*");
  if ($image_path != "list") {
    printf("Smart ID Engine version: %s\n", IdEngine::GetVersion());
    printf("image_path = %s\n", $image_path);
    printf("config_path = %s\n", $config_path);
    printf("document_types = %s\n", $document_types);
  }

  try {
    $engine = IdEngine::Create($config_path);
    $session_settings = $engine->CreateSessionSettings();

    // Print all supported documents
    printf("Supported modes:\n");
    for ($modeIterator = $session_settings->SupportedModesBegin(); 
          !$modeIterator->Equals($session_settings->SupportedModesEnd());
          $modeIterator->Advance()) {
      $modeName = $modeIterator->GetValue();
      printf("Mode name is: %s\n", $modeName);
      $session_settings->SetCurrentMode($modeName);

      for ($engineIterator = $session_settings->InternalEngineNamesBegin(); 
          !$engineIterator->Equals($session_settings->InternalEngineNamesEnd());
          $engineIterator->Advance()) {
        $engineName = $engineIterator->GetValue();
        printf("  Engine name is: %s\n", $engineName);

        for ($docNameIterator = $session_settings->SupportedDocumentTypesBegin($engineName); 
            !$docNameIterator->Equals($session_settings->SupportedDocumentTypesEnd($engineName));
            $docNameIterator->Advance()) {
              $docName = $docNameIterator->GetValue();
              printf("    Document name is: %s\n", $docName);
          }
      }
    }
    if ($image_path != "list") {
      // For starting the session we need to set up the mask of document types
      //     which will be recognized->
      $session_settings->AddEnabledDocumentTypes($document_types);
      $session_settings->SetCurrentMode("default");

      // Creating a session object - a main handle for performing recognition->
      $session = $engine->SpawnSession($session_settings, @put_yor_personalized_signature_from_doc_README.html@);


      // Creating an image object which will be used as an input for the session
      $image = Image::FromFile($image_path);

      // Performing the recognition and obtaining the recognition result
      $result = $session->Process($image);

      OutputRecognitionResult($result, $session_settings);
    }

  } catch (Exception $e) {
    printf("Exception caught: %s\n", $e->getMessage());
    }
}

main($argc, $argv);

?>
