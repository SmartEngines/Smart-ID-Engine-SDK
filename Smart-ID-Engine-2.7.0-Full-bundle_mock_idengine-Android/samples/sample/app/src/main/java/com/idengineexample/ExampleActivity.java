/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.idengineexample;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.ImageDecoder;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.util.Log;
import android.util.Pair;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;

import com.smartengines.CameraActivity;
import com.smartengines.R;
import com.smartengines.ResultStore;
import com.smartengines.SettingsStore;
import com.smartengines.databinding.ActivityExampleBinding;
import com.smartengines.id.IdEngine;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ExampleActivity extends AppCompatActivity {
    public static final String LIBRARY_NAME = "jniidengine";
    public static final String SIGNATURE = "INSERT_SIGNATURE_FROM_README.html\";

    private static final String TAG = "myapp.MainActivity";

    Context context;
    public TextView resultTextField;
    ExampleUpload exampleUpload = new ExampleUpload();

    ListView listView;
    ExampleResultAdapter adapter;
    ActivityExampleBinding binding;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Log.d(TAG,"onCreate");

        binding = DataBindingUtil.setContentView(this, R.layout.activity_example);
        context = getBaseContext();

        // INIT CONTROLS
        listView = binding.list;
        resultTextField = binding.resultInfo;
        ImageButton selector = binding.selector;
        Button selectUpload = binding.gallery;
        Button selectCamera = binding.buttonCamera;
        TextView version = binding.version;

        // ListView
        adapter = new ExampleResultAdapter(context);
        listView.setAdapter(adapter);

        // LOAD ENGINE
        IdEngine engine = com.smartengines.IdEngine.getInstance(context);
        version.setText("Version: " + engine.GetVersion());

        selectCamera.setOnClickListener(v -> openCamera());
        selector.setOnClickListener(v -> openSelector());
        selectUpload.setOnClickListener(v -> mUploadActivity.launch("image/*"));
        initSESettings();
    }

    private void initSESettings() {
        // mask
        String[] mask = {"*"};
        ArrayList<String> strList = new ArrayList<>(Arrays.asList(mask));
        SettingsStore.SetMask(strList);

        String dateInString = new SimpleDateFormat("dd.MM.yyyy", Locale.US).format(new Date());

        // options
        Map<String, String> options = new HashMap();
        options.put("common.sessionTimeout", "5.0");
        options.put("common.extractTemplateImages", "true");
        options.put("common.currentDate", dateInString);// common.currentDate for forensics

        SettingsStore.SetOptions(options);
        SettingsStore.SetForensics(false);
    }

    ActivityResultLauncher<String> mUploadActivity = registerForActivityResult(new ActivityResultContracts.GetContent(),
            uri -> {
                adapter.clear();
                if (uri == null) {
                    return;
                }

                try {
                    // Get bitmap from file
                    Bitmap gallery_file;

                    if (Build.VERSION.SDK_INT >=29 ) {
                        gallery_file = ImageDecoder.decodeBitmap(ImageDecoder.createSource(context.getContentResolver(), uri), (imageDecoder, imageInfo, source1) -> imageDecoder.setMutableRequired(true));

                    } else {
                        gallery_file = MediaStore.Images.Media.getBitmap(context.getContentResolver(), uri);
                    }

                    try {
                        resultTextField.setText("Recognizing...");

                        ExecutorService executor = Executors.newSingleThreadExecutor();
                        Handler handler = new Handler(Looper.getMainLooper());

                        executor.execute(() -> {
                            try {
                                exampleUpload.getResultFromGallery(context, gallery_file);
                            } catch (Exception e) {
                                Log.e(TAG, e.getMessage());
                                handler.post(() -> {
                                    String err = (e.getMessage().length() >= 800) ? e.getMessage().substring(0, 800) : e.getMessage();
                                    Toast t = Toast.makeText(getApplicationContext(), err, Toast.LENGTH_LONG);
                                    t.show();
                                    Log.e(TAG, err);
                                    resultTextField.setText("Exception");
                                });
                            }

                            handler.post(this::renderResult);
                        });
                    } catch (Exception e) {
                        Log.e(TAG, "Recognizing error", e);
                    }
                } catch (IOException e) {
                    resultTextField.setText(e.getMessage());
                    Log.e(TAG, "Recognizing IO error", e);
                }
            });

    private void openCamera() {

        // reset state of UI
        resultTextField.setText("");
        // Reset items in result adapter
        if (adapter != null) {
            adapter.clear();
        }

        Intent intent;
        intent = new Intent(getApplicationContext(), CameraActivity.class);
        mStartCameraActivity.launch(intent);
    }
    // Document camera activity
    ActivityResultLauncher<Intent> mStartCameraActivity = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            result -> {
                if (result.getResultCode() == Activity.RESULT_OK) {
                    renderResult();
                }
            });

    public void renderResult() {
        // Get data from store
        Map<String, ResultStore.FieldInfo> fields = ResultStore.instance.getFields();
        Map<String, ResultStore.FieldInfo> images = ResultStore.instance.getImages();
        Map<String, ResultStore.FieldInfo> forensics = ResultStore.instance.getForensics();

        // Get docType
        String docType = ResultStore.instance.getType();

        // Check if document found
        if (docType.isEmpty()) {
            docType = "Document not found";
            resultTextField.setText(docType);
            return;
        }

        // Add first section to result view
        adapter = new ExampleResultAdapter(context);

        adapter.addItem(ResultStore.instance.getType(), "section");
        // Put fields ti result
        for (Map.Entry<String, ResultStore.FieldInfo> set : fields.entrySet()) {
            Pair<String, ResultStore.FieldInfo> tempMap = new Pair(set.getKey(), set.getValue());
            adapter.addItem(tempMap, "field");
        }

        adapter.addItem("Images", "section");
        // Put images to result
        for (Map.Entry<String, ResultStore.FieldInfo> img : images.entrySet()) {
            Pair<String, ResultStore.FieldInfo> tempMap = new Pair(img.getKey(), img.getValue());
            adapter.addItem(tempMap, "image");
        }

        // Put forensics results
        if (!forensics.isEmpty()) {
            adapter.addItem("Forensics", "section");
            for (Map.Entry<String, ResultStore.FieldInfo> ff : forensics.entrySet()) {
                Pair<String, ResultStore.FieldInfo> tempMap = new Pair(ff.getKey(), ff.getValue());
                adapter.addItem(tempMap, "field");
            }
        }

        listView.setAdapter(adapter);

        if (!images.containsKey("photo")) {
            docType = "Photo not found in document";
            resultTextField.setText(docType);
            return;
        }

        resultTextField.setText(docType);
    }
    // Select document type
    private void openSelector() {
        final String[] documents = com.smartengines.IdEngine.getDocumentsList(context);

        AlertDialog.Builder builder = new AlertDialog.Builder(ExampleActivity.this);
        builder.setTitle("Select mode:mask");
        builder.setItems(documents, (dialog, item) -> {

            String docMask = documents[item];
            int separator = docMask.indexOf(':');
            String currentMode = docMask.substring(0, separator);
            String currentMask = docMask.substring(separator + 1);
            resultTextField.setText(currentMode + ':' + currentMask);
            ArrayList<String> mask_from_menu = new ArrayList<>(Arrays.asList(currentMask));
            SettingsStore.SetMode(currentMode);
            SettingsStore.SetMask(mask_from_menu);
        });

        builder.setCancelable(true);
        AlertDialog alert = builder.create();
        alert.show();
    }


}