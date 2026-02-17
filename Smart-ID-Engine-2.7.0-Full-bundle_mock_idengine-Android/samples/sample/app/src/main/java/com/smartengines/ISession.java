/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines;

import android.content.Context;

import androidx.lifecycle.LiveData;

import com.smartengines.common.Image;
import com.smartengines.id.IdResult;

public interface ISession {
    void    initSession(Context context, StateCallback callback);
    void    processFrame(Image frame);
    IdResult getResult();
    boolean isSessionEnded();
    void    reset();

    // Data
    LiveData<String> getInstruction();
}
