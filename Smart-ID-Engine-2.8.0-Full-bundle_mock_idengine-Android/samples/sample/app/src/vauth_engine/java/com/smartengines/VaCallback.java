/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines;

import androidx.lifecycle.MutableLiveData;

import com.smartengines.id.IdCheckStatus;
import com.smartengines.id.IdFaceLivenessResult;
import com.smartengines.id.IdFaceSimilarityResult;
import com.smartengines.id.IdResult;
import com.smartengines.id.IdVideoAuthenticationAnomaly;
import com.smartengines.id.IdVideoAuthenticationCallbacks;
import com.smartengines.id.IdVideoAuthenticationInstruction;

public class VaCallback extends IdVideoAuthenticationCallbacks {
    boolean sessionEnded = false;
    public MutableLiveData<String> instruction = new MutableLiveData<>("");

    public void reset(){
        sessionEnded=false;
        instruction.postValue("");
    }

    @Override
    public void InstructionReceived(int i, IdVideoAuthenticationInstruction instr) {
        instruction.postValue(instr.GetInstructionCode());
    }
    @Override
    public void MessageReceived(String s) {}
    @Override
    public void AuthenticationStatusUpdated(IdCheckStatus idCheckStatus) {}
    @Override
    public void GlobalTimeoutReached() {}
    @Override
    public void DocumentResultUpdated(IdResult idResult) {}
    @Override
    public void FaceLivenessResultUpdated(IdFaceLivenessResult idFaceLivenessResult) {}
    @Override
    public void FaceMatchingResultUpdated(IdFaceSimilarityResult idFaceSimilarityResult) {}
    @Override
    public void AnomalyRegistered(int i, IdVideoAuthenticationAnomaly idVideoAuthenticationAnomaly) {}
    @Override
    public void InstructionTimeoutReached() {}
    @Override
    public void SessionEnded() {
        sessionEnded = true;
    }
}
