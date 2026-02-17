#  Copyright (c) 2016-2025, Smart Engines Service LLC
#  All rights reserved.

clang++ idengine_sample.cpp -O2 -std=c++11 -I ../../include -L ../../bin -l idengine -o idengine_sample

# How to run
# DYLD_LIBRARY_PATH=../../bin ./idengine_sample <image> <bundle_path> <document_types>

