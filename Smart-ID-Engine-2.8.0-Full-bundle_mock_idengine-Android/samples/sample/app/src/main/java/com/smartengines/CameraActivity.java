/*
  Copyright (c) 2016-2026, Smart Engines Service LLC
  All rights reserved.
*/

package com.smartengines;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Rect;
import android.os.Bundle;
import android.util.Log;
import android.util.Size;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.camera.core.CameraSelector;
import androidx.camera.core.ImageAnalysis;
import androidx.camera.core.ImageProxy;
import androidx.camera.core.Preview;
import androidx.camera.core.UseCaseGroup;
import androidx.camera.core.ViewPort;
import androidx.camera.core.resolutionselector.ResolutionSelector;
import androidx.camera.core.resolutionselector.ResolutionStrategy;
import androidx.camera.lifecycle.ProcessCameraProvider;
import androidx.camera.view.PreviewView;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.databinding.DataBindingUtil;
import androidx.lifecycle.LiveData;

import com.google.common.util.concurrent.ListenableFuture;
import com.smartengines.common.Image;
import com.smartengines.common.Rectangle;
import com.smartengines.common.YUVDimensions;
import com.smartengines.common.YUVType;
import com.smartengines.databinding.ActivityCameraBinding;
import com.smartengines.id.IdResult;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * Main sample activity for documents recognition with Smart ID Engine Android SDK
 */
public class CameraActivity extends AppCompatActivity implements StateCallback {

    private final int REQUEST_CAMERA_PERMISSION = 1;

    private boolean init_once = true;
    private int imageRotationDegrees = 0;
    private final ISession session = EngineFactory.createSession();
    private Button button;
    public static boolean pauseAnalysis = true;

    private IdDraw draw;

    // Best image frame section
    public static final boolean isBestImageFrameEnabled = true;
    public static @NonNull String bestImageFrame = "";
    public static Map<String, Double> frameImageTemplatesInfo = new HashMap<>();


    PreviewView cameraView;
    ListenableFuture<ProcessCameraProvider> cameraProviderFuture;
    Executor executor = Executors.newSingleThreadExecutor();
    ActivityCameraBinding binding;
    RelativeLayout drawing;

    Context mContext;

    static int height;
    static int width;
    static Rectangle crop_rect;
    static int rotationTimes = 0;

    private long startTime;

    private TextView txtInstruction;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = DataBindingUtil.setContentView(this, R.layout.activity_camera);
        cameraProviderFuture = ProcessCameraProvider.getInstance(this);
        // Bind to UI DRAW class
        draw = new IdDraw(this.getBaseContext());
        drawing = binding.drawing;
        drawing.addView(draw);
        txtInstruction = findViewById(R.id.txtInstruction);

        // Disable Viewport by default
        binding.viewport.setVisibility(View.INVISIBLE);

        mContext = this.getBaseContext();

        button = binding.start;
        button.setVisibility(View.INVISIBLE);
        button.setEnabled(false);

        cameraView = binding.cameraView;
        // Bind label object to xml
        binding.setLabel(Label.getInstance());

        button.setOnClickListener(v -> {
            if (pauseAnalysis) {
                started();
                pauseAnalysis = false;
            } else {
                stopped();
                pauseAnalysis = true;
            }
        });

        // Subscribe to the session data
        session.getInstruction().observe(this,this::onInstructionChanged);

        // Benchmark
        startTime = System.nanoTime();

        session.initSession(this, this);

        if (permission(Manifest.permission.CAMERA))
            request(Manifest.permission.CAMERA, REQUEST_CAMERA_PERMISSION);

        /**
         * * For native Android projects you can call initCamera() without ViewTreeObserver().
         * * We use TreeObserver because of an issue with flutter! After the first call of this activity in flutter
         * * we get cameraView.getHeight() equal to 0 in all subsequent calls.
         * ** We must wait for the rendering of the cameraView to be completed.
          */
        binding.main.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                binding.main.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                initCamera();
            }
        });
    }

    private void onInstructionChanged(String instruction){
        txtInstruction.setText(instruction);
    }

    private void initCamera() {
        if (SettingsStore.isRoi) {
            /** ROI - region of interest.
             * 1. Set size of viewport hole
             * 2. Set crop in CameraX below
             * Image size for phone numbers must be 2/1 ratio!
             */
            binding.viewport.setVisibility(View.VISIBLE);
            Viewport.setRoiRectSize(cameraView.getWidth());
        }

        cameraProviderFuture.addListener(() -> {
            try {
                ProcessCameraProvider cameraProvider = cameraProviderFuture.get();
                bindPreview(cameraProvider);
            } catch (ExecutionException | InterruptedException e) {
                // No errors need to be handled for this Future.
                // This should never be reached.
            }
        }, ContextCompat.getMainExecutor(this));
    }

    private static byte[] getByteArrayFromByteBuffer(ByteBuffer byteBuffer, int rowStride) {

        /** getBuffer() - The stride after the last row may not be mapped into the buffer.
         *  This is why we always calculate the byteBuffer offset.
         *  https://developer.android.com/reference/android/media/Image.Plane#getBuffer()
         */

        int bufferSize = byteBuffer.remaining();
        // The byte array size is stride * height (the leftover spaces will be filled with 0 bytes)
        byte[] bytesArray = new byte[height * rowStride];
        byteBuffer.get(bytesArray, 0, bufferSize);
        return bytesArray;
    }

    void bindPreview(@NonNull ProcessCameraProvider cameraProvider) {

        // "cameraView.getDisplay().getRotation()" some times null object reference error
        int rotation = this.getWindowManager().getDefaultDisplay().getRotation();

        // Preview
        Preview preview = new Preview.Builder().build();
        preview.setSurfaceProvider(cameraView.getSurfaceProvider());

        // Camera
        CameraSelector cameraSelector = new CameraSelector.Builder()
                .requireLensFacing(CameraSelector.LENS_FACING_BACK)
                .build();

        // Set up the image analysis
        ImageAnalysis imageAnalysis = new ImageAnalysis.Builder()
                .setResolutionSelector(
                        new ResolutionSelector.Builder()
                                .setResolutionStrategy(
                                        new ResolutionStrategy(new Size(1200, 720), ResolutionStrategy.FALLBACK_RULE_CLOSEST_HIGHER_THEN_LOWER)
                                ).build())
                .setOutputImageFormat(ImageAnalysis.OUTPUT_IMAGE_FORMAT_YUV_420_888)
                .setTargetRotation(rotation)
                .build();

		ViewPort viewPort = ((PreviewView)findViewById(R.id.cameraView)).getViewPort();

        // Use case
        UseCaseGroup useCaseGroup = new UseCaseGroup.Builder()
                .addUseCase(preview)
                .setViewPort(viewPort)
                .addUseCase(imageAnalysis)
                .build();

        imageAnalysis.setAnalyzer(executor, image -> {
            // If image analysis is in paused state
            if (pauseAnalysis) {
                image.close();
                return;
            }
            //  initialized only once:
            if (init_once) {
                // Get sensor orientation
                imageRotationDegrees = image.getImageInfo().getRotationDegrees();
                // Calculate rotation image counts
                rotationTimes = imageRotationDegrees / 90;
                // Reset BestImageFrame vars
                bestImageFrame = "";
                frameImageTemplatesInfo.clear();
                // Cropping rectangle
                Rect crop = image.getCropRect();

                // Rotate crop rectangle if needed
                if (imageRotationDegrees == 0 || imageRotationDegrees == 180) {
                    // If smartphone in landscape - NOT TESTED

                    // width = image.getWidth(); // ~1280
                    // height = image.getHeight(); // ~960
                    // // Set scale for canvas drawing
                    // int heightPreview = binding.cameraView.getWidth();
                    // IdDraw.scale = (float) heightPreview / (float) height;
                    // // Calculate crop rectangle
                    // crop_rect = new Rectangle(crop.left, crop.top, crop.right - crop.left, crop.bottom);
                } else {
                    width = image.getWidth(); // ~1280
                    height = image.getHeight(); // ~960

                    // Set scale for canvas drawing
                    int heightPreview = cameraView.getHeight();
                    IdDraw.scale = (float) heightPreview / (float) width;
                    // Reset points offset.
                    IdDraw.translate_x = 0;
                    IdDraw.translate_y = 0;
                    // Calculate crop rectangle
					int c_height = crop.bottom - crop.top;
					int c_width = crop.right - crop.left;

					/**
					* Rectangle:
					* int x, X-coordinate of the top-left corner
					* int y, Y-coordinate of the top-left corner
					* int width, Width of the rectangle
					* int height, Height of the rectangle
					*/

					crop_rect = new Rectangle(crop.top, crop.left, c_height, c_width);

                    if (SettingsStore.isRoi) {
                        // get crop roi rectangle
                        crop_rect = Viewport.getCropRoiRectangle(width, height, crop_rect.getWidth());
                        // Set points offset
                        IdDraw.translate_x = Viewport.ViewRoiRect.left;
                        IdDraw.translate_y = Viewport.ViewRoiRect.top;
                    }
                }
                init_once = false;
            }

            IdResult result=null;

            // Try recognition
            try {

                /**
                 * Example for OUTPUT_IMAGE_FORMAT_YUV_420_888
                 * According to our tests RGBA_8888 has ~45ms overhead per frame (tested on Helio G90T)
                 * https://developer.android.com/reference/android/graphics/ImageFormat#YUV_420_888
                 */

                ImageProxy.PlaneProxy planeY = image.getPlanes()[0];
                ImageProxy.PlaneProxy planeU = image.getPlanes()[1];
                ImageProxy.PlaneProxy planeV = image.getPlanes()[2];

                YUVDimensions yuvDimensions = new YUVDimensions(
                        planeY.getPixelStride(), planeY.getRowStride(),
                        planeU.getPixelStride(), planeU.getRowStride(),
                        planeV.getPixelStride(), planeV.getRowStride(),
                        width, height, YUVType.YUVTYPE_420_888);

                Image frame = Image.FromYUV(
                        getByteArrayFromByteBuffer(planeY.getBuffer(), planeY.getRowStride()),
                        getByteArrayFromByteBuffer(planeU.getBuffer(), planeU.getRowStride()),
                        getByteArrayFromByteBuffer(planeV.getBuffer(), planeV.getRowStride()),
                        yuvDimensions);

                /** Example for OUTPUT_IMAGE_FORMAT_RGBA_8888
                 *
                 *  ImageProxy.PlaneProxy planeRGBA = image.getPlanes()[0];
                 *  int stride = planeRGBA.getRowStride();
                 *
                 *  ByteBuffer bufferRGBA = planeRGBA.getBuffer();
                 *  byte[] frame_bytes = new byte[bufferRGBA.remaining()];
                 *  bufferRGBA.get(frame_bytes);
                 *  Image frame = Image.FromBufferExtended(frame_bytes, height, width, stride, ImagePixelFormat.IPF_RGBA, 1);
                 */

                // String base64_test_string = frame.GetBase64String().GetCStr();
                frame.Rotate90(rotationTimes);
                //String base64_test_string2 = frame.GetBase64String().GetCStr();

                /** According to our tests without cropping frame (W=546 H=1088) for image (W=1088 H=1088)
                 * the recognition speed decreases by ~125ms per frame (tested on Helio G90T)
                 */

                frame.Crop(crop_rect);
                // String base64_test_string3 = frame.GetBase64String().GetCStr();
                session.processFrame(frame);
                result = session.getResult();

                // Best image frame section
                if (isBestImageFrameEnabled) {
                    // NOTE: Do not forget to reset bestImageFrame and frameImageTemplatesInfo vars
                    // on new recognition!
                    bestDocumentFrameFinder(result, frame);
                }
                Log.d("SMARTENGINES", "FRAME EVENT");

            } catch (Exception e) {
                error(e.getMessage());
                finish();
                return;
            }

            // Draw overlay
            draw.showMatching(result);

            //Getting intermediate results during the recognition session:
            /** runOnUiThread(() -> {
                // for flutter
                IdEngineModulePlugin.streamRecognized(result, (int) (Math.random() * 100));
                // for react-native
                IdEngineReactModule.streamRecognized(result, (int) (Math.random() * 100));
            }); */

            if (session.isSessionEnded()) {
                // The result is terminal when the engine decides that the recognition result
                // has had enough information and ready to produce result, or when the session
                // is timed out
                Log.d("SMARTENGINES", "ENGINE TERMINATED...");

                // This will stop data from streaming
                imageAnalysis.clearAnalyzer();

                runOnUiThread(() -> {
                    recognized(session.getResult());
                    this.session.reset();
                });
            }
            image.close();
        });
        cameraProvider.unbindAll();
        cameraProvider.bindToLifecycle(this, cameraSelector, useCaseGroup);
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////

    void toast(final String message) {

        runOnUiThread(() -> {
            Toast t = Toast.makeText(getApplicationContext(), message, Toast.LENGTH_LONG);
            t.show();
        });
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////

    public boolean permission(String permission) {
        int result = ContextCompat.checkSelfPermission(this, permission);
        return result != PackageManager.PERMISSION_GRANTED;
    }

    public void request(String permission, int request_code) {
        ActivityCompat.requestPermissions(this, new String[]{permission}, request_code);
    }

    @Override
    public void onRequestPermissionsResult(
            int requestCode, String permissions[], int[] grantResults) {
        switch (requestCode) {
            case REQUEST_CAMERA_PERMISSION: {
                boolean granted = false;
                for (int grantResult : grantResults) {
                    if (grantResult == PackageManager.PERMISSION_GRANTED) { // Permission is granted
                        granted = true;
                    }
                }
                if (granted) {
                    // view.updatePreview();
                } else {
                    error("Please allow Camera permission");
                }
            }
            default: {
                super.onRequestPermissionsResult(requestCode, permissions, grantResults);
            }
        }
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////

    private void bestDocumentFrameFinder(IdResult result, Image image) {
        if(result==null) return;

        // If no template found
        if (result.GetTemplateDetectionResultsCount() == 0) {
            return;
        }

        boolean isNewConfidenceBetter = true;

        // Check document templates
        for (int i = 0; i < result.GetTemplateDetectionResultsCount(); i++) {

            boolean not_fully_presented = false;
            // Get template name
            String templateName = result.GetTemplateDetectionResult(i).GetTemplateName();
            // Get template confidence - quality of the document detection
            Double confidence = result.GetTemplateDetectionResult(i).GetConfidence();

            // Checking that document template outside viewport, not fully presented on
            // image frame
            if (result.GetTemplateDetectionResult(i).HasAttribute("fully_presented")) {
                if (Objects.equals(result.GetTemplateDetectionResult(i).GetAttribute("fully_presented"), "false")) {
                    not_fully_presented = true;
                }
            }
            // Set confidence to 0.0 if the points of a document quadrangle outside the
            // viewport.
            if (not_fully_presented) {
                confidence = 0.0;
            }

            // Add new template to store if not exist.
            // Every new template will be update frameImage
            if (!frameImageTemplatesInfo.containsKey(templateName)) {
                frameImageTemplatesInfo.put(templateName, confidence);
                bestImageFrame = image.GetBase64String().GetCStr();
            }

            // Checking new confidence. We must update imageFrame if any confidence
            // from all templates will be higher than saved before.
            if (isNewConfidenceBetter) {
                Double old_confidence = frameImageTemplatesInfo.get(templateName);
                if (old_confidence >= confidence) {
                    isNewConfidenceBetter = false;
                }
            }
        }

        // Update imageFrame if confidence from all templates better than previous
        if (isNewConfidenceBetter) {

            // Update template confidences
            for (int i = 0; i < result.GetTemplateDetectionResultsCount(); i++) {
                String templateName = result.GetTemplateDetectionResult(i).GetTemplateName();
                Double confidence = result.GetTemplateDetectionResult(i).GetConfidence();
                frameImageTemplatesInfo.put(templateName, confidence);
            }
            // Update document_frame
            bestImageFrame = image.GetBase64String().GetCStr();
        }
    }


    @Override
    public void initialized(boolean engine_initialized) {
        if (engine_initialized) {
            // enable buttons
            button.setEnabled(true);
            button.setVisibility(View.VISIBLE);


            long elapsedTime = System.nanoTime() - startTime;
            long t = TimeUnit.MILLISECONDS.convert(elapsedTime, TimeUnit.NANOSECONDS);
            Label.getInstance().message.set("Engine Ready: " + t + "ms");
        }
    }

    @Override
    public void recognized(IdResult result) {
        pauseAnalysis = true;
        double elapsedTime = System.nanoTime() - startTime;
        double t = TimeUnit.MILLISECONDS.convert((long) elapsedTime, TimeUnit.NANOSECONDS);

        toast("Time:" + t);
        Log.i("== se_recognized: ==" , ""+ t +"");


        ResultStore.instance.addResult(result);
        Intent intent = new Intent();

        setResult(RESULT_OK, intent);
        finish();
    }

    @Override
    public void started() {
        startTime = System.nanoTime();
        button.setText("CANCEL");
    }

    @Override
    public void stopped() {
        finish();
    }

    @Override
    public void error(String message) {
        Log.e("SmartEngines", message);
        toast(message);
    }
}
