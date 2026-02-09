/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.idengineexample;

import static com.idengineexample.ExampleActivity.SIGNATURE;

import android.content.Context;
import android.graphics.Bitmap;

import com.smartengines.IdEngine;
import com.smartengines.Label;
import com.smartengines.ResultStore;
import com.smartengines.SettingsStore;
import com.smartengines.common.Image;
import com.smartengines.common.ImagePixelFormat;
import com.smartengines.id.IdResult;
import com.smartengines.id.IdSession;
import com.smartengines.id.IdSessionSettings;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Map;

public class ExampleUpload {
    public void getResultFromGallery(final Context context, Bitmap imageData) {
        try {
            Label.getInstance().message.set("Wait...");
            // 1. Get engine instance
            com.smartengines.id.IdEngine engine = IdEngine.getInstance(context);
            // 2. Create new session settings object
            IdSessionSettings sessionSettings = engine.CreateSessionSettings();
            sessionSettings.SetCurrentMode(SettingsStore.currentMode);
            // 2.1 Set forensics
            if (SettingsStore.isForensics) {
                sessionSettings.EnableForensics();
            }
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
            IdSession session = engine.SpawnSession(sessionSettings, SIGNATURE);

            // Prepare for FromBufferExtended()
            byte[] bytes = bitmapToByteArray(imageData);
            int stride = imageData.getRowBytes();
            int height = imageData.getHeight();
            int width = imageData.getWidth();

            // Bitmap.getConfig() return ARGB_8888 pixel format. The channel order of ARGB_8888 is RGBA!
            Image se_image = Image.FromBufferExtended(bytes, width, height, stride, ImagePixelFormat.IPF_RGBA, 1);
            IdResult finalResult = session.Process(se_image);
            ResultStore.instance.addResult(finalResult);
            // 4. Reset session
            session.Reset();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public byte[] bitmapToByteArray(Bitmap bitmap) {
        ByteBuffer byteBuffer = ByteBuffer.allocate(bitmap.getByteCount());
        bitmap.copyPixelsToBuffer(byteBuffer);
        byteBuffer.rewind();
        return byteBuffer.array();
    }
}
