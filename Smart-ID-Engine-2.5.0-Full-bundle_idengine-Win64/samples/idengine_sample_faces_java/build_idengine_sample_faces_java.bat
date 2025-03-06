javac *.java -cp .;..\..\bindings\java\jniidenginejar.jar

@REM How to run
@REM java -Djava.library.path=..\..\bin -cp .;..\..\bindings\java\jniidenginejar.jar Main <face_1_path> <face_2_path> <bundle_path>