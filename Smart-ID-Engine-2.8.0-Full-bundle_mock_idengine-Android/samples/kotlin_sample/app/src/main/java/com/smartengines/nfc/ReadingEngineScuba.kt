/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.nfc

import android.content.Context
import android.nfc.tech.IsoDep
import android.util.Log

// Scuba library
import net.sf.scuba.smartcards.CardService
import org.jmrtd.BACKey
import org.jmrtd.PassportService
import org.jmrtd.lds.CardAccessFile
import org.jmrtd.lds.PACEInfo

// JMRTD library
import org.jmrtd.lds.icao.DG1File
import org.jmrtd.lds.icao.DG2File
import org.jmrtd.lds.SecurityInfo

private const val TAG = "myapp.RdEngineScuba"

/**
 * Passport reading engine based on scuba library
 */
class ReadingEngineScuba : ReadingEngine {

    //----------------------------------------------------------------------------------------------
    // DATA
    private lateinit var service: PassportService
    // Internal caches
    private lateinit var dg1File: DG1File
    private lateinit var dg2File: DG2File

    //----------------------------------------------------------------------------------------------
    // INTERFACE
    override fun open(
        isoDep: IsoDep
    ) {
        Log.w(TAG, "open $isoDep")
        // CREATE A NEW PASSPORT SERVICE for accessing the passport.
        Log.d(TAG, "Creating a new passport service for accessing the passport.")
        isoDep.timeout = 10000
        val cardService = CardService.getInstance(isoDep)
        cardService.open()
        service = PassportService(
            cardService,
            PassportService.NORMAL_MAX_TRANCEIVE_LENGTH,
            PassportService.DEFAULT_MAX_BLOCKSIZE,
            false,
            false,
        )
        service.open()
    }

    override fun close() {
        try {
            service.close()
        }catch (_:Exception){}
    }

    override fun readPassportData(
        bacKey: BACKey,
        context: Context,
    ): PassportData {
        // Performs the PACE 2.0 / SAC protocol. A secure messaging channel is set up as a result.
        Log.d(TAG,"Performs the PACE 2.0 / SAC protocol. A secure messaging channel is set up as a result.")
        var paceSucceeded = false
//        val bacKey =
//            with(bacKeyData) { BACKey(passportNumber, birthDate, expirationDate) }

//        try {
//            val cardAccessFile =
//                CardAccessFile(service.getInputStream(PassportService.EF_CARD_ACCESS))
//            val securityInfoCollection = cardAccessFile.securityInfos
//            for (securityInfo: SecurityInfo in securityInfoCollection) {
//                if (securityInfo is PACEInfo) {
//                    service.doPACE(
//                        bacKey,
//                        securityInfo.objectIdentifier,
//                        PACEInfo.toParameterSpec(securityInfo.parameterId),
//                        null,
//                    )
//                    paceSucceeded = true
//                }
//            }
//        } catch (e: Exception) {
//            Log.e(TAG, "doPACE", e)
//        }

        // Selects the card side applet.
        // If PACE has been executed successfully previously, then the ICC has authenticated us
        // and a secure messaging channel has already been established.
        // If not, then the caller should request BAC execution as a next step.
        service.sendSelectApplet(paceSucceeded)
        if (!paceSucceeded) {
            try {
                service.getInputStream(PassportService.EF_COM).read()
            } catch (e: Exception) {
                // Performs the Basic Access Control protocol.
                service.doBAC(bacKey)
                Log.w(TAG, "doBAC $bacKey")
            }
        }

        // READ DATA
        val dg1In = service.getInputStream(PassportService.EF_DG1)
        dg1File = DG1File(dg1In)
        Log.w(TAG, "$dg1File")

        val dg2In = service.getInputStream(PassportService.EF_DG2)
        dg2File = DG2File(dg2In)
        Log.w(TAG, "$dg2File")

        // READ OTHER DATA FIELDS
        val otherFields = mutableMapOf<String,String>().apply {
            try {
                val comStream = service.getInputStream(PassportService.EF_COM)
                val comBytes = comStream.readBytes()
                put("COM", android.util.Base64.encodeToString(comBytes, android.util.Base64.NO_WRAP))

            } catch (e: Exception) {
                Log.e(TAG, "COM reading error: ${e.message}")
            }
            try {
                val sodStream = service.getInputStream(PassportService.EF_SOD)
                val sodBytes = sodStream.readBytes()
                put("SOD", android.util.Base64.encodeToString(sodBytes, android.util.Base64.NO_WRAP))
            } catch (e: Exception) {
                Log.e(TAG, "SOD reading error: ${e.message}")
            }
            try {
                val dg1Stream = service.getInputStream(PassportService.EF_DG1)
                val dg1Bytes = dg1Stream.readBytes()
                put("DG1", android.util.Base64.encodeToString(dg1Bytes, android.util.Base64.NO_WRAP))
            } catch (e: Exception) {
                Log.e(TAG, "DG1 reading error: ${e.message}")
            }
            try {
                val dg2Stream = service.getInputStream(PassportService.EF_DG2)
                val dg2Bytes = dg2Stream.readBytes()
                put("DG2", android.util.Base64.encodeToString(dg2Bytes, android.util.Base64.NO_WRAP))
            } catch (e: Exception) {
                Log.e(TAG, "DG2 reading error: ${e.message}")
            }
            try {
                val dg7Stream = service.getInputStream(PassportService.EF_DG7)
                val dg7Bytes = dg7Stream.readBytes()
                put("DG7", android.util.Base64.encodeToString(dg7Bytes, android.util.Base64.NO_WRAP))
            } catch (e: Exception) {
                Log.e(TAG, "DG7 reading error: ${e.message}")
            }
            try {
                val dg11Stream = service.getInputStream(PassportService.EF_DG11)
                val dg11Bytes = dg11Stream.readBytes()
                put("DG11", android.util.Base64.encodeToString(dg11Bytes, android.util.Base64.NO_WRAP))
            } catch (e: Exception) {
                Log.e(TAG, "DG11 reading error: ${e.message}")
            }
            try {
                val dg12Stream = service.getInputStream(PassportService.EF_DG12)
                val dg12Bytes = dg12Stream.readBytes()
                put("DG12", android.util.Base64.encodeToString(dg12Bytes, android.util.Base64.NO_WRAP))
            } catch (e: Exception) {
                Log.e(TAG, "DG12 reading error: ${e.message}")
            }
            try {
                val dg14Stream = service.getInputStream(PassportService.EF_DG14)
                val dg14Bytes = dg14Stream.readBytes()
                put("DG2", android.util.Base64.encodeToString(dg14Bytes, android.util.Base64.NO_WRAP))
            } catch (e: Exception) {
                Log.e(TAG, "DG14 reading error: ${e.message}")
            }
            try {
                val dg15Stream = service.getInputStream(PassportService.EF_DG2)
                val dg15Bytes = dg15Stream.readBytes()
                put("DG15", android.util.Base64.encodeToString(dg15Bytes, android.util.Base64.NO_WRAP))
            } catch (e: Exception) {
                Log.e(TAG, "DG15 reading error: ${e.message}")
            }
        }
        Log.d(TAG, "other fields: $otherFields")

        // SAVE DATA
        //saveData(context)

        // RETURN THE RESULT
        return PassportData(
            mrzInfo   = dg1File.mrzInfo,
            faceInfos = dg2File.faceInfos,
            otherFields = otherFields,
            chipAuth  = null,
            dataAuth  = null
        )
    }

    override fun doChipAuth(): AuthResult {
        TODO("Not yet implemented")
    }

    override fun doDataAuth(context: Context): AuthResult {
        TODO("Not yet implemented")
    }
}