#  Copyright (c) 2016-2026, Smart Engines Service LLC
#  All rights reserved.

g++ idengine_sample.cpp -O2 -std=c++11 -I ../../include -L ../../bin -l idengine -o idengine_sample  -Wl,-rpath,../../bin

# How to run
# LD_LIBRARY_PATH=../../bin ./idengine_sample <image> <bundle_path> <document_types>