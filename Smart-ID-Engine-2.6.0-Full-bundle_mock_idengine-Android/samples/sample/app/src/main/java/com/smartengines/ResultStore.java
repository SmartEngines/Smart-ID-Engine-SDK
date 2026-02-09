/*
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines;

import android.util.Base64;
import android.util.Log;

import androidx.annotation.NonNull;

import com.smartengines.common.Image;
import com.smartengines.common.Rectangle;
import com.smartengines.common.Size;
import com.smartengines.common.StringsMapIterator;
import com.smartengines.id.IdBaseFieldInfo;
import com.smartengines.id.IdCheckFieldsMapIterator;
import com.smartengines.id.IdImageFieldsMapIterator;
import com.smartengines.id.IdResult;
import com.smartengines.id.IdTextFieldsMapIterator;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class ResultStore {

    /**
     * Document fields
     */
    public static class FieldInfo {

        public final String value;
        public boolean isAccepted;
        public final Map<String, String> attr;

        // Fields, forensics
        FieldInfo(final String value, final boolean accepted, final Map<String, String> attr) {
            this.value = value;
            this.isAccepted = accepted;
            this.attr = attr;
        }

        // Images
        FieldInfo(final String value, final Map<String, String> attr) {
            this.value = value;
            this.attr = attr;
        }
    }


    /*
     * ========================================================================
     * ===================== ResultStore Storage ==========================
     * ========================================================================
     */

    public static final ResultStore instance = new ResultStore();

    private @NonNull String docType = ""; // representation of the returned document type

    private static final Map<String, FieldInfo> fields = new HashMap<>();
    private static final Map<String, FieldInfo> forensics = new HashMap<>();
    private static final Map<String, FieldInfo> images = new HashMap<>();

    public void addResult(IdResult result) {

        fields.clear();
        forensics.clear();
        images.clear();

        docType = result.GetDocumentType();

        // Get strings results
        for (IdTextFieldsMapIterator it = result.TextFieldsBegin(); !it.Equals(result.TextFieldsEnd()); it.Advance()) {

            String name = it.GetKey(); // name
            String value = it.GetValue().GetValue().GetFirstString().GetCStr(); // value

            IdBaseFieldInfo info = it.GetValue().GetBaseFieldInfo(); // info

            Map<String, String> attr = new HashMap<>();
            for (StringsMapIterator mi = info.AttributesBegin(); !mi.Equals(info.AttributesEnd()); mi.Advance()) {
                attr.put(mi.GetKey(), mi.GetValue());
            }

            fields.put(name, new FieldInfo(value, info.GetIsAccepted(), attr));
        }

        // Get forensics results
        for (IdCheckFieldsMapIterator it = result.ForensicCheckFieldsBegin(); !it
                .Equals(result.ForensicCheckFieldsEnd()); it.Advance()) {
            String name = it.GetKey();

            String value = it.GetValue().GetValue().toString();
            IdBaseFieldInfo info = it.GetValue().GetBaseFieldInfo();

            Map<String, String> attributes = new HashMap<>();

            for (StringsMapIterator mi = info.AttributesBegin(); !mi.Equals(info.AttributesEnd()); mi.Advance()) {
                attributes.put(mi.GetKey(), mi.GetValue());
            }

            forensics.put(name, new FieldInfo(value, info.GetIsAccepted(), attributes));
        }

        // Get all image results
        for (IdImageFieldsMapIterator it = result.ImageFieldsBegin(); !it.Equals(result.ImageFieldsEnd()); it
                .Advance()) {
            String name = it.GetKey();
            String value = it.GetValue().GetValue().GetBase64String().GetCStr(); // base64
            // String value =
            // getUriAfterImageSave(it.GetValue().GetValue().GetBase64String().GetCStr(),
            // name);

            IdBaseFieldInfo info = it.GetValue().GetBaseFieldInfo();

            Map<String, String> attributes = new HashMap<>();

            for (StringsMapIterator mi = info.AttributesBegin(); !mi.Equals(info.AttributesEnd()); mi.Advance()) {
                attributes.put(mi.GetKey(), mi.GetValue());
            }

            images.put(name, new FieldInfo(value, attributes));
        }

        // Get best document frame.
        if (CameraActivity.isBestImageFrameEnabled) {
            // Ignore imageFrame in result if some template has a value of 0.0
            for (Map.Entry set : CameraActivity.frameImageTemplatesInfo.entrySet()) {
                if ((Double) set.getValue() == 0.0) {
                    return;
                }
            }

            if (CameraActivity.bestImageFrame.length() > 0) {
                Map<String, String> attributes = new HashMap<>();
                images.put("document_frame", new ResultStore.FieldInfo(CameraActivity.bestImageFrame, attributes));
                CameraActivity.bestImageFrame = ""; // reset
            }
        }

        /*
         * ==============================================
         * ======== Example of cropping images ==========
         * ==============================================
         */
        if (!images.isEmpty() & !SettingsStore.cropCoords.isEmpty()) {

            String prefix = docType;
            FieldInfo linkToImage = null;

            // Looking for document template
            for (Map.Entry<String, FieldInfo> set : images.entrySet()) {
                String key = set.getKey();
                if (key.startsWith(prefix)) {
                    linkToImage = set.getValue();
                    break;
                }
            }

            if (linkToImage != null) {

                // Create id engine image object
                Image img = Image.FromBase64Buffer(linkToImage.value);

                // Add extra attributes
                Map<String, String> attributes = new HashMap<>();
                attributes.put("my_custom_property", "true");
                attributes.put("estimate_focus_score", String.valueOf(img.EstimateFocusScore()));

                int width = img.GetWidth();
                int height = img.GetHeight();
                int newWidth = SettingsStore.cropCoords.get("resizeTo");
                float ratio = (float) height / (float) width;
                int newHeight = (int) Math.ceil(newWidth * ratio);

                img.Resize(new Size(newWidth, newHeight));

                int cX = SettingsStore.cropCoords.get("x");
                int cY = SettingsStore.cropCoords.get("y");
                int cWidth = SettingsStore.cropCoords.get("width");
                int cHeight = SettingsStore.cropCoords.get("height");

                Rectangle rectangle = new Rectangle(cX, cY, cWidth, cHeight);
                img.Crop(rectangle);

                // Put to result images object
                images.put("cropped", new FieldInfo(img.GetBase64String().GetCStr(), attributes));
            }
        }
    }

    public Map<String, FieldInfo> getFields() {
        return fields;
    }

    public Map<String, FieldInfo> getImages() {
        return images;
    }

    public Map<String, FieldInfo> getForensics() {
        return forensics;
    }

    public String getType() {
        return docType;
    }

    // Decode base64 and save to local folder. JSON file will become much lighter.
    // React Native passes the json file from the native part with the images encoded
    // in base64 for quite a long time. Flutter doesn't have this problem.
    // Visually it works faster with base64 images. Tested on Mediatek Helio G95

    private String getUriAfterImageSave(String base64, String prefix) {
        // image name
        String filename = prefix + "-" + UUID.randomUUID().toString();
        String str = null;

        byte[] dd = Base64.decode(base64, 0);

        try {
            File createTempFile = File.createTempFile(
                    filename,
                    ".jpg",
                    null // if null it become as context.getCacheDir().
            );
            OutputStream fileOutputStream = new FileOutputStream(createTempFile);
            fileOutputStream.write(dd);
            fileOutputStream.close();
            str = createTempFile.getAbsolutePath();

        } catch (IOException e) {
            Log.e("Exception", "File write failed: " + e);
        }
        return str;
    }
}