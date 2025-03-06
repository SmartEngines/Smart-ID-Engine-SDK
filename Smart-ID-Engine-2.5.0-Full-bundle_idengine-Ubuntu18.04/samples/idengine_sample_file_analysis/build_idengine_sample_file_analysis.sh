#  Copyright (c) 2016-2024, Smart Engines Service LLC
#  All rights reserved.

g++ idengine_sample_file_analysis.cpp -O2 -std=c++11 -I ../../include -L ../../bin -l idengine -o idengine_sample_file_analysis  -Wl,-rpath,../../bin

# How to run
# LD_LIBRARY_PATH=../../bin ./idengine_sample_file_analysis <image> <config>
