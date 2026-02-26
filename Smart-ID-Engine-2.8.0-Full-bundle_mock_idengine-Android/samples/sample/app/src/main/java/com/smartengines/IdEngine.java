/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines;

import static com.idengineexample.ExampleActivity.LIBRARY_NAME;

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
    private static final String TAG = "myapp.IdEngine";

    private static com.smartengines.id.IdEngine instance;

    public static com.smartengines.id.IdEngine getInstance(Context context) {
        if (instance == null) {
            loadEngine(context);
        }
        return instance;
    }

    private static void loadEngine(Context context){
        Log.d(TAG,"loadEngine");

        byte[] bundle_data = prepareBundle(context);

        // load library
        Log.d(TAG,"System.loadLibrary( "+LIBRARY_NAME+" )");
        System.loadLibrary(LIBRARY_NAME);

        try {
            Log.d(TAG,"IdEngine.Create()");
            instance = com.smartengines.id.IdEngine.Create(bundle_data, true);
        } catch (Exception e) {
            Handler handler = new Handler(Looper.getMainLooper());
            handler.post(() -> {
                Toast t = Toast.makeText(context, e.getMessage(), Toast.LENGTH_LONG);
                t.show();
            });
            Log.e(TAG, "Engine loading error", e);
        }
    }

    private static byte[] prepareBundle(Context context) {
        Log.d(TAG,"prepareBundle");
        AssetManager assetManager = context.getAssets();
        String bundle_name = "";
        String[] file_list;

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
            Log.d(TAG,"bundle path: "+bundle_path);

            // Open the bundle file
            InputStream stream = assetManager.open(bundle_path);
            int size = stream.available();
            Log.d(TAG,"bundle size: "+size);

            // Read data
            byte[] buffer = new byte[size];
            int len = stream.read(buffer);
            stream.close();

            // Check result length
            if(len!=size) throw new Exception("stream reading error");

            return buffer;
        } catch (Exception e) {
            Log.e(TAG, "Bundle loading error", e);
        }
        return null;
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

