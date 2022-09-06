#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# activate the python environment
source $SCRIPT_DIR/../anica_ui/env/anica_ui/bin/activate

set -ex

cd $SCRIPT_DIR

../anica_ui/anica_ui/manage.py makemigrations
../anica_ui/anica_ui/manage.py migrate

