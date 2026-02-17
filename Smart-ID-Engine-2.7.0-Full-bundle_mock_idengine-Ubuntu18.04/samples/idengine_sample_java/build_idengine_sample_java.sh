#  Copyright (c) 2016-2025, Smart Engines Service LLC
#  All rights reserved.

javac IdEngineSample.java -cp ../../bindings/java/jniidenginejar.jar

# How to run
# LD_LIBRARY_PATH=../../bin LC_ALL=en_US.utf-8 java -Djava.library.path=../../bin -cp ../../bindings/java/jniidenginejar.jar:. IdEngineSample <image> <bundle_path> <document_types>
