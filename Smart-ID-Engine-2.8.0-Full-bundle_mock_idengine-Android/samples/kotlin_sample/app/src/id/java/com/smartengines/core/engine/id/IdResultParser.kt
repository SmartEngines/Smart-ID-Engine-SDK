/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.core.engine.id

import com.smartengines.id.IdBaseFieldInfo
import com.smartengines.id.IdCheckFieldsMapIterator
import com.smartengines.id.IdImageFieldsMapIterator
import com.smartengines.id.IdResult
import com.smartengines.id.IdTextFieldsMapIterator
import android.util.Base64
import android.graphics.BitmapFactory
import android.util.Log
import com.smartengines.core.engine.Engine
import com.smartengines.id.IdSessionSettings

private const val TAG = "engine.IdResultParser"

/**
 * PARSE IdResult => IdResultData
 */
fun IdResult.parse(sessionSettings: IdSessionSettings): IdResultData?{
    // DOC TYPE
    val docType = GetDocumentType()
    if(docType.isNullOrEmpty()) return null

    val supportedRFID = sessionSettings.GetDocumentInfo(docType).SupportedRFID() == 1

    return IdResultData(
        docType = docType,
        textFields     = parseTextFields(),
        images         = parseImages(),
        forensicCheckFields = parseForensicCheckFields(),
        forensicTextFields  = parseForensicTextFields(),
        forensicImages      = parseForensicImages(),
        rfidSupported = supportedRFID
    )
        .also {  Log.d(TAG,"IdResultData: $it") }
}

//--------------------------------------------------------------------------------------------------
// ATTRIBUTES
/**
 * PARSE StringsMapIterator => Attribute
 */
fun IdBaseFieldInfo.parseAttributes():List<Attribute>{
    return ArrayList<Attribute>().apply {
        val iterator = AttributesBegin()
        val iterEnd  = AttributesEnd()
        while (!iterator.Equals(iterEnd)) {
            add(
                Attribute(
                    key   = iterator.GetKey(),
                    value = iterator.GetValue()
                )
            )
            iterator.Advance()
        }
    }
}

//--------------------------------------------------------------------------------------------------
// TEXT FIELDS
/**
 * IdResult => TEXT FIELDS
 */
fun IdResult.parseTextFields():List<TextField>{
    return ArrayList<TextField>().apply {
        val iterator = TextFieldsBegin()
        val iterEnd  = TextFieldsEnd()
        while (!iterator.Equals(iterEnd)) {
            add(iterator.parseTextField())
            iterator.Advance()
        }
    }
}
/**
 * PARSE IdTextFieldsMapIterator => FieldInfo
 */
fun IdTextFieldsMapIterator.parseTextField(): TextField {
    val info = GetValue().GetBaseFieldInfo()
    return  TextField(
        key         = GetKey(),
        value       = GetValue().GetValue().GetFirstString().GetCStr(),
        isAccepted  = info.GetIsAccepted(),
        attr        = info.parseAttributes()
    )
}

//--------------------------------------------------------------------------------------------------
// IMAGES
/**
 * IdResult => IMAGES
 */
fun IdResult.parseImages():List<ImageField>{
    return ArrayList<ImageField>().apply {
        val iterator = ImageFieldsBegin()
        val iterEnd  = ImageFieldsEnd()
        while (!iterator.Equals(iterEnd)) {
            try {
                add(iterator.parseImage())
            }catch(e:Exception){
                Log.e(TAG,"IdResult.parseImages",e)
            }
            iterator.Advance()
        }
    }
}

/**
 * PARSE IdTextFieldsMapIterator => ImageInfo
 */
fun IdImageFieldsMapIterator.parseImage(): ImageField {
    val info = GetValue().GetBaseFieldInfo()
    val base64String = GetValue().GetValue().GetBase64String().GetCStr()
    val base64Buf = Base64.decode(base64String, Base64.DEFAULT)
    return  ImageField(
        key         = GetKey(),
        value       = BitmapFactory.decodeByteArray(base64Buf, 0, base64Buf.size),
        isAccepted  = info.GetIsAccepted(),
        attr        = info.parseAttributes()
    )
}

//--------------------------------------------------------------------------------------------------
// FORENSICS
/**
 * IdResult => FORENSIC CHECK FIELDS
 */
fun IdResult.parseForensicCheckFields():List<TextField>{
    return ArrayList<TextField>().apply {
        val iterator = ForensicCheckFieldsBegin()
        val iterEnd  = ForensicCheckFieldsEnd()
        while (!iterator.Equals(iterEnd)) {
            // Excluding NFC/RFID checks
            if (!iterator.GetKey().equals("check_4000000000001") && !iterator.GetKey().equals("check_4000000000002") &&
                !iterator.GetKey().equals("check_4000000000003")) {
                add(iterator.parseForensicCheckField())
            }
            iterator.Advance()
        }
    }
}
/**
 * PARSE IdCheckFieldsMapIterator => FieldInfo
 */
fun IdCheckFieldsMapIterator.parseForensicCheckField(): TextField {
    val info = GetValue().GetBaseFieldInfo()
    return  TextField(
        key         = GetKey(),
        value       = GetValue().GetValue().toString(),
        isAccepted  = info.GetIsAccepted(),
        attr        = info.parseAttributes()
    )
}
/**
 * IdResult => FORENSIC TEXT FIELDS
 */
fun IdResult.parseForensicTextFields():List<TextField>{
    return ArrayList<TextField>().apply {
        val iterator = ForensicTextFieldsBegin()
        val iterEnd  = ForensicTextFieldsEnd()
        while (!iterator.Equals(iterEnd)) {
            add(iterator.parseTextField())
            iterator.Advance()
        }
    }
}
/**
 * IdResult => IMAGES
 */
fun IdResult.parseForensicImages():List<ImageField>{
    return ArrayList<ImageField>().apply {
        val iterator = ForensicImageFieldsBegin()
        val iterEnd  = ForensicImageFieldsEnd()
        while (!iterator.Equals(iterEnd)) {
            try {
                add(iterator.parseImage())
            }catch(e:Exception){
                Log.e(TAG,"IdResult.parseForensicImages",e)
            }
            iterator.Advance()
        }
    }
}
