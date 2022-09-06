#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd $SCRIPT_DIR

# import the provided campaigns
../anica_ui/anica_ui/manage.py import_campaign paper_eval_provided ../results/provided/oopsla22_data/campaigns/campaign_*

# import the provided basic block set with measurements
../anica_ui/anica_ui/manage.py import_bbset --isa x86 "Data for Fig. 1 (Paper)" ../results/provided/oopsla22_data/overview_bbs_hsw_l4_03.csv

# compute metrics involving both
../anica_ui/anica_ui/manage.py compute_bbset_coverage

# import generalizations
../anica_ui/anica_ui/manage.py import_generalization ../results/provided/generalizations/*

