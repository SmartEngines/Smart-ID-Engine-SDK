/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.nfc

// JMRTD library
import org.jmrtd.lds.icao.MRZInfo
import org.jmrtd.lds.iso19794.FaceInfo

data class PassportData(
    // Passport data fields
    val mrzInfo     : MRZInfo,         // from DG1File
    val faceInfos   : List<FaceInfo>,  // from DG2File
    // Other fields
    val otherFields : Map<String,String> = emptyMap(), // COM,SOD,DG1... data fields
    // Checks
    val chipAuth    : AuthResult?,
    val dataAuth    : AuthResult?
)