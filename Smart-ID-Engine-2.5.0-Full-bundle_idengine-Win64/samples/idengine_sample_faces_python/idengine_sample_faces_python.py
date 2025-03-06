#!/usr/bin/python
#  Copyright (c) 2016-2024, Smart Engines Service LLC
#  All rights reserved.

import sys
import os

sys.path.append(os.path.join(sys.path[0], '../../bindings/python/'))
sys.path.append(os.path.join(sys.path[0],'../../bin/'))

import pyidengine

def main():
  if len(sys.argv) != 4:
    print('Version {}. Usage: '
            '{} <image_path_lvalue> <image_path_rvalue> <bundle_se_path>'.format(
            pyidengine.IdEngine.GetVersion(), sys.argv[0]))
    sys.exit(-1)

  image_path, image_two_path, config_path = sys.argv[1:]

  print('Smart ID Engine version {}'.format(
         pyidengine.IdEngine.GetVersion()))
  print('image_path = {}'.format( image_path))
  print('image2_path = {}'.format( image_two_path))
  print('config_path = {}'.format( config_path))
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
    session_settings = engine.CreateFaceSessionSettings()

    # Creating a session object - a main handle for performing recognition.
    session = engine.SpawnFaceSession(session_settings, @put_yor_personalized_signature_from_doc_README.html@)

    # Creating default image processing settings - needs to be created before
    #     passing an image for processing. This specifies how the session
    #     should process the updated source.
    # Creating image objects which will be used as an input for the session
    image = None
    image_two = None
    try:
      image = pyidengine.Image.FromFile(image_path)
      image_two = pyidengine.Image.FromFile(image_two_path)
    except BaseException as e: 
      print(e.ExceptionName() + ': ' + e.what())
      print('Caught exception')
      return 0
    
    # Obtaining the recognition result
    result = session.GetSimilarity(image, image_two)

    # Printing the contents of the recognition result
    print('similiar like: {}'.format(result.GetSimilarityEstimation()))

  except BaseException as e: 
    print('Exception thrown: {}'.format( e.ExceptionName() + ': ' + e.what()))
    return -1
  

  return 0


if __name__ == '__main__':
    main()
