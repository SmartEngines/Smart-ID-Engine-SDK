/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.kotlin_sample.targets

import com.smartengines.id.IdSessionSettings

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

            // Enable forensics
            //sessionSettings.EnableForensics()

            // Set document mask
            AddEnabledDocumentTypes(mask)

            // Set custom options
            SetOption("common.sessionTimeout", "5.0")
            SetOption("common.extractTemplateImages", "true")
            SetOption("common.currentDate", "30.08.2024")//TODO set current date
        }

    }
}
