/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.kotlin_sample.targets

import com.smartengines.id.IdSessionSettings

data class IdTarget(
    val mode : String,
    val mask : String
) : AppTarget {
    override val name: String
        get() = "$mode : $mask"
    override val description: String?
        get() = if(mode=="anydoc") "Any document" else null
    override val cropImage: Boolean
        get() = false // do not crop images for id-engine


    override fun fillSessionSettings(sessionSettings:Any){
        with(sessionSettings as IdSessionSettings) {
            // Set current mode
            SetCurrentMode(mode)

            // Set forensics
//        if (SettingsStore.isForensics) {
//            sessionSettings.EnableForensics()
//        }

            // Set document mask
            AddEnabledDocumentTypes(mask)

            // Set custom options
            SetOption("common.sessionTimeout", "15.0")
            SetOption("common.extractTemplateImages", "true")
            SetOption("common.currentDate", "30.08.2024")//TODO set current date
        }

    }
}
