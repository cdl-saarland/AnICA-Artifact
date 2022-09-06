#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd $SCRIPT_DIR

session=anica_ui

# Check if the session exists, discarding output
# We can check $? for the exit status (zero for success, non-zero for failure)
tmux has-session -t $session 2>/dev/null

if [ $? == 0 ]; then
    echo "Terminating existing tmux session '$session'."
    # Tear it down first
    tmux kill-session -t $session
    sleep 1
fi

set -e

echo "Starting server in new tmux session '$session'."
tmux new-session -d -s $session 'export PATH=$PATH:/home/vagrant/utils/llvm13/install/bin/; cd ../anica_ui/anica_ui; source ../env/anica_ui/bin/activate; ./manage.py runserver 0.0.0.0:8000'


# ithemal session
ITHEMAL_DIR=$SCRIPT_DIR/../anica_ui/lib/anica/lib/iwho/predictors/ithemal

cd $ITHEMAL_DIR

echo "Stopping the previous Ithemal session, if there was any."
./stop.sh

echo "Start the Ithemal session."
./start.sh

