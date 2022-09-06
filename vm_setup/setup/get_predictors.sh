#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

BASE_DIR=$SCRIPT_DIR/../anica_ui/lib/anica/lib/iwho/predictors/


# activate the python environment
source $SCRIPT_DIR/../anica_ui/env/anica_ui/bin/activate

set -ex

# build the tools

## llvm-mca 13
# that one is already built from bootstrap.sh

## llvm-mca 9
# avoid cloning the llvm sources again
cd $SCRIPT_DIR/../utils/llvm09
cp -r ../llvm13/llvm-project .
cd llvm-project
git switch release/9.x
cd ..
./cmake_setup.sh
cd build
ninja install-llvm-mca


## llvm-mca 8
cd $SCRIPT_DIR/../utils/llvm08
cp -r ../llvm13/llvm-project .
cd llvm-project
git switch release/8.x

# LLVM 8 was missing includes in the MS demangler, which causes compile errors
# with current compilers.
git apply $SCRIPT_DIR/resources/llvm08.patch

cd ..
./cmake_setup.sh
cd build
ninja install-llvm-mca


## uiCA
cd $BASE_DIR/uica
./get.sh


## OSACA
cd $BASE_DIR/osaca
./get.sh


## DiffTune
cd $BASE_DIR/difftune
./get.sh


## Ithemal
cd $BASE_DIR/ithemal
./build.sh

## not IACA, since that is under a restrictive license


