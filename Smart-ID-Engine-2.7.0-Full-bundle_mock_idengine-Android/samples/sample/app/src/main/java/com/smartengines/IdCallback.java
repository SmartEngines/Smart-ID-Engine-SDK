/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines;

import com.smartengines.id.IdFeedback;
import com.smartengines.id.IdFeedbackContainer;
import com.smartengines.id.IdResult;
import com.smartengines.id.IdTemplateDetectionResult;
import com.smartengines.id.IdTemplateSegmentationResult;

public class IdCallback extends IdFeedback {
    IdResult idResult = null;
    boolean sessionEnded = false;
    public void reset(){
        idResult=null;
        sessionEnded=false;
    }

    @Override
    public void FeedbackReceived(IdFeedbackContainer var1){}
    @Override
    public void ResultReceived(IdResult result) {
        idResult = result;
    }
    @Override
    public void TemplateDetectionResultReceived(IdTemplateDetectionResult var1){}
    @Override
    public void TemplateSegmentationResultReceived(IdTemplateSegmentationResult var1) {}
    @Override
    public void SessionEnded(){// called by timeout only!!!
        sessionEnded=true;
    }
}