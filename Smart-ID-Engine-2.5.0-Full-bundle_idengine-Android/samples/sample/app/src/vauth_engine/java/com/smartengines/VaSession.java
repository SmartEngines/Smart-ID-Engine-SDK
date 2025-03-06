/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.lifecycle.LiveData;

import com.smartengines.common.Image;
import com.smartengines.id.IdResult;
import com.smartengines.id.IdVideoAuthenticationSession;
import com.smartengines.id.IdVideoAuthenticationSessionSettings;


import java.util.ArrayList;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class VaSession implements ISession{

    private IdVideoAuthenticationSession session;
    private final IdCallback idCallback = new IdCallback();
    private final VaCallback vaCallback = new VaCallback();

    @Override
    public LiveData<String> getInstruction(){return vaCallback.instruction;}

    @Override
    public void initSession(Context context, StateCallback callback) {
        ExecutorService SessionExecutor = Executors.newSingleThreadExecutor();
        Handler handler = new Handler(Looper.getMainLooper());

        SessionExecutor.execute(() -> {
            try {
                Label.getInstance().message.set("Wait...");

                // 1. Get engine instance
                com.smartengines.id.IdEngine engine = IdEngine.getInstance(context);
                // 2. Create new session settings object
                IdVideoAuthenticationSessionSettings sessionSettings = engine.CreateVideoAuthenticationSessionSettings();
                sessionSettings.SetCurrentMode(SettingsStore.currentMode);
                // 2.2 Set document mask
                ArrayList<String> docArray = SettingsStore.currentMask;
                for (String name : docArray) {
                    // System.out.println(name);
                    sessionSettings.AddEnabledDocumentTypes(name);
                }
                // 2.3 Set custom options
                Map<String, String> map = SettingsStore.options;
                for (Map.Entry<String, String> entry : map.entrySet()) {
                    String key = entry.getKey();
                    String value = entry.getValue();
                    sessionSettings.SetOption(key, value);
                }
                // 3. Spawn recognition session
                session = engine.SpawnVideoAuthenticationSession(sessionSettings, SettingsStore.signature,
                        vaCallback, idCallback);

                handler.post(() -> {
                    callback.initialized(true);
                    Log.d("SMARTENGINES", "SESSION INITIALIZED...");
                });

            } catch (Exception e) {
                Label.getInstance().message.set("Exception");
                handler.post(() -> callback.error("SpawnSession: "+ e.getMessage()));
            }
        });
    }

    @Override
    public void processFrame(Image frame) {
        session.ProcessFrame(frame);
    }
    @Override
    public IdResult getResult(){
        return idCallback.idResult;
    }

    @Override
    public boolean isSessionEnded() {
        return vaCallback.sessionEnded;
    }


    @Override
    public void reset() {
        session.Reset();
        idCallback.reset();
        vaCallback.reset();
    }
}
