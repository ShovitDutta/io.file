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

 #mkdir -p ${tfp_root}
 #mkdir -p ${tfp_info_root}

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

SOFT_DEPLOYMENT=$(echo "N")
azure_resource_mining ()
{
    echo "INFO: FUNCTION_NAME azure_resource_mining"

# declare -A tfp_configuration_hash
# declare -A tfp_planned_values_hash
# declare -A tfp_prior_state_hash
# declare -A tfp_relevant_attributes_hash
# declare -A tfp_resource_changes_hash
# declare -A tfp_resource_drift_hash

    bn=$(echo "${2}")

      tfp_configuration_file_name=$(echo "$1}")
      tfp_planned_values_file_name=$(echo "${1}" | sed 's/configuration/planned_values/')
      tfp_prior_state_file_name=$(echo "${1}" | sed 's/configuration/prior_state/')
      tfp_relevant_attributes_file_name=$(echo "${1}" | sed 's/configuration/relevant_attributes/')
      tfp_resource_changes_file_name=$(echo "${1}" | sed 's/configuration/resource_changes/')

      echo "INFO: tfp_planned_values_file_name=${tfp_planned_values_file_name}"
      echo "INFO: tfp_prior_state_file_name=${tfp_prior_state_file_name}"
      echo "INFO: tfp_resource_changes_file_name=${tfp_resource_changes_file_name}"
      root_module_chk=$(cat ${tfp_planned_values_file_name} | jq '.root_module' | sed 's/{}//') 
      root_module_chk=${root_module_chk:-NONE}
      SOFT_DEPLOYMENT=$(echo "N")
      if [ "${root_module_chk}" != "NONE" ]; then
            get_tags_pv=$(cat ${tfp_planned_values_file_name} | jq '.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq 'keys,values|join("|")' | tr '\n' '^'| sed 's/\^/|resource_name|subscription_id|date|hour|pipeline_name|app_id|terraform_id\^/')
      else
            echo "INFO: tfp_planned_values_file_name ${tfp_planned_values_file_name} empty. SOFT_DEPLOYMENT"
            SOFT_DEPLOYMENT=$(echo "Y")
      fi

      get_tags_ps=$(cat ${tfp_prior_state_file_name} | jq '.values.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq 'keys,values|join("|")' | tr '\n' '^'| sed 's/\^/|resource_name|subscription_id|date|hour|pipeline_name|app_id|terraform_id\^/')


      get_tags_rc=$(cat ${tfp_resource_changes_file_name} | jq '.[].change.before.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq 'keys,values|join("|")' | tr '\n' '^'| sed 's/\^/|resource_name|subscription_id|date|hour|pipeline_name|app_id|terraform_id\^/')

      #echo "INFO: tfp_planned_values_file_name=${tfp_planned_values_file_name}"
      #echo "INFO: get_tags_pv=${get_tags_pv}"

      #echo "INFO: tfp_prior_state_file_name=${tfp_prior_state_file_name}"
      #echo "INFO: get_tags_ps=${get_tags_ps}"

      #echo "INFO: tfp_resource_changes_file_name}=${tfp_resource_changes_file_name}}"
      #echo "INFO: get_tags_rc=${get_tags_rc}"
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
                           echo "INFO: SUBSCRIPTION_ID=${azure_subscription_id}"
                           file_to_write_changes_of_resources_pipe=$(echo "${tfp_root}/${3}_resource_changes.pipe")
                           echo "INFO: Writing_Resource_related_changes_file ${file_to_write_changes_of_resources_pipe}"
                           cat ${resource_changes_file} |  jq '.[]|[.type,.change.actions[0]]|join("|")' > ${file_to_write_changes_of_resources_pipe}
                           get_changes_create=$(cat ${resource_changes_file} |  jq '.[]|.change.actions[0]' | sed 's/\"//g'|  sort -u | tr '\n' '|' | sed 's/|$//')
                           echo "INFO: changes_in_tfp ${3}  ${get_changes_create}"
                           echo "${3}|${get_changes_create}" >>${tfp_root}/tfp_resource_changes.file
                           #subid_from_perior_state=$(cat ${prior_state_file} | jq '.values.root_module.child_modules[].resources[0].values.subscription_id?' | sed 's/\"//g' |  sed 's/null//')
                           #subid_from_perior_state=${subid_from_perior_state:-NONE}
                           #subid_from_resource_changes=$(cat ${resource_changes_file} | jq '.[0].change.before.id?' | grep "subscriptions" | cut -d "/" -f 3)
                           #subid_from_resource_changes=${subid_from_resource_changes:-NONE}
                           #echo "INFO: SUBSCRIPTION_ID=${subid_from_perior_state}"
                           #read SSSSS
                           tfp_azure_subscription[${3}]="${azure_subscription_id}"
                           #echo "INFO: KEY=planned_values, FILE=${planned_values_file}"
                           root_module_found=$(cat ${planned_values_file} | jq '.root_module|keys|join("|")' | sed 's/\"//g')
                           root_module_found=${root_module_found:-NONE}
                           file_to_write_json=$(echo "${tfp_root}/${3}.pipe.json")
                           file_to_write_key_json=$(echo "${tfp_root}/${3}.pipe.keys.json")
                           if [ "${root_module_found}" != "NONE" ]; then
                                get_tags=$(cat ${planned_values_file} | jq '.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq 'keys,values|join("|")' | tr '\n' '^'| sed 's/\^/|resource_name|subscription_id|scan_date|report_run_date|pipeline_name|app_id|terraform_id\^/')
                                cat ${planned_values_file} | jq '.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' > ${file_to_write_json}
                                cat ${planned_values_file} | jq '.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq 'keys' > ${file_to_write_key_json}
                           else
                                echo "INFO: NO_TAGS_FROM_PLANNED_VALUES, PICKING_FROM_PRIOR_STATE"
                                get_tags=$(cat ${prior_state_file} | jq '.values.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq 'keys,values|join("|")' | tr '\n' '^'| sed 's/\^/|resource_name|subscription_id|scan_date|report_run_date|pipeline_name|app_id|terraform_id\^/')
                                cat ${prior_state_file} | jq '.values.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' > ${file_to_write_json}
                                cat ${prior_state_file} | jq '.values.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq 'keys' > ${file_to_write_key_json}
                           fi
                           get_tags=${get_tags:-NONE}
                           if [ "${get_tags}" == "NONE" ]; then
                               echo "INFO: SOFT_DEPLOYMENT_NO_RESOURCES"
                           else
                               ##echo "INFO: ALL_RESOURCES- ${collect_resources[@]}"
                               ##echo "INFO:TAG_INFO-${get_tags}"
                               ##echo "INFO: SUBSCRIPTION_ID=${azure_subscription_id}"
                               file_date_combo_local=$(echo "${2}" |sed 's/\.\///' |  sed 's/\//\|/g' | sed 's/\.tfplan//')
                               file_date_combo=$(echo "${tfp_additional_fields_hash[${3}]}")
                               echo "INFO: file_date_combo=${file_date_combo}"
                               echo "INFO: file_date_combo_local=${file_date_combo_local}"
                               #read SSSSS
                               final_file_nm=$(echo "${file_date_combo_local}" | cut -d "|" -f 5)
                               final_file_nm_module=$(echo "${file_date_combo_local}_module" | cut -d "|" -f 5)
                               traceability_info=()
                               traceability_info_header=()
                               traceability_info_rec=()
                               traceability_info_header=$(echo "${get_tags}" | cut -d "^" -f 1)
                               traceability_info_rec=$(echo "${get_tags}" | cut -d "^" -f 2)
                               declare -A final_rec
                               #echo "INFO: HEADER-${traceability_info_header[@]}"
                               total_resources=$(echo "${#collect_resources[@]}")
                               #echo "INFO: TOTAL_RESOURCE-${total_resources}"
                               #rec_with_sub_id=$(echo "${traceability_info_rec[@]}|${3}|azurerm|${azure_subscription_id}")
                               #`echo "${collect_resources[@]}"`
                               header_cols_num=$(echo "${traceability_info_header[@]}" | awk -F "|" '{print NF;}')
                               clean_header_col=(`echo "COL_##${header_cols_num}:${traceability_info_header[@]}" | sed 's/\"//g'`)
                               file_to_write=$(echo "${tfp_root}/${3}.pipe")
                               tfp_key=$(echo "${3}" | cut -d "_" -f 1-2)
                               appid_sub_tfp_file_to_write=$(echo "${tfp_root}/${tfp_key}.info")
                               rm -rf ${appid_sub_tfp_file_to_write}
                               file_to_write_module=$(echo "${tfp_root}/${3}.module_pipe")
                               get_pipe_file=$(ls -C1 ${file_to_write} 2>/dev/null)
                               get_pipe_file=${get_pipe_file:-NONE}
                               get_module_file=$(ls -C1 ${file_to_write_module} 2>/dev/null)
                               get_module_file=${get_module_file:-NONE}
                               echo "INFO: get_module_file ${get_module_file}, file_to_write ${file_to_write}"
                               if [ "${get_pipe_file}" != "NONE" ]; then
                                   cd ${tfp_root}
                                   rm -rf ${3}.module_pipe
                                   rm -rf ${3}.pipe
                                   cd -
                                   echo "INFO: ${3}.module_pipe and ${3}.pipe are deleted"
                               else
                                   echo "INFO: get_module_file ${get_module_file}, file_to_write ${file_to_write} are new."
                               fi
                               #read SSSSS
                               #echo "INFO: WRITING_PIPE_DELIMITED_FILE ${file_to_write}"
                               #echo "INFO: WRITING_PIPE_DELIMITED_FOR_MODULE_FILE ${file_to_write_module}"
                               echo "COL_##${header_cols_num}:${traceability_info_header[@]}" | sed 's/\"//g' > ${file_to_write}
                               echo "COL_##${header_cols_num}:${traceability_info_header[@]}" | sed 's/\"//g' > ${file_to_write_module}
                               tfp_pipe_based_header[${3}]="${clean_header_col}"
                               tfp_azure_additional_col[${3}]="${file_date_combo}"
                               #for all_recs_produced_per_resource in ${!collect_resources[@]}
                               for all_recs_produced_per_resource in ${!collect_only_azure_resources[@]}
                               do
                                   app_name=()
                                   app_name=$(echo "${traceability_info_rec[0]}"| cut -d "|" -f 1 | sed 's/$/\"/')
                                   echo "${3}|${tfp_key}|${app_name[@]}|${azure_subscription_id}|${file_date_combo}|${traceability_info_rec[@]}"
                               done | sort -u > ${appid_sub_tfp_file_to_write} 
                       
                               for all_recs_produced_per_resource in ${!collect_only_azure_resources[@]}
                               do
                                #echo "INFO: REC-${all_recs_produced_per_resource}, ${collect_only_azure_resources[$all_recs_produced_per_resource]}"
                                cols=$(echo "${collect_only_azure_resources[$all_recs_produced_per_resource]}")
                                #if [ "${cols}" == "azurerm" ]; then
                                      full_rec=$(echo "${traceability_info_rec[@]}|azurerm|${azure_subscription_id}|${file_date_combo}" | sed 's/\"//g')
                                #else
                                      #full_rec=$(echo "${traceability_info_rec[@]}|${collect_resources[$all_recs_produced_per_resource]}|NA|${file_date_combo}" | sed 's/\"//g')
                                #      full_module_rec=$(echo "${traceability_info_rec[@]}|${cols}|NA|${file_date_combo}" | sed 's/\"//g')
                                #fi
                                #echo "${full_rec}"
                                rec_cols_num=$(echo "${full_rec}" | awk -F "|" '{print NF;}')
                                if [ ${header_cols_num} -eq ${rec_cols_num} ]; then
                                      echo "COL_##${rec_cols_num}:${full_rec}"
                                      #echo "COL_##${rec_cols_num}:${full_module_rec}" >> ${file_to_write_module}
                                else
                                      echo "INFO: MISMATCH_REC"
                                      #read SSSSSS
                                fi 

                                #read SSSSS
                                #key_rec=$(echo "rec_${all_recs_produced_per_resource}")
                                #final_rec[${key_rec}]="${full_rec}"
                               done | sort -u >> ${file_to_write}
                               #cat ${file_to_write}
                               #collect_only_modules
                               for all_recs_produced_per_resource in ${!collect_only_modules[@]}
                               do
                                #echo "INFO: REC-${all_recs_produced_per_resource}, ${collect_only_modules[$all_recs_produced_per_resource]}"
                                cols=$(echo "${collect_only_modules[$all_recs_produced_per_resource]}")
                                #if [ "${cols}" == "azurerm" ]; then
                                      full_rec=$(echo "${traceability_info_rec[@]}|${cols}|NA|${file_date_combo}" | sed 's/\"//g')
                                #else
                                      #full_rec=$(echo "${traceability_info_rec[@]}|${collect_resources[$all_recs_produced_per_resource]}|NA|${file_date_combo}" | sed 's/\"//g')
                                #     #full_module_rec=$(echo "${traceability_info_rec[@]}|${cols}|NA|${file_date_combo}" | sed 's/\"//g')
                                #fi
                                #echo "${full_rec}"
                                rec_cols_num=$(echo "${full_rec}" | awk -F "|" '{print NF;}')
                                if [ ${header_cols_num} -eq ${rec_cols_num} ]; then
                                      echo "COL_##${rec_cols_num}:${full_rec}"
                                      #echo "COL_##${rec_cols_num}:${full_module_rec}"
                                else
                                      echo "INFO: MISMATCH_REC"
                                      #read SSSSSS
                                fi

                                #read SSSSS
                                #key_rec=$(echo "rec_${all_recs_produced_per_resource}")
                                #final_rec[${key_rec}]="${full_rec}"
                               done | sort -u >> ${file_to_write_module}
                                #cat ${file_to_write_module}
                                #read SSSSS
                                #echo "${full_rec}"
                                #read SSSSS
                               tfp_final_pipe_files_name_hash[${3}]="${file_to_write}"
                           fi
                           #read SSSSS

                           #for all_recs in `echo "${!final_rec[@]})"`
                           #do
                           #     echo "INFO: REC_NUM=${all_recs}"
                           #     echo "INFO: REC_VAL=${final_rec[${all_recs}]}"
                           #done
                           #echo "INFO: #--------------#"
                           #echo "INFO: HEADER-${traceability_info_header[@]}"
                           #echo "INFO: REC-${traceability_info_rec[@]}"
                           #echo "INFO: #--------------#"
                           #read SSSSS

    #else
    #      echo "INFO: NO_OBJ-NO_KEYS-PROCESSING"
    #fi
    #read SSSSS
}

gcp_tfp_obj_key_process ()
{
    echo "INFO: FUNCTION_NAME gcp_tfp_obj_key_process"
}

aws_tfp_obj_key_process ()
{
    echo "INFO: FUNCTION_NAME aws_tfp_obj_key_process"
}

cloud_aws ()
{
    echo "INFO: FUNCTION_NAME cloud_aws"
}

cloud_gcp ()
{
    echo "INFO: FUNCTION_NAME cloud_gcp"
}


unique_process_signature=$(echo "US")
write_processed_pipe_files ()
{
    echo "INFO: FUNCTION_NAME write_processed_pipe_files"
    #pipe_loc=$(echo "${tfp_info_root}/${yyyymmdd_format}_processed_tfp.info")
    for all_pipes in `echo "${!tfp_final_pipe_files_name_hash[@]}"`
    do
       echo "${all_pipes}:${tfp_final_pipe_files_name_hash[${all_pipes}]}"
    done  >${pipe_loc}
    unique_process_signature=$(sum ${pipe_loc} | awk '{print $1,$2}' | tr ' ' '_'| awk '{ print "S"$1}')
    #pipe_header_loc=$(echo "${tfp_info_root}/${yyyymmdd_format}_processed_tfp_header.info")
    for all_headers in `echo "${!tfp_pipe_based_header[@]}"`
    do
       echo "${all_headers}:${tfp_pipe_based_header[${all_headers}]}"
    done > ${pipe_header_loc}
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

  pipe_column_name_ar=()
  pipe_column_name_str=$(echo "none")
  declare -A pipe_column_name_hash=()
#declare -A tfp_pipe_based_header
#declare -A tfp_azure_subscription
#declare -A tfp_azure_additional_col

final_file_to_produce=$(echo "csv")
final_process ()
{
    echo "INFO: FUNCTION_NAME final_process"
    #echo "INFO: FILE_TO_PROCESS P1  ${1}"
    #echo "INFO: FILE_TO_PROCESS P2  ${2}"
    #echo "INFO: FILE_TO_PROCESS P3  ${3}"
    #echo "INFO: FILE_TO_PROCESS P4  ${4}"
#S11176_3635_1700521476:/data/iac_scan_status/20240123/tfp/S11176_3635_1700521476.pipe    
    get_tfp_key=$(echo "${1}" | cut -d ":" -f 1)
    get_tfp_file=$(echo "${1}" | cut -d ":" -f 2)
    get_header=$(cat ${get_tfp_file} | head -n 1 | cut -d ":" -f 2)
    count=$(cat ${get_tfp_file} | head -n 1 | cut -d ":" -f 1 | sed 's/COL_##//')
    pipe_rec=$(cat ${get_tfp_file} | sort -u | cut -d ":" -f 2 | grep -v "^applicationname")
    #echo "INFO: count: ${count}"
    #echo "INFO: REC_FROM_FILE ${pipe_rec}"
    if [ "${get_header}" == "${3}" ]; then
          #echo "INFO: CLO_MATCH- P3 ${3}"
          #echo "INFO: CLO_MATCH- HD ${get_header}"
          #echo "${pipe_rec}" >> ${final_file_to_produce}
          #echo "${pipe_rec}" | awk -F "|" '{print NF;}'
          echo "${pipe_rec}" >> ${final_file_to_produce}
          #echo "INFO: ${pipe_rec}" 
    else
          #echo "INFO: CLO_MATCH- ${3}"
          #echo "INFO: CLO_MATCH- ${get_header}"
          fields_needed=()
          fields_needed=$(cat ${tfp_root}/${get_tfp_key}.pipe.json | jq '[.applicationname,.businessunit,.costcenter,.createdondate,.dataclassification,.environmenttype,.itpmid,.itpr,.migration,.reportingsegment,.resourceowner,.sharedemailaddress]|join("|")') 
          final_rec_with_added_col=()
          final_rec_with_added_col=$(echo "${fields_needed}|azurerm|${tfp_azure_subscription[${get_tfp_key}]}|${tfp_azure_additional_col[${get_tfp_key}]}" | sed 's/\"//g')
          echo "${final_rec_with_added_col}" >> ${final_file_to_produce}
          #echo "INFO: ${final_rec_with_added_col}"
    fi
}


process_pipe_columns ()
{

    echo "INFO: FUNCTION_NAME process_pipe_columns"
    #cat 2024_01_25-18_12_27-1706206347-04_2024-025_processed_tfp_header.info | awk -F "|" -v num=19 '{print NF,$0;}' | sort -u  | cut -d ":" -f 3  | cut -d "|" -f 1-19 | sort -u | grep "terraform_id$" | awk -F "|" '{print NF;}'

#19 S22673_2906_1698113103:COL_##19:applicationname|businessunit|costcenter|createdondate|dataclassification|environmenttype|itpmid|itpr|migration|reportingsegment|resourceowner|sharedemailaddress|resource_name|subscription_id|date|hour|pipeline_name|app_id|terraform_id
    column_ar=()
    column_ar=(`cat ${pipe_header_loc} | awk -F "|" -v num=19 '{print NF,$0;}' | sort -u  | head -n 1`)
    total_col=(`echo "${column_ar[0]}"`)
    num_colums_found=(`echo "${column_ar[1]}" | cut -d ":" -f 2 | sed 's/COL_##//'`)
    tfp_id=(`echo "${column_ar[1]}" | cut -d ":" -f 1`)
    tfp_columns=(`echo "${column_ar[1]}" | cut -d ":" -f 3`)
    actual_column_of_rec=(`echo "${column_ar[1]}" | cut -d ":" -f 3  | awk -F "|" '{print NF;}'`)
    if [ ${total_col} -eq ${actual_column_of_rec} ]; then
          pipe_column_name_ar=(`echo "${column_ar[1]}" | cut -d ":" -f 3  | tr '|' ' '`)
          for all_rec_cols in `echo "${pipe_column_name_ar[@]}"`
          do
              #echo "INFO: COLUMN_NAME- ${all_rec_cols}"
              pipe_column_name_hash[${all_rec_cols}]="${all_rec_cols}"
          done
    fi

    azrm_pipe_files=()
    azrm_pipe_files=(`cat ${pipe_loc} | sort -u`)
    date_fron_file=$(echo "${azrm_pipe_files[@]}"| cut -d "/" -f 4)
    final_file_to_produce=$(echo "${tfp_csv_root}/${date_fron_file}.${unique_process_signature}.csv")
    echo "${tfp_columns}" > ${final_file_to_produce}
    for all_files in `echo "${azrm_pipe_files[@]}"`
    do
         echo "INFO: PIPE_FILE ${all_files} ${tfp_id} ${tfp_columns} ${total_col}"
         final_process "${all_files}" ${tfp_id} "${tfp_columns}" ${total_col}
         #read SSSSS
    done
}

check_process_is_done ()
{
      echo "INFO: FUNCTION_NAME check_process_is_done"
  
      echo "INFO: SEARCH_FILE ls -C1 ${1}"
      file_found=$(ls -C1 ${tfp_csv_root}/tfp.*.csv 2>/dev/null)
      file_found=${file_found:-NONE}

      echo "INFO: file_found=${file_found}"
      if [ "${file_found}" == "NONE" ]; then
           echo "INFO: $0 will_continue_to_process"
      else

          #total_recs_produced=$(cat "${file_found}" | wc -l)
          

          #let total_recs_produced=${total_recs_produced}-1
          #let total_recs_produced=${processed_tfp_files_ct}
          #if [ ${SCAN_RESULT_FILE_CT} -eq ${total_recs_produced} ]; then
             echo "INFO: process_complete"
             exit 0
          #fi  
      fi
      echo "INFO: COUNT ${1} ${total_recs_produced}"
}

      #if [ "${CONFIGURATION_FILE_LIST}" == "NONE" ]; then
      #     echo "ERROR: Parameter P1 Configuration_file_location_required."
      #     echo "Usage- $0 /data/iac_scan_status/tfp/2024/20240123-04-023/20240123/tfp/keys/tfp_root_key_configuration_process_status.info"
      #     exit 100
      #fi

      get_config_key_file_list=$(ls -C1 ${CONFIGURATION_FILE_LIST} 2>/dev/null)
      get_config_key_file_list=${get_config_key_file_list:-NONE}

      if [ "${get_config_key_file_list}" == "NONE" ]; then
           #echo "ERROR: Parameter P1 Configuration_file not_found" 
           #echo "Usage- $0 /data/iac_scan_status/tfp/2024/20240123-04-023/20240123/tfp/keys/tfp_root_key_configuration_process_status.info"
           echo "ERROR: DATA_FILE_PREPROCESS_FAILED. /data/iac_scan_status/tfp/${year_to_keep}/${daily_date_format}/${yyyymmdd_format}/tfp/keys/tfp_root_key_configuration_process_status.info"
           exit 101
      fi

      echo_vars
      #echo "INFO: LIST_OF_FILES_TO_PROCESS ${get_config_key_file_list}"
      rpt_configuration_date=$(echo "${get_config_key_file_list}" | tr '/' '\n' | grep -E "[0-9]{4}[0-9]{2}[0-9]{2}")
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
      #read SSSSS

      processed_tfp_files_ct=$(ls -C1 ${tfp_root}/S*.info 2>/dev/null | wc -l)
      echo "INFO: ALREADY_PROCESSED_FILES-${processed_tfp_files_ct}"
      pipe_loc=$(echo "${tfp_info_root}/${yyyymmdd_format}_processed_tfp.info")
      pipe_header_loc=$(echo "${tfp_info_root}/${yyyymmdd_format}_processed_tfp_header.info")
      status_of_tfp_root_files=$(echo "tfp_root_key_process_status.info")
      load_all_tfp_root_keys_processed_files_json
      
      #csv_root=(`echo "${tfp_root}" | sed 's/\/tfp/csv/g'`)
      csv_root=(`echo "${tfp_root}" | sed 's/\/tfp/\/csv/' | sed 's/\/tfp$//'`)
      echo "INFO: csv_root ${csv_root}"
      yyyymmdd=$(basename ${csv_root})
      sub_dir=$(dirname ${csv_root}) 
      echo "INFO: csv_root ${csv_root} sub_dir ${sub_dir} "
      yr_format=$(basename ${sub_dir}) 
      echo "INFO: yr_format ${yr_format} rpt_configuration_date ${rpt_configuration_date}"
      #/data/iac_scan_status/csv/2024/20240216-07-047/all_csv/SCAN_RESULT_20240216.csv
      #clip_yr=$(echo "${yr_format}" | sed -r 's/[0-9]{4}$//') 
      full_path_csv=$(echo "${sub_dir}/all_csv")

      echo "INFO: full_path ${full_path_csv}"

      additional_fields_file=$(ls -C1 ${full_path_csv}/SCAN_ADDITIONAL_DATE_FIELDS.csv 2>/dev/null)
      #SCAN_RESULT_FILE=$(ls -C1 ${full_path_csv}/SCAN_RESULT_${yr_format}.csv)
      SCAN_RESULT_FILE=$(ls -C1 ${full_path_csv}/SCAN_RESULT_${yyyymmdd}.csv 2>/dev/null)
      SCAN_RESULT_FILE=${SCAN_RESULT_FILE:-NONE}
   
      if [ "${SCAN_RESULT_FILE}" != "NONE" ]; then
         SCAN_RESULT_FILE_CT=$(cat "${SCAN_RESULT_FILE}" | wc -l)
      #SCAN_RESULT_20240123-04-023.csv
         echo "INFO: SCAN_CT ${SCAN_RESULT_FILE_CT}"

         if [ "${already_done}" == "Y" ]; then
          check_process_is_done "${tfp_csv_root}" ${SCAN_RESULT_FILE_CT}
         else
           echo "INFO: over_rule-reprocess"
           rm -rf ${tfp_root}/*_resource_changes.file
         fi
      else
           echo "INFO: NO_SCAN_FILE_FOUND" 
           echo "ERROR: csv download and pre_processing_not_done_or_failed"
           exit 129
      fi
      echo "INFO: SCAN_ADDITIONAL_DATE_FIELDS_FILE ${additional_fields_file}"

      processed_csv_root=$(echo "${sub_dir}")

      declare -A csv_date_additional_fields_hash
      declare -A csv_date_key_hash

      echo "INFO: csv_root=${processed_csv_root}"

      echo "INFO: additional_fields_file ${additional_fields_file}"
      for all_fields in `cat ${additional_fields_file}`
      do
           echo "INFO: additional_fields_file ${all_fields}"
           dkey=$(echo "${all_fields}" | cut -d "^" -f 1 | sed 's/\./_/')
           echo "INFO: dkey ${dkey}"
           dval=$(echo "${all_fields}" | cut -d "^" -f 2 | sed -r 's/.[0-9]+$//')
           csv_date_key_hash[${dkey}]="${dkey}"
           csv_date_additional_fields_hash[${dkey}]="${dval}"
      done
      

      declare -A tfp_additional_fields_hash

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
                  get_additional_field=$(echo "${csv_date_additional_fields_hash[${base_name}]}")
                  echo "INFO: ADDTIONAL_FIELDS=${get_additional_field}"
                  tfp_additional_fields_hash[${base_name}]="${get_additional_field}"
                  #read SSSSS
                  appnm=$(echo "${get_additional_field}" | awk -F "|" '{ print $4;}')
                  pp_name=$(echo "${get_additional_field}" | awk -F "|" '{ print $3;}')
                  #appnm=$(echo "${tfp_root_file}" | awk -F "/" '{ APPNM=NF-1; print $APPNM;}')
                  #pp_name=$(echo "${tfp_root_file}" | awk -F "/" '{ APPNM=NF-2; print $APPNM;}')
                  tfp_files_appnm_hash[${base_name}]="${appnm}"
                  tfp_files_pp_hash[${base_name}]="${pp_name}"
                  dir_in_process=$(dirname ${all})
                  echo "INFO: APPNM-${appnm}, pp_name=${pp_name}, rpt_date-${rpt_date}"
                  #read SSSSS
                  echo "INFO: Calling FN-process_configuration_file ${configuration_file} ${tfp_root_file} ${base_name} ${cloud}" 
                   azure_resource_mining "${configuration_file}" "${base_name}"
                   #read SSSSS
                   ${cloud}_tfp_obj_key_process "${configuration_file}" "${tfp_root_file}" "${base_name}" "${cloud}" 
                   #read SSSSS
            else
                  echo "INFO: NOT_A_TERRAFORM_PROCESSED_FILE"
            fi
      done
      echo "INFO: OUT_OF_FILE_LOOP"
      #read SSSSS
      write_processed_pipe_files
      process_pipe_columns
      #echo_unique_keys
