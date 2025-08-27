EXIT_ON_USER_INPUT ()
{
    ECHO "INFO: TYPE OPT-INDIRECT FN-NAME EXIT_ON_USER_INPUT"

    rules_violated_file_dir=${1:-/tmp}
    choice_exit=$(echo "${exit_on_user_input_hash[${scan_rule_severity}]}")
    choice_exit=${choice_exit:-low}
    if [ "${choice_exit}" == "critical" ]; then
          echo "INFO: choice_exit is critical."
          echo "INFO: higest level allowed is high. switching to high"
          choice_exit=$(echo "high")
    fi

    

     M7ID=$(date '+%s')
     echo "INFO: TIME ${M7ID}-TFP_STAGE_06-EXIT-START"
     let total_rules=0
     let rules_low_mi_hi_cri_ct=0
     RULES_SEVERITY_COUNT 
      print_rules_violation_list_before_exception
      print_rules_exception_found
      exception_process_user_choice
      final_count_cal
      if [ "${veto_cvsid}" == "0.1.1.1" ]; then
           echo "#INFO: APP_BASED_VETO. (${app_nm}) ALL_RULES_VIOLATION_EXCEPT. EXIT_CODE=0"
           exit 0
      fi
      cloud_based_global_exception
      exception_print_info

}
