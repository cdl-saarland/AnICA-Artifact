#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

VM_BASE=$SCRIPT_DIR/vm_setup

# get the anica repo
cd $VM_BASE
rm -rf ./anica_ui
git clone https://github.com/cdl-saarland/AnICA-UI.git anica_ui

cd $VM_BASE/anica_ui
git submodule update --init --recursive


# unpack the provided data
cd $VM_BASE/results/provided/

if [ ! -f ./oopsla22_data.tgz ]
then
    echo "Provided evaluation data not yet downloaded, downloading now..."
    # obtain the data from our nextcloud
    wget https://kingsx.cs.uni-saarland.de/index.php/s/ZQyiazK5TB9HZe6/download/oopsla22_data.tgz
else
    echo "Using previously downloaded evaluation data."
fi

# delete previous unpack (if present)
rm -rf oopsla22_data

# unpack the new one
tar -xzvf oopsla22_data.tgz


cd $SCRIPT_DIR

# hide some tracks
rm -rf $VM_BASE/anica_ui/.git*
rm -rf $VM_BASE/anica_ui/lib/anica/.git*
rm -rf $VM_BASE/anica_ui/lib/anica/lib/iwho/.git*
rm -rf $VM_BASE/anica_ui/lib/anica/lib/iwho/predictors/ithemal/.git*

