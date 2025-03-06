#  Copyright (c) 2016-2024, Smart Engines Service LLC
#  All rights reserved.

javac *.java -cp ../../bindings/java/jniidenginejar.jar

# How to run
# LD_LIBRARY_PATH=../../bin LC_ALL=en_US.utf-8 java -Djava.library.path=../../bin -cp ../../bindings/java/jniidenginejar.jar:. Main <face_1_path> <face_2_path> <bundle_path>