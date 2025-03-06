/*
  Copyright (c) 2016-2024, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines;

import android.content.Context;
import android.content.res.AssetManager;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.widget.Toast;

import com.smartengines.common.StringsSetIterator;
import com.smartengines.id.IdSessionSettings;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class IdEngine {
    private static com.smartengines.id.IdEngine instance;

    public static com.smartengines.id.IdEngine getInstance(Context context) {
        if (instance == null) {

            byte[] bundle_data = prepareBundle(context);

            // load library
            System.loadLibrary("jniidengine");

            try {
                instance = com.smartengines.id.IdEngine.Create(bundle_data, true);
            } catch (Exception e) {
                Handler handler = new Handler(Looper.getMainLooper());
                handler.post(() -> {
                    Toast t = Toast.makeText(context, e.getMessage(), Toast.LENGTH_LONG);
                    t.show();
                });
                Log.e("SMARTENGINES", e.getMessage());
            }
        }
        return instance;
    }

    private static byte[] prepareBundle(Context context) {
        AssetManager assetManager = context.getAssets();
        String bundle_name = "";
        String[] file_list;
        ByteArrayOutputStream os = new ByteArrayOutputStream();

        try {
            file_list = assetManager.list("data");

            for (String file : file_list) {
                if (file.endsWith(".se")) {
                    bundle_name = file;
                    break;
                }
            }

            if (bundle_name.isEmpty()) {
                throw new IOException("No configuration bundle found!");
            }

            final String bundle_path = "data" + File.separator + bundle_name;

            InputStream is = assetManager.open(bundle_path);

            byte[] buffer = new byte[0xFFFF];
            for (int len = is.read(buffer); len != -1; len = is.read(buffer)) {
                os.write(buffer, 0, len);
            }
            os.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return os.toByteArray();
    }

    public static String[] getDocumentsList(Context context) {
        List<String> documents = new ArrayList<>();

        com.smartengines.id.IdEngine engine = getInstance(context);

        IdSessionSettings sessionSettings = engine.CreateSessionSettings();

        for (StringsSetIterator mt = sessionSettings.SupportedModesBegin();
             !mt.Equals(sessionSettings.SupportedModesEnd()); mt.Advance()) {

            sessionSettings.SetCurrentMode(mt.GetValue());

            for (StringsSetIterator dt = sessionSettings.PermissiblePrefixDocMasksBegin();
                 !dt.Equals(sessionSettings.PermissiblePrefixDocMasksEnd());
                 dt.Advance()) {
                documents.add(mt.GetValue() + ':' + dt.GetValue());
            }
        }

        String[] array = new String[documents.size()];
        documents.toArray(array);

        return array;
    }

}

