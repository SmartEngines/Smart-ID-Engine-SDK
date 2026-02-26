# Smart ID Engine SDK Overview

This is a collection of DEMO builds of Smart ID Engine SDK developed by Smart Engines. The SDK examples can be used to demonstrate the integration possibilities and understand the basic object recognition workflows.


  * [:warning: Personalized signature :warning:](#warning-personalized-signature-warning)
  * [Troubleshooting and Help](#troubleshooting-and-help)
  * [General Usage Workflow](#general-usage-workflow)
  * [Smart ID SDK Description](#smart-id-sdk-description)
    - [Code Documentation](#code-documentation)
    - [Header Files, Namespaces, and Modules](#header-files-namespaces-and-modules)
    - [Factory Methods and Memory Ownership](#factory-methods-and-memory-ownership)
    - [Exceptions](#exceptions)
    - [Configuration Bundles](#configuration-bundles)
    - [Specifying Document Types for IdSession](#specifying-document-types-for-idsession)
    - [Supported Document Types](#supported-document-types)
    - [Enabling Document Types Using Wildcard Expressions](#enabling-document-types-using-wildcard-expressions)
    - [Session Modes](#session-modes)
    - [Session Options](#session-options)
      - [Common Options](#common-options)
    - [Face Similarity Detection](#face-similarity-detection)
    - [Face Liveness Detection](#face-liveness-detection)
    - [Processing Feedback](#processing-feedback)
    - [Java API Specifics](#java-api-specifics)
      - [Object Deallocation](#object-deallocation)
      - [Feedback Scope](#feedback-scope)
* [PDF Recognition](#pdf-recognition)
* [Integration of the REST API Server with ERP Systems](#integration-of-the-rest-api-server-with-erp-systems)
* [FAQ](#faq)


## :warning: Personalized Signature :warning:

Starting from Smart ID Engine v1.4.0 users are required to use a personalized signature for starting a session. The signature is validated offline and locks to the copy of the native library, thus ensures that only an authorized client may use it. The signature is a string with 256 characters.

You will need to manually copy the signature string and pass it as an argument for the `SpawnSession()` method ([see item 6 below](#general-usage-workflow)). Do NOT keep the signature in any asset files, only inside code. If possible, clients are encouraged to keep the signature in a controlled server and load it into the application via a secure channel, to ensure that signature and the library are separated.

## Troubleshooting and Help

To resolve issue that you might be facing we recommend to do the following:

* Carefully read in-code documentation in API and samples and documentation in .pdf and .html, including this document;
* Check out the code details / compilation flags etc. in the sample code and projects;
* Read exception messages if an exception is thrown: they may contain useful information.

But remember:
* You are always welcome to ask for help at `support@smartengines.com` (or your sales manager's email) no matter what.

## General Usage Workflow

1. Create `IdEngine` instance:

    ```cpp
    // C++
    std::unique_ptr<se::id::IdEngine> engine(se::id::IdEngine::Create(
        configuration_bundle_path));
    ```

    ```java
    // Java
    IdEngine engine = IdEngine.Create(configuration_bundle_path);
    ```

    Configuration process can take a while, but it only needs to be performed once during the program lifetime. Configured `IdEngine` is used to spawn IdSessions which have actual recognition methods.

    The second parameter to the `Create()` method is a boolean flag for enabling lazy configuration (`true` by default). If lazy configuration is enabled, some of the internal structured will be allocated and initialized only when first needed. If you disable the lazy configuration, all the internal structures and components will be initialized in the `Create()` method.

    See more about configuration bundles in [Configuration Bundles](#configuration-bundles).

2. Create `IdSessionSettings` from configured `IdEngine`:

    ```cpp
    // C++
    std::unique_ptr<se::id::IdSessionSettings> settings(
          engine->CreateSessionSettings());
    ```

    ```java
    // Java
    IdSessionSettings settings = engine.CreateSessionSettings();
    ```

    Note, that `IdEngine::CreateSessionSettings()` is a factory method and returns an allocated pointer. You are responsible for deleting it.

3. Enable desired document types:

    ```cpp
    // C++
    settings->AddEnabledDocumentTypes("deu.id.*"); // Enabling German ID cards in this session
    ```

    ```java
    // Java
    settings.AddEnabledDocumentTypes("deu.id.*"); // Enabling German ID cards in this session
    ```

    See more about document types in [Specifying document types for IdSession](#specifying-document-types-for-idsession).

4. Specify additional session options (not required):

    ```cpp
    // C++
    settings->SetOption("common.extractTemplateImages", "true"); // Forcing to acquire full template images
    ```

    ```java
    // Java
    settings.SetOption("common.extractTemplateImages", "true"); // Forcing to acquire full template images
    ```

    See more about options in [Session Options](#session-options).

5. Subclass IdFeedback and implement callbacks (not required):

    ```cpp
    // C++
    class MyFeedback : public se::id::IdFeedback { /* callbacks */ };

    // ...

    MyFeedback my_feedback;
    ```

    ```java
    // Java
    class MyFeedback extends IdFeedback { /* callbacks */ }

    // ...

    MyFeedback my_feedback = new MyFeedback();
    ```

    See more about callbacks in [Processing Feedback](#processing-feedback).

6. Spawn IdSession:

    ```cpp
    // C++
    const char* signature = "... YOUR SIGNATURE HERE ...";
    std::unique_ptr<se::id::IdSession> session(
        engine->SpawnSession(*settings, signature, &my_feedback));
    ```

    ```java
    // Java
    String signature = "... YOUR SIGNATURE HERE ...";
    IdSession session = engine.SpawnSession(settings, signature, my_feedback); 
    ```

    For explanation of signatures, [see above](#warning-personalized-signature-warning).

7. Create an Image object which will be used for processing:

    ```cpp
    // C++
    std::unique_ptr<se::common::Image> image(
        se::common::Image::FromFile(image_path)); // Loading from file
    ```

    ```java
    // Java
    Image image = Image.FromFile(image_path);
    ```

8. Call `Process(...)` method for processing the image:

    ```cpp
    // C++
    const se::id::IdResult& result = session->Process(*image);
    ```

    ```java
    // Java
    IdResult result = session.Process(image);
    ```

    When performing recognition in video stream you might want to process frames coming from the stream until `result.GetIsTerminal()` is `true`.

9. Use `IdResult` fields to extract recognized information:

    ```cpp
    // C++
    for (auto it = result.TextFieldsBegin(); it != result.TextFieldsEnd(); ++it) {
        const se::id::IdTextField& field = it.GetValue();

        bool is_accepted = field.GetBaseFieldInfo().GetIsAccepted(); // Accept flag value
        std::string field_value = field.GetValue().GetFirstString().GetCStr(); // UTF-8 string representation of the recognized result
    }
    ```

    ```java
    // Java
    for (IdTextFieldsMapIterator it = result.TextFieldsBegin();
         !it.Equals(result.TextFieldsEnd());
         it.Advance()) {
        IdTextField field = it.GetValue();

        boolean is_accepted = field.GetBaseFieldInfo().GetIsAccepted(); // Accept flag value
        String field_value = field.GetValue().GetFirstString().GetCStr(); // UTF-8 string representation of the recognized result
    }
    ```

    Apart from the text fields there also are image fields and other types of fields:

    ```cpp
    // C++
    for (auto it = result.ImageFieldsBegin(); it != result.ImageFieldsEnd(); ++it) {
        const se::id::IdImageField& field = it.GetValue();

        const se::common::Image& image = field.GetValue();
    }
    ```

    ```java
    // Java
    for (IdImageFieldsMapIterator it = result.ImageFieldsBegin(); 
        !it.Equals(result.ImageFieldsEnd());
         it.Advance()) {
        IdImageField field = it.GetValue();

        Image image = field.GetValue();
    }
    ```

## Smart ID SDK Description

### Code Documentation

All classes and functions have useful Doxygen comments.
Other out-of-code documentation is available at `doc` folder of your delivery.
For complete compilable and runnable sample usage code and build scripts please see `samples` folder.

### Header Files, Namespaces and Modules
Common classes, such as Point, OcrString, Image, etc. are located within `se::common` namespace and are located within a `secommon` directory:

```cpp
// C++
#include <secommon/se_export_defs.h>      // This header contains export-related definitions of Smart Engines libraries
#include <secommon/se_exceptions.h>       // This header contains the definition of exceptions used in Smart Engines libraries
#include <secommon/se_geometry.h>         // This header contains geometric classes and procedures (Point, Rectangle, etc.)
#include <secommon/se_image.h>            // This header contains the definition of the Image class 
#include <secommon/se_string.h>           // This header contains the string-related classes (MutableString, OcrString, etc.)
#include <secommon/se_strings_iterator.h> // This header contains the definition of string-targeted iterators
#include <secommon/se_serialization.h>    // This header contains auxiliary classes related to object serialization (not used in Smart ID Engine)

#include <secommon/se_common.h>           // This is an auxiliary header which simply includes all of the above
```

The same common classes in Java API are located within `com.smartengines.common` module:

```java
// Java
import com.smartengines.common.*; // Import all se::common classes
```

Main Smart ID Engine classes are located within `se::id` namespaces and are located within an `idengine` directory:

```cpp
// C++
#include <idengine/id_engine.h>                 // Contains IdEngine class definition
#include <idengine/id_session_settings.h>       // Contains IdSessionSettings class definition
#include <idengine/id_session.h>                // Contains IdSession class definition
#include <idengine/id_result.h>                 // Contains IdResult class definition, as well as IdTemplateDetectionResult and IdTemplateSegmentationResult
#include <idengine/id_fields.h>                 // Contains the definitions of classes representing Smart ID Engine fields
#include <idengine/id_feedback.h>               // Contains the IdFeedback interface and associated containers

#include <idengine/id_face_feedback.h>          // Contains the IdFaceFeedback interface
#include <idengine/id_face_session_settings.h>  // Contains IdFaceSessionSettings class definition
#include <idengine/id_face_session.h>           // Contains IdFaceSession class definition
#include <idengine/id_face_result.h>            // Contains classes representing the Face matching result-related objects

#include <idengine/id_field_processing_session_settings.h>      // Contains IdFieldProcessingSessionSettings class definition
#include <idengine/id_field_processing_session.h>               // Contains the definition of the session for auxiliary fields processing
```

The same classes in Java API are located within `com.smartengines.id` module:

```java
// Java
import com.smartengines.id.*; // Import all se::id classes
```

### Factory Methods and Memory Ownership

Several Smart ID Engine SDK classes have factory methods which return pointers to heap-allocated objects.  **Caller is responsible for deleting** such objects _(a caller is probably the one who is reading this right now)_.
We recommend using `std::unique_ptr<T>` for simple memory management and avoiding memory leaks.

In Java API for the objects which are no longer needed it is recommended to use `.delete()` method to force the deallocation of the native heap memory.

### Exceptions

Our C++ API may throw `se::common::BaseException` subclasses when user passes invalid input, makes bad state calls or if something else goes wrong. Most exceptions contain useful human-readable information. Please read `e.what()` message if exception is thrown. Note that `se::common::BaseException` is **not** a subclass of `std::exception`, an Smart ID Engine interface in general do not have any dependency on the STL.

The thrown exceptions are wrapped in general `java.lang.Exception`, so in Java API do catch those.

### Configuration Bundles

Every delivery contains one or several _configuration bundles_ – archives containing everything needed for Smart ID Engine to be created and configured. Usually they are named as `bundle_something.se` and located inside `data-zip` folder.

### Specifying Document Types for IdSession

Assuming you already created the engine and session settings like this:

```cpp
// C++
// create recognition engine with configuration bundle path
std::unique_ptr<se::id::IdEngine> engine(
    se::id::IdEngine::Create(configuration_bundle_path));

// create session settings with se::id::IdEngine factory method
std::unique_ptr<se::id::IdSessionSettings> settings(
    engine->CreateSessionSettings());
```

```java
// Java
// create recognition engine with configuration bundle path
IdEngine engine = IdEngine.Create(configuration_bundle_path);

// create session settings with IdEngine factory method
IdSessionSettings settings = engine.CreateSessionSettings();
```

In order to call `engine->SpawnSession(...)` you need to specify enabled document types for session to be spawned using `IdSessionSettings` methods. **By default, all document types are disabled.**

#### Supported Document Types

A _document type_ is simply a string encoding real world document type you want to recognize, for example, `rus.passport.national` or `deu.id.type1`. Document types that Smart ID Engine SDK delivered to you can potentially recognize can be obtaining using the following procedure:

```cpp
// C++ 
// Iterating though internal engines
for (auto engine_it = settings->InternalEngineNamesBegin();
     engine_it != settings->InternalEngineNamesEnd();
     ++engine_it) {
    // Iterating though supported document types for this internal engine
    for (auto it = settings->SupportedDocumentTypesBegin(engine_it.GeValue());
         it != settings->SupportedDocumentTypesEnd(engine_it.GetValue());
         ++it) {
        // it.GetValue() returns the supported document type within the 
        // internal engine with name engine_it.GetValue()
    }
}
```

```java
// Java
// Iterating though internal engines
for (StringsSetIterator engine_it = settings.InternalEngineNamesBegin();
     !engine_it.Equals(settings.InternalEngineNamesEnd());
     engine_it.Advance()) {
    // Iterating though supported document types for this internal engine
    for (StringsSetIterator it = settings.SupportedDocumentTypesBegin(engine_it.GeValue());
         !it.Equals(settings.SupportedDocumentTypesEnd(engine_it.GetValue()));
         it.Advance()) {
        // it.GetValue() returns the supported document type within the 
        // internal engine with name engine_it.GetValue()
    }
}
```

**In a single session you can only enable document types that belong to the same internal engine**.

#### Enabling Document Types Using Wildcard Expressions

Since all documents in settings are disabled by default you need to enable some of them.
In order to do so you may use `AddEnabledDocumentTypes(...)` method of `IdSessionSettings`:

```cpp
// C++
settings->AddEnabledDocumentTypes("deu.id.type1"); // Enables German ID card of the 1st type
```

```java
// Java
settings.AddEnabledDocumentTypes("deu.id.type1"); // Enables German ID card of the 1st type
```

You may also use `RemoveEnabledDocumentTypes(...)` method to remove already enabled document types.

For convenience it's possible to use **wildcards** (using asterisk symbol) while enabling or disabling document types. When using document types related methods, each passed document type is matched against all supported document types. All matches in supported document types are added to the enabled document types list. For example, document type `rus.passport.internal` can be matched with `rus.*`, `*passport*` and of course a single asterisk `*`.

```cpp
// C++
settings->AddEnabledDocumentTypes("deu.*"); // Enables all supported documents of Germany
```

```java
// Java
settings.AddEnabledDocumentTypes("deu.*"); // Enables all supported documents of Germany
```

As it was mentioned earlier, you can only enable document types that belong to the same internal engine for a single session. If you do otherwise then an exception will be thrown during session spawning.

It's always better to enable the minimum number of document types as possible if you know exactly what are you going to recognize because the system will spend less time deciding which document type out of all enabled ones has been presented to it.

#### Session Modes

Based on the list of supported document types in the configuration bundle, and on the document masks provided by the caller, the engine is determining which internal engine to use in the created session. However, what if there have to be multiple engines which support a certain document type? For example, a USA Passport (`usa.passport.*`) can be recognized both in the internal engine for recognition of all USA documents, and in the internal engine for recognition of all international passports. To sort this out there is a concept of session modes.

To get the list of available session modes in the provided configuration bundle, you can use the corresponding method of the `IdSessionSettings`:

```cpp
// C++
for (auto it = settings->SupportedModesBegin();
     it != settings->SupportedModesEnd();
     ++it) {
    // it.GetValue() is a name of a supported mode
}
```

```java
// Java
for (StringsSetIterator it = settings.SupportedModesBegin();
     !it.Equals(settings.SupportedModesEnd());
     it.Advance()) {
    // it.GetValue() is a name of a supported mode
}
```

There is always a mode called `default` and it is enabled, well, by default. There are methods for getting the currently enabled mode and to set a new one:

```cpp
// C++
std::string current_mode = settings->GetCurrentMode();

settings->SetCurrentMode("anypassport"); // Setting a current mode to AnyPassport
settings->AddEnabledDocumentTypes("*");  // Setting a document type mask _within a mode_
```

```java
// Java
String current_mode = settings.GetCurrentMode();

settings.SetCurrentMode("anypassport"); // Setting a current mode to AnyPassport
settings.AddEnabledDocumentTypes("*"); // Setting a document type mask _within a mode_
```

Within any given configuration bundle there is a strict invariant: there cannot be internal engines which belong to the same mode and for which the subsets of supported documents types intersect.

### Session Options

Some configuration bundle options can be overriden in runtime using `IdSessionSettings` methods. You can obtain all currently set option names and their values using the following procedure:

```cpp
// C++
for (auto it = settings->OptionsBegin();
     it != settings->OptionsEnd();
     ++it) {
    // it.GetKey() returns the option name
    // it.GetValue() returns the option value
}
```

```java
// Java
for (StringsMapIterator it = settings.OptionsBegin();
     !it.Equals(settings.OptionsEnd());
     it.Advance()) {
    // it.GetKey() returns the option name
    // it.GetValue() returns the option value
}
```

You can change option values using the `SetOption(...)` method:

```cpp
// C++
settings->SetOption("common.extractTemplateImages", "true");
settings->SetOption("common.sessionTimeout", "3.0");
```

```java
// Java
settings.SetOption("common.extractTemplateImages", "true");
settings.SetOption("common.sessionTimeout", "3.0");
```

Option values are always represented as strings, so if you want to pass an integer or boolean it should be converted to string first.

#### Common Options

|                                   Option name |                           Value type |                                             Default | Description                                                                                                                                                                            |
|----------------------------------------------|-------------------------------------|----------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `common.barcodeAllowedSymbologies`            | String mask, separated with '&#124;' | DEFAULT                                             | List of allowed barcode symbologies. Valid values: `ALL_1D`. `CODABAR`, `CODE_39`, `CODE_93`, `CODE_128`, `EAN_8`, `EAN_13_UPC_A`, `ITF`, `UPC_E`, `AZTEC`, `PDF_417`, `QR_CODE`, `DATA_MATRIX`. By default all these symbologies are enabled. |
| `common.enableMultiThreading`                 | `"true"` or `"false"`                | true                                                | Enables parallel execution of internal algorithms                                                                                                                                      |
| `common.extractRawFields`                     | `"true"` or `"false"`                | false                                               | Enables output of raw physical field recognition results (without integration or postprocessing) in the RecognitionResult                                                              |
| `common.extractTemplateImages`                 | `"true"` or `"false"`                | false                                               | Extracts rectified template images (document pages) in the ImageFields section of the RecognitionResult                                                                                |
| `common.rgbPixelFormat`                       | String of characters R, G, B, and A  | RGB for 3-channel images, BGRA for 4-channel images | Sequence of color channels for session.ProcessSnapshot() method image interpretation                                                                                                   |
| `common.sessionTimeout`                       | Double value                         | `0.0` for server bundles, `5.0` for mobile bundles  | Session timeout in seconds                                                                                                                                                             |
| `common.useMrzControlDigitPostprocessing`     | `"true"` or `"false"`                | false                                               | Assumes valid MRZ checksums and uses this assumption for statistical language model postprocessing                                                                                     |
| `common.extractImageFieldsInSourceResolution` | `"true"` or `"false"`                | false                                               | Extracts ImageFields (such as photo or signature) in the resolution closest to the input image. If disabled, the resolution correposponds to the default internal template dimensions. |
| `common.enableStoppers`                       | `"true"` or `"false"`                | true                                                | Enables smart text fields stoppers                                                                                                                                                     |
| `common.useLuhnCodeCheck`                     | `"true"` or `"false"`                | true                                                | Enables Luhn code validity assumption in bank card number statistical post-processing |
| `common.anyPassportMrzRequired`               | `"true"` or `"false"`                | false                                              | Enables "light" mode of the AnyPassport module, with a hard restriction that MRZ is required |
| `common.constrainMultiThreading` | Integer number | 0 | Restricts the number of threads. Unlimited by default |
| `common.barcodeEffortLevel` | `"low"`, `"normal"` or `"high"` | normal | Effort level for detecting barcodes |
| `common.barcodeInterpretation` | String mask, separated with '&#124;' | empty | Mask for decoding and interpreting barcodes (AAMVA, GS1, etc.) |
| `common.barcodeMaxNumberPerFrame` | Integer number | `1` | Maximum number of barcodes searched in any given frame |
| `common.barcodeRoiDetectionMode` | `"focused"`, `"anywhere"` or `"dummy"` | `"focused"` | Barcode ROI detection mode |
| `common.barcodeFeedMode` | `"sequence"` or `"single"` | `"single"` |  By default, the barcode feedmode is set to 'single' - barcode recognition stops after one barcode is found. To recognize several barcodes, set feedmode to 'sequence' |
| `common.currentDate` | `DD.MM.YYYY` | n/a | Current date required for dates verification |
| `common.forceRawFieldsSourceExtraction` | `"true"` or `"false"` | false | Forces cropping of raw field images from source image |
| `common.extractRectifiedDocumentImage` | `"true"` or `"false"` | false | Enables output of the `"rectified_document_image"` field, which containes single rectified image of detected multi-page document |

### Face Similarity Detection

Face similarity detection (face comparison) is implemented in two modes:

1. "One-to-one" — two face images are compared.
2. "One-to-many" — multiple face images are compared with a reference one.

#### Face Similarity Usage Workflow

1. Create an `IdEngine` instance or use an existing one:

	```cpp
	// C++
	std::unique_ptr<se::id::IdEngine> engine(se::id::IdEngine::Create(face_config_path.c_str()));
	```
2. Create `IdFaceSessionSettings` from the configured `IdEngine`:

    ```cpp
    // C++
    id_face_settings_.reset(engine->CreateFaceSessionSettings());
    
    ```
    Note, that `IdEngine::CreateFaceSessionSettings()` is a factory method and returns an allocated pointer. You are responsible for deleting it.
3. Spawn an `IdFaceSession`:

    ```cpp
    // C++
    const char* signature = "... YOUR SIGNATURE HERE ...";
	id_face_session_.reset(engine->SpawnFaceSession(*id_face_settings_, signature));
    ```
4. Load images that contain faces:

    ```cpp
    // C++
    std::unique_ptr<se::common::Image> imageA(
        se::common::Image::FromFile(image_pathA)); // Loading image A
    
	std::unique_ptr<se::common::Image> imageB(
        se::common::Image::FromFile(image_pathB)); // Loading image B
    ```
For the "one-to-many" mode you can load any number of faces.

Next steps depend on the face comparison mode.

**For the "one-to-one" mode:**

5. Compare the two loaded face images using the `GetSimilarity()` method:

    ```cpp
    // C++
    double face_sim = face_session->GetSimilarity(*imageA, *imageB).GetSimilarityEstimation();
    ```
	This method compares two images by estimating how similar the presented faces are.

**For the "one-to-many" mode:**

5. Set the reference face image selecting it from the loaded ones. For this, use the `SetFaceToMatchWith()` method:

    ```cpp
	// C++
	face_session->SetFaceToMatchWith(*imageA); // Setting image A as the reference one
    ```
6. Compare other loaded face images (B, C, etc.) with the reference one (A) using the `GetSimilarityWith()` method:

    ```cpp
    // C++
    double face_sim_A_B = face_session->GetSimilarityWith(*imageB).GetSimilarityEstimation();
    double face_sim_A_C = face_session->GetSimilarityWith(*imageC).GetSimilarityEstimation();
    .....
    ```
    This method compares each presented image with the reference one by estimating their similarity.

For comparing each presented image with a single one it is recommended to use the "one-to-many" mode because it is more efficient.

### Face Similarity Result Description

#### GetSimilarity

> **IdFaceSimilarity** — the class used for checking the detected faces for similarity and returning the result of this check. Contains the methods:

- `GetSimilarity()` and `GetSimilarityWith()` — get one of three possible values: `different`, `uncertain`, `same`. It is recommended to use these methods.
- `GetSimilarityEstimation()` — returns a double value in the range from 0.0 to 1.0 indicating the similarity level: 1.0 — faces are 100% identical, 0.0 — the faces are completely different.


#### GetStatus

> **IdFaceStatus** — the class used for returning the processing status of the input images. Contains the method:

- `GetStatus()` — gets the processing status. 
If a face is not found in one or the both images, the system considers the faces to be different without further comparison.


```log
// Possible status values:
// IdFaceStatus_NotUsed,            ///< The status is not initialized
// IdFaceStatus_Success,            ///< The status is initialized, two face images have been compared
// IdFaceStatus_A_FaceNotFound,     ///< No face was found in image A
// IdFaceStatus_B_FaceNotFound,     ///< No face was found in image B
// IdFaceStatus_FaceNotFound,       ///< The both faces were not found in images A and B (for the "one-to-one" mode)
// IdFaceStatus_NoAccumulatedResult ///< No reference face image was set (for the "one-to-many" mode)
```

- `IdFaceStatus_A_FaceNotFound`, `IdFaceStatus_B_FaceNotFound`, `IdFaceStatus_FaceNotFound` — a real face was not found in one or the both images. Therefore, the faces are automatically considered different, and further comparison is skipped.
- `IdFaceStatus_Success` — faces were successfully detected in the both images.
- `IdFaceStatus_NoAccumulatedResult` — no reference face the other faces could be compared with was found. Used for multiple face similariry detection.

### Face Liveness Detection

Check if the face belongs to a real person.

1. Create a session settings object using the `CreateFaceSessionSettings()` method of the `IdFaceSessionSettings` class.

Such object can be created only by acquiring a default session settings object from the configured engine.

```cpp
// C++
std::unique_ptr<se::id::IdFaceSessionSettings> settings(engine->CreateFaceSessionSettings());
```

2. Set session options using the following procedure:

```cpp
// C++
session_settings->SetOption(key, value);
```

`key` is the option name, `std::string`, `value` is the option value, `std::string`.

The following keys are available:
* `initializerInstructionTime` – the maximum time required for passing the first instruction (in milliseconds);
* `faceMinInstructionTime` – the minimum time required for passing one instruction (in milliseconds);
* `faceMaxInstructionTime` – the maximum time required for passing one instruction (in milliseconds);
* `minPassTime` – the minimum delay of switching instructions (in milliseconds);
* `instructionsCountBase` – the number of instructions required for passing liveness detection;
* `instructionsCountDeltaRandom` – the maximum number of instructions the base number (the `instructionsCountBase` value) can deviate from. The `instructionsCountBase` and the `instructionsCountDeltaRandom` values are used for setting the lower and upper value of the instructions number range. For example, if the `instructionsCountBase` value is 7 and the `instructionsCountDeltaRandom` value is 2, the number of instructions is a random number within the [5, 9] range;
* `allowedNumberOfFailedInstructions` – the number of instructions that can be failed during liveness detection.

For example:

```cpp
// C++
std::unique_ptr<se::id::IdFaceSessionSettings>  session_settings(engine->CreateFaceSessionSettings());
session_settings.SetOption("initializerInstructionTime", "7000"); // setting the maximum time required for passing the first instruction — 7000 milliseconds.
session_settings.SetOption("faceMinInstructionTime", "6000"); // setting the minimum time required for passing one instruction — 6000 milliseconds.
session_settings.SetOption("faceMaxInstructionTime", "8000"); // setting the maximum time required for passing one instruction — 8000 milliseconds.
session_settings.SetOption("minPassTime", "6000"); // setting the minimum delay of switching instructions — 6000 milliseconds.
session_settings.SetOption("instructionsCountBase", "7"); // setting the number of instructions required for passing liveness detection — 7 instructions.
session_settings.SetOption("instructionsCountDeltaRandom", "2"); // setting the maximum number of instructions the base number can deviate from — 2 instructions.
session_settings.SetOption("allowedNumberOfFailedInstructions", "1"); // setting the number of instructions that can be failed during liveness detection — 1 instruction.
```

2. Create a session object — the main "handle" for performing liveness detection.

```cpp
// C++
std::unique_ptr<se::id::IdFaceSession> session(engine->SpawnFaceSession(*settings, ${put_yor_personalized_signature_from_doc_README.html}, &optional_feedback));
```

3. Create a liveness detection result object.

```cpp
// C++
se::id::IdFaceLivenessResult liveness_result;
```

4. Iterate all the face images and pass them to the session.

```cpp
// C++
 for (int i = 0; i < number_of_images; ++i) {
        std::unique_ptr<se::common::Image> image(se::common::Image::FromFile(lst_path.c_str(), i));
		session->AddFaceImage(*image);
 }
```

6. Get the liveness detection instruction.

```cpp
// C++
session->GetLivenessResult().GetLivenessInstruction();
```

7. Update the liveness detection result.

```cpp
// C++
liveness_result = session->GetLivenessResult();
```

If the `GetLivenessInstruction()` value is "CT" (Complete)

```cpp
// C++
liveness_result.GetLivenessInstruction() == "CT"
```

then estimate the result of liveness detection:

```cpp
// C++
std::string result = (liveness_result.GetLivenessEstimation() == 1.00000) ? "Liveness detected" : "Liveness undetected";
```

8. Process feedback for receiving the information before frame is processed — optionally.

```cpp
// C++
class OptionalFeedback : public se::id::IdFaceFeedback {
public:
	virtual ~OptionalFeedback() override = default;
public:
  virtual void MessageReceived(
      const char* message) override {
    printf("[Face feedback called]: %s\n", message);
  }
};
```

**Instructions for passing the face liveness**

When passing this check, hold the phone exactly in front of you (at the eye level) and follow the instructions on the screen. Your face should occupy about one third of the screen area (20—40%) and fit completely on the screen. The both eyes must always be in the frame, do not move them from the center of the screen. Head movements should be made smoothly and one by one. For example, for the "Up" instruction, slightly lift your head up.

Tips for each instruction:

* **Straight** — straight position. The both eyes should be visible;
* **Right** — turn your head to the right. The both eyes should be visible;
* **Up** — raise your head. The both eyes should be visible, the tip of the nose should not be above eye level;
* **Left** — turn your head to the left. The both eyes should be visible;
* **Down** — lower your head. The both eyes should be visible, the tip of the nose should not cover the upper lip.

An instruction is failed in one of the cases:
* it is executed incorrectly;
* the timeout* is reached.
**Timeout* is a random value between the minumum and maximum time required for one instruction. It is set using the `faceMinInstructionTime` and `faceMaxInstructionTime` parameters of the `session_settings.SetOption()` method. This random value is defined by the system.

The result of face liveness detection is "Liveness undetected" (failed) if the number of the failed instructions exceeds the allowed number. It is set using the `allowedNumberOfFailedInstructions` parameter of the `session_settings.SetOption()` method.

### Processing Feedback

Smart ID Engine SDK supports optional callbacks during document analysis and recognition process before the `Process(...)` method is finished.
It allows the user to be more informed about the underlying recognition process and also helps creating more interactive GUI.

To support callbacks you need to subclass `IdFeedback` class and implement desirable callback methods:

```cpp
// C++
class MyFeedback : public se::id::IdFeedback {
public:
  virtual ~OptionalFeedback() override = default;

public:
  virtual void FeedbackReceived(
      const se::id::IdFeedbackContainer& /*feedback_container*/) override { }
  virtual void TemplateDetectionResultReceived(
      const se::id::IdTemplateDetectionResult& result) override { }
  virtual void TemplateSegmentationResultReceived(
      const se::id::IdTemplateSegmentationResult& /*result*/) override { }
  virtual void ResultReceived(const se::id::IdResult& result) override { }
  virtual void SessionEnded() override { }
};
```

```java
// Java
class MyFeedback extends IdFeedback {
  public void FeedbackReceived(IdFeedbackContainer feedback_container) { }
  public void TemplateDetectionResultReceived(IdTemplateDetectionResult result) { }
  public void TemplateSegmentationResultReceived(IdTemplateSegmentationResult result) { }
  public void ResultReceived(IdResult result) { }
  public void SessionEnded() { }
}
```

Methods `TemplateDetectionResultReceived(...)` and `TemplateSegmentationResultReceived(...)` are especially useful for displaying document zones and fields bounds in GUI during live video stream recognition.

You also need to create an instance of `MyFeedback` somewhere in the code and pass it when you spawn the session:

```cpp
// C++
MyFeedback my_feedback;
std::unique_ptr<se::id::IdSession> session(
    engine->SpawnSession(*settings, signature, &my_feedback));
```

```java
// Java
MyFeedback my_feedback = new MyFeedback();
IdSession session = engine.SpawnSession(settings, signature, my_feedback);
```

**Important!** Your `IdFeedback` subclass instance must not be deleted while `IdSession` is alive. We recommend to place them in the same scope. For explanation of signatures, [see above](#warning-personalized-signature-warning).

## Java API Specifics

Smart ID Engine SDK has Java API which is automatically generated from C++ interface by SWIG tool.

Java interface is the same as C++ except minor differences, please see the provided Java sample.

There are several drawbacks related to Java memory management that you need to consider.

#### Object Deallocation

Even though garbage collection is present and works, it's strongly advised to manually call `obj.delete()` functions for our API objects because they are wrappers to the heap-allocated memory and their heap size is unknown to the garbage collector.

```java
IdEngine engine = IdEngine.Create(config_path); // or any other object

// ...

engine.delete(); // forces and immediately guarantees wrapped C++ object deallocation
```

This is important because from garbage collector's point of view these objects occupy several bytes of Java memory while their actual heap-allocated size may be up to several dozens of megabytes. GC doesn't know that and decides to keep them in memory – several bytes won't hurt, right?

You don't want such objects to remain in your memory when they are no longer needed so call `obj.delete()` manually.

#### Feedback Scope

When using optional callbacks by subclassing `IdFeedback` please make sure that its instance have the same scope as `IdSession`. The reason for this is that our API does not own the pointer to the feedback instance which cause premature garbage collection resulting in crash:

```java
// Java
// BAD: may cause premature garbage collection of the feedback instance
class MyDocumentRecognizer {
    private IdEngine engine;
    private IdSession session;

    private void InitializeSmartIdEngine() {
        // ...
        session = engine.SpawnSession(settings, signature, new MyFeedback());
        // feedback object might be garbage collected there because session doesn't own it
    }
}
```

```java
// Java
// GOOD: reporter have at least the scope of recognition session
class MyDocumentRecognizer {
    private IdEngine engine;
    private IdSession session;
    private MyGeedback feedback; // feedback has session's scope

    private void InitializeSmartIdEngine() {
        // ...
        feedback = new MyFeedback();
        session = engine.SpawnSession(settings, signature, feedback);
    }
}
```

For explanation of signatures, [see above](#warning-personalized-signature-warning).

## PDF Recognition

For server recognition, PDF files are supported as an input format. PDF support is implemented via preliminary conversion of PDF documents into raster images (e.g. PNG), which are then passed to the recognition pipeline.

PDF-to-raster conversion can be performed using the open-source **PDFium** library via the `pdfium_cli` command-line utility.

>The PDF conversion utility is given upon demand in order to reduce the size of the SDK distribution.

Upon customer request, a ready-to-use PDF-to-raster conversion utility can be provided for a specific target architecture.

| Option         | Description                                      | Default  |Required|
|----------------|--------------------------------------------------|----------|--------|
| -i, --input    | Path to the input PDF file                       | —        | Yes    |
| -o, --output   | The directory for PNG images                     | `result` |        |
| -d, --dpi      | Resolution (DPI)                                 | `300`    |        |
| -r, --pages    | Pages, e.g. "1-3,5,7" or "all"                   | `all`    |        |
| -p, --prefix   | Prefix name for the output files                 | `page_`  |        |
| -g, --grayscale| Render pages in grayscale (smaller PNG file size)| —        |        |
| -h, --help     | Help                                             | —        |        |

Examples:

```shell
./pdfium_cli -i file.pdf
```

```shell
./pdfium_cli -i file.pdf -o out -d 150 -r 1-5
```

## Integration of the REST API Server with ERP Systems

Smart ID Engine REST API server and ERPs communicate via http requests. 

No components need to be installed on the ERP side to integrate the REST-API server.

The REST-API server listens by default to the port on all available network interfaces. If it is installed on the same PC as the ERP, then the local address of this PC should be used to refer to it.
If it is installed on another PC of the network, then the external IP address of this PC should be used.

If the server is used in unsafe networks (unequipped with VPN), use http traffic encryption. It is recommended to use NGINX as a proxy server.

The server configuration, i.e. the policy of listening to network interfaces, and the port number are set in the `config.json` file.

The are two ways to recognize documents using API:

1. Simple recognition – the document and the session settings are sent in the same request. 
2. Session recognition – the user creates a session and sends multiple images for recognition within the same session ID. This can include multi-page documents or a series of images of a single document.

The recognition options settings include:

- *mode* — operation mode. Usually, `default`.
- *mask* — document mask.

For example, `default:deu.id.*`.

**How to start recognition**
In Swagger, make the first `POST` request to a simple URL attaching an image. If you receive an error stating "Found no single engine that supports document types enabled in settings," it means that your REST API server found no engine or multiple engines supporting the enabled document types. I.e. the server was unable to determine which recognition engine to use, see [Session Modes](#session-modes).
Make a request to diagnostic and check the bundle_masks content.
You will see that the documents are grouped by mode (`:` (colon) mode and mask separation), see [Enabling document types using wildcard expressions](#enabling-document-types-using-wildcard-expressions).

# FAQ

1.  ### How can I test the system? 

You can install demo apps from Apple Store and Google Play from the links below:

Google Play: https://play.google.com/store/apps/details?id=com.smartengines.se&showAllReviews=true

Apple Store: https://apps.apple.com/us/app/smart-engines/id1593408182


2. ### Which sample do I need? 

You need samples from idengine_sample* folder. smartid_sample* uses the legacy interface and presented only for testing a backward compatibility.

3. ### How can I install and test your library? 

We provide the classic SDK as a library and its integration samples, you need to install one of the examples (you can find it in the /samples folder)

4. ### Is there any API in your engine to help us identify the country of the passport? 

There are special engines in our system which able to recognize documents by type, e.g. all passports (anypassport), EU ID's, etc., to use this engine you need to make sure that you have this engine (you could list all supported modes and engines, see provided samples from /samples) or contact us at sales@smartengines.com or support@smartengines.com

5. ### How can I update to the new version?

You need to replace the libraries from /bin, bindings (from /bindings respectively) and configuration bundle (*.se file from /data-zip) You can find it in the provided SDK.

6. ### How can I find out what documents and engines are available to me? 

Inside our library all documents are sorted by engines, and engines sorted by modes, you can find the list of available modes, engines and documents using methods from IdSessionSettings. (see provided samples from /samples)

7. ### I have the SDK version for Windows, but our production system will use any OS from Linux family. How do I run in a Linux-based docker container? 

Our SDK are platform-dependent, so please contact us at sales@smartengines.com or support@smartengines.com and we will provide you with the required SDK.

8. ### I have SDK for Centos 7, I try to run it on Ubuntu/Debian/Alpine. I have a lot of "undefined symbol" errors. 

Please don't run SDK for operating systems not intended for it and contact us at sales@smartengines.com or support@smartengines.com to provide you with the required SDK.

# Oops! Something went wrong. 

## Common Errors

1. `Failed to verify static auth`: please look at the [1st paragraph of `Readme`](#warning-personalized-signature-warning)

2. `Found no single engine that supports settings-enabled document types`: our recognition engine contains a whole set of tools aimed at recognizing specific groups of documents. 
In order for the library to be able to select the right tool you need to set the document mask. 
To set the document mask please use `AddEnabledDocumentTypes` (document_types) in the session settings. Usually all documents are grouped by country name, so you can use the country name (country code according to ISO 3166-1 alpha-3). 
There are also tools that has all passports (or all driver's license or ID's of different countries): in this case in order to determine the right tool you have to use the `settings.SetCurrentMode` (mode_name) mod.

3. `Failed to initialize IdEngine: mismatching engine version in config`: .se format configuration bundles contain the number of the version with which they work so most likely you just did not replace bundles. Make sure that the bundle and the library are taken from the same SDK, if this does not help please contact the support.

4. `Libidengine.so:cannot open shared object file:no such file or directory`: 
integration for wrappers has in two stages: there is a main library with all the functionality and there is a lightweight wrapper that translates calls from the module to our library. This error occurs when the wrapper library cannot find the main library. You can fix this by setting the `LD_LIBRARY_PATH=</path/to/libidengine.so>` IMPORTANT! This environment variable must be set before running your program (you cannot set the path to the library when the program is already running by HP or JVM)

- for PYTHON and PHP
`libpython3.x.x:cannot open shared object file: No such file or directory`: the module you are using is built for a different version of python, /samples/idengine_sample_*/ contains a script for building the module on your side. Don't forget that you must have the dev packages installed for your language.