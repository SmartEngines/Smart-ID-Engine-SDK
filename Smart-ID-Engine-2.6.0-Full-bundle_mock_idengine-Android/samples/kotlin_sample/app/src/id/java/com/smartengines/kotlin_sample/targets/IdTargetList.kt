/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.kotlin_sample.targets

import android.util.Log
import com.smartengines.core.engine.Engine
import com.smartengines.core.engine.id.IdEngineWrapper
import com.smartengines.id.IdSessionSettings

private const val TAG = "myapp.IdTargetList"

object IdTargetList{
    fun load(engine: Engine) : List<AppTarget> {
        val idEngine = (engine as IdEngineWrapper).idEngine
        return ArrayList<AppTarget>().apply {
            val sessionSettings: IdSessionSettings = idEngine.CreateSessionSettings()

            // MODES LOOP
            val mode    = sessionSettings.SupportedModesBegin()
            val modeEnd = sessionSettings.SupportedModesEnd()
            while(!mode.Equals(modeEnd)){

                sessionSettings.SetCurrentMode(mode.GetValue())

                // MASKS (for the mode) LOOP
                val mask    = sessionSettings.PermissiblePrefixDocMasksBegin()
                val maskEnd = sessionSettings.PermissiblePrefixDocMasksEnd()
                while (!mask.Equals(maskEnd)){
                    // Add target
                    add(
                        IdTarget(
                            mode = mode.GetValue(),
                            mask = mask.GetValue()
                        )
                    )

                    // The next mask
                    mask.Advance()
                }

                // The next mode
                mode.Advance()
            }
            Log.d(TAG,"target list is loaded, size=$size")
        }
    }
}