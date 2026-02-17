/**
  Copyright (c) 2016-2025, Smart Engines Service LLC
  All rights reserved.
*/

wasm_module = ""


// Init recognition engine
function createEngine(SE, MODULE){
  try {
    console.time("Create Engine");
    ENGINE = new SE.seIdEngine(true, 1, true);
    console.timeEnd("Create Engine");
    wasm_module = SE

    readyEmitter({ version: SE.seIdEngineGetVersion() + " / " + MODULE + " / ", doclist: getAvailableDocList(ENGINE), areFacesAvailable: getFacesAvailability(ENGINE) });
  } catch (e) {
    errorEmitter({ message: e, SE });
  }
  return ENGINE;
}

// Used for runtime calculation
let PERFSTART;

// Check if session is activated, and start recognizing if it is
const checkSession = async (spawnedSession, ENGINE_CONFIG) => {
  // Is session already activated? (In case of images from canvas)
  self.PERFSTART = performance.now();
  if (spawnedSession.IsActivated()) {
    logEmitter({ message: "✅ Already activated." });
    return;
  }

  // Send request to activation server
  logEmitter({ message: "⏳ Sending activation request..." });
  // Get dynamic key
  const dynKey = spawnedSession.GetActivationRequest();
  // Get response from activation server
  const response = await fetch(ENGINE_CONFIG.activationUrl, {
    method: "POST",
    //mode: 'no-cors', // no-cors, *cors, same-origin
    headers: { "Content-Type": "text/plain" }, // text/plain requests don't trigger a CORS preflight.
    body: JSON.stringify({ action: "activate_id_session", message: dynKey }), //`{"action": "activate_id_session", "message": "${dynKey}" }`,
    signal: AbortSignal.timeout(3000),
  });

  if (!response.ok) {
    let desc = await response.json();
    throw new Error(desc.message);
  }

  const desc = await response.json();
  // Response is ok, activate session
  spawnedSession.Activate(desc.message);
  // self.PERFSTART = performance.now();

  logEmitter({ message: "✉ Activation done. Waiting for recognition..." });
};
// Load image from file pre-loaded in a buffer
function ImageFromRGBbytes(imageData, SE) {
  return new SE.seImage(imageData);
}
// Load image from pixels buffer
function ImageFromRGBAbytes(canvas, SE) {
  const width = canvas.width;
  const height = canvas.height;
  const rawData = canvas.data.buffer;
  const channels = rawData.byteLength / (height * width); // Number of channels
  const stride = channels >= 3 ? rawData.byteLength / height : width; // Stride calculation
  return new SE.seImageFromBuffer(rawData, width, height, stride, channels);
}

// Match two faces with each other
const faceMatching = async (faceData, engine, ENGINE_CONFIG, SE) => {
  const faceA = ImageFromRGBbytes(faceData.faceA, SE);
  const faceB = ImageFromRGBbytes(faceData.faceB, SE);

  // Debug:
  //console.log('FaceA:')
  //console.log(faceA.GetBase64String())
  //console.log('FaceB:')
  //console.log(faceB.GetBase64String())

  // 1. Create session settings
  const faceSettings = engine.CreateFaceSessionSettings();
  // 2. Spawn session
  const faceSession = engine.SpawnFaceSession(faceSettings, ENGINE_CONFIG.signature);
  // 3. Activate session
  await checkSession(faceSession, ENGINE_CONFIG);
  // 4. Performing face matching between two images
  const result = faceSession.GetSimilarity(faceA, faceB);

  const similarity_estimation = result.GetSimilarityEstimation();
  const similarity_result = result.GetSimilarity();
  similarity = ""
  if (similarity_result == wasm_module.seIdFaceSimilarity.Uncertain) {
    similarity = "uncertain"
  }
  else if (similarity_result == wasm_module.seIdFaceSimilarity.Same){
    similarity = "same"
  }
  else if (similarity_result == wasm_module.seIdFaceSimilarity.Different){
    similarity = "different"
  }

  return { requestType: "faceResult", similarity_estimation: similarity_estimation.toFixed(4), similarity: similarity, time: timeDiff() };
};

// Recognize image from file
async function recognizeFile(data, ENGINE, ENGINE_CONFIG, SE) {
  // 1. Create session
  let spawnedSessionRGB = createRGBSession(ENGINE, ENGINE_CONFIG);
  // 2. Activate session
  await checkSession(spawnedSessionRGB, ENGINE_CONFIG);
  // 3. Create image
  const image = ImageFromRGBbytes(data, SE);
  // 4. Get recognition result
  const result = spawnedSessionRGB.Process(image);

  const resultMessage = resultObject(result, image.GetSize());

  // Free the memory!
  image.delete();
  result.delete();
  spawnedSessionRGB.Reset();

  return resultMessage;
}

// Frame processing method
function recognizeFrame(image, spawnedSessionRGBA) {

  let result;

  try {

    result = spawnedSessionRGBA.Process(image);

    /* We must feed the system if it still feels image hungry */
    if (!result.GetIsTerminal()) {
      return {
        requestType: "FeedMeMore",
        templateDetection: getTemplateDetection(result),
        templateSegmentation: getTemplateSegmentation(result),
      };
    }

    return resultObject(result, image.GetSize());


  } finally {
    // Always free native resources!!
    if (result.GetIsTerminal()) spawnedSessionRGBA.Reset();
    result.delete();
    image.delete();
  }
}

// Used for image sequence
function createRGBASession(engine, ENGINE_CONFIG) {
  let sessionSettings = engine.CreateSessionSettings();
  sessionSettings.SetCurrentMode(ENGINE_CONFIG.mode);
  sessionSettings.AddEnabledDocumentTypes(ENGINE_CONFIG.docTypes);
  sessionSettings.SetOption("common.extractTemplateImages", "true");
  sessionSettings.SetOption("common.sessionTimeout", "5.0");
  // images from canvas has RGBA pixel format
  sessionSettings.SetOption("common.rgbPixelFormat", "RGBA");

  spawnedSession = engine.SpawnSession(sessionSettings, ENGINE_CONFIG.signature);

  return spawnedSession;
}

// Used for file
function createRGBSession(engine, ENGINE_CONFIG) {
  let sessionSettings = engine.CreateSessionSettings();
  sessionSettings.SetCurrentMode(ENGINE_CONFIG.mode);
  sessionSettings.AddEnabledDocumentTypes(ENGINE_CONFIG.docTypes);
  sessionSettings.SetOption("common.extractTemplateImages", "true");
  sessionSettings.SetOption("common.sessionTimeout", "5.0");

  let spawnedSession = engine.SpawnSession(sessionSettings, ENGINE_CONFIG.signature);

  return spawnedSession;
}

// code from wasm-feature-detect.js
const getModuleName = async () => {
  const a = async (e) => {
    try {
      return "undefined" != typeof MessageChannel && new MessageChannel().port1.postMessage(new SharedArrayBuffer(1)), WebAssembly.validate(e);
    } catch (e) {
      return !1;
    }
  };

  const simd = async () => WebAssembly.validate(new Uint8Array([0, 97, 115, 109, 1, 0, 0, 0, 1, 5, 1, 96, 0, 1, 123, 3, 2, 1, 0, 10, 10, 1, 8, 0, 65, 0, 253, 15, 253, 98, 11]));
  const threads = () => a(new Uint8Array([0, 97, 115, 109, 1, 0, 0, 0, 1, 4, 1, 96, 0, 0, 3, 2, 1, 0, 5, 4, 1, 3, 1, 1, 10, 11, 1, 9, 0, 65, 0, 254, 16, 2, 0, 26, 11]));

  const hasSimd = await simd();
  // const hasThreads = await threads();
  const hasThreads = false;

  let module;

  if (hasSimd === true) {
    hasThreads //hasThreads
      ? (module = "simd.threads")
      : (module = "simd.nothreads");
  } else {
    module = "nosimd.nothreads";
  }

  return module;
};

// postMessages for errors for UI thread
const errorEmitter = (data) => {
  // It doesn't look good, but so far it's the only way to get string exceptions from WASM
  if (typeof data.message === "number") {
    try {
      data.message = "❌ " + data.SE.getExceptionMessage(data.message);
    } catch (e) {
      /* empty */
    }
  }
  console.error(data.message);
  // Some worker objects cannot be cloned to UI thread. Delete it.
  delete data["SE"];
  data.type = "error";
  postMessage({ requestType: "eventChannel", data });
};

// Event for ready state
const readyEmitter = (data) => {
  data.type = "ready";
  postMessage({ requestType: "eventChannel", data });
};

// Event for printing messages in log in UI side
const logEmitter = (data) => {
  data.type = "log";
  postMessage({ requestType: "eventChannel", data });
};

// Process runtime calculation
const timeDiff = () => ((performance.now() - self.PERFSTART) / 1000).toFixed(2);

//
const getArrFromPoints = (q) => [q.GetPoint(0), q.GetPoint(1), q.GetPoint(2), q.GetPoint(3)];

// Prepare result object for worker response
function resultObject(result, templateSize) {
  const templateDetection = getTemplateDetection(result);
  const templateSegmentation = getTemplateSegmentation(result);

  return {
    requestType: "result",
    docType: result.GetDocumentType(),
    data: getTextFields(result),
    images: getImageFields(result, templateDetection, templateSegmentation, templateSize),
    time: timeDiff(),
  };
}

// Get text fields in result
function getTextFields(result) {
  const data = {};
  const tf = result.TextFieldsBegin();
  for (; !tf.Equals(result.TextFieldsEnd()); tf.Advance()) {
    const key = tf.GetKey();
    const field = tf.GetValue();
    let value = field.GetValue().GetFirstString();

    // In IdEngine all barcode results return in base64.
    // If the barcode result is decoded in base64 format, decode it
    if (field.GetBaseFieldInfo().HasAttribute("encoding")) {
      if (field.GetBaseFieldInfo().GetAttribute("encoding") === "base64") {
        const data = atob(value);
        const length = data.length;
        const bytes = new Uint8Array(length);

        for (let i = 0; i < length; i++) {
          bytes[i] = data.charCodeAt(i);
        }

        const decoder = new TextDecoder(); // default is utf-8
        value = decoder.decode(bytes);
      }
    }

    data[key] = {
      name: key,
      value: value,
      isAccepted: field.GetBaseFieldInfo().GetIsAccepted(),
      attr: {},
    };

  }

  return data;
}

// Get images fields in result
function getImageFields(result, templateDetection, templateSegmentation, imageSize) {
  const images = {};

  // add svg masks for segmentation demonstration in total result
  images.mask = _getSvgQuads(imageSize, templateDetection, templateSegmentation);
  const img = result.ImageFieldsBegin();
  for (; !img.Equals(result.ImageFieldsEnd()); img.Advance()) {
    const key = img.GetKey();
    const field = img.GetValue();
    images[key] = _base64toBlob(field.GetValue().GetBase64String());
  }

  return images;
}

// Convert base64 images to blob urls for better reuse in UI
function _base64toBlob(data) {
  const b = atob(data);
  const byteNumbers = new Array(b.length);
  for (let i = 0; i < b.length; i++) {
    byteNumbers[i] = b.charCodeAt(i);
  }
  const byteArray = new Uint8Array(byteNumbers);
  const file = new Blob([byteArray], { type: "image/jpg" + ";base64" });
  return URL.createObjectURL(file);
}

// Create SVG file from feedback data in result
function _getSvgQuads(imageSize, templateDetection, templateSegmentation) {
  let areas = "";
  let fields = "";

  if (templateDetection) {
    for (let i = 0; i < templateDetection.length; i++) {
      const p = templateDetection[i];
      let arr = [p[0].x, p[0].y, p[1].x, p[1].y, p[2].x, p[2].y, p[3].x, p[3].y];
      areas += `<polygon points="${arr.join(" ")}" class="areas" />`;
    }
  }
  if (templateSegmentation) {
    for (let i = 0; i < templateSegmentation.length; i++) {
      const p = templateSegmentation[i];
      let arr = [p[0].x, p[0].y, p[1].x, p[1].y, p[2].x, p[2].y, p[3].x, p[3].y];

      fields += `<polygon points="${arr.join(" ")}" class="fields" />`;
    }
  }

  let svg = `<svg height="${imageSize.height}" width="${imageSize.width}"  xmlns="http://www.w3.org/2000/svg">
                  <style type="text/css" >
                  <![CDATA[
                      .areas {
                          stroke: #989898;
                          fill: #e6e6e6;
                          stroke-width: 5px;
                          stroke-dasharray: 25;
                      }
                      .fields {
                          stroke: #909090;
                          fill: none;
                          stroke-width: 3;
                      }
                  ]]>
              </style>
              ${areas}
              ${fields}
              </svg>
      `;

  let blob = new Blob([svg], { type: "image/svg+xml" });
  let url = URL.createObjectURL(blob);
  return url;
}

/** Parse Template Detection from result
 *  GetTemplateDetectionResultsCount - Returns the number of detected document pages (templates).
 *  GetTemplateDetectionResult: Returns the document page (template) detection result by index.
 *  (Rectangles of document, photo and etc).
 */

function getTemplateDetection(result) {
  const arr = [];

  for (let i = 0; i < result.GetTemplateDetectionResultsCount(); i++) {
    const templateResult = result.GetTemplateDetectionResult(i);
    const q = templateResult.GetQuadrangle();
    arr.push(getArrFromPoints(q));
  }
  return arr;
}

/** Parse Template Segmentation from result
 *  GetTemplateSegmentationResultsCount - Returns the number of document page
 *  (templates) segmentation results.
 *  GetTemplateSegmentationResult: Returns the document page (template)
 *  segmentation result by index.
 *  Rectangles of mrz zones and other text fields.
 */

function getTemplateSegmentation(result) {
  const arr = [];
  for (let i = 0; i < result.GetTemplateSegmentationResultsCount(); i++) {
    // sr = IdTemplateSegmentationResult
    const sr = result.GetTemplateSegmentationResult(i);
    // qmi = QuadranglesMapIterator
    let qmi = sr.RawFieldQuadranglesBegin();
    for (; !qmi.Equals(sr.RawFieldQuadranglesEnd()); qmi.Advance()) {
      const q = qmi.GetValue();
      arr.push(getArrFromPoints(q));
    }
  }
  return arr;
}

function getFacesAvailability(engine){
  let areFacesAvailable 
  try {
    const faceSessionSettings = engine.CreateFaceSessionSettings();
    areFacesAvailable = true
  } catch (err) {
    areFacesAvailable = false
  }
  return areFacesAvailable
}

// Get available document lists in your SDK
function getAvailableDocList(engine) {
  const sessionSettings = engine.CreateSessionSettings();

  let arr = [];
  const ie = sessionSettings.SupportedModesBegin();
  for (; !ie.Equals(sessionSettings.SupportedModesEnd()); ie.Advance()) {
    let mode = ie.GetValue();
    sessionSettings.SetCurrentMode(mode);

    console.log("🔸Mode : " + ie.GetValue());
    const dd = sessionSettings.PermissiblePrefixDocMasksBegin();
    for (; !dd.Equals(sessionSettings.PermissiblePrefixDocMasksEnd()); dd.Advance()) {
      arr.push(mode + ":" + dd.GetValue());
      console.log("▪ " + dd.GetValue());
    }
  }
  return arr;
}
