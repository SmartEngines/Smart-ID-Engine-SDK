/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.core.engine.id

import android.graphics.Bitmap
import android.util.Log
import com.smartengines.core.engine.Session
import com.smartengines.common.Image
import com.smartengines.core.engine.common.Utils
import com.smartengines.id.IdEngine
import com.smartengines.id.IdSession
import com.smartengines.id.IdSessionSettings

private const val TAG = "myapp.IdEngineSession"

class IdEngineSession(
    idEngine: IdEngine,
    sessionSettings: IdSessionSettings,
    signature:String
) : Session {
    val idSession : IdSession

    val idCallback = IdCallback()

    override val isTerminal: Boolean
        get() = idCallback.idResult?.GetIsTerminal() ?: false
    override val isEnded: Boolean
        get() = idCallback.isSessionEnded
    override val isSelfieCheckRequired: Boolean
        get() = false

    override val quadsPrimary   = idCallback.quadsDetection
    override val quadsSecondary = idCallback.quadsSegmentation
    override val instruction    = null

    init {

        // Spawn recognition session
        idSession = idEngine.SpawnSession(sessionSettings, signature, idCallback)
        Log.d(TAG,"Session created")
    }

    override fun processImage(bitmap: Bitmap) {
        val image: Image = Utils.imageFromBitmap(bitmap)
        idSession.Process(image)
    }


}