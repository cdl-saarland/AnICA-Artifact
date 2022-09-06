#!/usr/bin/env bash

# This script should be run after the VM is first created and initialized,
# before it is packaged. It remove unnecessary build artifacts to reduce the
# size of the packaged VM.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

set -ex


# the installed binaries are sufficient, no need for sources and build
cd $SCRIPT_DIR/../utils
rm -rf llvm13/llvm-project llvm13/build
rm -rf llvm09/llvm-project llvm09/build
rm -rf llvm08/llvm-project llvm08/build

