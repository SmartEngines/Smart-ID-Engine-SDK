/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.core.engine.id

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import android.util.Log
import com.smartengines.common.ByteString
import com.smartengines.core.engine.Session
import com.smartengines.common.Image
import com.smartengines.core.engine.common.Utils
import com.smartengines.id.IdEngine
import com.smartengines.id.IdResult
import com.smartengines.id.IdSession
import com.smartengines.id.IdSessionSettings
import com.smartengines.nfc.PassportData
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject
import java.io.DataInputStream

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

    private val isForensicEnabled:Boolean

    init {

        // Spawn recognition session
        idSession = idEngine.SpawnSession(sessionSettings, signature, idCallback)
        Log.d(TAG,"Session created")
        isForensicEnabled = sessionSettings.IsForensicsEnabled()
    }

    override fun processImage(bitmap: Bitmap) {
        val image: Image = Utils.imageFromBitmap(bitmap)
        idSession.Process(image)
    }

    companion object{
        val passportDataChecks = arrayOf("check_4000000000001", "check_4000000000002");
    }

    /**
     * Checks the passport data in the current session
     * Forensics must be enabled!
     *    ex: sessionSettings.EnableForensics() (uncomment this string in IdTarget class)
     */
    override suspend fun checkPassportData(passportData: PassportData):Map<String,String> {
        Log.w(TAG,"checkPassportData isForensicEnabled=$$isForensicEnabled")

        // Check the condition
        if(!isForensicEnabled) return mapOf("no data" to "forensics is disabled")

        // Get current result
        val currentResult = idSession.GetCurrentResult()

        // Process in the MAIN THREAD only!
        val result : IdResult = withContext(Dispatchers.Main) {
            // Prepare data
            val data = JSONObject()
                .put("doc_type", currentResult.GetDocumentType())
                .put("physical_fields", JSONObject().apply {
                    // MRZ
                    put(
                        "rfid_mrz", JSONObject()
                            .put("value", passportData.mrzInfo.toString().replace("\n", ""))
                            .put("type", "String")
                    )
                    // PHOTO
                    passportData.faceInfos.firstOrNull()?.faceImageInfos?.firstOrNull()?.let {
                        // Read buffer
                        val imageLength = it.imageLength
                        val dataInputStream = DataInputStream(it.imageInputStream)
                        val buffer = ByteArray(imageLength)
                        dataInputStream.readFully(buffer, 0, imageLength)
                        // Decode by the SDK
                        val image = com.smartengines.common.Image.FromFileBuffer(buffer)
                        // Convert to string
                        val base64String = image.GetBase64String().GetCStr()
                        // Check the buffer
    //                        val base64Buf = Base64.decode(base64String, Base64.DEFAULT)
    //                        val bitmap = BitmapFactory.decodeByteArray(base64Buf, 0, base64Buf.size)
    //                        Log.w(TAG,"image buffer converted to bitmap: ${bitmap.width}x${bitmap.height}")

                        // ADD TO DATA
                        put(
                            "rfid_photo", JSONObject()
                                .put("value", base64String)
                                .put("type", "Image")
                        )
                    }
                }
            )

            Log.w(TAG, "checkPassportData   data: $data")
            idSession.Process(ByteString(data.toString().toByteArray()))
        }

        // Parse the check result
        val checks = HashMap<String,String>().apply {
            val iterator = result.ForensicCheckFieldsBegin()
            val end      = result.ForensicCheckFieldsEnd()
            while(!iterator.Equals(end)){
                val checkField = iterator.GetValue()
                val key   = checkField.GetName()
                val value = checkField.GetValue()
                //Log.e(TAG,"   ===   checkField $key : $value")
                // Append known fields
                if(passportDataChecks.contains(key))
                    put(key, value.toString().removePrefix("IdCheckStatus_"))
                // Next
                iterator.Advance()
            }
        }

        Log.w(TAG,"checkPassportData result: $checks")

        return checks
    }


}
