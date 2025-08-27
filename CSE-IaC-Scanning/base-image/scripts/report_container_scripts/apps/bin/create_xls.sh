#!/usr/bin/env sh

     export PATH=${PATH}:/apps/bin:/apps/kics/bin:/apps/snyk/bin:/apps/opa/bin:/apps/gcp/google-cloud-sdk/bin:/apps/hc/tf:/apps/hc/vault:/apps/hc/consul:/apps/hc/bin
     echo "INFO: Running $0 script"

     if [ $# -lt 7 ]; then
        echo "INFO: Usage $0 iac_scan.41.2023.xlsx /apps/custom/report/cr.csv 41.kics.sm.csv 41.snyk.sm.csv 41.rr.csv 41.rr.detail.unique.rules.csv /apps/custom/report/kics_terraform_rules.csv"
        echo "INFO: Minimum 7 sheets required to create report"
        echo "ERROR: Exiting. Insufficient spreadsheet #s. EXIT_WITH_ERROR_CODE=100"
        exit 100
     fi

    python3 /apps/bin/convert_files_to_cr_sm_rr_formatted_xls.py ${1} ${2} ${3} ${4} ${5} ${6} ${7}
