#!/usr/bin/env sh


 #CONFIGURATION_FILE_LIST=${1:-NONE}
 daily_date_format=${1:-NONE}
 already_done=${2:-Y}
 DEBUG=${3:-n}

  
#/data/iac_scan_status/20240123/tfp/keys/tfp_root_key_configuration_process_status.info
#./process_tfp_configuration_metadata.sh /data/iac_scan_status/tfp/2024/20240123-04-023/20240123/tfp/keys/tfp_root_key_configuration_process_status.info N
#all_tf_list.info
#dups_tf_list.info
#ecs_tf_list.info
#err_tf_list.info
#gcp_tf_list.info
#tf_list.info

   if  [ "${daily_date_format}" == "NONE" ]; then
         echo "ERROR: Parameter daily_date_format required."
         echo "INFO: Usage- $0 20240125-04-025"
         exit 100
   fi
 
   year_to_keep=$(echo "${daily_date_format}" | cut -c1-4)
   yyyymmdd_format=$(echo "${daily_date_format}" | cut -c1-8)
   echo "INFO: year ${year_to_keep} yyyymmdd_format ${yyyymmdd_format}"

   CONFIGURATION_FILE_LIST=$(echo "/data/iac_scan_status/tfp/${year_to_keep}/${daily_date_format}/${yyyymmdd_format}/tfp/keys/tfp_root_key_configuration_process_status.info")
   
 declare -A tfp_root_keys_hash
 declare -A tfp_root_keys_type_hash
 declare -A tfp_final_pipe_files_name_hash
 tfp_root_keys_ar=()

 tfp_root_keys_hash["configuration"]="configuration"
 tfp_root_keys_hash["format_version"]="format_version"
 tfp_root_keys_hash["planned_values"]="planned_values"
 tfp_root_keys_hash["prior_state"]="prior_state"
 tfp_root_keys_hash["relevant_attributes"]="relevant_attributes"
 tfp_root_keys_hash["resource_changes"]="resource_changes"
 tfp_root_keys_hash["resource_drift"]="resource_drift"
 tfp_root_keys_hash["terraform_version"]="terraform_version"
 tfp_root_keys_hash["NONE"]="NONE"

 tfp_root_keys_type_hash["configuration"]="obj:configuration"
 tfp_root_keys_type_hash["format_version"]="key:format_version"
 tfp_root_keys_type_hash["planned_values"]="obj:planned_values"
 tfp_root_keys_type_hash["prior_state"]="obj:prior_state"
 tfp_root_keys_type_hash["relevant_attributes"]="obj:relevant_attributes"
 tfp_root_keys_type_hash["resource_changes"]="obj:resource_changes"
 tfp_root_keys_type_hash["resource_drift"]="obj:resource_drift"
 tfp_root_keys_type_hash["terraform_version"]="key:terraform_version"
 tfp_root_keys_type_hash["NONE"]="none:NONE"

 declare -A tfp_configuration_hash
 declare -A tfp_format_version_hash
 declare -A tfp_planned_values_hash
 declare -A tfp_prior_state_hash
 declare -A tfp_relevant_attributes_hash
 declare -A tfp_resource_changes_hash
 declare -A tfp_resource_drift_hash
 declare -A tfp_terraform_version_hash
 declare -A tfp_terraform_cloud_hash

 declare -A tfp_hash
 declare -A tfp_files_hash
 declare -A tfp_files_appnm_hash
 declare -A tfp_files_pp_hash

#2023_10_13-15_46_50-1697212010-41_2023-286
  build_id_run_str=$(date '+%Y_%m_%d-%H_%M_%S-%s-%W_%Y-%j')
#20231013-15_46_50-1697212010-41_2023-286
  Ymd=$(echo "${build_id_run_str}" | cut -d "-" -f 1)
  YEAR=$(echo "${Ymd}" | cut -d "_" -f 1)
  MONTH=$(echo "${Ymd}" | cut -d "_" -f 2)
  DAY_OF_MONTH=$(echo "${Ymd}" | cut -d "_" -f 3)
#20231013
  RUN_DATE=$(echo "${YEAR}${MONTH}${DAY_OF_MONTH}")
  HMS_KEY=$(echo "${build_id_run_str}" | cut -d "-" -f 2)
  HOUR_KEY=$(echo "${HMS_KEY}" | cut -d"_" -f 1)
  MINUTE_KEY=$(echo "${HMS_KEY}" | cut -d"_" -f 2)
  SECOND_KEY=$(echo "${HMS_KEY}" | cut -d"_" -f 3)
#1697212010
  ID=$(echo "${build_id_run_str}" | cut -d "-" -f 3)
#41_2023
  WEEK_YEAR_KEY=$(echo "${build_id_run_str}" | cut -d "-" -f 4)
#41_2023
  WEEK=$(echo "${WEEK_YEAR_KEY}" | cut -d "_" -f 1)
#286
  DAY_OF_YEAR=$(echo "${build_id_run_str}" | cut -d "-" -f 5)
#20231013-15_46_50-1697212010-412023-286
  build_id_run=$(echo "${RUN_DATE}-${HMS_KEY}-${ID}-${WEEK}${YEAR}-${DAY_OF_YEAR}")
#20231013-41-286
  STORAGE_FOLDER_KEY1=$(echo "${RUN_DATE}-${WEEK}-${DAY_OF_YEAR}")
#1697212010-20231013-41-286
  STORAGE_FOLDER_KEY2=$(echo "${ID}-${STORAGE_FOLDER_KEY1}")

echo_vars ()
{
  echo "INFO: FUNCTION_NAME echo_vars"
  echo "INFO: build_id_run=${build_id_run} DATE_FORMAT='+%Y%m%d%H%M%S-%W%Y-%j'"
  echo "INFO: STORAGE_FOLDER_KEY1=${STORAGE_FOLDER_KEY1} DATE_FORMAT='+%Y%m%d-%W-%j'"
  echo "INFO: STORAGE_FOLDER_KEY2=${STORAGE_FOLDER_KEY2} DATE_FORMAT='+%s-%Y%m%d-%W-%j'"
  echo "INFO: RUN_DATE=${RUN_DATE} DATE_FORMAT='+%Y%m%d'"
  echo "INFO: YEAR=${YEAR} DATE_FORMAT='+%Y'"
  echo "INFO: MONTH=${MONTH} DATE_FORMAT='+%m'"
  echo "INFO: WEEK=${WEEK} DATE_FORMAT='+%W'"
  echo "INFO: DAY_OF_MONTH=${DAY_OF_MONTH} DATE_FORMAT='+%d'"
  echo "INFO: DAY_OF_YEAR=${DAY_OF_YEAR} DATE_FORMAT='+%j'"
  echo "INFO: HOUR_KEY=${HOUR_KEY} DATE_FORMAT='+%H'"
  echo "INFO: MINUTE_KEY=${MINUTE_KEY} DATE_FORMAT='+%M'"
  echo "INFO: SECOND_KEY=${SECOND_KEY} DATE_FORMAT='+%S'"
  echo "INFO: ID=${ID} DATE_FORMAT='%s'"
}

 rc=$(echo "rc")

 base_name=$(echo "NONE")

 rpt_date=$(echo "rpt_date")

 tfp_root=$(echo "/data/iac_scan_status/${RUN_DATE}/tfp")
 tfp_info_root=$(echo "/data/iac_scan_status/${RUN_DATE}/tfp/info")

 appnm=$(echo "NONE")

 debug=$(echo "${DEBUG}")

break_step ()
{
    echo "INFO: FUNCTION_NAME break_step"
    if [ "${debug}" == "t" ]; then
         read SSSSS
    fi
}
echo_unique_keys ()
{
    echo "INFO: FUNCTION_NAME echo_unique_keys"
    ##echo "INFO: keys=${tfp_hash[@]}"
}


NONE ()
{
    echo "INFO: FUNCTION_NAME NONE"
}

  declare -A UCLOUD

  UCLOUD["azure"]="AZURE"
  UCLOUD["aws"]="AWS"
  UCLOUD["gcp"]="GCP"
  UCLOUD["AZURE"]="AZURE"
  UCLOUD["AWS"]="AWS"
  UCLOUD["GCP"]="GCP"

 SOFT_DEPLOYMENT=$(echo "N")
 STS_ACCT_ID=$(echo "0000-0000-0000-0000-0000")

   sts_all_files=()
   declare -A sts_tfp_hash
   declare -A tfp_sts_hash
   declare -A sts_tfp_all_hash
   declare -A sts_tfp_aditional_field

   sts_tfp_unique_ct=$(echo "0")

azure_resource_mining ()
{
    echo "INFO: FUNCTION_NAME azure_resource_mining"

# declare -A tfp_configuration_hash
# declare -A tfp_planned_values_hash
# declare -A tfp_prior_state_hash
# declare -A tfp_relevant_attributes_hash
# declare -A tfp_resource_changes_hash
# declare -A tfp_resource_drift_hash
#${post_process_full_path}/${my_sts_file_nm}
    my_cld=$(echo "AZURE")
    bn=$(echo "${3}")
    unique_time=$(echo "${3}" | cut -d "_" -f 3)
    my_sts_file_nm=$(echo "${bn}" | cut -d "_" -f1-2 | sed "s/$/_${my_cld}_${unique_time}/")
    echo "INFO: my_sts_file_nm ${my_sts_file_nm}"
    get_sts_file_1=$(echo "${sts_tfp_hash[${my_sts_file_nm}]}")
    get_sts_file=$(echo "${sts_tfp_all_hash[${my_sts_file_nm}]}")
    get_sts_file=${get_sts_file:-NONE}
    echo "INFO: get_sts_file_1_from_sts_tfp_hash ${get_sts_file_1}"
    echo "INFO: get_sts_file_from_sts_tfp_all_hash ${get_sts_file}"
    #read SSSSS
    if [ "${get_sts_file}" != "NONE" ]; then
           processed_file_nm=$(echo "${get_sts_file}" | sed 's/\.pipe/_processed\.pipe/')
           planned_values_tf_file_nm=$(echo "${get_sts_file}" | sed 's/\.pipe/_planned_values_tf\.pipe/')
           prior_state_tf_file_nm=$(echo "${get_sts_file}" | sed 's/\.pipe/_perior_state_tf\.pipe/')
           resource_changestf_file_nm=$(echo "${get_sts_file}" | sed 's/\.pipe/_resource_changes_tf\.pipe/')
             echo "INFO: processed_file_nm  ${processed_file_nm}"
             echo "INFO: get_sts_file ${get_sts_file}"
             STS_ACCT_ID=$(echo "0000-0000-0000-0000-0000")
             azure_tfp_obj_key_process "${1}" "${2}" "${3}" "azure"
             echo "INFO: STS_ACCT_ID ${STS_ACCT_ID}"
             tfp_configuration_file_name=$(echo "$1}")
             tfp_planned_values_file_name=$(echo "${1}" | sed 's/configuration/planned_values/')
             tfp_prior_state_file_name=$(echo "${1}" | sed 's/configuration/prior_state/')
             tfp_relevant_attributes_file_name=$(echo "${1}" | sed 's/configuration/relevant_attributes/')
             tfp_resource_changes_file_name=$(echo "${1}" | sed 's/configuration/resource_changes/')

             #echo "INFO: tfp_planned_values_file_name=${tfp_planned_values_file_name}"
             #echo "INFO: tfp_prior_state_file_name=${tfp_prior_state_file_name}"
             #echo "INFO: tfp_resource_changes_file_name=${tfp_resource_changes_file_name}"
             root_module_chk=$(cat ${tfp_planned_values_file_name} | jq '.root_module' | sed 's/{}//') 
             root_module_chk=${root_module_chk:-NONE}
             SOFT_DEPLOYMENT=$(echo "N")
             if [ "${root_module_chk}" != "NONE" ]; then
                   #get_tags_pv=$(cat ${tfp_planned_values_file_name} | jq '.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq -r -c  'keys,values|join("|")' | tr '\n' '^'| sed 's/\^/|resource_name|subscription_id|date|hour|pipeline_name|app_id|terraform_id\^/')
                   get_tags_pv=$(cat ${tfp_planned_values_file_name} | jq '.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq -r -c  'keys,values|join("|")' | tr '\n' '^') #| sed 's/\^/|resource_name|subscription_id|date|hour|pipeline_name|app_id|terraform_id\^/')
            
             else
                   echo "INFO: tfp_planned_values_file_name ${tfp_planned_values_file_name} empty. SOFT_DEPLOYMENT"
                   SOFT_DEPLOYMENT=$(echo "Y")
             fi

             #get_tags_ps=$(cat ${tfp_prior_state_file_name} | jq '.values.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq -r -c  'keys,values|join("|")' | tr '\n' '^'| sed 's/\^/|resource_name|subscription_id|date|hour|pipeline_name|app_id|terraform_id\^/')
             get_tags_ps=$(cat ${tfp_prior_state_file_name} | jq '.values.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq -r -c  'keys,values|join("|")' | tr '\n' '^') #| sed 's/\^/|resource_name|subscription_id|date|hour|pipeline_name|app_id|terraform_id\^/')


             get_tags_rc=$(cat ${tfp_resource_changes_file_name} | jq '.[].change.before.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq -r -c  'keys,values|join("|")' | tr '\n' '^') #| sed 's/\^/|resource_name|subscription_id|date|hour|pipeline_name|app_id|terraform_id\^/')

             #echo "INFO: tfp_planned_values_file_name=${tfp_planned_values_file_name}"
             #echo "INFO: get_tags_pv=${get_tags_pv}"

             real_appnm=$(echo "NONE")
             declare -A real_appnm_hash
             #echo "INFO:---------------- RECORDS ------------------"
             get_tags_pv_ar=()
             read_app_nm_from_pv=$(echo "NONE")
             echo "${get_tags_pv}" | sed 's/\^$//' |  tr '^' '\n' | grep  "^applicationname" | sed 's/$/|acctid/' > ${planned_values_tf_file_nm}
             echo "${get_tags_pv}" | sed 's/\^$//' |  tr '^' '\n' | grep -v  "^applicationname" | tr '\n' ' '|  sed "s/$/|${STS_ACCT_ID}/" >> ${planned_values_tf_file_nm}
             read_app_nm_from_pv=$(echo "${get_tags_pv}" | sed 's/\^$//' |  tr '^' '\n' | grep -v  "^applicationname" | awk -F "|" '{ OFS="|"; print $1;}' | tr '\n' ' ')
             #echo "INFO: PV  REALAPPNM - ${read_app_nm_from_pv}"
             real_appnm=${read_app_nm_from_pv:-NONE}
             real_appnm_hash["APPNM"]="${real_appnm}"
             #echo "INFO:---------------- RECORDS ------------------"

             #echo "INFO: tfp_prior_state_file_name=${tfp_prior_state_file_name}"
             #echo "INFO: get_tags_ps=${get_tags_ps}"

             #echo "INFO:---------------- RECORDS ------------------"
             get_tags_ps_ar=()
             read_app_nm_from_ps=$(echo "NONE")
             read_app_nm_ar=()
             echo "${get_tags_ps}" | sed 's/\^$//' | tr '^' '\n' | grep  "^applicationname" | sed 's/$/|acctid/'  > ${prior_state_tf_file_nm}
             echo "${get_tags_ps}" | sed 's/\^$//' | tr '^' '\n' | grep -v "^applicationname" | tr '\n' ' ' | sed "s/$/|${STS_ACCT_ID}/" >> ${prior_state_tf_file_nm} 
             read_app_nm_from_ps=$(echo "${get_tags_ps}" | sed 's/\^$//' | tr '^' '\n' | grep -v "^applicationname" | awk -F "|" '{ OFS="|"; print $1;}' |  tr '\n' ' ')
             #echo "INFO: PS  REALAPPNM - ${read_app_nm_from_ps}"
             real_appnm=${read_app_nm_from_ps:-NONE}
             get_appnm=$(echo "${real_appnm_hash[APPNM]}")
             if [ "${get_appnm}" == "NONE" ]; then
                 real_appnm_hash["APPNM"]="${real_appnm}"
             fi
             #echo "INFO:---------------- RECORDS ------------------"

             #echo "INFO: tfp_resource_changes_file_name=${tfp_resource_changes_file_name}"
             #echo "INFO: get_tags_rc=${get_tags_rc}"

             #echo "INFO:---------------- RECORDS ------------------"
             get_tags_rc_ar=()
             read_app_nm_from_rc=$(echo "NONE")
             read_app_nm_ar=()
             echo "${get_tags_rc}" | sed 's/\^$//' |  tr '^' '\n' | grep  "^applicationname" | sed 's/$/|acctid/' > ${resource_changestf_file_nm}
             echo "${get_tags_rc}" | sed 's/\^$//' |  tr '^' '\n' | grep -v "^applicationname" | tr '\n' ' ' | sed "s/$/|${STS_ACCT_ID}/" >> ${resource_changestf_file_nm} 
             read_app_nm_from_rc=$(echo "${get_tags_rc}" | sed 's/\^$//' |  tr '^' '\n' | grep -v "^applicationname" | awk -F "|" '{ OFS="|"; print $1;}' | tr '\n' ' ')
             #echo "INFO: RC  REALAPPNM - ${read_app_nm_from_rc}"
             real_appnm=${read_app_nm_from_rc:-NONE}
             get_appnm=$(echo "${real_appnm_hash[APPNM]}")
             if [ "${get_appnm}" == "NONE" ]; then
                 real_appnm_hash["APPNM"]="${real_appnm}"
             fi
             #echo "INFO:---------------- RECORDS ------------------"


             get_appnm=$(echo "${real_appnm_hash[APPNM]}")
             if [ "${get_appnm}" == "NONE" ]; then
                 get_appnm=$(echo "APPNM_NOT_DEFINED")
             else
                 get_appnm=$(echo "${get_appnm}" | sed 's/\s$//g')
             fi

             echo "INFO: FINAL_REALAPPNM ${get_appnm}"
             echo "INFO: ACCTID ${STS_ACCT_ID}"
             #processed_file_nm=$(echo "${get_sts_file}" | sed 's/\.pipe/_processed\.pipe/')
             #echo "INFO ${processed_file_nm}"
             base_nm_processed_file_nm=$(basename ${processed_file_nm})
             cat ${get_sts_file} | sed -e  "s/REALAPPNAME/${get_appnm}/" | sed -e  "s/ACCTID/${STS_ACCT_ID}/" > ${post_process_full_path}/${base_nm_processed_file_nm}
             #cat ${get_sts_file} | sed -e  "s/REALAPPNAME/${get_appnm}/" | sed -e  "s/ACCTID/${STS_ACCT_ID}/" > ${processed_file_nm}
     else
              echo "INFO: STS_PROCESS_${3}_NOT_FOUND"
              echo "INFO: STS_PROCESS_${3}_NOT_FOUND" >> ${sts_root}/STS_PROCESS_NOT_FOUND.err
      #read SSSSS
     fi
      #read SSSSS
}

declare -A tfp_pipe_based_header
declare -A tfp_azure_subscription
declare -A tfp_azure_additional_col
azure_tfp_obj_key_process ()
{
    echo "INFO: FUNCTION_NAME azure_tfp_obj_key_process"

    #echo "INFO: $@"
    #read SSSSS

                           echo "INFO: KEY=configuration, FILE=${1}"
                           planned_values_file=$(echo "${1}" | sed 's/\/configuration/\/planned_values/')
                           prior_state_file=$(echo "${1}" | sed 's/\/configuration/\/prior_state/')
                           resource_changes_file=$(echo "${1}" | sed 's/\/configuration/\/resource_changes/')

                           collect_resources=()
                           collect_resources=(`cat ${1}| jq '.provider_config|keys' | jq '.| join("|")' | sed 's/\"//g' | tr '|' '\n'`)
                           collect_only_azure_resources=(`echo "${collect_resources[@]}" | tr ' ' '\n' | grep "^azurerm"`)
                           collect_only_modules=(`echo "${collect_resources[@]}" | tr ' ' '\n' | grep -v  "^azurerm"`)
                           ##echo "INFO: ALL_RESOURCES- ${collect_resources[@]}"
                           #echo "INFO: AZURE_RESOURCES- ${collect_only_azure_resources[@]}"
                           total_resources=$(echo "${#collect_only_azure_resources[@]}")

                           if [ "${total_resources}" -gt  0 ]; then
                                azure_subscription_id=$(cat ${1} | jq '.provider_config.azurerm.expressions.subscription_id.constant_value?' | sed 's/\"//g' |  sed 's/null//')
                                azure_subscription_id=${azure_subscription_id:-NONE}
                                #azure_subscription_id=$(cat ${1} | jq '.provider_config.azurerm' | tr '\n' ' ' | sed 's/\"subscription_id\"/\n\"subscription_id\"/g' | grep subscription_id | sed 's/ //g' | sed 's/^/{/' | sed 's/}$//' | jq '.subscription_id.constant_value')
                           else
                                 echo "INFO: NO_AZURE_CLOUD_RESOURCES_USED_FOR_THIS_DEPLOYMENT(ONLY_SOFT_RESOURCES)"
                                 #azure_subscription_id=$(echo "0000-0000-0000-0000-0000")
                                 azure_subscription_id=$(cat ${prior_state_file} | jq '.values.root_module.child_modules[].resources[0].values.subscription_id?' | sed 's/\"//g' |  sed 's/null//')
                                 azure_subscription_id=${azure_subscription_id:-NONE}
                           fi

                           if [ "${azure_subscription_id}" == "NONE" ]; then
                                 azure_subscription_id=$(echo "0000-0000-0000-0000-0000")
                           fi
                           STS_ACCT_ID=$(echo "${azure_subscription_id}")
}

gcp_tfp_obj_key_process ()
{
    echo "INFO: FUNCTION_NAME gcp_tfp_obj_key_process"
}

aws_tfp_obj_key_process ()
{
    echo "INFO: FUNCTION_NAME aws_tfp_obj_key_process"
}

CLOUD_AZURE ()
{
    echo "INFO: FUNCTION_NAME CLOUD_AZURE"
}
CLOUD_AWS ()
{
    echo "INFO: FUNCTION_NAME CLOUD_AWS"
}

CLOUD_GCP ()
{
    echo "INFO: FUNCTION_NAME CLOUD_GCP"
}


load_all_tfp_root_keys_processed_files_json ()
{
    echo "INFO: FUNCTION_NAME load_all_tfp_root_keys_processed_files_json"
    #echo "INFO: ${tfp_status_root}/${status_of_tfp_root_files}"
    for all_keys in `cat "${tfp_status_root}/${status_of_tfp_root_files}"`
    do
        #echo "INFO: KEY=${all_keys}"
        cols3_ar=()
        cols3_ar=(`echo "${all_keys}" | tr ':' ' '`)
        col1=$(echo "${cols3_ar[0]}")
        col2=$(echo "${cols3_ar[1]}")
        col3=$(echo "${cols3_ar[3]}")
        tfp_files_hash[${col1}]="${col2}"
    done

}

check_process_is_done ()
{
      echo "INFO: FUNCTION_NAME check_process_is_done"
  
      echo "INFO: SEARCH_FILE ls -C1 ${1}"
      check_err_file=$(ls -C1 ${sts_root}/POST_PROCESS.ERR 2>/dev/null)
      check_err_file=${check_err_file:-NONE}
      let err_files_ct=0
      if [ "${check_err_file}" == "NONE" ]; then
         err_files_ct=$(cat ${sts_root}/POST_PROCESS.ERR 2>/dev/null | wc -l)
      fi
      cd ${1} 
      sts_found=$(ls -C1 ./S*.pipe 2>/dev/null | sort -u |  grep -v "_tf.pipe" | wc -l)
      ppf_found=$(ls -C1 ./post_processed/S*.pipe 2>/dev/null |  wc -l)
      echo "INFO: (sts_found,ppf_found)=(${sts_found},${ppf_found})"
      #let sts_found=${sts_found}
      #let ppf_found=${ppf_found}+${err_files_ct}
      #echo "INFO: with_err_files (sts_found,ppf_found)=(${sts_found},${ppf_found})"
      if [ "${sts_found}" ==  "${ppf_found}" ]; then
             #echo "INFO: (sts_found,ppf_found)=(${sts_found},${ppf_found})"
             echo "INFO: NOTHING_TO_DO"
             if [ "${already_done}" == "Y" ]; then
               echo "INFO: ALREADY_COMPLETED. NOTHING_TO_DO. EXIT 0"
               exit 0
             else
               echo "INFO: OVER_RIDE. PROCESS_WILL_CONTINUE"     
             fi
      else
             
             echo "INFO: PROCESS_WILL_CONTINUE"
      fi
     cd -
}
   
collect_additional_fields ()
{
      echo "INFO: FUNCTION_NAME collect_additional_fields"
      echo "INFO: ALL_STS_DIR: ${1}"
      rm -rf ${sts_root}/POST_PROCESS_TFP_STS_NO_RULES_APPLIED.info
      rm -rf ${sts_root}/POST_PROCESS_TFP_STS_RULES_APPLIED.info
      sts_all_files=$(ls -C1 ${1}/*.pipe 2>/dev/null | grep -v "_tf\.pipe" | grep -v "_processed\.pipe")
      sts_all_files_ct=$(echo "${sts_all_files[@]}" | wc -l)
      file_list_from_flag_file=$(cat ${1}/../sts_${2}_pipe.info | sort -u | wc -l)
      echo "INFO: VALIDATION_PHASE_CT (${sts_all_files_ct},${file_list_from_flag_file})"
      if [ "${sts_all_files_ct}" == "${file_list_from_flag_file}" ]; then
            echo "INFO: STS_FILE_COUNT_MATCH. CONTINUING..."
            for all_tfp_sts in `echo "${sts_all_files[@]}"`
            do
                #echo "INFO: FILE ${all_tfp_sts}"
                clip_tfp_cloud=$(echo "${all_tfp_sts}" | cut -d "/" -f 8 | awk -F "-" '{ OFS="-"; print $1,$4;}' | sed 's/_R-/_/')
                #echo "INFO: tfp-${clip_tfp_cloud}"
                sts_tfp_hash["${clip_tfp_cloud}"]="${all_tfp_sts}"
            done
            sts_tfp_unique_ct=$(echo "${sts_tfp_hash[@]}" | tr ' ' '\n' |  wc -l)
            echo "INFO: sts_tfp_unique_ct=${sts_tfp_unique_ct}"
      else
            echo "INFO: STS_FILE_COUNT_MISMATCH. EXTING..."
            exit 101
      fi
      tfp_files_ct=$(cat ${get_config_key_file_list} | wc -l)
      echo "INFO: tfp_files_ct=${tfp_files_ct}"
      for all in `cat ${get_config_key_file_list}`
      do
            #echo "INFO: CONFIGURATION_FILE-${all}"
            tfp_root_keys_ar=(`echo "${all}" | tr ':' ' '`)
            any_keys=$(echo "${#tfp_root_keys_ar[@]}")
            if [ ${any_keys} -gt 0 ]; then
                  base_name=$(echo "${tfp_root_keys_ar[0]}")
                  configuration_file=$(echo "${tfp_root_keys_ar[1]}")
                  cloud=$(echo "${tfp_root_keys_ar[2]}")
                  #echo "INFO: base_name=${base_name}, cloud=${cloud}"
                  UCLD=$(echo "${UCLOUD[${cloud}]}")
                  tfp_combo_key=$(echo "${base_name}" | awk -v cld=${UCLD} -F "_"  '{ OFS="_";  print $1,$2,cld,$3;}')
                  #echo "INFO: tfp_combo_key=${tfp_combo_key}"
                  tfp_sts_hash["${tfp_combo_key}"]="${tfp_combo_key}"
                  get_sts_file=$(echo "${sts_tfp_hash[${tfp_combo_key}]}")
                  get_sts_file=${get_sts_file:-NONE}
                  if [ "${get_sts_file}" != "NONE" ]; then
                       sts_tfp_all_hash["${tfp_combo_key}"]="${get_sts_file}"
                       echo "RULES_APPLIED|${all}" >> ${sts_root}/POST_PROCESS_TFP_STS_RULES_APPLIED.info
                  else
                       echo "INFO: THERE_IS_NO_STS_FILE_FOR_KEY_${tfp_combo_key}"
                       echo "NO_RULES_APPLIED|${all}" >> ${sts_root}/POST_PROCESS_TFP_STS_NO_RULES_APPLIED.info
                  fi
            fi
      done
      sts_tfp_key_ct=$(echo "${sts_tfp_all_hash[@]}" | tr ' ' '\n' |  wc -l)
      echo "INFO: sts_tfp_key_ct ${sts_tfp_key_ct}"
      #read SSSSS
      if [ "${DEBUG}" == "Y" ]; then
          for all_tfp_cloud in `echo "${!sts_tfp_hash[@]}"`
          do
            echo "INFO: TFP ${all_tfp_cloud}"
            echo "INFO: FILE ${sts_tfp_hash[${all_tfp_cloud}]}"
          done
      fi
}
      get_config_key_file_list=$(ls -C1 ${CONFIGURATION_FILE_LIST} 2>/dev/null)
      get_config_key_file_list=${get_config_key_file_list:-NONE}

      if [ "${get_config_key_file_list}" == "NONE" ]; then
           #echo "ERROR: Parameter P1 Configuration_file not_found" 
           #echo "Usage- $0 /data/iac_scan_status/tfp/2024/20240123-04-023/20240123/tfp/keys/tfp_root_key_configuration_process_status.info"
           echo "ERROR: DATA_FILE_PREPROCESS_FAILED. /data/iac_scan_status/tfp/${year_to_keep}/${daily_date_format}/${yyyymmdd_format}/tfp/keys/tfp_root_key_configuration_process_status.info"
           exit 101
      fi

      echo_vars
      echo "INFO: LIST_OF_FILES_TO_PROCESS ${get_config_key_file_list}"
      tfp_keys_root=$(dirname ${get_config_key_file_list})
      tfp_root=$(echo "${tfp_keys_root}" | sed 's/\/keys//')
      tfp_info_root=$(echo "${tfp_root}/info")
      tfp_status_root=$(echo "${tfp_root}/status")
      tfp_csv_root=$(echo "${tfp_root}/csv")
      mkdir -p ${tfp_csv_root}
      echo "INFO: tfp_root=${tfp_root}"
      echo "INFO: tfp_info_root=${tfp_info_root}"
      echo "INFO: tfp_status_root=${tfp_status_root}"
      echo "INFO: tfp_keys_root=${tfp_keys_root}"
      echo "INFO: tfp_csv_root=${tfp_csv_root}"

      processed_tfp_files_ct=$(ls -C1 ${tfp_root}/S*.info 2>/dev/null | wc -l)
      echo "INFO: ALREADY_PROCESSED_FILES-${processed_tfp_files_ct}"
      pipe_loc=$(echo "${tfp_info_root}/${yyyymmdd_format}_processed_tfp.info")
      pipe_header_loc=$(echo "${tfp_info_root}/${yyyymmdd_format}_processed_tfp_header.info")
      status_of_tfp_root_files=$(echo "tfp_root_key_process_status.info")
      load_all_tfp_root_keys_processed_files_json
      
      sts_root_1=(`echo "${tfp_root}" | sed 's/\/tfp/\/sts/' | sed 's/\/sts$//'`)
      sts_root=(`echo "${sts_root_1}" | cut -d "/" -f1-6`)
      echo "INFO: sts_root ${sts_root}"
      yyyymmdd=$(basename ${sts_root})
      sub_dir=$(dirname ${sts_root}) 
      full_path_sts=$(echo "${sts_root}/all_sts")

      check_process_is_done "${full_path_sts}"
      echo "INFO: full_path ${full_path_sts}"
      collect_additional_fields ${full_path_sts} ${1}
      post_process_full_path=$(echo "${full_path_sts}/post_processed")
      mkdir -p ${post_process_full_path}
      rm -rf ${post_process_full_path}/*
      rm -rf ${sts_root}/STS_PROCESS_NOT_FOUND.err
      
      for all in `cat ${get_config_key_file_list}`
      do
            echo "INFO: CONFIGURATION_FILE-${all}"
            tfp_root_keys_ar=(`echo "${all}" | tr ':' ' '`)
            any_keys=$(echo "${#tfp_root_keys_ar[@]}")
            if [ ${any_keys} -gt 0 ]; then
                  base_name=$(echo "${tfp_root_keys_ar[0]}")
                  configuration_file=$(echo "${tfp_root_keys_ar[1]}")
                  cloud=$(echo "${tfp_root_keys_ar[2]}")
                  tfp_terraform_cloud_hash[${base_name}]="cloud_${cloud}"
                  tfp_hash[${base_name}]="${base_name}"
                  tfp_configuration_hash[${base_name}]="${configuration_file}"
                  tfp_root_file=$(echo "${tfp_files_hash[${base_name}]}")
                  rpt_date=$(echo "${tfp_root_file}" | tr '/' '\n' | grep -E "[0-9]{8}-[0-9]{2}-[0-9]{3}")
                  tfp_root_file=$(echo "${tfp_files_hash[${base_name}]}")
                  echo "INFO: conf=${configuration_file} root_file=${tfp_root_file} base_name=${base_name} cloud=${cloud} date=${rpt_date}" 
                  get_additional_field=$(echo "GET_IT_FROM_STS")
                  echo "INFO: ADDTIONAL_FIELDS=${get_additional_field}"
                  tfp_additional_fields_hash[${base_name}]="${get_additional_field}"
                  dir_in_process=$(dirname ${all})
                  echo "INFO: Calling FN-process_configuration_file ${configuration_file} ${tfp_root_file} ${base_name} ${cloud}" 
                  ${cloud}_resource_mining "${configuration_file}" "${tfp_root_file}"  "${base_name}"
            else
                  echo "INFO: NOT_A_TERRAFORM_PROCESSED_FILE"
            fi
      done

fix_mis_match_files_during_post_process ()
{

      echo "INFO: FUNCTION_NAME fix_mis_match_files_during_post_process"
      rm -rf ${sts_root}/POST_PROCESS.ERR
      get_all_post_processed_file_ar=()
      get_all_pre_processed_file_ar=()
      get_all_post_processed_file_ar=$(ls -C1 ${post_process_full_path}/S*_processed.pipe)
      get_all_pre_processed_file_ar=$(ls -C1 ${full_path_sts}/S*.pipe | grep -v "_tf.pipe")
      source_files_ct=$(echo "${get_all_pre_processed_file_ar[@]}" | wc -l)
      target_files_ct=$(echo "${get_all_post_processed_file_ar[@]}" | wc -l)
      declare -A tfp_app_acct_hash
      echo "INFO: ${source_files_ct} ${target_files_ct}"
      
      if [ ${target_files_ct} -lt ${source_files_ct} ]; then
            echo "FEW_ACCTID_MISSING. TRY_TO_CORRECT"
            for all_processed_acct in `echo "${get_all_post_processed_file_ar[@]}"`
            do
                  file_nm_only=$(basename ${all_processed_acct})
                  clip_tfp=$(echo "${file_nm_only}" | cut -d "_" -f 1-2)
                  get_3_fields=$(cat ${all_processed_acct} | cut -d "|" -f 14,15 | sort -u |  sed "s/^/${clip_tfp}|/")
                  tfp_app_acct_hash["${clip_tfp}"]="${get_3_fields}"
            done
            for all_processed_acct in `echo "${get_all_pre_processed_file_ar[@]}"`
            do
                 file_nm_only=$(basename ${all_processed_acct})
                 target_file=$(echo "${file_nm_only}" | sed 's/\.pipe/_processed\.pipe/')
                 #clip_tfp=$(echo "${file_nm_only}" | cut -d "_" -f 1-2)
                 #echo "INFO: TFP-${clip_tfp}"
                 chk_file_produced=$(ls -C1 ${post_process_full_path}/${target_file} 2>/dev/null)
                 chk_file_produced=${chk_file_produced:-NONE}
                 if [ "${chk_file_produced}" == "NONE" ]; then
                       echo "INFO: FILE_FOUND- ${all_processed_acct}"
                       echo "INFO: TARGET_FILE_FOUND: ${target_file}"
                       clip_tfp=$(echo "${file_nm_only}" | cut -d "_" -f 1-2)
                       echo "INFO: TFP-${clip_tfp}"
                       
                       echo "INFO: POSSIBLE_ACCTID_APPNM ${tfp_app_acct_hash[${clip_tfp}]}"
                       get_appnm=$(echo "${tfp_app_acct_hash[${clip_tfp}]}" | cut -d "|" -f 2)
                       get_appnm=${get_appnm:-APPNM_NOT_DEFINED}
                       STS_ACCT_ID=$(echo "${tfp_app_acct_hash[${clip_tfp}]}" | cut -d "|" -f 3)
                       STS_ACCT_ID=${STS_ACCT_ID:-0000-0000-0000-0000-0000}
                       
                       echo "INFO: COL_REPLACE ${get_appnm} ${STS_ACCT_ID}"
                       cat ${all_processed_acct}   |  sed -e  "s/REALAPPNAME/${get_appnm}/" | sed -e  "s/ACCTID/${STS_ACCT_ID}/"  >  ${post_process_full_path}/${target_file}  | cut -d "|" -f 14,15 | sed "s/^/${clip_tfp}/"
                       echo "${daily_date_format}|${file_nm_only}|FILE_FOUND_NO_TF_PLAN_UNABLE_TO_FIND|${get_appnm}|${STS_ACCT_ID}" >> ${sts_root}/POST_PROCESS.ERR
                 fi
            done
      fi
}

fix_mis_match_files_during_post_process
