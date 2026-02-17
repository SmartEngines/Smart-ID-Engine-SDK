# Quick start

1. Copy your signature from `readme.html` to appropriate parameter in `App.kt`
2. Uncomment the line in build.gradle according to your SDK:

`"idImplementation"  (fileTree(mapOf("dir" to "src/id/libs/",     "include" to listOf("*.jar"))))`
`"codeImplementation"(fileTree(mapOf("dir" to "src/code/libs/",   "include" to listOf("*.jar"))))`
`"docImplementation" (fileTree(mapOf("dir" to "src/doc/libs/",    "include" to listOf("*.jar"))))`

3. Please check which product is selected as the build.

Go to `Build`-> `Select build varian`t and select product: `Id (Debug)`, `Code (Debug)`, `Doc (Debug)`

# SDK description

## Build variant dependencies

There are 3 dependencies required for the project:

- **Binaries**:
  - `jniLibs/` folder with binary library. (`app/src/id` or `app/src/code` or `app/src/doc`)

- **Wrapper**: 
  - `src/main/libs/*.jar` C++ glue-code library file. (`app/src/main` in build.gradle `implementation(fileTree("src/main/libs") { include("*.jar") })`).

- **Bundle**: 
  - `src/main/assets/data/*.se` config file.

## SDK level

- `com.smartengines.common` - common SDK classes
- `com.smartengines.[id|code|doc]` - engine classes

### App level

- `com.smartengines.kotlin_sample` - the application logic implementation.
- `com.smartengines.kotlin_sample.targets` - the SessionTarget implementations. Each target defines session settings when session is creating

## Core level

Don't depend on the app logic, so can be used in another projects

- `com.smartengines.core.engine` - the business-logic implementation. Independent on SDK
- `com.smartengines.core.engine.[id|code|doc]` - session and result wrappers. Depends on SDK
