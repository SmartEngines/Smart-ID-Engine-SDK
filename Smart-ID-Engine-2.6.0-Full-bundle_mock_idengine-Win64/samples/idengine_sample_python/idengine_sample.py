#!/usr/bin/python
#  Copyright (c) 2016-2025, Smart Engines Service LLC
#  All rights reserved.

import sys
import os

sys.path.append(os.path.join(sys.path[0], '../../bindings/python/'))
sys.path.append(os.path.join(sys.path[0],'../../bin/'))

import pyidengine

#  Here we simply output the recognized fields
def OutputRecognitionResult(recog_result,session_settings):
    doc_type = recog_result.GetDocumentType()
    print('Document type: {}'.format(doc_type))
    if doc_type != "":
      doc_info = session_settings.GetDocumentInfo(doc_type)
      print('    Description: {}'.format(doc_info.GetDocumentDescription()))
      if doc_info.GetPradoLinks().GetStringsCount() > 0:
          print('    PRADO links:')
          prado_it = doc_info.GetPradoLinks().StringsBegin()
          while (prado_it != doc_info.GetPradoLinks().StringsEnd()):
              print('        {}'.format(prado_it.GetValue()))
              prado_it.Advance()

    for i in range(recog_result.GetTemplateDetectionResultsCount()):
      print("Template detection result {}".format(i))
      tpl_res = recog_result.GetTemplateDetectionResult(i)
      print('    Template Name: {}'.format(tpl_res.GetTemplateName()))
      print('    Quad = ({0}, {1}), ({2}, {3}), ({4}, {5}), ({6}, {7})'.format(
        tpl_res.GetQuadrangle().GetPoint(0).x, 
        tpl_res.GetQuadrangle().GetPoint(0).y,
        tpl_res.GetQuadrangle().GetPoint(1).x, 
        tpl_res.GetQuadrangle().GetPoint(1).y,
        tpl_res.GetQuadrangle().GetPoint(2).x, 
        tpl_res.GetQuadrangle().GetPoint(2).y,
        tpl_res.GetQuadrangle().GetPoint(3).x, 
        tpl_res.GetQuadrangle().GetPoint(3).y)
        )
      if tpl_res.GetAttributesCount() > 0:
        print('    Attributes:\n')
        f_it = tpl_res.AttributesBegin()
        while(f_it != tpl_res.AttributesEnd()):
          print('        {0}: {1}\n'.format(f_it.GetKey(), f_it.GetValue()))
          f_it.Advance()

    print('    Text fields ({} in total):'.format( recog_result.GetTextFieldsCount()))
    f_it = recog_result.TextFieldsBegin()
    while(f_it != recog_result.TextFieldsEnd()):
      print('        {0} : {1}'.format( f_it.GetKey(),
             f_it.GetValue().GetValue().GetFirstString().GetCStr()))
      f_it.Advance()
    print('    Image fields ({} in total):'.format( recog_result.GetImageFieldsCount()))

    print('    Forensic fields ({} in total):'.format( recog_result.GetForensicCheckFieldsCount()))
    f_it = recog_result.ForensicCheckFieldsBegin()
    while(f_it != recog_result.ForensicCheckFieldsEnd()):
      status = 'undefined'
      if (f_it.GetValue().GetValue() == pyidengine.IdCheckStatus_Passed):
        status = 'passed'
      elif (f_it.GetValue().GetValue() == pyidengine.IdCheckStatus_Failed):
        status = 'failed'
      print('        {} : {}'.format( f_it.GetKey(), status))
      f_it.Advance()

    

def main():
  if len(sys.argv) != 4 and len(sys.argv) !=3:
    print('Version {}. Usage: '
            '{} <image_path> <bundle_se_path> [document_types]'.format(
            pyidengine.IdEngine.GetVersion(), sys.argv[0]))
    sys.exit(-1)

  image_path = sys.argv[1]
  config_path = sys.argv[2]
  document_types = sys.argv[3] if len(sys.argv) == 4 else "*"

  print('Smart ID Engine version {}'.format(
         pyidengine.IdEngine.GetVersion()))
  print('image_path = {}'.format( image_path))
  print('config_path = {}'.format( config_path))
  print('document_types = {}'.format( document_types))
  print('')

  try:
    # Creating the recognition engine object - initializes all internal
    #     configuration structure. Second parameter to the factory method
    #     is the lazy initialization flag (true by default). If set to
    #     false, all internal objects will be initialized here, instead of
    #     waiting until some session needs them.
    print(config_path)
    engine = pyidengine.IdEngine.Create(config_path, True)

    # Before creating the session we need to have a session settings
    #     object. Such object can be created only by acquiring a
    #     default session settings object from the configured engine.
    session_settings = engine.CreateSessionSettings()

    # Print all supported documents
    print("Supported modes:")
    mode_iterator = session_settings.SupportedModesBegin()
    while (mode_iterator != session_settings.SupportedModesEnd()):
      mode_name = mode_iterator.GetValue()
      mode_iterator.Advance()
      print("Mode name is: " + mode_name)
      session_settings.SetCurrentMode(mode_name)
      engine_iterator = session_settings.InternalEngineNamesBegin()
      while (engine_iterator != session_settings.InternalEngineNamesEnd()):
        engine_name = engine_iterator.GetValue()
        engine_iterator.Advance()
        print("  Engine name is: " + engine_name)
        doc_name_iterator = session_settings.SupportedDocumentTypesBegin(engine_name)
        while (doc_name_iterator != session_settings.SupportedDocumentTypesEnd(engine_name)):
          doc_name = doc_name_iterator.GetValue()
          doc_name_iterator.Advance()
          print("    Document name is: " + doc_name)
    if image_path != "list":
      session_settings.SetCurrentMode("default")

      # For starting the session we need to set up the mask of document types
      #     which will be recognized.
      session_settings.AddEnabledDocumentTypes(document_types)

      # Creating a session object - a main handle for performing recognition.
      session = engine.SpawnSession(session_settings, @put_yor_personalized_signature_from_doc_README.html@)

      # Creating image objects which will be used as an input for the session
      image = None
      try:
        image = pyidengine.Image.FromFile(image_path)
        session.Process(image)

        # Obtaining the recognition result
        result = session.GetCurrentResult()
        OutputRecognitionResult(result, session_settings)

      except BaseException as e: 
        print(e)
        print('Caught exception')
        return 0
    
  except BaseException as e: 
    print('Exception thrown: {}'.format(e))
    return -1

  return 0


if __name__ == '__main__':
    main()