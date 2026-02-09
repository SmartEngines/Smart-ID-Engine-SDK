# Smart ID Engine SDK Integration Guide for Android

1. Copy `jniLibs` folder (arm64-v8a, armeabi-v7a, x86, x86_64) to `app/src/main/jniLibs/`
2. Copy `jniidengine.jar` wrapper to `src/main/libs/`
3. Add to **build.gradle** (app):

    ```gradle
    dependencies {
        implementation fileTree(include: ['*.jar'], dir: 'src/main/libs/')
        ...
    }
    ```

4. Copy **%bundle_name%.se** bundle to `app/src/assets/data/`
5. Copy **proguard-rules.pro** to `app/`
6. Add to **build.gradle** (app):

    ```gradle
    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
        debug {
            minifyEnabled false
        }
    }
    ```
