/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
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
            idEngine.CreateSessionSettings();
            val sessionSettings: IdSessionSettings = engine.sessionSettings

            // MODES LOOP
            val modeIterator = sessionSettings.SupportedModesBegin()
            val modeEnd      = sessionSettings.SupportedModesEnd()
            while(!modeIterator.Equals(modeEnd)){
                val mode = modeIterator.GetValue()
                sessionSettings.SetCurrentMode(mode)

                // MASKS (for the mode) LOOP
                val maskIterator = sessionSettings.PermissiblePrefixDocMasksBegin()
                val maskEnd      = sessionSettings.PermissiblePrefixDocMasksEnd()
                while (!maskIterator.Equals(maskEnd)){
                    val mask = maskIterator.GetValue()
                    // Check if ROI (image cropping) required
                    sessionSettings.AddEnabledDocumentTypes(mask)
                    var isRoi = true
                    val docTypeIterator = sessionSettings.EnabledDocumentTypesBegin()
                    val docTypeEnd      = sessionSettings.EnabledDocumentTypesEnd()
                    while(!docTypeIterator.Equals(docTypeEnd)){
                        val docType = docTypeIterator.GetValue()
                        if(docType.contains("phone")||docType.contains("card_number")){
                            docTypeIterator.Advance()
                        }else{
                            isRoi = false
                            break
                        }
                    }
                    sessionSettings.RemoveEnabledDocumentTypes(mask)

                    // Add target
                    add(
                        IdTarget(
                            mode = mode,
                            mask = mask,
                            cropImage = isRoi
                        )
                    )

                    // The next mask
                    maskIterator.Advance()
                }

                // The next mode
                modeIterator.Advance()
            }
            Log.d(TAG,"target list is loaded, size=$size")
        }
    }
}