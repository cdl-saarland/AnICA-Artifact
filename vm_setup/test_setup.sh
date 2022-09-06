#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source $SCRIPT_DIR/anica_ui/env/anica_ui/bin/activate

LOG_FILE=/tmp/test_setup.log
echo "running test_setup.sh " > $LOG_FILE

TEST_BBS=$SCRIPT_DIR/setup/resources/test_bbs.s


function check_return() {
    retVal=$1
    if [ $retVal -ne 0 ]; then
        cp $LOG_FILE /vagrant/test_setup_error.log
        echo "  FAILED! A report has been written to the shared folder of the VM." | tee -a $LOG_FILE
        exit $retVal
    else
        echo "  SUCCESS!" | tee -a $LOG_FILE
    fi
}


echo "Testing llvm-mc..." | tee -a $LOG_FILE

echo ".intel_syntax noprefix" | cat - $TEST_BBS | llvm-mc >> $LOG_FILE 2>&1

check_return $?

echo "Done testing llvm-mc." | tee -a $LOG_FILE


echo "Testing the provided predictors..." | tee -a $LOG_FILE

PREDICTORS="test.all_1 llvm-mca.13-r+a.hsw llvm-mca.9-r+a.hsw llvm-mca.8-r+a.hsw uica.hsw osaca.0.4.6.hsw difftune.artifact.hsw ithemal.bhive.hsw"

PREDICT=$SCRIPT_DIR/anica_ui/lib/anica/lib/iwho/tool/iwho-predict
PRED_CONFIG=$SCRIPT_DIR/anica_ui/lib/anica/lib/iwho/configs/predictors/default.json

for pred in $PREDICTORS; do
    echo "  Testing $pred..." | tee -a $LOG_FILE

    $PREDICT --predconfig $PRED_CONFIG -p $pred --asm $TEST_BBS >> $LOG_FILE 2>&1

    check_return $?
done

echo "Done testing the provided predictors." | tee -a $LOG_FILE


echo "Running AnICA tests..." | tee -a $LOG_FILE

$SCRIPT_DIR/anica_ui/lib/anica/tests/run_tests.sh >> $LOG_FILE 2>&1

check_return $?


echo "Running a small AnICA campaign..." | tee -a $LOG_FILE

anica-discover -c "$SCRIPT_DIR/artifact_configs/campaign/test_llvmmca_uica.json" "$SCRIPT_DIR/results/test/" >> $LOG_FILE 2>&1

check_return $?

echo "Importing the results to the UI..." | tee -a $LOG_FILE

$SCRIPT_DIR/anica_ui/anica_ui/manage.py import_campaign "setup_test" $SCRIPT_DIR/results/test/campaign_* >> $LOG_FILE 2>&1

check_return $?

echo "Please check in the UI for the new test campaign! (default: 127.0.0.1:8300/anica/campaign/?tag=setup_test)" | tee -a $LOG_FILE

echo "Done testing AnICA." | tee -a $LOG_FILE

