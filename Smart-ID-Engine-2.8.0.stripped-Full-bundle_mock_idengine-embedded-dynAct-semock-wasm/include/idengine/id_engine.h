/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

/**
 * @file id_engine.h
 * @brief id.engine main engine class declaration
 */

#ifndef IDENGINE_ID_ENGINE_H_INCLUDED
#define IDENGINE_ID_ENGINE_H_INCLUDED

#include <secommon/se_common.h>

#include <idengine/id_session_settings.h>
#include <idengine/id_session.h>

#include <idengine/id_file_analysis_session_settings.h>
#include <idengine/id_file_analysis_session.h>

#include <idengine/id_face_session_settings.h>
#include <idengine/id_face_session.h>

#include <idengine/id_field_processing_session_settings.h>
#include <idengine/id_field_processing_session.h>

#include <idengine/id_video_authentication_callbacks.h>
#include <idengine/id_video_authentication_session_settings.h>
#include <idengine/id_video_authentication_session.h>

#include <idengine/id_feedback.h>
#include <idengine/id_face_feedback.h>

namespace se { namespace id {


/**
 * @brief The main IdEngine class containing all configuration and resources
 *        of the Smart ID Engine product.
 */
class SE_DLL_EXPORT IdEngine {
public:
  /// Default dtor
  virtual ~IdEngine() = default;

  /**
   * @brief Creates a Session Settings object with default recognition settings,
   *        specified in the configuration bundle.
   * @return A newly created IdSessionSettings object. The object is allocated,
   *         the caller is responsible for deleting it.
   */
  virtual IdSessionSettings* CreateSessionSettings() const = 0;

  /**
   * @brief Spawns a new documents recognition session
   * @param settings - a settings object which are used to spawn a session
   * @param signature - a unique caller signature to unlock the internal
   *        library calls (provided with your SDK package)
   * @param feedback_reporter - an optional pointer to the implementation of
   *        feedback callbacks class
   * @return A newly created session (IdSession object). The object is
   *         allocated, the caller is responsible for deleting it.
   */
  virtual IdSession* SpawnSession(
      const IdSessionSettings& settings,
      const char*              signature,
      IdFeedback*              feedback_reporter = nullptr) const = 0;

  /**
   * @brief Creates a File Analysis Session Settings object with default settings,
   *        specified in the configuration bundle.
   * @return A newly created IdSessionSettings object. The object is allocated,
   *         the caller is responsible for deleting it.
   */
  virtual IdFileAnalysisSessionSettings* CreateFileAnalysisSessionSettings() const = 0;

  /**
   * @brief Spawns a new file analysis session
   * @param settings - a settings object which are used to spawn a session
   * @param signature - a unique caller signature to unlock the internal
   *        library calls (provided with your SDK package)
   * @return A newly created session (IdFileAnalysisSession object). The object is
   *         allocated, the caller is responsible for deleting it.
   */
  virtual IdFileAnalysisSession* SpawnFileAnalysisSession(
      const IdFileAnalysisSessionSettings& settings,
      const char*              signature) const = 0;

  /**
   * @brief Creates a Face Session Settings object with default face matching
   *        and processing settings, specified in the configuration bundle.
   * @return A newly created IdFaceSessionSettings object. The object is
   *         allocated, the caller is responsible for deleting it.
   */
  virtual IdFaceSessionSettings* CreateFaceSessionSettings() const = 0;

  /**
   * @brief Spawns a new face matching and processing session
   * @param settings - face matching session settings which are used
   *        to spawn a new session
   * @param signature - a unique caller signature to unlock the internal
   *        library calls (provided with your SDK package)
   * @param feedback_reporter - an optional pointer to the implementation of
   *        face session feedback callbacks class
   * @return A newly created session (IdFaceSession object). The object is
   *         allocated, the caller is responsible for deleting it.
   */
  virtual IdFaceSession* SpawnFaceSession(
      const IdFaceSessionSettings& settings,
      const char*                  signature,
      IdFaceFeedback*              feedback_reporter = nullptr) const = 0;

  /**
   * @brief Process image to check face one shot liveness presentation attacks detections.
   * @param image - an input image
   * @return A newly created IdOslResult object. The object is
   *         allocated, the caller is responsible for deleting it.
   */
  virtual IdOslResult* ProcessOneShotLiveness(const se::common::Image& image) const = 0;

  /**
   * @brief Create a Field Processing Session Settings object with default
   *        field processing settings, specified in the configuration bundle.
   * @return A newly created IdFieldProcessingSessionSettings object. The
   *         object is allocated, the caller is responsible for deleting it.
   */
  virtual IdFieldProcessingSessionSettings* CreateFieldProcessingSessionSettings() const = 0;

  /**
   * @brief Spawns a new field processing session
   * @param settings - field processing session settings which are used to
   *        spawn a new session
   * @param signature - a unique caller signature to unlock the internal
   *        library calls (provided with your SDK package)
   * @return A newly created IdFieldProcessingSession object. The object is
   *         allocated, the caller is responsible for deleting it.
   */
  virtual IdFieldProcessingSession* SpawnFieldProcessingSession(
      const IdFieldProcessingSessionSettings& settings,
      const char*                             signature) const = 0;

/**
   * @brief Create a Video Authentication Session Settings object with default
   *        parameters, specified in the configuration bundle.
   * @return A newly created IdVideoAuthenticationSessionSettings object. The
   *         object is allocated, the caller is responsible for deleting it
   */
  virtual IdVideoAuthenticationSessionSettings*
  CreateVideoAuthenticationSessionSettings() const = 0;

  /**
   * @brief Spawns a new video identification & authentication session
   * @param settings - a settings object which are used to spawn a session
   * @param signature - a unique caller signature to unlock the internal
   *        library calls (provided with your SDK package)
   * @param video_authentication_callbacks - an optional pointer to the
   *        implementation of video authentication callbacks class
   * @param feedback_reporter - an optional pointer to the implementation of
   *        feedback callbacks class
   * @return A newly created session (IdVideoAuthenticationSession object). The
   *         object is allocated, the caller is responsible for deleting it.
   */
  virtual IdVideoAuthenticationSession* SpawnVideoAuthenticationSession(
      const IdVideoAuthenticationSessionSettings& settings,
      const char*                                 signature,
      IdVideoAuthenticationCallbacks*             video_authentication_callbacks = nullptr,
      IdFeedback*                                 feedback_reporter = nullptr,
      IdFaceFeedback*                             face_feedback_reporter = nullptr) const = 0;
  
public:
  /**
   * @brief The factory method for creating the IdEngine object with a
   *        configuration bundle file.
   * @param config_path - filesystem path to a engine configuration bundle
   * @param lazy_configuration - if true, some components of the internal
   *        engine structure will be initialized only when first needed. If
   *        false, all engine structure will be loaded and initialized
   *        immediately. Lazy configuration is enabled by default.
   * @param init_concurrency - allowed concurrent threads while configuring the
   *        engine. 0 means unlimited.
   * @param delayed_initialization - performs a blank configuration, delaying
   *        the internal engines initialization until the corresponding
   *        SpawnSession method is called
   * @return A newly created IdEngine object. The object is allocated,
   *         the caller is responsible for deleting it.
   */
  static IdEngine* Create(const char* config_path,
                          bool        lazy_configuration = true,
                          int         init_concurrency = 0,
                          bool        delayed_initialization = false);

  /**
   * @brief The factory method for creating the IdEngine object with a
   *        configuration bundle buffer.
   * @param config_data - pointer to the configuration bundle file buffer.
   * @param config_data_length - size of the configuration buffer in bytes.
   * @param lazy_configuration - if true, some components of the internal
   *        engine structure will be initialized only when first needed. If
   *        false, all engine structure will be loaded and initialized
   *        immediately. Lazy configuration is enabled by default.
   * @param init_concurrency - allowed concurrent threads while configuring the
   *        engine. 0 means unlimited.
   * @param delayed_initialization - performs a blank configuration, delaying
   *        the internal engines initialization until the corresponding
   *        SpawnSession method is called
   * @return A newly created IdEngine object. The object is allocated,
   *         the caller is responsible for deleting it.
   */
  static IdEngine* Create(unsigned char* config_data,
                          int            config_data_length,
                          bool           lazy_configuration = true,
                          int            init_concurrency = 0,
                          bool           delayed_initialization = false);

  /**
   * @brief The factory method for creating the IdEngine object with a
   *        configuration bundle buffer embedded within the library.
   * @param lazy_configuration - if true, some components of the internal
   *        engine structure will be initialized only when first needed. If
   *        false, all engine structure will be loaded and initialized
   *        immediately. Lazy configuration is enabled by default.
   * @param init_concurrency - allowed concurrent threads while configuring the
   *        engine. 0 means unlimited.
   * @param delayed_initialization - performs a blank configuration, delaying
   *        the internal engines initialization until the corresponding
   *        SpawnSession method is called
   * @return A newly created IdEngine object. The object is allocated,
   *         the caller is responsible for deleting it.
   */
  static IdEngine* CreateFromEmbeddedBundle(
      bool           lazy_configuration = true,
      int            init_concurrency = 0,
      bool           delayed_initialization = false);

  /**
   * @brief Returns the Smart ID Engine version number
   * @return Smart ID Engine version number string
   */
  static const char* GetVersion();
};


} } // namespace se::id

#endif // IDENGINE_ID_ENGINE_H_INCLUDED
