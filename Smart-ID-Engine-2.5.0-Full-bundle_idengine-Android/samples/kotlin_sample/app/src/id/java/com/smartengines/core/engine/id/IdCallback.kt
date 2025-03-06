/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines.core.engine.id

import android.util.Log
import com.smartengines.core.engine.Quad
import com.smartengines.core.engine.common.toQuad
import com.smartengines.id.IdFeedback
import com.smartengines.id.IdFeedbackContainer
import com.smartengines.id.IdResult
import com.smartengines.id.IdTemplateDetectionResult
import com.smartengines.id.IdTemplateSegmentationResult
import kotlinx.coroutines.flow.MutableStateFlow

private const val TAG = "myapp.IdCallback"

class IdCallback : IdFeedback() {
    var isSessionEnded = false
    var idResult:IdResult?=null

    val quadsDetection    = MutableStateFlow<Set<Quad>>(emptySet())
    val quadsSegmentation = MutableStateFlow<Set<Quad>>(emptySet())


    override fun FeedbackReceived(p0: IdFeedbackContainer?) { }

    override fun TemplateDetectionResultReceived(detectionResult: IdTemplateDetectionResult) {
        Log.d(TAG, "   ---> TemplateDetectionResultReceived")
        val qs: MutableSet<Quad> = HashSet()
        try {
            qs.add(detectionResult.GetQuadrangle().toQuad())
        } catch (e: Exception) {
            Log.e(TAG, "TemplateDetectionResultReceived",e)
        }
        // Call back (in the same thread)
        quadsDetection.value = qs

    }

    override fun TemplateSegmentationResultReceived(segmentationResult: IdTemplateSegmentationResult) {
        Log.d(TAG, "   ---> TemplateSegmentationResultReceived")
        val qs: MutableSet<Quad> = HashSet()
        try {
            segmentationResult.RawFieldQuadranglesBegin().let {
                while (!it.Equals(segmentationResult.RawFieldQuadranglesEnd())) {
                    qs.add(it.GetValue().toQuad())
                    it.Advance()
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "TemplateSegmentationResultReceived",e)
        }
        // Call back (in the same thread)
        quadsSegmentation.value = qs
    }

    override fun ResultReceived(result: IdResult) {
        Log.d(TAG, "   ---> ResultReceived isTerminal=${result.GetIsTerminal()}")
        idResult = result
    }

    override fun SessionEnded() { // Calls on timeout only!!!
        Log.e(TAG, "   ---> SessionEnded")// by TIMEOUT!!!
        isSessionEnded = true
    }
}