#!/usr/bin/env bash

# This script needs to be run after the VM is first created, before it is
# packaged. These steps take a while.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

set -e

echo ">>> Obtaining and building predictors..."
$SCRIPT_DIR/get_predictors.sh

# it's important to do that before we import data
echo ">>> Initializing the django database..."
$SCRIPT_DIR/init_django.sh

echo ">>> Importing provided data..."
$SCRIPT_DIR/import_provided_campaigns.sh

echo ">>> Installing auto start entry..."
$SCRIPT_DIR/install_autostart.sh

echo ">>> All done!"

