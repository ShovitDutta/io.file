#!/usr/bin/env sh

     export PATH=${PATH}:/apps/bin:/apps/kics/bin:/apps/opa/bin:/apps/gcp/google-cloud-sdk/bin
     echo "INFO: Running iac_srv.sh script"

     declare -A storage_type
     storage_type[sw]=sw
     storage_type[sv]=sv
     getst=(`echo "sv"`)
     let tag_len=0
#default value is /scan Start -DPC-10042023
     root_scan_dir=(`echo "/scan"`)
     root_scan_dir_pt=(`echo "scan"`)
#default value is /scan End -DPC-10042023

     . /apps/lib/cn_common_cloud_map.sh
     . /apps/lib/CSE_AZURE_RULES_HASH.sh
     . /apps/lib/CSE_AZURE_RULES_HASH_Q3.sh
     . /apps/lib/CSE_AZURE_RULES_HASH_Q3_RH.sh
     . /apps/lib/CSE_GCP_RULES_HASH.sh
     . /apps/lib/CSE_GCP_RULES_HASH_Q3.sh
     . /apps/lib/CSE_GCP_RULES_HASH_Q3_RH.sh
     . /apps/lib/CSE_AWS_RULES_HASH.sh
     . /apps/lib/CSE_AWS_RULES_HASH_Q3.sh
     . /apps/lib/CSE_AWS_RULES_HASH_Q3_RH.sh
     . /apps/lib/ECHO.sh
     . /apps/lib/HELP.sh
     . /apps/lib/INPUT_FILE_VALIDATION.sh
     . /apps/lib/OBJ_STORE_OPS.sh
     . /apps/lib/CISS_SCAN.sh
     . /apps/lib/EXCEPTION_PROCESS.sh
     . /apps/lib/SCAN_RPT.sh
     . /apps/lib/CLOUD_TFP_OBJ_PROCESS.sh
     . /apps/lib/PROCESS_TFP_METADATA.sh
     . /apps/lib/POST_PROCESS_FILES.sh
     . /apps/lib/EXIT_DECISION.sh
     . /apps/lib/ll_tfp_process.sh
     . /apps/lib/SPLIT_GCP_TFP.sh 
     . /apps/lib/SPLIT_AZURE_TFP.sh
     . /apps/lib/SPLIT_AWS_TFP.sh
     . /apps/lib/SPLIT_TFP_FILES.sh
     . /apps/lib/PROCESS_STANDARD_EXP_LIST.sh

#### REDIRECT_ROUTINE_STDOUT_START 01/10/2024

     scan_rc_file_out_delete_flg=$(echo "Y")
declare -A verbose_level_hash

    verbose_level_hash["all"]="all"
    verbose_level_hash["error"]="error"
    verbose_level_hash["err"]="err"
    verbose_level_hash["info"]="info"
    verbose_level_hash["warn"]="warn"

   declare -A exit_on_user_input_hash

   #exit_on_user_input_hash["all"]="all"
   exit_on_user_input_hash["all"]="low"
   exit_on_user_input_hash["medium"]="medium"
   exit_on_user_input_hash["high"]="high"
   #exit_on_user_input_hash["veto"]="veto"
   exit_on_user_input_hash["veto"]="low"
   exit_on_user_input_hash["low"]="low"
   #exit_on_user_input_hash["critical"]="critical"
   exit_on_user_input_hash["critical"]="high"

   let exception_wgt_severity_low=1
   let exception_wgt_severity_medium=2
   let exception_wgt_severity_high=4
   let exception_wgt_severity_critical=8
   let exception_wgt_severity_info=0
   let exception_wgt_severity_all=16
   let exception_wgt_severity_veto=32

     let all_severity_ct=0
     let pwd_secrets_tokens_severity_ct=0
     let non_common_rules_violation_ct=0
     let total_severity_info_ct=0
     let total_severity_critical_ct=0
     let total_severity_high_ct=0
     let total_severity_medium_ct=0
     let total_severity_low_ct=0
     let kics_all_rc=0
     summary_file_nm=$(echo "NONE")
     exception_applied_summary_file_nm=$(echo "NONE")
     rules_file_nm=$(echo "NONE")

     SEV=$(echo "CRITICAL,HIGH,LOW,MEDIUM")
     SE=$(echo "HIGH")
     #marker 1 Nov-15-2024
     choice_exit=${choice_exit:-NONE}
     #marker 1 Nov-15-2024

     #marker 1 Nov-15-2024
     declare -A choice_exit_msg_hash
     declare -A choice_exit_code_hash

     choice_exit_msg_hash['info']="EXIT_CONDITION SEVERIY INFO and above."
     choice_exit_msg_hash['low']="EXIT_CONDITION SEVERIY LOW and above."
     choice_exit_msg_hash['medium']="EXIT_CONDITION SEVERIY MEDIUM and above."
     choice_exit_msg_hash['high']="EXIT_CONDITION SEVERIY HIGH and above."
     choice_exit_msg_hash['critical']="EXIT_CONDITION SEVERIY CRITICAL and above."

     choice_exit_code_hash['info']="30"
     choice_exit_code_hash['low']="30"
     choice_exit_code_hash['medium']="40"
     choice_exit_code_hash['high']="60"
     choice_exit_code_hash['critical']="60"

     let final_exit_code=0

     #marker 1 Nov-15-2024

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

     EXP_FL_RULE_CT_BY_SEVERITY_HASH["critical"]="0"
     EXP_FL_RULE_CT_BY_SEVERITY_HASH["high"]="0"
     EXP_FL_RULE_CT_BY_SEVERITY_HASH["low"]="0"
     EXP_FL_RULE_CT_BY_SEVERITY_HASH["medium"]="0"
     EXP_FL_RULE_CT_BY_SEVERITY_HASH["info"]="0"


  declare -A rule_violation_summary_file_list

     if [ "$#" -gt 0 ]; then
          echo "INFO: Parameter1 is ${1}. Storage Type: ${1}"
          getst=${storage_type[${1}]}
          if [ "${getst}" != "${1}" ]; then
             echo "ERROR: Storage ${1} type Not Known. exiting 100"
             exit 100
          fi
     else
        chk_scan=(`ls -C1 / | grep scan  2>/dev/null`)
        chk_scan=${chk_scan:-NONE}
        chk_ws=(`ls -C1 / | grep  workspace  2>/dev/null`)
        chk_ws=${chk_ws:-NONE}

        if  [ "${chk_scan}" == "scan" ] && [ "${chk_ws}" == "workspace" ]; then
           echo "ERROR: Both dir - /scan, /workspace exists and no parameter passed to choose (sw or sv). Exiting with ERROR_CODE=70"
           exit 70
        fi
        if [ "${chk_scan}" != "NONE" ]; then
          getst=(`echo "sv"`)
        else
          if [ "${chk_ws}" != "NONE" ]; then
             getst=(`echo "sw"`)
             root_scan_dir=(`echo "/workspace"`)
             root_scan_dir_pt=(`echo "workspace"`)
          else
              echo "ERROR: Storage type not Exist (/scan or /workspace). Error. Exiting with ERROR_CODE=70"
              exit 70
          fi
        fi
     fi


     if [ "${getst}" != "sv" ]; then
        root_scan_dir=(`echo "/workspace"`)
        root_scan_dir_pt=(`echo "workspace"`)
     fi     
     chk_scan=(`ls -C1 / | grep ${root_scan_dir_pt} 2>/dev/null`)
     chk_scan=${chk_scan:-NONE}

     if [ "${chk_scan}" != "NONE" ]; then
          echo "INFO: VALIDATED_STORAGE Storage type ${getst}, Dir is ${root_scan_dir}"
     else
          echo "ERROR: Storage type ${getst} Dir ${root_scan_dir}  not Exist. Error. Exiting with ERROR_CODE=75"
          exit 70
     fi

#DPC-Global Variables -Start

  pass_or_fail="P"
  build_id_run=$(date '+%Y%m%d-%H_%M_%S-%s-%W%Y-%j')
  ID=$(date '+%s')
  M1ID=$(date '+%s')
  M2ID=$(date '+%s')
  M3ID=$(date '+%s')
  M4ID=$(date '+%s')
  M5ID=$(date '+%s')
  WEEK=$(date '+%W')
  RUN_DATE=$(date '+%Y%m%d')
  STOTAGE_FOLDER_KEY=$(date '+%Y%m%d-%W-%j')
  daily_date_format=$(date '+%Y%m%d-%W-%j')
  STORAGE_FOLDER_KEY=$(date '+%s-%Y%m%d-%W-%j')
  HOUR_KEY=$(date '+%H')
  DAY_OF_MONTH=$(date '+%d')
  year_to_keep=$(echo "${daily_date_format}" | cut -c1-4)
  scan_tools_ar=(kics)

  declare -A scan_tools_hash

  for all in `echo "${scan_tools_ar[@]}"`
  do
       scan_tools_hash[$all]=$all
  done

  declare -A scan_type_hash

     scan_type_hash["TFP_PV"]="TFP_PV"
     scan_type_hash["TFP_FULL"]="TFP_FULL"

#DPC-Global Variables -End

     sleep 1
     echo "INFO: RUN_TIME_VAR_CHK -Start"
     echo "INFO: id for this Run- ${ID} and ${build_id_run}"

#DPC- RUN_TIME_VAR_CHK - Start

     SCAN_DIR=(`echo "/scan"`)

     if [ "${getst}" != "sv" ]; then
         chk_ws=(`ls -C1 / | grep workspace 2>/dev/null`)
         chk_ws=${chk_ws:-NONE}
         if [ "${chk_ws}" != "NONE" ]; then
             SCAN_DIR=(`echo "/workspace/scan"`)
             echo "INFO: Storage is not volume mount"
          else
             echo "ERROR: Directory /workspace not found. Error. Exiting with ERROR_CODE=75"
             exit 75
          fi
     else
         echo "INFO: Storage is volume mount"
         chk_scan=(`ls -C1 / | grep scan 2>/dev/null`)
         chk_scan=${chk_scan:-NONE}
         if [ "${chk_scan}" == "NONE" ]; then
            echo "ERROR: Storage Issue. /scan directory mount by -v source:/scan not done properly. exiting with ERROR_CODE=80"
            exit 80
         else
            echo "INFO: /scan Dir found. Ready to continue Storage is Mount by -v option"
         fi
     fi

     echo "INFO: tfutfiles root dir is SCAN_DIR=${SCAN_DIR}"
     echo "INFO: root scan  dir is ${root_scan_dir}"
     get_env=(`ls -C1 ${root_scan_dir}/.env 2>/dev/null`)
     get_env=${get_env:-NONE}

     if [ "${get_env}" != 'NONE' ]; then
          echo "INFO: env file .env (${get_env}) found."
         . ${get_env}
     else
          echo "INFO: NO .env file found. will try --env APP_NM --env PIPELINE_NM --env SYNK_TOKEN"
     fi

     pv_process=${PV_PROCESS:-Y}
     SCAN_TYPE=$(echo "TFP_PV")
     if [ "${pv_process}" != "Y" ]; then
       SCAN_TYPE=$(echo "TFP_FULL")
     fi
     scan_verbose_level=${SCAN_VERBOSE_LEVEL:-err}
     echo "INFO: scan_verbose_level ${scan_verbose_level} and ENV=${SCAN_VERBOSE_LEVEL}"
     scan_verbose_level=$(echo "${scan_verbose_level}" | tr '[A-Z]' '[a-z]')

     scan_rule_severity=${SCAN_RULE_SEVERITY:-all}
     echo "INFO: scan_rule_severity ${scan_rule_severity} and ENV=${SCAN_RULE_SEVERITY}"
     scan_rule_severity=$(echo "${scan_rule_severity}" | tr '[A-Z]' '[a-z]')


     pipeline_nm=${PIPELINE_NM:-NONE}

     chk_none_value 'E' "${pipeline_nm}" "PIPELINE_NM" "104"

     app_nm=${APP_NM:-NONE}

     chk_none_value 'E' "${app_nm}" "APP_NM" "106"

      infra=${INFRA:-CSE}

     clean_app_nm=(`echo "${app_nm}" | sed 's/\///g'`)
     #clean_pipeline_nm=(`echo "${pipeline_nm}" | sed 's/\///g'`)
     clean_pipeline_nm=(`echo "${pipeline_nm}" | sed 's/__*/_/g' | sed 's/\///g'`)
        
     app_nm=(`echo "${clean_app_nm}"`)
     pipeline_nm=(`echo "${clean_pipeline_nm}"`)

     file_type=${FILE_TYPE:-NONE}
        
     directory=${DIRECTORY:-NONE}

     chk_none_value 'E' "${directory}" "DIRECTORY" "105"

     directory_combo_ct=$(echo "${directory}" | cut -d "/" -f 1-4 |  awk -F "/" '{ OFS="/"; print NF;}')

     if [ ${directory_combo_ct} -lt 4 ]; then
         echo "ERROR: directory must have at least 4 levels. Exiting with 106"
         exit 106
     fi

     directory=$(echo "${directory}" | tr '[A-Z]' '[a-z]')

     LOB=$(echo "${directory}" | cut -d "/" -f 1)
     real_appnm=$(echo "${directory}" | cut -d "/" -f 2)
     ENVI=$(echo "${directory}" | cut -d "/" -f 3)
     LOC=$(echo "${directory}" | cut -d "/" -f 4)

     DIRECTORY_WITH_APPNM_FOLDER=$(echo "${LOB}/${real_appnm}/${ENVI}/${LOC}")

     directory_combo_ct=$(echo "${DIRECTORY_WITH_APPNM_FOLDER}" | cut -d "/" -f 1-4 | sed 's/\//|/g' | sed 's/ //g' | awk -F "|" '{ OFS="|"; print NF;}')

     if [ ${directory_combo_ct} -lt 4 ]; then
         echo "ERROR: directory must have at least 4 levels. LOB/APPLICATION/ENVI/LOC  Exiting with 106"
         exit 106
     fi

     ECHO "INFO: Checking for terraform plan files"
     scan_dir_exists=()
     scan_dir_exists=(`ls -C1 ${SCAN_DIR}/tfut*/*.json 2>/dev/null`)

     count_of_tf_dirs=`echo "${#scan_dir_exists[@]}"`

     if [ ${count_of_tf_dirs} -gt 0 ]; then
         ECHO "INFO: Total projects found count ${count_of_tf_dirs}  dir - ${scan_dir_exists[@]}"
     else
         ECHO "INFO: Mount volume dir ${SCAN_DIR} is empty (No project folders found)"
         ECHO "INFO: Storage type pull from CICD pipeline must have failed"
         ECHO "ERROR: Total projects found ${count_of_tf_dirs} exiting with error code 100"
         exit 100
     fi

     custom_lib=${CUSTOM_LIB:-Y}

     if [ "${custom_lib}" == "Y" ]; then
           ECHO "INFO: kics custom rules included. assets - /apps/custom/kics/assets/..."
     else
           ECHO "INFO: STANDARD libraries and no custom rules included."
     fi

     

     scan_type=${SCAN_TYPE:-NONE}

     if [ "${scan_type}" == "NONE" ]; then
          scan_type=TFP_PV
          ECHO "INFO: scan_type-${scan_type}"
     else
          get_type=${scan_type_hash[$scan_type]}
          ECHO "INFO: hash_get_type-${get_type}"
          get_type=${get_type:-NONE}
          ECHO "INFO: get_type-${get_type}"
          chk_none_value 'E' "${get_type}" "SCAN_TYPE" "100"
     fi
     build_id=$(echo "R-${build_id_run}-${ID}-${app_nm}-${pipeline_nm}")
     scan=${SCAN:-all}

     run_plan=${RUN_PLAN:-Y}
     output_dir=${OUTPUT_DIR:-NONE}
     if [ "${run_plan}" == "N" ]; then
        global_info_dir=(`echo "/tmp/${build_id}"`)
     else
        if [ "${output_dir}" != "NONE" ]; then
             global_info_dir=(`echo "/tmp/${build_id}"`)
             mkdir -p ${global_info_dir}
        else
             global_info_dir=(`echo "${SCAN_DIR}/${build_id}"`)
             mkdir -p ${global_info_dir}
        fi
     fi

     daily_date_format_dir=$(echo "/tmp/iac_scan_status/tfp/${year_to_keep}/${daily_date_format}")
     #rm -rf /tmp/iac_scan_status/
     mv /tmp/iac_scan_status /tmp/iac_scan_status.${build_id_run} 2>/dev/null
     mkdir -p ${daily_date_format_dir}
     tfp_daily_dir=$(echo "${daily_date_format_dir}/daily_tfp")
     mkdir -p ${tfp_daily_dir}
     create_tfp_dir
     
     echo "INFO: GLOBAL_INFO_DIR_CREATION ${global_info_dir}" 
     echo "INFO: DAILY_DATE_FORMAT_DIR ${daily_date_format_dir}" 

#Cloud related OPS - Start

  WHO_AM_I=$(whoami)
  ECHO "INFO: RUN_TIME_INFO: ${WHO_AM_I}"

  GCLOUD_STORAGE_PUSH=(`echo "Y"`)

  declare -A exception_process_cvsid_list_files_hash
  declare -A exception_process_cvsid_csv_files_hash
  declare -A exception_process_cvsid_list_tmp_files_hash
  declare -A exception_directory_root_obj_folder_ar

    gcp_ct=$(ls -C1 /apps/gcp 2>/dev/null | wc -l)
    if [ ${gcp_ct} -gt 0 ]; then
       GCLOUD_STORAGE_PUSH=(`echo "Y"`)
    else
       /apps/bin/gcp_srv_acct_scan_stp.sh 1>/dev/null 2>/dev/null
    fi

  my_current_buk_exp=$(echo "current_buk_exp")
  my_current_buk_scan=$(echo "current_buk_scan")
  my_proj_based_service_acct_fqdn=$(echo "current_buk_scan")
  my_proj_jq_json=$(echo '{"current_buk_exp":"current_buk_exp","current_buk_scan":"current_buk_scan","my_proj_based_service_acct_fqdn":"my_proj_based_service_acct_fqdn"}')
process_proj_name ()
{
          echo "INFO: TYPE DIRECT FN-NAME process_proj_name"
          #echo "${my_proj_json_info}" | jq '.'
          my_proj_jq_json_from_file=$(cat /apps/.config/proj_info.json 2>/dev/null)
          my_proj_jq_json_from_file=${my_proj_jq_json_from_file:-NONE}
          if [ "${my_proj_jq_json_from_file}" != "NONE" ]; then
             my_current_buk_exp=$(echo "${my_proj_jq_json_from_file}" | jq -Mr '.current_buk_exp') # | sed 's/\"//g')
             my_current_buk_scan=$(echo "${my_proj_jq_json_from_file}" | jq -Mr '.current_buk_scan') # | sed 's/\"//g')
             my_proj_based_service_acct_fqdn=$(echo "${my_proj_jq_json_from_file}" | jq -Mr '.current_srv_acct_fqdn') # | sed 's/\"//g')
          else
             my_proj_jq_json=$(echo '{"current_buk_exp":"current_buk_exp","current_buk_scan":"current_buk_scan","my_proj_based_service_acct_fqdn":"my_proj_based_service_acct_fqdn"}')
             my_current_buk_exp=$(echo "${my_proj_jq_json}" | jq -Mr '.current_buk_exp') # | sed 's/\"//g')
             my_current_buk_scan=$(echo "${my_proj_jq_json}" | jq -Mr '.current_buk_scan') # | sed 's/\"//g')
             my_proj_based_service_acct_fqdn=$(echo "${my_proj_jq_json}" | jq -Mr '.current_srv_acct_fqdn') # | sed 's/\"//g')
          fi
          echo "INFO: BUCKET_INFO_SCAN ${my_current_buk_exp} ${my_current_buk_scan}"

          gcloud_acct_if_any=$(gcloud info | grep "Account:" | cut -d ":" -f 2 | sed 's/\[//' | sed 's/\]//' | sed 's/^ //')
          gcloud_acct_if_any=${gcloud_acct_if_any:-NONE}
    
          echo "INFO: service acct Used: ${gcloud_acct_if_any}"
            
          if [ "${my_proj_based_service_acct_fqdn}" != "${gcloud_acct_if_any}" ]; then
              GCLOUD_STORAGE_PUSH=(`echo "N"`)
          fi
}

dummied_case ()
{
  case "${gcloud_acct_if_any}" in
  "NONE")
         ECHO "WARN: Condition - NONE. gcloud acct not set for PIPELINE ${pipeline_nm}. ignoring. NOT_ABLE_TO_PUSH_RPT_FILES"
         GCLOUD_STORAGE_PUSH=(`echo "N"`)
         ;;
  "None")
          ECHO "INFO: Condition - None.  ${HOME}/.config file mismatch."
          GCLOUD_STORAGE_PUSH=(`echo "N"`)
          ECHO "WARN: ${config_present} acct not set for PIPELINE ${pipeline_nm}. ignoring. NOT_ABLE_TO_PUSH_RPT_FILES"
                 ;;
   *)
          ECHO "INFO: Condition - Default.  ${HOME}/.config Test."
          config_present=$(ls -R -C1 ${HOME}/.config/*  | grep "^cse-cc-snyk-scan-report@security-controls-sandbox.iam.gserviceaccount.com")
          config_present=${config_present:-NONE}
          echo "INFO: Condition - Default  config_present ${config_present}"
          if [ "${config_present}" != "NONE" ]; then
             test_remote_object_list "${config_present}"
          else
             GCLOUD_STORAGE_PUSH=(`echo "N"`)
             ECHO "WARN: ${config_present} acct not set for PIPELINE ${pipeline_nm}. ignoring. NOT_ABLE_TO_PUSH_RPT_FILES"
          fi
          ;;
   esac
}

   process_proj_name

#Exception_file_list_info -Start
     echo "INFO: Exception_file_list_info -Start"
     declare -A exception_process_levels_based_files_hash
     declare -A exception_process_all_levels_based_files_hash
     exception_process_obj_prefix=$(echo "gs://${my_current_buk_scan}")
     exception_process_levels_csv_files_of_cvsids_ar=()
     exception_process_enabled=$(echo "NO")
     exception_process_cvsid_list=$(echo "0.0.0.0")
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

       let info_exp_total_severity_ct=0
       let low_exp_total_severity_ct=0
       let high_exp_total_severity_ct=0
       let medium_exp_total_severity_ct=0
       let critical_exp_total_severity_ct=0

     let sep_ct=0
     let real_sep_ct=0
     search_pat=$(echo '*')
     if [ "${directory}" != "NONE" ]; then
         echo "INFO: APP_NM=${app_nm}, PIPELINE_NM=${pipeline_nm} and DIRECTORY=${directory} REAL_APPNM=${real_appnm} INFRA=${infra}"
         exception_process_enabled=$(echo "YES")
         exception_process_directory=$(echo "${directory}" | sed 's/\/^//' | tr '[A-Z]' '[a-z]')
         sep_ct=$(echo "${exception_process_directory}" | awk -F "/" '{ OFS="/"; print NF;}')
         let real_sep_ct=${sep_ct}-2
         prepare_exception_process_filter_files "iac_${app_nm_case}_exception_list" "${exception_process_directory}" "${exception_process_obj_prefix}"
         get_exception_process_list "iac_${app_nm_case}_exception_list" "${exception_process_directory}"
     else
         echo "INFO: APP_NM=${app_nm} and PIPELINE_NM=${pipeline_nm} REAL_APPNM=${real_appnm} INFRA=${infra}"
     fi
     ECHO "INFO: Exception_file_list_info -Start"
     get_glb_exception_process_list
     ECHO "INFO: before  exception_process_cvsid_list = ${exception_process_cvsid_list}"
     ECHO "INFO: before  exception_process_all_glb_ids = ${exception_process_all_glb_ids}"
     if [ "${exception_process_all_glb_ids}" != "NONE" ]; then
         exception_process_cvsid_list=$(echo "${exception_process_cvsid_list},${exception_process_all_glb_ids}")
         tmp_process=$(echo "${exception_process_cvsid_list}" | tr ',' '\n' | sort -u | tr '\n' ',' | sed 's/\,$//' | sed 's/^\,//')
         exception_process_cvsid_list=$(echo "${tmp_process}")
     fi
     process_exception_global_list
     #ciss_standard_exception=$(echo "${exception_process_cvsid_list}" | tr ',' '\n' | grep ".1.1.1" | tr '\n' ',')
     
     #veto_cvsid=$(echo "${exception_process_cvsid_list}" | tr ',' '\n' | grep "0.1.1.1")
     #veto_cvsid=${veto_cvsid:-NONE}
     #if [ "${veto_cvsid}" != "NONE" ]; then
     #   veto_cvsid=$(echo "0.1.1.1")
     #fi
     ECHO "INFO: exception_process_enabled = ${exception_process_enabled}"
     ECHO "INFO: exception_process_cvsid_file_location = ${exception_process_cvsid_file_location}"
     echo "INFO: exception_process_cvsid_list = ${exception_process_cvsid_list}"
     ECHO "INFO: exception_directory_root_obj_folder = ${exception_directory_root_obj_folder}"
     ECHO "INFO: count_of_slashes = ${sep_ct} actual = ${real_sep_ct} search_pat=${search_pat}"
     echo "INFO: Exception_file_list_info -End"
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
            ECHO "INFO: exception_cvsid ${all_exp}"
       done
#Exception_file_list_info -End"

#ACCTID/PROJECTID/AWSID_RELATED_VAR -Start
    STS_ACCT_ID=$(echo "0000-0000-0000-0000-0000")
    declare -A tfp_acctid_hash
#ACCTID/PROJECTID/AWSID_RELATED_VAR -End

   app_nm_cse=$(echo "${app_nm}" | cut -c 1-3 | tr '[A-Z]' '[a-z]')

   if [ "${app_nm_cse}" == "cse" ]; then
         echo "INFO: NO_CLOUD_PUSH_FOR_CSE"
         GCLOUD_STORAGE_PUSH=(`echo "N"`)
   fi

   echo "INFO: Cloud_Push_Status-${GCLOUD_STORAGE_PUSH}"

   #get_exception_process_list
#just create a .config directory for cloud -End
#Cloud related OPS - End

     opt_scan=()

     declare -A opt_scan_rc_hash
     
     opt_scan_rc_hash[kics]=kics
     ECHO "INFO: Key for this Scan is ${build_id} and Scan tools to run ${opt_scan_rc_hash[@]}"
     ECHO "INFO: RUN_TIME_VAR_CHK -End"

#DPC- RUN_TIME_VAR_CHK - End

#DPC-Function find_files_for_tools  -Definition Start
## this function will find files for scan type tools
## example for terraform, terraform plan output files.

   files_to_scan=()

   declare -A tf_plan_check_sum_files_list_hash
   declare -A tf_plan_dir_to_process
   declare -A tf_plan_files_to_process
   declare -A tf_plan_files_resources
   declare -A tf_plan_files_check_sum
   declare -A tf_plan_file_unique_hash
   declare -A tf_plan_file_key_name_hash
   declare -A tf_plan_file_key_dir_hash
   declare -A tf_plan_file_key_just_file_hash
   declare -A tf_plan_file_report_hash
   declare -A tf_plan_file_rpt_hash
   declare -A report_info_hash
   declare -A cr_report_info_hash
   declare -A sm_report_info_hash
   declare -A rr_report_info_hash
   declare -A rr_report_info_keys_hash
   declare -A all_scan_report_info_hash
   declare -A cr_all_scan_report_info_hash
   declare -A kics_report_dir_hash

   declare -A processed_tf_plan_files

   sm_report_info_hash[kics_severity_high]=0
   sm_report_info_hash[kics_severity_medium]=0
   sm_report_info_hash[kics_rules]=0

      total_project_based_tfut_files_ct=(`echo "0"`)
      report_info=()
      cr_report_info=()
      report_info_content=()
      report_info[0]=`echo 'APP_NM,PIPELINE,SCAN_TYPE,DATE_COMBO,ID,BUILD_ID,KEY_SCAN_TYPE,KEY,PROJECT,FILE,UNIQUE_KEY,REPORT_KEY,RESULT,RULES_APPLIED,CUSTOM_RULES_APPLIED,VIOLATIONS,COUNT'`
      cr_report_info[0]=`echo 'APP_NM,PIPELINE,SCAN_TYPE,SERVICE,STANDARD_RULES_CT (Failed),CUSTOM_RULES_CT (Failed)'`
#INFO: DIM - "CSE-PC-AZURE-STORAGEACCOUNT-1222","CsePcAzureStorageaccount1222ConfigureMinimumRequiredVersionOfTransportLayerSecurityTlsOf12ForTheStorageAccount",Custom,"security","high",20230907162128
      let global_row_ct=0
      #dummy_tfplan_output_file_and_resources
      #dummy_all_validated_tf_json_files ()
      #dummy_find_all_json_files()

   declare -A final_output_rule_hash
   declare -A final_kics_output_rule_hash
   declare -A rulesid_kics_hash
   declare -A rulesid_hash
   declare -A tfplan_signature_hash
   declare -A kics_tfplan_signature_hash

      #dummy_process_kics_output_files ()

declare -A tfp_terraform_cloud_hash
declare -A tfp_pipe_file_hash

#declare -A cld_map

#cld_map['azure']="AZURE"
#cld_map['gcp']="GCP"
#cld_map['aws']="AWS"

  get_ucld=$(echo "AZURE")

      #dummy_sim_iac_kics_tools()
      #dummy ()
kics_rc=(`echo "0"`)

      #dummy_run_iac_kics_tools()


sim_client_option_all ()
{
      ECHO "INFO: TYPE INDIRECT FN-NAME run_client_option_all"
            #sim_iac_kics_tools
}

sim_client_option_kics ()
{
      ECHO "INFO: TYPE INDIRECT  FN-NAME client_option_kics"
            ECHO "INFO: kics scan tools"
            #sim_iac_kics_tools
}



run_client_option_all ()
{
      ECHO "INFO: TYPE INDIRECT FN-NAME run_client_option_all"
            ECHO "INFO: run all scan tools"
            #run_iac_kics_tools 
}

run_client_option_kics ()
{
      ECHO "INFO: TYPE INDIRECT  FN-NAME client_option_kics"
            ECHO "INFO: kics scan tools"
            #run_iac_kics_tools
}

#DPC-Function push_report_to_bucket  -Definition Start
## this function will push all the reports to bucket with key $build_id

        #dummy_push_pipe_status_files ()
        ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_status Start #######################
        #dummy_push_report_to_bucket()
        ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_tf_plan Start #######################
        ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_rpt_bucket Start #######################
        ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_rpt_kics Start #######################
        #summary_keys ()
        ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_rpt_keys Start #######################

#DPC-Function push_report_to_bucket  -Definition End


     prefix_run=(`echo "run"`)
scan_plan_files ()
{
    ECHO "INFO: TYPE DIRECT FN-NAME scan_plan_files"
    if [ "${run_plan}" != 'Y' ]; then
         prefix_run=(`echo "sim"`)
         ECHO "INFO: simulation."
    fi
       for all in `echo "${opt_scan_rc_hash[@]}"`
       do
           ECHO "INFO: Running ${all}"
           if [ "${all}" != "NONE" ]; then
                 ${prefix_run}_client_option_${all}
           fi
       done
    if [ "${prefix_run}" != "sim" ]; then
        if [ "${GCLOUD_STORAGE_PUSH}" == "Y" ]; then
           ECHO "INFO: GCLOUD_STORAGE_PUSH_RPT"
           push_report_to_bucket
        fi
    fi
}

#Main Action Start
     llv=${LLV:-INFO}
     #find_all_json_files
     #split_tfp_files_into_keys
     #tfplan_output_file_and_resources
     CN_ASSETS_PATH=$(echo "/apps/custom/common/assets/queries")
     CUSTOM_ASSETS_PATH=$(echo "/apps/custom/kics/assets/queries")
     export KICS_QUERIES_PATH="/apps/kics/assets/queries"
     if [ "${custom_lib}" == "Y" ]; then
         ECHO "INFO: custom_lib ${custom_lib} KICS_SEARCH_RULE /apps/kics/assets/queries,/apps/custom/kics/assets/queries"
         export KICS_QUERIES_PATH="/apps/kics/assets/queries,/apps/custom/kics/assets/queries"
     else
         ECHO "INFO: custom_lib ${custom_lib} KICS_SEARCH_RULE /apps/kics/assets/queries"
         export KICS_QUERIES_PATH="/apps/kics/assets/queries"
     fi
     include_cn_rules=${INCLUDE_CN_RULES:-Y}
     case_type=${CASE_TYPE:-scan}
     common_passwd_secrets_severity_flg=${COMMON_PASSWD_SECRETS_SEVERITY_FLG:-LOW}

     export SP_CN_PATH=/apps/custom/common/assets/queries/terraform/common/passwords_and_secrets/regex_rules.json
     ECHO "INFO: KICS_QUERIES_PATH ${KICS_QUERIES_PATH}"
     ECHO "INFO: COMMON_RULES_DIR_VAR SP_CN_PATH ${SP_CN_PATH}"
     let rules_violated_file_fields=17
     let summary_rules_violated_file_fields=30
     let ENGINE_CT=2
     SCAN_CN_OPTION=$(echo "--secrets-regexes-path ${SP_CN_PATH}")
     if [ "${include_cn_rules}" == "N" ]; then
          #SCAN_CN_OPTION=$(echo "")
          SCAN_CN_OPTION=$(echo "--disable-secrets ")
          export KICS_QUERIES_PATH="${KICS_QUERIES_PATH}"
          let ENGINE_CT=1
     else
          export KICS_QUERIES_PATH="${KICS_QUERIES_PATH},${CN_ASSETS_PATH}"
          let ENGINE_CT=2
     fi
     chk_cn=$(echo "{KICS_QUERIES_PATH}" | grep "common" | wc -l)
     chk_cn=${chk_cn:-NONE}
     if [ "${chk_cn}" == "NONE" ]; then
         let ENGINE_CT=1
     fi
     let summary_rules_violated_file_fields=26
     echo "INFO: KICS_ENGINE_USED: ${ENGINE_CT}. SCAN_TYPE: ${scan_type}"
     echo "INFO: IF SCAN_TYPE is TFP_PV, KICS_ENGINE_USED_IS 2 (DEFAULT_CONDITION)"
     echo "INFO: IF SCAN_TYPE is TFP_FULL, KICS_ENGINE_USED_IS 1 (DEFAULT_CONDITION)"
     echo "INFO: KICS_QUERIES_PATH SET AS ${KICS_QUERIES_PATH}"
     echo "INFO: KICS_QUERIES_CN_PATH_OPT ${SCAN_CN_OPTION}"
     M1ID=$(date '+%s')
     echo "INFO: TIME ${M1ID}-TFP_STAGE_01-JSON"
     find_all_json_files
     M2ID=$(date '+%s')
     echo "INFO: TIME ${M2ID}-TFP_STAGE_01-JSON"
     split_tfp_files_into_keys
     tfplan_output_file_and_resources
     scan_plan_files 
     #cat rules_violated_file_R-20240802-04_07_31-1722571651-312024-215-1722571651-CSE-PASSWD_SECRET.pipe | awk -F "|" '{ OFS="|"; print NF;}' | sort -u 17
     #cat summary_rules_violated_file_R-20240802-04_07_31-1722571651-312024-215-1722571651-CSE-PASSWD_SECRET.pipe | awk -F "|" '{ OFS="|"; print NF;}' | sort -u 30
     #let rules_violated_file_fields=17
     #let summary_rules_violated_file_fields=30
     M9ID=$(date '+%s')
     let TTS=${M2ID}-${M9ID}
     echo "INFO: TOTAL_TIME_SPENT-${TTS}"
     EXIT_ON_USER_INPUT ${global_info_dir} ${build_id}
#Main Action End
