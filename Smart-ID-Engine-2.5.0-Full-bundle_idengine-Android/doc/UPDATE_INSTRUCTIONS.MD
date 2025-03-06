# HOW TO UPDATE A PROJECT FROM THE SDK

You can update your integration by updating only the necessary files.

## Table of Contents

Mobile SDK:

   1. [React-native](#react)
   2. [Flutter](#flutter)
   3. [Android](#android)
   4. [IOS](#ios)

---

### <a id="react"></a> React-native

Find your `react-native-smartengines-module` npm package.

1. Find `android` folder at root level of your npm package. Use [Android](#android) instructions to update android project.
3. Find `ios` folder at root level of your npm package.
     - Use [ios](#ios) instructions to update your android project.
     - Run `pod update`  in your ios project folder (where Podfile file is located).

Update completed!

---

### <a id="flutter"></a> Flutter

Find your `idenginemodule` dart package.

1. Find `android` folder at root level of your package. Use [Android](#android) instructions to update android project.
2. Find `ios` folder at root level of your package:
     - Use [ios](#ios) instructions to update your ios project.
     - Run `pod update`  in your ios project folder (where Podfile file is located).

Update completed!

---

### <a id="android"></a> Android

Unzip SDK. Update the Android project in 3 steps:

1. **Binaries**: find `jniLibs\` folder in your app. Replace with `sample\app\src\main\jniLibs\`.
    - For React-Native and Flutter: `android\src\main\jniLibs\`
2. **Wrapper**: find `lib\jniidengine.jar` file in your app. Replace with `sample\app\src\main\libs\jniidengine.jar`.
    - For React-Native and Flutter: `android\src\main\libs\jniidengine.jar`
3. **Bundle**: find `assets\data\*.se` file in your app. Replace with `sample\app\src\main\assets\data\*.se`.
    - For React-Native and Flutter: `android\src\main\assets\data\*.se`

Update completed!

**Step 3 is not necessary if your sdk have a bundle inside the binaries.**

---

### <a id="ios"></a> IOS

Unzip SDK. Open xcode with your project:

1. **Helper library**: replace `SESmartID` folder with `SESmartID` from SDK.
2. **Wrapper, bundle, xcframework**: replace `SESmartIDCore` folder with `SESmartIDCore` from SDK.

Update completed!

