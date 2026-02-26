/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.core.engine.id

import android.graphics.Bitmap

data class IdResultData(
    val docType         : String,
    // Data
    val textFields      : List<TextField>,
    val images          : List<ImageField>,
    // Forensics
    val forensicCheckFields : List<TextField>,
    val forensicTextFields  : List<TextField>,
    val forensicImages      : List<ImageField>,

    //RFID
    val rfidSupported       : Boolean
    )

data class Attribute(
    val key         : String,
    val value       : String
)

data class TextField(
    val key         : String,
    val value       : String,
    val isAccepted  : Boolean,
    val attr        : List<Attribute>
)

data class ImageField(
    val key         : String,
    val value       : Bitmap,
    val isAccepted  : Boolean,
    val attr        : List<Attribute>
)

