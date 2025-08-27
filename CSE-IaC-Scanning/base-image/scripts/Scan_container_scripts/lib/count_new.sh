#!/usr/bin/env sh


   declare -A exit_on_user_input_hash

   exit_on_user_input_hash["all"]="all"
   exit_on_user_input_hash["medium"]="medium"
   exit_on_user_input_hash["high"]="high"
   exit_on_user_input_hash["veto"]="veto"
   exit_on_user_input_hash["low"]="low"
   exit_on_user_input_hash["critical"]="critical"

     let all_severity_ct=0
     let pwd_secrets_tokens_severity_ct=0
     let non_common_rules_violation_ct=0
     let total_severity_info_ct=0
     let total_severity_critical_ct=0
     let total_severity_high_ct=0
     let total_severity_medium_ct=0
     let total_severity_low_ct=0
     let kics_all_rc=0
     #summary_file_nm=$(echo "NONE")
     exception_applied_summary_file_nm=$(echo "NONE")
     rules_file_nm=$(echo "NONE")

     SEV=$(echo "CRITICAL,HIGH,LOW,MEDIUM")
     SE=$(echo "HIGH")
     choice_exit=${choice_exit:-NONE}

     declare -A choice_exit_msg_hash
     declare -A choice_exit_code_hash

     choice_exit_code_hash['info']="30"
     choice_exit_code_hash['low']="30"
     choice_exit_code_hash['medium']="40"
     choice_exit_code_hash['high']="60"
     choice_exit_code_hash['critical']="60"

     let final_exit_code=0

     choice_exit_msg_hash['info']="EXIT_CONDITION SEVERIY INFO and above."
     choice_exit_msg_hash['low']="EXIT_CONDITION SEVERIY LOW and above."
     choice_exit_msg_hash['medium']="EXIT_CONDITION SEVERIY MEDIUM and above."
     choice_exit_msg_hash['high']="EXIT_CONDITION SEVERIY HIGH and above."
     choice_exit_msg_hash['critical']="EXIT_CONDITION SEVERIY CRITICAL and above."

     declare -A  RULE_CT_BY_SEVERITY_HASH
     declare -A  EXP_RULE_CT_BY_SEVERITY_HASH
     declare -A  EXP_UC_RULE_CT_BY_SEVERITY_HASH
     declare -A  EXP_FL_RULE_CT_BY_SEVERITY_HASH

     RULE_CT_BY_SEVERITY_HASH["CRITICAL"]="0"
     RULE_CT_BY_SEVERITY_HASH["HIGH"]="0"
     RULE_CT_BY_SEVERITY_HASH["LOW"]="0"
     RULE_CT_BY_SEVERITY_HASH["MEDIUM"]="0"
     RULE_CT_BY_SEVERITY_HASH["INFO"]="0"

     EXP_RULE_CT_BY_SEVERITY_HASH["critical"]="0"
     EXP_RULE_CT_BY_SEVERITY_HASH["high"]="0"
     EXP_RULE_CT_BY_SEVERITY_HASH["low"]="0"
     EXP_RULE_CT_BY_SEVERITY_HASH["medium"]="0"
     EXP_RULE_CT_BY_SEVERITY_HASH["info"]="0"

     EXP_UC_RULE_CT_BY_SEVERITY_HASH["critical"]="0"
     EXP_UC_RULE_CT_BY_SEVERITY_HASH["high"]="0"
     EXP_UC_RULE_CT_BY_SEVERITY_HASH["low"]="0"
     EXP_UC_RULE_CT_BY_SEVERITY_HASH["medium"]="0"
     EXP_UC_RULE_CT_BY_SEVERITY_HASH["info"]="0"

     declare -A exception_process_levels_based_files_hash
     declare -A exception_process_all_levels_based_files_hash
     exception_process_obj_prefix=$(echo "gs://dev-cvs-scan-reports")
     exception_process_levels_csv_files_of_cvsids_ar=()
     exception_process_enabled=$(echo "NO")
#1.1.1.998|LOW^1.27.5.1|LOW^2.1.1.966|LOW^2.1.1.966|LOW^2.1.1.966|LOW^2.1.1.966|LOW
#2.6.2.1|MEDIUM^2.6.1.4|MEDIUM^2.6.2.1|MEDIUM^2.6.1.4|MEDIUM^2.6.2.1|MEDIUM^2.6.1.4|MEDIUM^2.6.2.1|MEDIUM^2.6.1.4|MEDIUM
     #exception_process_cvsid_list=$(echo "0.0.0.0,1.27.3.1,1.1.1.998,1.27.5.1,2.1.1.966,2.6.2.1,2.6.1.4")
     #exception_process_cvsid_list=$(echo "0.0.0.0,2.1.1.966,2.6.2.1")
     exception_process_cvsid_list=$(echo "0.0.0.0,1.1.1.968,1.1.1.998,1.13.3.6,1.3.1.7,1.3.4.1,1.4.5.2,2.10.1.3,2.40.1.2")
     exception_process_all_glb_ids=$(echo "NONE")
     exception_process_cvsid_file_location=$(echo "NONE")
     exception_process_cvsid_loal_file_location=$(echo "/tmp/exp_list.csv")
     app_nm_case=$(echo "${app_nm}" | tr '[A-Z]' '[a-z]')
     exception_process_directory=$(echo "NONE")
     exception_directory_l1_folder=$(echo "NONE")
     exception_directory_root_obj_folder=$(echo "NONE")
     declare -A exception_cvsid_hash
     declare -A exception_cvsid_vs_severity_hash
     declare -A exception_cvsid_vs_severity_low_hash
     declare -A exception_cvsid_vs_severity_medium_hash
     declare -A exception_cvsid_vs_severity_high_hash
     declare -A exception_cvsid_vs_severity_critical_hash
     declare -A exception_cvsid_vs_severity_info_hash

       all_ids_found=$(echo "${exception_process_cvsid_list}" | tr ',' '\n' | grep -v "0.0.0.0" |  sort -u | tr '\n' ',')
       all_ids_found=${all_ids_found:-NONE}
       if [ "${all_ids_found}" != "NONE" ]; then
            for all_cvsid in `echo "${all_ids_found}" | tr ',' '\n'`
            do
                exception_cvsid_hash[${all_cvsid}]="${all_cvsid}"
            done
       fi
       for all_exp in `echo "${exception_cvsid_hash[@]}"`
       do
            echo "INFO: exception_cvsid ${all_exp}"
       done
       let info_exp_total_severity_ct=0
       let low_exp_total_severity_ct=0
       let high_exp_total_severity_ct=0
       let medium_exp_total_severity_ct=0
       let critical_exp_total_severity_ct=0

low_exp_total_severity_ct ()
{
   let low_exp_total_severity_ct=${low_exp_total_severity_ct}+1
   exception_cvsid_vs_severity_low_hash[${1}]="low"
}

medium_exp_total_severity_ct ()
{
   let medium_exp_total_severity_ct=${medium_exp_total_severity_ct}+1
   exception_cvsid_vs_severity_medium_hash[${1}]="medium"
}

high_exp_total_severity_ct ()
{
   let high_exp_total_severity_ct=${high_exp_total_severity_ct}+1
   exception_cvsid_vs_severity_high_hash[${1}]="high"
}

critical_exp_total_severity_ct ()
{
   let critical_exp_total_severity_ct=${critical_exp_total_severity_ct}+1
   exception_cvsid_vs_severity_critical_hash[${1}]="critical"
}

info_exp_total_severity_ct ()
{
   #echo "INFO: ct ${info_exp_total_severity_ct}, ${1}"
   let info_exp_total_severity_ct=${info_exp_total_severity_ct}+1
   exception_cvsid_vs_severity_info_hash[${1}]="info"
}

exception_process_info ()
{
    #if [ ${info_exp_total_severity_ct} -gt 0 ]; then
    #    echo "INFO: severity info ct ${info_exp_total_severity_ct}"
    #    echo "INFO: info cvsid ${!exception_cvsid_vs_severity_info_hash[@]}"
    #    echo "INFO: info cvsid severity ${exception_cvsid_vs_severity_info_hash[@]}"
    #fi
    #if [ ${low_exp_total_severity_ct} -gt 0 ]; then
    #    echo "INFO: severity low ct ${low_exp_total_severity_ct}"
    #    echo "INFO: low cvsid ${!exception_cvsid_vs_severity_low_hash[@]}"
    #    echo "INFO: low cvsid severity ${exception_cvsid_vs_severity_low_hash[@]}"
    #fi
    #if [ ${medium_exp_total_severity_ct} -gt 0 ]; then
    #    echo "INFO: severity medium ct ${medium_exp_total_severity_ct}"
    #    echo "INFO: medium cvsid ${!exception_cvsid_vs_severity_medium_hash[@]}"
    #    echo "INFO: medium cvsid severity ${exception_cvsid_vs_severity_medium_hash[@]}"
    #fi
    #if [ ${high_exp_total_severity_ct} -gt 0 ]; then
    #    echo "INFO: severity high ct ${high_exp_total_severity_ct}"
    #    echo "INFO: high cvsid ${!exception_cvsid_vs_severity_high_hash[@]}"
    #    echo "INFO: high cvsid severity ${exception_cvsid_vs_severity_high_hash[@]}"
    #fi
    #if [ ${critical_exp_total_severity_ct} -gt 0 ]; then
    #    echo "INFO: severity critical ct ${critical_exp_total_severity_ct}"
    #    echo "INFO: critical cvsid ${!exception_cvsid_vs_severity_critical_hash[@]}"
    #    echo "INFO: critical cvsid severity ${exception_cvsid_vs_severity_critical_hash[@]}"
    #fi
        get_exp_info_ct=$(echo "${EXP_RULE_CT_BY_SEVERITY_HASH['info']}")
        get_exp_info_ct=${get_exp_info_ct:-0}
        if [ ${get_exp_info_ct} -gt 0 ]; then
             :
        else
             EXP_RULE_CT_BY_SEVERITY_HASH['info']=0
        fi
        get_exp_low_ct=$(echo "${EXP_RULE_CT_BY_SEVERITY_HASH['low']}")
        get_exp_low_ct=${get_exp_low_ct:-0}
        if [ ${get_exp_low_ct} -gt 0 ]; then
             :
        else
             EXP_RULE_CT_BY_SEVERITY_HASH['low']=0
        fi
        get_exp_meduim_ct=$(echo "${EXP_RULE_CT_BY_SEVERITY_HASH['medium']}")
        get_exp_meduim_ct=${get_exp_meduim_ct:-0}
        if [ ${get_exp_meduim_ct} -gt 0 ]; then
             :
        else
             EXP_RULE_CT_BY_SEVERITY_HASH['medium']=0
        fi
        get_exp_high_ct=$(echo "${EXP_RULE_CT_BY_SEVERITY_HASH['high']}")
        get_exp_high_ct=${get_exp_high_ct:-0}
        if [ ${get_exp_high_ct} -gt 0 ]; then
             :
        else
             EXP_RULE_CT_BY_SEVERITY_HASH['high']=0
        fi
        get_exp_critical_ct=$(echo "${EXP_RULE_CT_BY_SEVERITY_HASH['critical']}")
        get_exp_critical_ct=${get_exp_critical_ct:-0}
        if [ ${get_exp_critical_ct} -gt 0 ]; then
             :
        else
             EXP_RULE_CT_BY_SEVERITY_HASH['critical']=0
        fi
}

exception_process_user_choice ()
{
        case "${choice_exit}" in
        "info")
               #echo "INFO: choice ${choice_exit}"
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["critical"]=${EXP_RULE_CT_BY_SEVERITY_HASH['critical']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["high"]=${EXP_RULE_CT_BY_SEVERITY_HASH['high']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["low"]=${EXP_RULE_CT_BY_SEVERITY_HASH['low']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["medium"]=${EXP_RULE_CT_BY_SEVERITY_HASH['medium']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["info"]=${EXP_RULE_CT_BY_SEVERITY_HASH['info']}
               EXP_RULE_CT_BY_SEVERITY_HASH["info"]=0
               RULE_CT_BY_SEVERITY_HASH["INFO"]=0
               #echo "INFO: choice ${choice_exit}"
               ;;
        "low")
               #echo "INFO: choice ${choice_exit}"
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["critical"]=${EXP_RULE_CT_BY_SEVERITY_HASH['critical']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["high"]=${EXP_RULE_CT_BY_SEVERITY_HASH['high']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["low"]=${EXP_RULE_CT_BY_SEVERITY_HASH['low']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["medium"]=${EXP_RULE_CT_BY_SEVERITY_HASH['medium']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["info"]=${EXP_RULE_CT_BY_SEVERITY_HASH['info']}
               EXP_RULE_CT_BY_SEVERITY_HASH["info"]=0
               RULE_CT_BY_SEVERITY_HASH["INFO"]=0
               #echo "INFO: choice ${choice_exit}"
               ;;
        "medium")
               #echo "INFO: choice ${choice_exit}"
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["critical"]=${EXP_RULE_CT_BY_SEVERITY_HASH['critical']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["high"]=${EXP_RULE_CT_BY_SEVERITY_HASH['high']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["medium"]=${EXP_RULE_CT_BY_SEVERITY_HASH['medium']}
               EXP_RULE_CT_BY_SEVERITY_HASH["low"]=0
               EXP_RULE_CT_BY_SEVERITY_HASH["info"]=0
               RULE_CT_BY_SEVERITY_HASH["LOW"]=0
               RULE_CT_BY_SEVERITY_HASH["INFO"]=0
               #echo "INFO: choice ${choice_exit}"
               ;;
        "high")
               #echo "INFO: choice ${choice_exit}"
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["critical"]=${EXP_RULE_CT_BY_SEVERITY_HASH['critical']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["high"]=${EXP_RULE_CT_BY_SEVERITY_HASH['high']}
               EXP_RULE_CT_BY_SEVERITY_HASH["low"]=0
               EXP_RULE_CT_BY_SEVERITY_HASH["medium"]=0
               EXP_RULE_CT_BY_SEVERITY_HASH["info"]=0
               RULE_CT_BY_SEVERITY_HASH["LOW"]=0
               RULE_CT_BY_SEVERITY_HASH["MEDIUM"]=0
               RULE_CT_BY_SEVERITY_HASH["INFO"]=0
               #echo "INFO: choice ${choice_exit}"
               ;;
        "critical")
               #echo "INFO: choice ${choice_exit}"
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["critical"]=${EXP_RULE_CT_BY_SEVERITY_HASH['critical']}
               EXP_RULE_CT_BY_SEVERITY_HASH["high"]=0
               EXP_RULE_CT_BY_SEVERITY_HASH["low"]=0
               EXP_RULE_CT_BY_SEVERITY_HASH["medium"]=0
               EXP_RULE_CT_BY_SEVERITY_HASH["info"]=0
               RULE_CT_BY_SEVERITY_HASH["HIGH"]=0
               RULE_CT_BY_SEVERITY_HASH["LOW"]=0
               RULE_CT_BY_SEVERITY_HASH["MEDIUM"]=0
               RULE_CT_BY_SEVERITY_HASH["INFO"]=0
               #echo "INFO: choice ${choice_exit}"
               ;;
        
         *)
               #echo "INFO: choice unknown ${choice_exit}"
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["critical"]=${EXP_RULE_CT_BY_SEVERITY_HASH['critical']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["high"]=${EXP_RULE_CT_BY_SEVERITY_HASH['high']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["low"]=${EXP_RULE_CT_BY_SEVERITY_HASH['low']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["medium"]=${EXP_RULE_CT_BY_SEVERITY_HASH['medium']}
               #EXP_UC_RULE_CT_BY_SEVERITY_HASH["info"]=${EXP_RULE_CT_BY_SEVERITY_HASH['info']}
               EXP_RULE_CT_BY_SEVERITY_HASH["info"]=0
               RULE_CT_BY_SEVERITY_HASH["INFO"]=0
               #echo "INFO: choice ${choice_exit}"
               ;;
         esac
}

final_count_cal ()
{
         #echo "INFO: RULE_CT_BY_SEVERITY_HASH Start"
         for all_sev in `echo "${!RULE_CT_BY_SEVERITY_HASH[@]}"`
         do
             get_ct=$(echo "${RULE_CT_BY_SEVERITY_HASH[${all_sev}]}")
             #echo "INFO: TOTAL-SEVERITY ${all_sev} COUNT=${get_ct}"
         done
         #echo "INFO: RULE_CT_BY_SEVERITY_HASH End"
         #echo "INFO: EXP_RULE_CT_BY_SEVERITY_HASH Start"
         for all_sev in `echo "${!EXP_RULE_CT_BY_SEVERITY_HASH[@]}"`
         do
             get_ct=$(echo "${EXP_RULE_CT_BY_SEVERITY_HASH[${all_sev}]}")
             #echo "INFO: TOTAL-SEVERITY ${all_sev} COUNT=${get_ct}"
         done
         #echo "INFO: EXP_RULE_CT_BY_SEVERITY_HASH End"
         #echo "INFO: EXP_UC_RULE_CT_BY_SEVERITY_HASH Start"
         for all_sev in `echo "${!EXP_UC_RULE_CT_BY_SEVERITY_HASH[@]}"`
         do
             get_ct=$(echo "${EXP_UC_RULE_CT_BY_SEVERITY_HASH[${all_sev}]}")
             #echo "INFO: TOTAL-SEVERITY ${all_sev} COUNT=${get_ct}"
         done
         #echo "INFO: EXP_UC_RULE_CT_BY_SEVERITY_HASH End"
         echo "#@@@@@@@@@@@@@@@@@@@@@@@ FINAL_RULES_COUNT_TO_EXIT_DECISION Start @@@@@@@@@@@@@@@@@@@@@@"
         for all_sev in `echo "${!RULE_CT_BY_SEVERITY_HASH[@]}"`
         do
             lall_sev=$(echo "${all_sev}" | tr '[A-Z]' '[a-z]')
             exp_all_get_ct=$(echo "${RULE_CT_BY_SEVERITY_HASH[${all_sev}]}")
             exp_uc_get_ct=$(echo "${EXP_RULE_CT_BY_SEVERITY_HASH[${lall_sev}]}")
             #echo "INFO: FL_CAL- ${all_sev} ${lall_sev} RULE-${exp_all_get_ct} UC-${exp_uc_get_ct}"
             let exp_fl_cal_val=${exp_all_get_ct}-${exp_uc_get_ct}
             if [ ${exp_fl_cal_val} -gt 0 ]; then
                   final_exit_code=${choice_exit_code_hash[${choice_exit}]}
             fi
             echo "#INFO: EXIT_ON_USER_INPUT FL_CAL- Severity ${all_sev} SCAN_RULE_CT-${exp_all_get_ct} EXCEPTION_RULE_CT-${exp_uc_get_ct} FINAL_RULE_CT-${exp_fl_cal_val}"
             EXP_FL_RULE_CT_BY_SEVERITY_HASH[${all_sev}]=${exp_fl_cal_val}
         done
         echo "#@@@@@@@@@@@@@@@@@@@@@@@ FINAL_RULES_COUNT_TO_EXIT_DECISION End @@@@@@@@@@@@@@@@@@@@@@"
         #echo "INFO: EXP_FL_RULE_CT_BY_SEVERITY_HASH Start"
         for all_sev in `echo "${!EXP_FL_RULE_CT_BY_SEVERITY_HASH[@]}"`
         do
             get_ct=$(echo "${EXP_FL_RULE_CT_BY_SEVERITY_HASH[${all_sev}]}")
             #echo "INFO: TOTAL-SEVERITY ${all_sev} COUNT=${get_ct}"
         done
         #echo "INFO: EXP_FL_RULE_CT_BY_SEVERITY_HASH End"
         let total_severity_critical_ct=${EXP_FL_RULE_CT_BY_SEVERITY_HASH["CRITICAL"]}
         let total_severity_high_ct=${EXP_FL_RULE_CT_BY_SEVERITY_HASH["HIGH"]}
         let total_severity_medium_ct=${EXP_FL_RULE_CT_BY_SEVERITY_HASH["MEDIUM"]}
         let total_severity_low_ct=${EXP_FL_RULE_CT_BY_SEVERITY_HASH["LOW"]}
         let total_severity_info_ct=${EXP_FL_RULE_CT_BY_SEVERITY_HASH["INFO"]}
         let all_severity_ct=${total_severity_critical_ct}+${total_severity_high_ct}+${total_severity_medium_ct}+${total_severity_low_ct}+${total_severity_info_ct}
}
stdout_summary_select_column_file ()
{

    prefix=$(echo "# ")
    echo "############################## Consolidated_List_of_Non-Compliance_Policies -Start ##############################"
    echo "#  CVSID |              Desc                         |    Cloud_Resource                |         Context                       "
    #cat ${summary_file_nm} | awk -F "|" -v prefix="${prefix}" '{ OFS="|"; print prefix$1,$3,$10,$25;}' | sort -u
    cat ${summary_file_nm} | awk -F "|" -v prefix="${prefix}" '{ OFS="|"; print prefix$1,$4,$10,$18,$19,$20,$21,$22,$25;}' | sort -u
    echo "############################## Consolidated_List_of_Non-Compliance_Policies -End ################################"
}
stdout_summary_file ()
{
    echo "INFO: EXIT_ON_USER_INPUT- NON_COMPLIANCE_POLICIES_SUMMARY_LIST_START"
    echo "INFO: EXIT_ON_USER_INPUT- CVSID|UUID|Desc|Severity|Cloud|tfplan_file|Ruld_GUUID|Resource|ResourceID|Attribute_Type|Property|Reason|Actual_Value|TFP_SIGNATURE"
    cat ${summary_file_nm} | awk -F "|" -v PREFIX="INFO: EXIT_ON_USER_INPUT- " '{ OFS="|"; print PREFIX,$1,$2,$4,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$25  ;}' |  sort
    echo "INFO: EXIT_ON_USER_INPUT- NON_COMPLIANCE_POLICIES_SUMMARY_LIST_END"
}

print_rules_violation_list_before_exception ()
{
         let vbl_ct=0
         echo "################ SEVERITY_VIOLATION_CT_FROM_SCAN Start #####################"
         echo "INFO: EXIT_ON_USER_INPUT- choice_exit ${choice_exit}"
         for all_sev in `echo "${!RULE_CT_BY_SEVERITY_HASH[@]}"`
         do
             get_ct=$(echo "${RULE_CT_BY_SEVERITY_HASH[${all_sev}]}")
             echo "#INFO: EXIT_ON_USER_INPUT- TOTAL-SEVERITY_VIOLATION_CT_FROM_SCAN  (SEVERITY=${all_sev},COUNT=${get_ct})"
             let vbl_ct=${vbl_ct}+${get_ct}
         done
         echo "#INFO: EXIT_ON_USER_INPUT- TOTAL-SEVERITY_VIOLATION_CT_FROM_SCAN (SEVERITY=ALL,COUNT=${vbl_ct})"
         echo "################ SEVERITY_VIOLATION_CT_FROM_SCAN End #####################"
}

exit_based_on_rules ()
{
     if [ ${all_severity_ct} -eq 0 ]; then
        M7ID=$(date '+%s')
        echo "INFO: TIME ${M7ID}-TFP_STAGE_06-EXIT_End"
        let rc_ct_based_on_severity=0
        echo "INFO: NO_RULES_VIOLATION_FOUND. STATUS (exit ${rc_ct_based_on_severity})"
        exit ${rc_ct_based_on_severity}
     fi
}

print_rules_exception_found ()
{       
         let vrl_ct=0
         echo "%%%%%%%%%%%%%%%% SEVERITY_EXCEPTION_FOUND_FROM_TABLE Start  %%%%%%%%%%%%%%%%%"
         for all_sev in `echo "${!EXP_RULE_CT_BY_SEVERITY_HASH[@]}"`
         do
             get_ct=$(echo "${EXP_RULE_CT_BY_SEVERITY_HASH[${all_sev}]}")
             echo "#INFO: EXIT_ON_USER_INPUT- EXIT_ON_USER_INPUT- TOTAL-SEVERITY_EXCEPTION_FOUND_FROM_TABLE (SEVERITY=${all_sev},COUNT=${get_ct})"
             let vrl_ct=${vrl_ct}+${get_ct}
         done
         echo "#INFO: EXIT_ON_USER_INPUT- TOTAL-SEVERITY_EXCEPTION_FOUND_FROM_TABLE (SEVERITY=ALL,COUNT=${vrl_ct})"
         echo "%%%%%%%%%%%%%%%% SEVERITY_EXCEPTION_FOUND_FROM_TABLE End %%%%%%%%%%%%%%%%%%%%%"
}

exception_print_info ()
{        
        #echo "INFO: EXIT_ON_USER_INPUT- summary_of_rules_violation_due_to_policy  ${RULE_CT_BY_SEVERITY_HASH[@]}"
        #echo "INFO: EXIT_ON_USER_INPUT- summary_of_rules_exclude_due_to_exception_request  ${EXP_RULE_CT_BY_SEVERITY_HASH[@]}"
        #echo "INFO: EXIT_ON_USER_INPUT- summary_of_rules_exclude_due_to_uc ${EXP_UC_RULE_CT_BY_SEVERITY_HASH[@]}"
        echo "&&&&&&&&&&&&&&&&& SEVERITY_FINAL_CT_EXIT_RETURN_VALUE Start &&&&&&&&&&&&&&&&&&&&"
        echo "#INFO: EXIT_ON_USER_INPUT- SEVERITY_FINAL_CT final_rules_ct summary_of_rules_violation=summary_of_rules_violation_due_to_policy-summary_of_rules_exclude_due_to_uc"
        echo "#INFO: EXIT_ON_USER_INPUT- SEVERITY=critical rules count ${total_severity_critical_ct}"
        echo "#INFO: EXIT_ON_USER_INPUT- SEVERITY=high rules count ${total_severity_high_ct}"
        echo "#INFO: EXIT_ON_USER_INPUT- SEVERITY=medium rules count ${total_severity_medium_ct}"
        echo "#INFO: EXIT_ON_USER_INPUT- SEVERITY=low rules count ${total_severity_low_ct}"
        echo "#INFO: EXIT_ON_USER_INPUT- SEVERITY=info rules count ${total_severity_info_ct}"
        echo "#INFO: EXIT_ON_USER_INPUT- TOTAL_ALL_SEVERITY rules count ${all_severity_ct}"
        echo "#INFO: ${choice_exit_msg_hash[${choice_exit}]}"
        echo "#INFO: EXIT_CODE_SET ${choice_exit_code_hash[${choice_exit}]}"
        M7ID=$(date '+%s')
        echo "INFO: TIME ${M7ID}-TFP_STAGE_06-EXIT_End"
        echo "&&&&&&&&&&&&&&&&& SEVERITY_FINAL_CT_EXIT_RETURN_VALUE End &&&&&&&&&&&&&&&&&&&&"
        #exit ${choice_exit_code_hash[${choice_exit}]}
        exit ${final_exit_code}
}       

RULES_SEVERITY_COUNT ()
{
    #echo "INFO: TYPE OPT-INDIRECT FN-NAME RULES_SEVERITY_COUNT"
       let ct=1
       let total_rules=0
       FN=${1:-6}
       summary_file_nm=${2:-NONE}
       choice_exit=${3:-low}
       #echo "INFO: FILES: ${summary_file_nm}  ${exception_applied_summary_file_nm}"
       if [ "${summary_file_nm}" == "NONE" ]; then
           echo "ERROR: input 2 missing"
           exit 100
       fi
       exception_applied_summary_file_nm=$(echo "${summary_file_nm}" | sed 's/summary_rules_violated_file_/exception_applied_summary_rules_violated_file_/')
       #echo "INFO: FILES: ${summary_file_nm}  ${exception_applied_summary_file_nm}"
       rm -rf ${exception_applied_summary_file_nm}
#INFO: Severity info,low,medium, high, critical process Start.
       for states in `echo "INFO|LOW|MEDIUM|HIGH|CRITICAL" | tr '|' '\n'`
       do
           #echo "INFO: state ${states}"
           all=$(cat ${summary_file_nm} | sort -k 6 -t "|" | cut -d "|" -f 6 | sed 's/\"//g' | awk -F "|"  -v st="${states}" '{ OFS="|"; if ( $1 == st ) { print $1;}}' | sed 's/\"//g' |  tr '\n' '|' | sed 's/|$//')
           all=${all:-NONE}
           if [ "${all}" != "NONE" ]; then
              #echo "INFO: state ${states}  all ${all}"
              REC=$(echo "${all}" | awk -F "|" '{ OFS="|"; print $1,NF;}')
              F1=$(echo "${REC}" | cut -d "|" -f 1)
              F2=$(echo "${REC}" | cut -d "|" -f 2)
              #echo "INFO: ${REC} ${F1} ${F2}"
              RULE_CT_BY_SEVERITY_HASH["${F1}"]=${F2}
              let total_rules=${total_rules}+${F2}
           else
              RULE_CT_BY_SEVERITY_HASH["${states}"]=0
           fi
           #RULE_CT_BY_SEVERITY_HASH are loaded with state versus count if else case.
           lsrv=$(echo "${states}" | tr '[A-Z]' '[a-z]')
           all_cvsid_severity=$(cat ${summary_file_nm} | sort -k 6 -t "|" | cut -d "|" -f 1,6 | sed 's/\"//g' | awk -F "|"  -v st="${states}" '{ OFS="|"; if ( $2 == st ) { print $1,$2;}}' | sed 's/\"//g' |  tr '\n' '^' | sed 's/\^$//')
           all_cvsid_severity=${all_cvsid_severity:-NONE}

           if [ "${all_cvsid_severity}" != "NONE" ]; then
              tmp_ct=$(echo "${all_cvsid_severity}" | tr '^' '\n' | tr '|' '\n' | egrep "${states}" | wc -l) 
              let tmp_ct=0 #${tmp_ct}
              #echo "INFO: all_cvsid_severity ${all_cvsid_severity}"
              for all_cvsid_severity_combo in `echo "${all_cvsid_severity}" | tr '^' '\n'`
              do
                scvsid=$(echo "${all_cvsid_severity_combo}" | cut -d "|" -f 1)
                severity=$(echo "${all_cvsid_severity_combo}" | cut -d "|" -f 2)
                #echo "INFO: CVSID: ${scvsid}, Severity ${severity}"
                get_exp_cvsid=$(echo "${exception_cvsid_hash[${scvsid}]}")
                get_exp_cvsid=${get_exp_cvsid:-NONE}
                if [ "${get_exp_cvsid}" != "NONE" ]; then
                    exception_cvsid_vs_severity_hash[${scvsid}]="${severity}"
                    #cat ${summary_file_nm} | egrep -v ${scvsid} >> ${exception_applied_summary_file_nm}
                    let tmp_ct=${tmp_ct}+1
                    ${lsrv}_exp_total_severity_ct "${scvsid}"
                    #echo "INFO: ##### scvsid ${scvsid}, Severity ${severity} is_in_exception_list"
                else
                    :
                    #echo "INFO: %%%%% scvsid ${scvsid}, Severity ${severity} is_not_in_exception_list"
                fi
              done
              EXP_RULE_CT_BY_SEVERITY_HASH["${lsrv}"]=${tmp_ct}
           fi
       done
        exception_process_info
        stdout_summary_file
        stdout_summary_select_column_file

       if [ ${total_rules} -eq 0 ]; then
          M7ID=$(date '+%s')
          echo "INFO: TIME ${M7ID}-TFP_STAGE_06-EXIT_End"
          let rc_ct_based_on_severity=0
          echo "INFO: NO_RULES_VIOLATION_FOUND. STATUS (exit ${rc_ct_based_on_severity})"
          exit ${rc_ct_based_on_severity}
       fi
}
      RULES_SEVERITY_COUNT ${1} ${2} ${3}
      #exit_based_on_rules
      print_rules_violation_list_before_exception
      print_rules_exception_found
      exception_process_user_choice
      #exception_print_info
      #print_rules_violation_list_before_exception
      #print_rules_exception_found
      final_count_cal
      exception_print_info
