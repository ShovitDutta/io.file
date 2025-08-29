#!/usr/bin/env sh


 daily_date_format=${1:-NONE}
 already_done=${2:-Y}
 DEBUG=${3:-n}

#all_tf_list.info
#dups_tf_list.info
#ecs_tf_list.info
#err_tf_list.info
#gcp_tf_list.info
#tf_list.info


   if  [ "${daily_date_format}" == "NONE" ]; then
         echo "ERROR: Parameter daily_date_format required."
         #echo "INFO: Usage- $0 /data/iac_scan_status/tfp/2024/20240125-04-025"
         echo "INFO: Usage- $0 20240125-04-025"
         exit 100
   fi

   year_to_keep=$(echo "${daily_date_format}" | cut -c1-4)
   echo "INFO: year -${year_to_keep}"

   daily_date_format_dir=$(echo "/data/iac_scan_status/tfp/${year_to_keep}/${daily_date_format}")

   chk_dir=$(ls -C1 ${daily_date_format_dir} 2>/dev/null)
   chk_dir=${chk_dir:-NONE}

   tfp_file_list_collected=()

   if  [ "${chk_dir}" == "NONE" ]; then
         echo "ERROR: daily_date_format_dir not_found"
         exit 101
   else
        #echo "INFO: ${chk_dir}"
        tfp_file_list_collected=(`ls -C1 ${daily_date_format_dir}/daily_tfp/*.tfplan`) # | tr '\n' ' ')
        echo "INFO: FILES_TO_PROCESS_CT ${#tfp_file_list_collected[@]}"
   fi

 tfp_files_ct_to_process=$(echo "${#tfp_file_list_collected[@]}")
 #date_to_keep=$(echo "${daily_date_format_dir}" |  tr '/' '\n' | cut -d"-" -f 1 | grep -E "[0-9]{8}")
 date_to_keep=$(echo "${daily_date_format}" | cut -d"-" -f 1 | grep -E "[0-9]{8}")

 echo "INFO: date_to_keep=${date_to_keep}"

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
 tfp_root_keys_hash["errored"]="errored"
 tfp_root_keys_hash["checks"]="checks"
 tfp_root_keys_hash["timpstamp"]="timpstamp"
 tfp_root_keys_hash["NONE"]="NONE"

 tfp_root_keys_type_hash["configuration"]="obj:configuration"
 tfp_root_keys_type_hash["format_version"]="key:format_version"
 tfp_root_keys_type_hash["planned_values"]="obj:planned_values"
 tfp_root_keys_type_hash["prior_state"]="obj:prior_state"
 tfp_root_keys_type_hash["relevant_attributes"]="obj:relevant_attributes"
 tfp_root_keys_type_hash["resource_changes"]="obj:resource_changes"
 tfp_root_keys_type_hash["resource_drift"]="obj:resource_drift"
 tfp_root_keys_type_hash["terraform_version"]="key:terraform_version"
 tfp_root_keys_type_hash["errored"]="key:errored"
 tfp_root_keys_type_hash["checks"]="obj:checks"
 tfp_root_keys_type_hash["timpstamp"]="key:timpstamp"
 tfp_root_keys_type_hash["NONE"]="none:NONE"

 declare -A tfp_configuration_hash
 declare -A tfp_format_version_hash
 declare -A tfp_planned_values_hash
 declare -A tfp_prior_state_hash
 declare -A tfp_relevant_attributes_hash
 declare -A tfp_resource_changes_hash
 declare -A tfp_resource_drift_hash
 declare -A tfp_terraform_version_hash
 declare -A tfp_checks_hash
 declare -A tfp_errored_hash
 declare -A tfp_errored_hash
 declare -A tfp_timestamp_hash

 declare -A tfp_hash
 declare -A tfp_files_hash

 declare -A tfp_checks_resources_hash

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

 tfp_root=$(echo "${daily_date_format_dir}/${date_to_keep}/tfp")
 tfp_info_root=$(echo "${daily_date_format_dir}/${date_to_keep}/tfp/info")
 tfp_status_root=$(echo "${daily_date_format_dir}/${date_to_keep}/tfp/status")
 tfp_key_root=$(echo "${daily_date_format_dir}/${date_to_keep}/tfp/keys")
 tfp_daily_dir=$(echo "${daily_date_format_dir}/daily_tfp")

 mkdir -p ${tfp_root}
 mkdir -p ${tfp_info_root}
 mkdir -p ${tfp_status_root}
 mkdir -p ${tfp_key_root}

 process_completed=()
 process_completed=(`cat ${tfp_status_root}/tfp_root_key_process_status.info 2>/dev/null | wc -l`)

   if [ "${already_done}" == "Y" ]; then
 
       if [ ${process_completed} -eq ${tfp_files_ct_to_process} ]; then

         echo "INFO: PROCESS_ALREADY_COMPLETED_NOTHING_TO_DO (${process_completed},${tfp_files_ct_to_process})"
         exit 0
      else
         echo "INFO: $0 PROCESS_WILL_CONTINUE (${process_completed},${tfp_files_ct_to_process})"
      fi 
   else
      echo "INFO: over_rule-reprocess"
   fi
 
   #read SSSSS
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
# declare -A tfp_configuration_hash
# declare -A tfp_format_version_hash
# declare -A tfp_planned_values_hash
# declare -A tfp_prior_state_hash
# declare -A tfp_relevant_attributes_hash
# declare -A tfp_resource_changes_hash
# declare -A tfp_resource_drift_hash
# declare -A tfp_terraform_version_hash
# declare -A tfp_terraform_cloud_hash

    #echo "INFO: keys=${tfp_hash[@]}"
    file_to_write_tfp_root_keys=$(echo "${tfp_status_root}/tfp_root_key_process_status.info")
    for all_status in `echo "${!tfp_hash[@]}"`
    do
        echo "${all_status}:${tfp_files_hash[${all_status}]}:${tfp_terraform_cloud_hash[${all_status}]}"
    done > ${file_to_write_tfp_root_keys}

    file_to_write_tfp_configuration_keys=$(echo "${tfp_key_root}/tfp_root_key_configuration_process_status.info")
    for all_configuration_files in `echo "${!tfp_configuration_hash[@]}"`
    do
       echo "${all_configuration_files}:${tfp_configuration_hash[${all_configuration_files}]}:${tfp_terraform_cloud_hash[${all_configuration_files}]}"
    done > ${file_to_write_tfp_configuration_keys}

    file_to_write_tfp_checks_keys=$(echo "${tfp_key_root}/tfp_root_key_checks_process_status.info")
    for all_checks_files in `echo "${!tfp_checks_hash[@]}"`
    do
       echo "${all_checks_files}:${tfp_checks_hash[${all_checks_files}]}:${tfp_terraform_cloud_hash[${all_checks_files}]}"
    done > ${file_to_write_tfp_checks_keys}

    file_to_write_tfp_pv_keys=$(echo "${tfp_key_root}/tfp_root_key_planned_values_process_status.info")
    for all_pv_files in `echo "${!tfp_planned_values_hash[@]}"`
    do
       echo "${all_pv_files}:${tfp_planned_values_hash[${all_pv_files}]}"
    done > ${file_to_write_tfp_pv_keys}

    file_to_write_tfp_ps_keys=$(echo "${tfp_key_root}/tfp_root_key_prior_state_process_status.info")
    for all_ps_files in `echo "${!tfp_prior_state_hash[@]}"`
    do
       echo "${all_ps_files}:${tfp_prior_state_hash[${all_ps_files}]}"
    done > ${file_to_write_tfp_ps_keys}

    file_to_write_tfp_ra_keys=$(echo "${tfp_key_root}/tfp_root_key_relevant_attributes_process_status.info")
    for all_ra_files in `echo "${!tfp_relevant_attributes_hash[@]}"`
    do
       echo "${all_ra_files}:${tfp_relevant_attributes_hash[${all_ra_files}]}"
    done > ${file_to_write_tfp_ra_keys}

    file_to_write_tfp_rc_keys=$(echo "${tfp_key_root}/tfp_root_key_resource_changes_process_status.info")
    for all_rc_files in `echo "${!tfp_resource_changes_hash[@]}"`
    do
       echo "${all_rc_files}:${tfp_resource_changes_hash[${all_rc_files}]}"
    done > ${file_to_write_tfp_rc_keys}

    file_to_write_tfp_rd_keys=$(echo "${tfp_key_root}/tfp_root_key_resource_drift_process_status.info")
    for all_rd_files in `echo "${!tfp_resource_drift_hash[@]}"`
    do
       echo "${all_rd_files}:${tfp_resource_drift_hash[${all_rd_files}]}"
    done > ${file_to_write_tfp_rd_keys}
}

declare -A cld_map

cld_map['azure']="AZURE"
cld_map['gcp']="GCP"
cld_map['aws']="AWS"

  get_ucld=$(echo "AZURE")
chk_cloud ()
{
    echo "INFO: FUNCTION_NAME chk_cloud"

    ##echo "INFO: TFP_FILE=${1} Start"
    #cloud_gcp=$(cat ${1} | jq . | grep "google" | wc -l)
    #cloud_gcp=$(cat ${1} | jq -r '.planned_values.root_module.child_modules[].resources[].provider_name' | cut -d"/" -f3 | sort -u |  grep "google" | wc -l)
    #cloud_gcp=${cloud_gcp:-0}
    #cloud_azure=$(cat ${1} | jq -r '.planned_values.root_module.child_modules[].resources[].provider_name' | cut -d"/" -f3 | sort -u | grep "azure" | wc -l)
    #cloud_azure=${cloud_azure:-0}
    #cloud_aws=$(cat ${1} | jq -r '.planned_values.root_module.child_modules[].resources[].provider_name' | cut -d"/" -f3 | sort -u |  grep "aws" | wc -l)
    #cloud_aws=${cloud_aws:-0}

    cloud_gcp=$(cat ${1} | jq -r '.' |  grep "provider_name" | cut -d ":" -f 2 | sed 's/\"//g' | sed 's/\,$//' | cut -d "/" -f 3 | sort -u |  grep -i google | wc -l)
    cloud_gcp=${cloud_gcp:-0}
    cloud_azure=$(cat ${1} | jq -r '.' |  grep "provider_name" | cut -d ":" -f 2 | sed 's/\"//g' | sed 's/\,$//' | cut -d "/" -f 3 | sort -u |  grep -i azure | wc -l)
    cloud_azure=${cloud_azure:-0}
    cloud_aws=$(cat ${1} | jq -r '.' | grep "provider_name" | cut -d ":" -f 2 | sed 's/\"//g' | sed 's/\,$//' | cut -d "/" -f 3 | sort -u |  grep -i "aws" | wc -l)
    cloud_aws=${cloud_aws:-0}

    ##echo "INFO: ${cloud_gcp},${cloud_azure},${cloud_aws}"
    if [ ${cloud_azure} -gt 0 ]; then
       tfp_terraform_cloud_hash[${2}]="azure"
    fi
    if [ ${cloud_gcp} -gt 0 ]; then
       tfp_terraform_cloud_hash[${2}]="gcp"
    fi
    if [ ${cloud_aws} -gt  0 ]; then
       tfp_terraform_cloud_hash[${2}]="aws"
    fi
    CLOUD=$(echo "${tfp_terraform_cloud_hash[${2}]}")
    CLOUD=${CLOUD:-NONE}
    if [ "${CLOUD}" == "NONE" ]; then
       tfp_terraform_cloud_hash[${2}]="NONE"
    fi
    echo "INFO: CLOUD=${tfp_terraform_cloud_hash[${2}]},SIGNAURE=${2}"
    get_ucld=$(echo "${cld_map[${CLOUD}]}")
    echo "INFO: TFP_FILE=${1} End"
    break_step 
}

clip_base_name ()
{
    #echo "INFO: FUNCTION_NAME clip_base_name"
#basename ./20231031-44-304/16/createPE_Sandbox-parkpoc-dev-eastus2/ECS/S48974_565.1698768720.tfplan S48974_565.1698768720.tfplan
    base_name=$(basename ${1})
    #echo "INFO: basename ${base_name} and ${1}"
    base_name=${base_name:-NONE}
    if [ "${base_name}" != "NONE" ]; then
        clean_bnm=$(echo "${base_name}" | sed 's/\.tfplan$//' | sed 's/\./_/')
        tfp_hash[${clean_bnm}]="${clean_bnm}"
        tfp_files_hash[${clean_bnm}]="${1}"
        
        current_base=$(echo "${clean_bnm}")
        rpt_date=$(echo "${1}" | tr '/' '\n' | grep -E "[0-9]{8}-[0-9]{2}-[0-9]{3}") 
        base_name=$(echo "${clean_bnm}")
        echo "${base_name}"
        appnm=$(echo "${1}" | awk -F "/" '{ APPNM=NF-1; print $APPNM;}')
        chk_cloud ${1} "${clean_bnm}"
    else
        echo "ERROR"
    fi

}

NONE ()
{
    echo "INFO: FUNCTION_NAME NONE"

}

configuration ()
{
    echo "INFO: FUNCTION_NAME configuration"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    #tfp_configuration_hash[${pop_base}]="${pop_base}"
    #get_config_keys=$(cat ${1} | | jq '.configuration' | jq 'keys|join("|")' | sed 's/\"//g')
    #appnm=$(echo "${1}" | awk -F "/" '{ APPNM=NF-1; print $APPNM;}')
    ##echo "INFO: pop_base=${pop_base},APPNM=${appnm}"
    config_filenm=$(echo "${tfp_root}/configuration_${appnm}_${pop_base}.json")
    chk_file=$(ls -C1 ${config_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.configuration' > ${config_filenm}
    else
         echo "INFO: key-configuration-already-done,${chk_file}"
    fi
    tfp_configuration_hash[${pop_base}]="${config_filenm}"
    echo "INFO: configuration=${tfp_configuration_hash[${pop_base}]}"
    break_step
}

checks ()
{
    echo "INFO: FUNCTION_NAME checks"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    checks_filenm=$(echo "${tfp_root}/checks_${appnm}_${pop_base}.json")
    chk_file=$(ls -C1 ${checks_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.checks' > ${checks_filenm}
    else
         echo "INFO: key-checks-already-done,${chk_file}"
    fi
    tfp_checks_hash[${pop_base}]="${checks_filenm}"
    echo "INFO: checks=${tfp_checks_hash[${pop_base}]}"
    resources_from_checks=()
    resources_from_checks_filenm=$(echo "${tfp_root}/resources_${appnm}_${pop_base}.pipe")
    chk_file=$(ls -C1 ${resources_from_checks_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${checks_filenm} | jq '.[].address|join("|")' | grep "\"resource" | sed 's/\"//g' > ${resources_from_checks_filenm}
    else
         echo "INFO: key-checks-resources-already-done,${chk_file}"
    fi
    vars_from_checks_filenm=$(echo "${tfp_root}/vars_${appnm}_${pop_base}.pipe")
    chk_file=$(ls -C1 ${vars_from_checks_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${checks_filenm} | jq '.[].address|join("|")' | grep "^\"var" | sed 's/\"//g' > ${vars_from_checks_filenm}
    else
         echo "INFO: key-checks-vars-already-done,${chk_file}"
    fi
    tfp_checks_resources_hash[${pop_base}]="${resources_from_checks_filenm}"
    echo "INFO: resources_checks=${tfp_checks_resources_hash[${pop_base}]}"
    break_step
}


format_version ()
{
    echo "INFO: FUNCTION_NAME format_version"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    fv=$(cat ${1} | jq '.format_version')
    tfp_format_version_hash[${pop_base}]="${fv}"
    echo "INFO: format_version=${tfp_format_version_hash[${pop_base}]}"

}

errored ()
{
    echo "INFO: FUNCTION_NAME errored"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    fv=$(cat ${1} | jq '.errored')
    tfp_errored_hash[${pop_base}]="${fv}"
    echo "INFO: errored=${tfp_errored_hash[${pop_base}]}"

}

timestamp ()
{
    echo "INFO: FUNCTION_NAME timestamp"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    fv=$(cat ${1} | jq '.timestamp')
    tfp_timestamp_hash[${pop_base}]="${fv}"
    echo "INFO: timestamp=${tfp_timestamp_hash[${pop_base}]}"

}


planned_values ()
{
    echo "INFO: FUNCTION_NAME  planned_values"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    planned_values_filenm=$(echo "${tfp_root}/planned_values_${appnm}_${pop_base}.json")
    chk_file=$(ls -C1 ${planned_values_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.planned_values' > ${planned_values_filenm} 
    else
         echo "INFO: key-planned_values-already-done,${chk_file}"
    fi
    tfp_planned_values_hash[${pop_base}]="${planned_values_filenm}"
    echo "INFO: planned_values=${tfp_planned_values_hash[${pop_base}]}"

}


prior_state ()
{
    echo "INFO: FUNCTION_NAME prior_state"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    prior_state_filenm=$(echo "${tfp_root}/prior_state_${appnm}_${pop_base}.json")
    chk_file=$(ls -C1 ${prior_state_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.prior_state' > ${prior_state_filenm} 
    else
         echo "INFO: key-prior_state-already-done,${chk_file}"
    fi
    tfp_prior_state_hash[${pop_base}]="${prior_state_filenm}"
    echo "INFO: prior_state=${tfp_prior_state_hash[${pop_base}]}"

}


relevant_attributes ()
{
    echo "INFO: FUNCTION_NAME relevant_attributes"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    relevant_attributes_filenm=$(echo "${tfp_root}/relevant_attributes_${appnm}_${pop_base}.json")
    chk_file=$(ls -C1 ${relevant_attributes_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.relevant_attributes' > ${relevant_attributes_filenm} 
    else
         echo "INFO: key-relevant_attributes-already-done,${chk_file}"
    fi
    tfp_relevant_attributes_hash[${pop_base}]="${relevant_attributes_filenm}"
    echo "INFO: relevant_attributes=${tfp_relevant_attributes_hash[${pop_base}]}"

}


resource_changes ()
{
    echo "INFO: FUNCTION_NAME resource_changes"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    resource_changes_filenm=$(echo "${tfp_root}/resource_changes_${appnm}_${pop_base}.json")
    chk_file=$(ls -C1 ${resource_changes_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.resource_changes' > ${resource_changes_filenm} 
    else
         echo "INFO: key-resource_changes-already-done,${chk_file}"
    fi
    tfp_resource_changes_hash[${pop_base}]="${resource_changes_filenm}"
    echo "INFO: resource_changes=${tfp_resource_changes_hash[${pop_base}]}"

}


resource_drift ()
{
    echo "INFO: FUNCTION_NAME resource_drift"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    resource_drift_filenm=$(echo "${tfp_root}/resource_drift_${appnm}_${pop_base}.json")
    chk_file=$(ls -C1 ${resource_drift_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.resource_drift' > ${resource_drift_filenm} 
    else
         echo "INFO: key-resource_drift-already-done,${chk_file}"
    fi
    tfp_resource_drift_hash[${pop_base}]="${resource_drift_filenm}"
    echo "INFO: resource_drift=${tfp_resource_drift_hash[${pop_base}]}"

}

terraform_version ()
{
    echo "INFO: FUNCTION_NAME terraform_version"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    get_terraform_version=(`cat ${1} | jq '.terraform_version'`)
    tfp_terraform_version_hash[${pop_base}]="${get_terraform_version}"
    echo "INFO: terraform_version=${tfp_terraform_version_hash[${pop_base}]}"
}

find_tag ()
{
    echo "INFO: FUNCTION_NAME find_tag"
    for all_root_key in `echo "${tfp_root_keys_ar[@]}"`
    do
        get_root_key=(`echo "${tfp_root_keys_hash[${all_root_key}]}"`)
        get_root_key=${get_root_key:-NONE}
        ${get_root_key} "${1}"
    done
}

process_json_file ()
{
    echo "INFO: FUNCTION_NAME process_json_file"
    echo "INFO: resource_root_locator - ${tfp_root_keys_ar[@]}"
    clip_base_name ${1}
    get_cloud=$(echo "cloud_${tfp_terraform_cloud_hash[${base_name}]}")
    if [ "${get_cloud}" == "cloud_NONE" ]; then
        rc=$(echo "ERROR")
    fi
    if [ "${rc}" != "ERROR" ]; then
        echo "INFO: rpt_date=${rpt_date}"
        find_tag ${1}
    else
        echo "INFO: ${rc}"
    fi
    break_step
}

      cd ${tfp_daily_dir}
      echo_vars
      for all in `echo "${tfp_file_list_collected[@]}"`
      do
            echo "INFO: ${all}"
            file_tfp=$(echo "${all}")
            tfp_root_keys_ar=$(cat ${all} | jq 'keys|join("|")'  2>/dev/null | sed 's/\"//g' | tr '|' ' ')
            any_keys=$(echo "${#tfp_root_keys_ar[@]}")
            if [ ${any_keys} -gt 0 ]; then
                  echo "INFO: CALLING_FN- process_json_file ${all}"
                  process_json_file ${all}
            else
                  echo "INFO: NOT_A_TERRAFORM_FILE(NOT_A_JSON)"
            fi
      done
      echo_unique_keys
