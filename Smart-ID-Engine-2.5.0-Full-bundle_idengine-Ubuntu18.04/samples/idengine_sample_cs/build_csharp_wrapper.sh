#  Copyright (c) 2016-2024, Smart Engines Service LLC
#  All rights reserved.

#!/usr/bin/bash

set -x
set -e

### Checking that the library path is passed as an argument

if [[ $# -ne 1 ]]; then
  echo "Wrong number of parameters: "
  echo "Usage: $0 <PATH_TO_LIBRARY_DIRECTORY>"
  exit 1
fi

LIBRARY_PATH="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
BUILD_DIR="$(pwd)"

### Unpacking, building, and installing (locally) SWIG 4.1.1

cd $BUILD_DIR
tar -xf swig-4.1.1.tar.gz
cd swig-4.1.1
./configure --without-pcre --prefix=$BUILD_DIR/swig
make
make install
cd ../..

### Making Csharp module

mkdir $BUILD_DIR/build
cd $BUILD_DIR/build
cmake .. -DSWIG_EXECUTABLE=$BUILD_DIR/swig/bin/swig \
         -DSWIG_DIR=$BUILD_DIR/swig/share/swig/4.1.1 \
         -DLIBRARY_PATH=$LIBRARY_PATH  
make install
