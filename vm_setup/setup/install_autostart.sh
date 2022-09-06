#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

set -e

sudo cp $SCRIPT_DIR/resources/start_custom.service /etc/systemd/system/

sudo systemctl daemon-reload

sudo systemctl enable start_custom.service

