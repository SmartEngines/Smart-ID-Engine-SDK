/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.core.engine.id

import com.smartengines.id.IdEngine
import com.smartengines.core.engine.Engine
import com.smartengines.core.engine.Session
import com.smartengines.core.engine.SessionTarget
import com.smartengines.core.engine.SessionType
import com.smartengines.id.IdSessionSettings

class IdEngineWrapper(
    private val signature : String
): Engine {
    lateinit var idEngine: IdEngine
        private set
    override val isVideoModeAllowed = true

    override fun createEngine(bundle: ByteArray?){
        // Create SDK engine
        idEngine = if(bundle!=null) IdEngine.Create(bundle,
            true,
            0,
            true//delayed
        ) else IdEngine.CreateFromEmbeddedBundle(
            true,
            0,
            true//delayed
        )
    }

    override fun createSession(target: SessionTarget, sessionType: SessionType): Session {

        // Create new session settings object
        val sessionSettings: IdSessionSettings = idEngine.CreateSessionSettings()

        // Fill by the target
        target.fillSessionSettings(sessionSettings)

        return IdEngineSession(idEngine, sessionSettings, signature)
    }
}
