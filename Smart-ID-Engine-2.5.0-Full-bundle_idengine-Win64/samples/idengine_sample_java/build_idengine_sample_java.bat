@REM Copyright (c) 2016-2024, Smart Engines Service LLC
@REM All rights reserved.

javac IdEngineSample.java -cp .;..\..\bindings\java\jniidenginejar.jar

@REM How to run
@REM java -Djava.library.path=..\..\bin -cp .;..\..\bindings\java\jniidenginejar.jar IdEngineSample <image> <bundle_path> <document_types>