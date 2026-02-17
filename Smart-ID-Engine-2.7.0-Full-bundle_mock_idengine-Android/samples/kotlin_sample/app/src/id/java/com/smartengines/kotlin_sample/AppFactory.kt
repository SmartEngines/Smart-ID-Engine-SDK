/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.kotlin_sample

import androidx.compose.runtime.Composable
import com.smartengines.core.engine.Engine
import com.smartengines.core.engine.EngineBundle
import com.smartengines.core.engine.Session
import com.smartengines.core.engine.id.IdEngineWrapper
import com.smartengines.core.engine.id.IdResultData
import com.smartengines.kotlin_sample.targets.AppTarget
import com.smartengines.kotlin_sample.targets.IdTargetList
import com.smartengines.nfc.PassportKey

object AppFactory {
    val jniLibrary = "jniidengine"
    val bundle     = EngineBundle.FirstFound("data", ".se")

    fun createEngineWrapper(signature:String) : Engine = IdEngineWrapper(signature)

    val loadTargetList : (Engine)->List<AppTarget> = IdTargetList::load

    val ResultScreen: @Composable (Session)->Unit = { IdResultScreen(session = it)}
}

// CALCULATE NFC/RFID passport key by recognition result
fun IdResultData.calculatePassportKey(): PassportKey?{
    try {
        textFields.find { it.key == "full_mrz" }?.let {
            return PassportKey.fromMRZ(it.value)
        }
    }catch (_:Exception){}
    return null
}
