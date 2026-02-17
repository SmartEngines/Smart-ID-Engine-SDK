# Smart ID Engine SDK Overview

This is a collection of DEMO builds of Smart ID Engine SDK developed by Smart Engines. The SDK examples can be used to demonstrate the integration possibilities and understand the basic object recognition workflows.


  * [:warning: Personalized signature :warning:](#warning-personalized-signature-warning)
  * [Troubleshooting and help](#troubleshooting-and-help)
  * [General Usage Workflow](#general-usage-workflow)
    - [Video Authentication Workflow](#video-authentication-workflow)
  * [SDK Overview](#sdk-overview)
    - [Header files, namespaces, and modules](#header-files-namespaces-and-modules)
    - [Code documentation](#code-documentation)
    - [Exceptions](#exceptions)
    - [Factory methods and memory ownership](#factory-methods-and-memory-ownership)
  * [Configuration bundles](#configuration-bundles)
  * [Specifying document types for IdSession](#specifying-document-types-for-idsession)
    - [Supported document types](#supported-document-types)
    - [Enabling document types using wildcard expressions](#enabling-document-types-using-wildcard-expressions)
    - [Session modes](#session-modes)
  * [Session options](#session-options)
    - [Common options](#common-options)
  * [Face Similarity Detection](#face-similarity-detection)
  * [Processing Feedback](#processing-feedback)
    - [Processing Video Authentication Feedback](#processing-video-authentication-feedback)
  * [Java API Specifics](#java-api-specifics)
    - [Object deallocation](#object-deallocation)
    - [Feedback scope](#feedback-scope)
* [FAQ](#faq)


## :warning: Personalized signature :warning:

Starting from Smart ID Engine v1.4.0 users are required to use a personalized signature for starting a session. The signature is validated offline and locks to the copy of the native library, thus ensures that only an authorized client may use it. The signature is a string with 256 characters.

You will need to manually copy the signature string and pass it as an argument for the `SpawnSession()` method ([see item 6 below](#general-usage-workflow)). Do NOT keep the signature in any asset files, only inside code. If possible, clients are encouraged to keep the signature in a controlled server and load it into the application via a secure channel, to ensure that signature and the library are separated.

## Troubleshooting and help

To resolve issue that you might be facing we recommend to do the following:

* Carefully read in-code documentation in API and samples and documentation in .pdf and .html, including this document
* Check out the code details / compilation flags etc. in the sample code and projects
* Read exception messages if exception is thrown - it might contain usable information

But remember: 
* You are always welcome to ask for help at `support@smartengines.com` (or your sales manager's email) no matter what

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

    Configuration process might take a while but it only needs to be performed once during the program lifetime. Configured `IdEngine` is used to spawn IdSessions which have actual recognition methods.

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

### Video Authentication Workflow
The video authentication component performs advanced scanning of documents in a video stream. This feature assumes that you should follow instructions displayed on your device screen in real time. It allows you to recognize documents including double-sided identity documents within one session. For example, when you are scanning a double-sided document, you will be offered to scan the other side of this document after having scanned the first side.

Video authentication configuration is included in the bundle file and is read and called from this bundle file.
Video authentication is performed within the general workflow ([see](#general-usage-workflow)) with the following specifics:

1. Create `IdVideoAuthenticationSessionSettings` from configured `IdEngine`:

```cpp
    // C++
    std::unique_ptr<se::id::IdVideoAuthenticationSessionSettings>
        session_settings(engine->CreateVideoAuthenticationSessionSettings());
```

```java
    // Java
    IdVideoAuthenticationSessionSettings session_settings = engine.CreateVideoAuthenticationSessionSettings();
```

2. Implement callbacks as follows:

```cpp
    // C++
    class MyCallbacks : public se::id::IdVideoAuthenticationCallbacks { /* callbacks */ };

    // ...

    MyCallbacks my_callbacks;
```

```java
    // Java
    class MyCallbacks extends IdVideoAuthenticationCallbacks { /* callbacks */ }

    // ...

    MyCallbacks my_callbacks = new MyCallbacks();
```
See more about video authentication feedback in [Processing Video Authentication Feedback](#processing-video-authentication-feedback)

3. Spawn VideoAuthenticationSession:

```cpp
    // C++
    const char* signature = "... YOUR SIGNATURE HERE ...";
    std::unique_ptr<se::id::IdVideoAuthenticationSession> session(
        engine->SpawnVideoAuthenticationSession(*session_settings, signature,  my_callbacks.get()));
```

```java
    // Java
    String signature = "... YOUR SIGNATURE HERE ...";
    IdVideoAuthenticationSession session = engine.SpawnVideoAuthenticationSession(*session_settings, signature, my_callbacks.get()); 
```
## SDK Overview

### Header files, namespaces, and modules
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
#include <idengine/id_video_authentication_session_settings.h>  // Contains IdVideoAuthenticationSessionSettings class definition
#include <idengine/id_video_authentication_session.h>           // Contains IdVideoAuthenticationSession class definition
#include <idengine/id_video_authentication_callbacks.h>         // Contains the IdVideoAuthenticationCallbacks interface
#include <idengine/id_video_authentication_result.h>            // Contains information about the classes: IdVideoAuthenticationInstruction, IdVideoAuthenticationFrameInfo, IdVideoAuthenticationAnomaly, IdVideoAuthenticationTranscript
```

The same classes in Java API are located within `com.smartengines.id` module:

```java
// Java
import com.smartengines.id.*; // Import all se::id classes
```

#### Code documentation

All classes and functions have useful Doxygen comments.
Other out-of-code documentation is available at `doc` folder of your delivery.
For complete compilable and runnable sample usage code and build scripts please see `samples` folder.

#### Exceptions

Our C++ API may throw `se::common::BaseException` subclasses when user passes invalid input, makes bad state calls or if something else goes wrong. Most exceptions contain useful human-readable information. Please read `e.what()` message if exception is thrown. Note that `se::common::BaseException` is **not** a subclass of `std::exception`, an Smart ID Engine interface in general do not have any dependency on the STL.

The thrown exceptions are wrapped in general `java.lang.Exception`, so in Java API do catch those.

#### Factory methods and memory ownership

Several Smart ID Engine SDK classes have factory methods which return pointers to heap-allocated objects.  **Caller is responsible for deleting** such objects _(a caller is probably the one who is reading this right now)_.
We recommend using `std::unique_ptr<T>` for simple memory management and avoiding memory leaks.

In Java API for the objects which are no longer needed it is recommended to use `.delete()` method to force the deallocation of the native heap memory.


## Configuration bundles

Every delivery contains one or several _configuration bundles_ – archives containing everything needed for Smart ID Engine to be created and configured. Usually they are named as `bundle_something.se` and located inside `data-zip` folder.

## Specifying document types for IdSession

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

#### Supported document types

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

#### Enabling document types using wildcard expressions

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

#### Session modes

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

## Session options

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

#### Common options

|                                   Option name |                           Value type |                                             Default | Description                                                                                                                                                                            |
|----------------------------------------------:|-------------------------------------:|----------------------------------------------------:|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
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
| `common.barcodeFeedMode` | `"sequence"` or `"single"` | `"single"` | Mode of internal barcode detection and temporal integration |
| `common.currentDate` | `DD.MM.YYYY` | n/a | Current date required for dates verification |
| `common.forceRawFieldsSourceExtraction` | `"true"` or `"false"` | false | Forces cropping of raw field images from source image |

## Face Similarity Detection

### Usage workflow

1. Create an `IdEngine` instance or use an existing one:

	```cpp
	// C++
	std::unique_ptr<se::id::IdEngine> engine(se::id::IdEngine::Create(face_config_path.c_str()));
	```
2. Create `IdFaceSessionSettings` from configured `IdEngine`:

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
5. Compare the faces using `GetSimilarity(...)`:
    ```cpp
    // C++
    double face_sim = face_session->GetSimilarity(*imageA, *imageB).GetSimilarityEstimation();
    ```
	This method compares two images by detecting faces in both and estimating how similar the faces are.

	To get detected face rectangles from an image, use:
	```cpp
	// C++
	virtual idFaceRectsResult GetRects(const common::Image& image) const = 0;
	```

#### Result Description

##### GetSimilarity

> **IdFaceSimilarity** - class methods check the detected faces for similarity and return the result of this check:
- `GetSimilarity()` - (recommend) method gets one of the three possible values: `different`, `uncertain`, `same`.
- `GetSimilarityEstimation()` -  returns a double value in the range from 0.0 to 1.0, indicating the similarity level: 1.0 — faces are 100% identical. 0.0 — faces are completely different.


##### GetStatus

> **IdFaceStatus** - class that returns the processing status of the input frames.

- `GetStatus()` - get the process status. If a face is not found in one or both images, the system considers the faces to be different without further comparison.


```log
// Possible status values:
// IdFaceStatus_NotUsed,            ///< Was created but not used
// IdFaceStatus_Success,            ///< Everything alright
// IdFaceStatus_A_FaceNotFound,     ///< Face was not found for image A
// IdFaceStatus_B_FaceNotFound,     ///< Face was not found for image B
// IdFaceStatus_FaceNotFound,       ///< There is no face found
// IdFaceStatus_NoAccumulatedResult ///< Face matching with session where is no Accumulated result
```


- `IdFaceStatus_A_FaceNotFound`, `IdFaceStatus_B_FaceNotFound`, `IdFaceStatus_FaceNotFound` - a real face was not found in one or both images. Therefore, the faces are automatically considered different, and further comparison is skipped.

- `IdFaceStatus_Success` - faces were successfully detected in both images.


## Processing Feedback

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

### Processing Video Authentication Feedback

For video authentication, process feedback as follows:
subclass `IdVideoAuthenticationCallbacks` class and implement desirable callback methods:

```cpp
// C++
class MyVideoAuthenticationCallbacks : public se::id::IdVideoAuthenticationCallbacks {
public:
    virtual ~IdVideoAuthenticationCallbacks() override = default;

public:
    virtual void InstructionReceived(
      int index,
      const IdVideoAuthenticationInstruction& instruction) override { }
    virtual void AnomalyRegistered(
      int index,
      const IdVideoAuthenticationAnomaly& anomaly) override { }
    virtual void DocumentResultUpdated(const IdResult& document_result) override { }
    virtual void FaceMatchingResultUpdated(
      const IdFaceSimilarityResult& face_matching_result) override { }
    virtual void FaceLivenessResultUpdated(
      const IdFaceLivenessResult& face_liveness_result) override { }
    virtual void AuthenticationStatusUpdated(IdCheckStatus status) override { }
    virtual void GlobalTimeoutReached() override { }
    virtual void InstructionTimeoutReached() override { }
    virtual void SessionEnded() override { }
    virtual void MessageReceived(const char* message) override { } 
};
```

```java
// Java
class MyVideoAuthenticationCallbacks extends IdVideoAuthenticationCallbacks {
  public void InstructionReceived(int index, IdVideoAuthenticationInstruction instruction) { }
  public void AnomalyRegistered(int index, IdVideoAuthenticationAnomaly anomaly) { }
  public void DocumentResultUpdated(IdResult document_result) { }
  public void FaceMatchingResultUpdated(IdFaceSimilarityResult face_matching_result) { }
  public void FaceLivenessResultUpdated(IdFaceLivenessResult face_liveness_result) { }
  public void AuthenticationStatusUpdated(IdCheckStatus status) { }
  public void GlobalTimeoutReached() { }
  public void InstructionTimeoutReached() { }
  public void SessionEnded() { }
  public void MessageReceived(char* message) { }
}
```

You also need to create an instance of `MyVideoAuthenticationCallbacks` somewhere in the code and pass it when you spawn a video authentication session:

```cpp
// C++
MyVideoAuthenticationCallbacks my_video_authentication_callbacks;
std::unique_ptr<se::id::IdVideoAuthenticationSession> session(
    engine->SpawnVideoAuthenticationSession(*settings, signature, &my_video_authentication_callbacks));
```

```java
// Java
MyVideoAuthenticationCallbacks my_video_authentication_callbacks = new MyFeedback();
IdVideoAuthenticationSession session = engine.SpawnVideoAuthenticationSession(settings, signature, my_video_authentication_callbacks);
```

**Important!** Your `IdVideoAuthenticationCallbacks` subclass instance must not be deleted while `IdSession` is alive. We recommend to place them in the same scope. For explanation of signatures, [see above](#warning-personalized-signature-warning).

## Java API Specifics

Smart ID Engine SDK has Java API which is automatically generated from C++ interface by SWIG tool.

Java interface is the same as C++ except minor differences, please see the provided Java sample.

There are several drawbacks related to Java memory management that you need to consider.

#### Object deallocation

Even though garbage collection is present and works, it's strongly advised to manually call `obj.delete()` functions for our API objects because they are wrappers to the heap-allocated memory and their heap size is unknown to the garbage collector.

```java
IdEngine engine = IdEngine.Create(config_path); // or any other object

// ...

engine.delete(); // forces and immediately guarantees wrapped C++ object deallocation
```

This is important because from garbage collector's point of view these objects occupy several bytes of Java memory while their actual heap-allocated size may be up to several dozens of megabytes. GC doesn't know that and decides to keep them in memory – several bytes won't hurt, right?

You don't want such objects to remain in your memory when they are no longer needed so call `obj.delete()` manually.

#### Feedback scope

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

## Common Errors:

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