/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.kotlin_sample.targets

import com.smartengines.id.IdSessionSettings
import java.text.SimpleDateFormat
import java.util.Date

data class IdTarget(
    val mode : String,
    val mask : String,
    override val cropImage: Boolean
) : AppTarget {
    override val name: String
        get() = "$mode : $mask"
    override val description: String?
        get() = if(mode=="anydoc") "Any document" else null

    override fun fillSessionSettings(sessionSettings:Any){
        with(sessionSettings as IdSessionSettings) {
            // Set current mode
            SetCurrentMode(mode)

            //Remove old document mask
            RemoveEnabledDocumentTypes("*")

            // Set document mask
            AddEnabledDocumentTypes(mask)

            // Set custom options
            SetOption("common.sessionTimeout", "5.0")
            SetOption("common.extractTemplateImages", "true")

            // Enable forensics
//            sessionSettings.EnableForensics()
//            val sdf = SimpleDateFormat("dd.MM.yyyy")
//            val currentDate = sdf.format(Date())
//            SetOption("common.currentDate", currentDate)


        }

    }
}
