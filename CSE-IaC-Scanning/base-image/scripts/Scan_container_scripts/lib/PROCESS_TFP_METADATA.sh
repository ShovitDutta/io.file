# TFP_GLOBAL_PROCESSING_Start

 declare -A tfp_root_keys_hash
 declare -A tfp_root_keys_type_hash
 declare -A tfp_final_pipe_files_name_hash
 declare -A tfp_post_processed_zip_files_hash
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
 tfp_root_keys_hash["variables"]="variables"
 tfp_root_keys_hash["applyable"]="applyable"
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
 tfp_root_keys_type_hash["variables"]="obj:variables"
 tfp_root_keys_type_hash["applyable"]="key:applyable"
 tfp_root_keys_type_hash["NONE"]="none:NONE"

 declare -A tfp_configuration_hash
 declare -A tfp_format_version_hash
 declare -A tfp_planned_values_hash
 declare -A ciss_tfp_pv_hash
 declare -A ciss_tfp_scan_rc_hash
 declare -A tfp_prior_state_hash
 declare -A tfp_relevant_attributes_hash
 declare -A tfp_resource_changes_hash
 declare -A tfp_resource_drift_hash
 declare -A tfp_terraform_version_hash
 declare -A tfp_checks_hash
 declare -A tfp_errored_hash
 declare -A tfp_errored_hash
 declare -A tfp_timestamp_hash
 declare -A tfp_variables_hash
 declare -A tfp_applyable_hash

 declare -A tfp_keys_type_sym_rel_hash

 tfp_keys_type_sym_rel_hash["tfp_pv"]="tfp_pv"
 tfp_keys_type_sym_rel_hash["tfp_pvc"]="tfp_pvc"
 tfp_keys_type_sym_rel_hash["tfp_pvr"]="tfp_pvr"
 tfp_keys_type_sym_rel_hash["tfp_rc"]="tfp_rc"
 tfp_keys_type_sym_rel_hash["tfp_rc_alsp"]="tfp_rc_alsp"
 tfp_keys_type_sym_rel_hash["tfp_rc_tbsp"]="tfp_rc_tbsp"
 tfp_keys_type_sym_rel_hash["tfp_ps"]="tfp_ps"
 tfp_keys_type_sym_rel_hash["tfp_pc"]="tfp_pc"
 tfp_keys_type_sym_rel_hash["tfp_rd"]="tfp_rd"
 tfp_keys_type_sym_rel_hash["tfp_pd"]="tfp_pd"
 tfp_keys_type_sym_rel_hash["tfp_rk"]="tfp_rk"
 tfp_keys_type_sym_rel_hash["tfp_gv"]="tfp_gv"
 declare -A tfp_hash
 declare -A tfp_files_hash

 declare -A tfp_key_based_obj_hash


 declare -A tfp_checks_resources_hash

 rc=$(echo "rc")

 base_name=$(echo "NONE")

 tfp_ciss_root=$(echo "${daily_date_format_dir}/ciss")
 tfp_root=$(echo "${daily_date_format_dir}/tfp")
 tfp_info_root=$(echo "${daily_date_format_dir}/tfp/info")
 tfp_status_root=$(echo "${daily_date_format_dir}/tfp/status")
 tfp_key_root=$(echo "${daily_date_format_dir}/tfp/keys")
 tfp_daily_dir=$(echo "${daily_date_format_dir}/daily_tfp")

# TFP_GLOBAL_PROCESSING_End

create_tfp_dir ()
{

 ECHO "INFO: FUNCTION_NAME create_tfp_dir"

 tfp_ciss_root=$(echo "${daily_date_format_dir}/ciss")
 tfp_root=$(echo "${daily_date_format_dir}/tfp")
 tfp_info_root=$(echo "${daily_date_format_dir}/tfp/info")
 tfp_status_root=$(echo "${daily_date_format_dir}/tfp/status")
 tfp_key_root=$(echo "${daily_date_format_dir}/tfp/keys")
 tfp_daily_dir=$(echo "${daily_date_format_dir}/daily_tfp")

 mkdir -p ${tfp_root}
 mkdir -p ${tfp_info_root}
 mkdir -p ${tfp_status_root}
 mkdir -p ${tfp_key_root}
 mkdir -p ${tfp_daily_dir}
 mkdir -p ${tfp_ciss_root}

}


break_step ()
{
    ECHO "INFO: FUNCTION_NAME break_step"
    if [ "${debug}" == "t" ]; then
         read SSSSS
    fi
}

echo_unique_keys ()
{
    ECHO "INFO: FUNCTION_NAME echo_unique_keys"
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

NONE ()
{
    ECHO "INFO: FUNCTION_NAME NONE"
    echo "INFO_DEBUG: NONE_VALUE_FOUND."

}

configuration ()
{
    ECHO "INFO: FUNCTION_NAME configuration"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    #tfp_configuration_hash[${pop_base}]="${pop_base}"
    #get_config_keys=$(cat ${1} | | jq '.configuration' | jq 'keys|join("|")' | sed 's/\"//g')
    #appnm=$(echo "${1}" | awk -F "/" '{ APPNM=NF-1; print $APPNM;}')
    ##echo "INFO: pop_base=${pop_base},APPNM=${appnm}"
    config_filenm=$(echo "${tfp_root}/configuration_${pop_base}.json")
    chk_file=$(ls -C1 ${config_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.configuration' > ${config_filenm}
    else
         ECHO "INFO: key-configuration-already-done,${chk_file}"
    fi
    tfp_configuration_hash[${pop_base}]="${config_filenm}"
    ECHO "INFO: configuration=${tfp_configuration_hash[${pop_base}]}"
    break_step
}

checks ()
{
    ECHO "INFO: FUNCTION_NAME checks"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    checks_filenm=$(echo "${tfp_root}/checks_${pop_base}.json")
    chk_file=$(ls -C1 ${checks_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.checks' > ${checks_filenm}
    else
         ECHO "INFO: key-checks-already-done,${chk_file}"
    fi
    tfp_checks_hash[${pop_base}]="${checks_filenm}"
    ECHO "INFO: checks=${tfp_checks_hash[${pop_base}]}"
    resources_from_checks=()
    resources_from_checks_filenm=$(echo "${tfp_root}/checks_${pop_base}.pipe")
    chk_file=$(ls -C1 ${resources_from_checks_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${checks_filenm} | jq '.[].address|join("|")' | grep "\"resource" | sed 's/\"//g' > ${resources_from_checks_filenm}
    else
         ECHO "INFO: key-checks-resources-already-done,${chk_file}"
    fi
    vars_from_checks_filenm=$(echo "${tfp_root}/vars_${pop_base}.pipe")
    chk_file=$(ls -C1 ${vars_from_checks_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${checks_filenm} | jq '.[].address|join("|")' | grep "^\"var" | sed 's/\"//g' > ${vars_from_checks_filenm}
    else
         ECHO "INFO: key-checks-vars-already-done,${chk_file}"
    fi
    tfp_checks_resources_hash[${pop_base}]="${resources_from_checks_filenm}"
    ECHO "INFO: resources_checks=${tfp_checks_resources_hash[${pop_base}]}"
    break_step
}


format_version ()
{
    ECHO "INFO: FUNCTION_NAME format_version"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    fv=$(cat ${1} | jq '.format_version')
    tfp_format_version_hash[${pop_base}]="${fv}"
    echo "INFO: SIGNATURE=${pop_base} tfp_format_version=${tfp_format_version_hash[${pop_base}]}"

}

errored ()
{
    ECHO "INFO: FUNCTION_NAME errored"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    fv=$(cat ${1} | jq '.errored')
    tfp_errored_hash[${pop_base}]="${fv}"
    ECHO "INFO: errored=${tfp_errored_hash[${pop_base}]}"

}

timestamp ()
{
    ECHO "INFO: FUNCTION_NAME timestamp"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    fv=$(cat ${1} | jq '.timestamp')
    tfp_timestamp_hash[${pop_base}]="${fv}"
    ECHO "INFO: timestamp=${tfp_timestamp_hash[${pop_base}]}"

}


variables ()
{
    ECHO "INFO: FUNCTION_NAME  variables"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    variables_filenm=$(echo "${tfp_root}/variables_${pop_base}.json")
    chk_file=$(ls -C1 ${variables_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.variables|{ "all_variables":.}'  > ${variables_filenm} 
    else
         ECHO "INFO: key-variables-already-done,${chk_file}"
    fi
    tfp_variables_hash[${pop_base}]="${variables_filenm}"
    ECHO "INFO: variables=${tfp_variables_hash[${pop_base}]}"

}

planned_values_dummy ()
{
    ECHO "INFO: FUNCTION_NAME  planned_values"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    planned_values_filenm=$(echo "${tfp_root}/planned_values_${pop_base}.json")
    chk_file=$(ls -C1 ${planned_values_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.planned_values' > ${planned_values_filenm} 
    else
         ECHO "INFO: key-planned_values-already-done,${chk_file}"
    fi
    tfp_planned_values_hash[${pop_base}]="${planned_values_filenm}"
    echo "INFO: planned_values=${tfp_planned_values_hash[${pop_base}]}"

}

xxplanned_values_init ()
{
    ECHO "INFO: FUNCTION_NAME  planned_values"
    ##echo "INFO: trp is ${1}, version ${ver}"
    #pop_base=$(echo "${tfp_hash[${base_name}]}")
    pop_base=${2}
    get_my_cld=${4}
    ECHO "INFO: parameters Passed ${1}, ${2}, pop_base ${pop_base} my_cld ${get_my_cld}"
    tfp_hash[${pop_base}_${get_my_cld}]="${pop_base}_${get_my_cld}"
    planned_values_filenm=$(echo "${3}/planned_values_${pop_base}_${get_my_cld}.json")
    chk_file=$(ls -C1 ${planned_values_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.planned_values' > ${planned_values_filenm}
    else
         ECHO "INFO: key-planned_values-already-done,${chk_file}"
    fi
    tfp_planned_values_hash[${pop_base}_${get_my_cld}]="${planned_values_filenm}"
    ECHO "INFO: planned_values=${tfp_planned_values_hash[${pop_base}_${get_my_cld}]}"

}


planned_values ()
{
    ECHO "INFO: FUNCTION_NAME  planned_values"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    planned_values_filenm=$(echo "${tfp_root}/planned_values_${pop_base}.json")
    chk_file=$(ls -C1 ${planned_values_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.planned_values' > ${planned_values_filenm}
    else
         ECHO "INFO: key-planned_values-already-done,${chk_file}"
    fi
    tfp_planned_values_hash[${pop_base}]="${planned_values_filenm}"
    echo "INFO: planned_values=${tfp_planned_values_hash[${pop_base}]}"
}



prior_state ()
{
    ECHO "INFO: FUNCTION_NAME prior_state"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    prior_state_filenm=$(echo "${tfp_root}/prior_state_${pop_base}.json")
    chk_file=$(ls -C1 ${prior_state_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.prior_state' > ${prior_state_filenm} 
    else
         ECHO "INFO: key-prior_state-already-done,${chk_file}"
    fi
    tfp_prior_state_hash[${pop_base}]="${prior_state_filenm}"
    echo "INFO: prior_state=${tfp_prior_state_hash[${pop_base}]}"

}


relevant_attributes ()
{
    ECHO "INFO: FUNCTION_NAME relevant_attributes"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    relevant_attributes_filenm=$(echo "${tfp_root}/relevant_attributes_${pop_base}.json")
    chk_file=$(ls -C1 ${relevant_attributes_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.relevant_attributes' > ${relevant_attributes_filenm} 
    else
         ECHO "INFO: key-relevant_attributes-already-done,${chk_file}"
    fi
    tfp_relevant_attributes_hash[${pop_base}]="${relevant_attributes_filenm}"
    ECHO "INFO: relevant_attributes=${tfp_relevant_attributes_hash[${pop_base}]}"

}


resource_changes ()
{
    ECHO "INFO: FUNCTION_NAME resource_changes"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    resource_changes_filenm=$(echo "${tfp_root}/resource_changes_${pop_base}.json")
    chk_file=$(ls -C1 ${resource_changes_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.resource_changes' > ${resource_changes_filenm} 
    else
         ECHO "INFO: key-resource_changes-already-done,${chk_file}"
    fi
    tfp_resource_changes_hash[${pop_base}]="${resource_changes_filenm}"
    ECHO "INFO: resource_changes=${tfp_resource_changes_hash[${pop_base}]}"

}


resource_drift ()
{
    ECHO "INFO: FUNCTION_NAME resource_drift"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    resource_drift_filenm=$(echo "${tfp_root}/resource_drift_${pop_base}.json")
    chk_file=$(ls -C1 ${resource_drift_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.resource_drift' > ${resource_drift_filenm} 
    else
         ECHO "INFO: key-resource_drift-already-done,${chk_file}"
    fi
    tfp_resource_drift_hash[${pop_base}]="${resource_drift_filenm}"
    ECHO "INFO: resource_drift=${tfp_resource_drift_hash[${pop_base}]}"

}

terraform_version ()
{
    ECHO "INFO: FUNCTION_NAME terraform_version"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${tfp_hash[${base_name}]}")
    get_terraform_version=(`cat ${1} | jq '.terraform_version'`)
    tfp_terraform_version_hash[${pop_base}]="${get_terraform_version}"
    echo "INFO: SIGNATURE=${pop_base} terraform_version=${tfp_terraform_version_hash[${pop_base}]}"
}

tfp_tag_process_for_gcp_clouds ()
{
      ECHO "INFO: FUNCTION_NAME tfp_tag_process_for_gcp_clouds"
      echo "INFO_DEBUG: p1, p2 ${1}, ${2} ${3}"
      file_to_write_values_from_pv_json=$(echo "${daily_date_format_dir}/tfp/tag_values_pv_info_${1}.json")
      file_to_write_keys_from_pv_json=$(echo "${daily_date_format_dir}/tfp/tag_key_pv_info_${1}.json")
      file_to_write_values_from_ps_json=$(echo "${daily_date_format_dir}/tfp/tag_values_ps_info_${1}.json")
      file_to_write_keys_from_ps_json=$(echo "${daily_date_format_dir}/tfp/tag_key_ps_info_${1}.json")
      file_to_write_json_pipe=$(echo "${daily_date_format_dir}/tfp/tag_info_${1}.pipe")
      tfp_configuration_file_name=$(echo "${3}")
      tfp_planned_values_file_name=$(echo "${3}" | sed 's/configuration/planned_values/')
      tfp_prior_state_file_name=$(echo "${3}" | sed 's/configuration/prior_state/')
      tfp_relevant_attributes_file_name=$(echo "${3}" | sed 's/configuration/relevant_attributes/')
      tfp_resource_changes_file_name=$(echo "${3}" | sed 's/configuration/resource_changes/')

      echo "INFO: tag_file_to_write ${file_to_write_values_from_pv_json} ${file_to_write_keys_from_pv_json}"
      echo "INFO: tag_file_to_write ${file_to_write_values_from_ps_json} ${file_to_write_keys_from_ps_json}"
      echo "INFO: tfp_planned_values_file_name=${tfp_planned_values_file_name}"
      echo "INFO: tfp_prior_state_file_name=${tfp_prior_state_file_name}"
      echo "INFO: tfp_resource_changes_file_name=${tfp_resource_changes_file_name}"

      planned_values_label_length=$(cat ${2}|  jq  '[.planned_values?|select( . != null)|.root_module?.resources[]?]|.[]|[ { "service_reource":.type,"service_name":.name, "properties_already_set":.values, "tags_already_set":.values.labels}]|.[]|.tags_already_set|keys|length')
      planned_values_label_length=${planned_values_label_length:-0}

      prior_state_values_label_length=$(cat ${2} | jq  '.prior_state?|.values?|select( . != null)|.root_module|[.resources[]]|[.[]|{ "service_reource":.type,"service_name":.name,  "properties_to_be_set":.values, "tags_to_be_set": .values.labels}]|sort|unique|.[]|.tags_to_be_set|keys|length')
      #| jq  '.prior_state?|.values?|select( . != null)|.root_module|[.resources[]]|[.[]|{ "service_reource":.type,"service_name":.name,  "properties_to_be_set":.values, "tags_to_be_set": .values.labels}]|sort|unique|.[]|.tags_to_be_set|keys|length'
      #cat /tmp/iac_scan_status/tfp/2024/20240813-33-226/tfp/prior_state_S05050_11_gcp.json |  jq '.values.root_module.resources[].values.labels|select( . != null)'
      prior_state_values_label_length=${prior_state_values_label_length:-0}
      
      SOFT_DEPLOYMENT=$(echo "N")

      echo "INFO: planned_values_label_length ${planned_values_label_length}"
      echo "INFO: prior_state_values_label_length ${prior_state_values_label_length}"

        if [ ${planned_values_label_length} -gt 0 ]; then
           cat ${2}|  jq  '[.planned_values?|select( . != null)|.root_module?.resources[]?]|.[]|[ { "service_reource":.type,"service_name":.name, "properties_already_set":.values, "tags_already_set":.values.labels}]|.[]|.tags_already_set|values' > ${file_to_write_values_from_pv_json}
           cat ${2}|  jq  '[.planned_values?|select( . != null)|.root_module?.resources[]?]|.[]|[ { "service_reource":.type,"service_name":.name, "properties_already_set":.values, "tags_already_set":.values.labels}]|.[]|.tags_already_set|keys' >  ${file_to_write_keys_from_ps_json}
        fi

        if [ ${prior_state_values_label_length} -gt 0 ]; then
            #cat ${tfp_prior_state_file_name}  | jq -Mr '.values.root_module.child_modules[]?|.resources[].values.labels?| select ( . != null)|values' > ${file_to_write_values_from_ps_json}
            #cat ${tfp_prior_state_file_name}  | jq -Mr '.values.root_module.child_modules[]?|.resources[].values.labels?| select ( . != null)|keys' > ${file_to_write_keys_from_ps_json}
            cat ${2} | jq  '.prior_state?|.values?|select( . != null)|.root_module|[.resources[]]|[.[]|{ "service_reource":.type,"service_name":.name,  "properties_to_be_set":.values, "tags_to_be_set": .values.labels}]|sort|unique|.[]|.tags_to_be_set|values' > ${file_to_write_values_from_ps_json}
            cat ${2} | jq  '.prior_state?|.values?|select( . != null)|.root_module|[.resources[]]|[.[]|{ "service_reource":.type,"service_name":.name,  "properties_to_be_set":.values, "tags_to_be_set": .values.labels}]|sort|unique|.[]|.tags_to_be_set|keys' > ${file_to_write_keys_from_ps_json}
            
        fi

       if [ ${prior_state_values_label_length} -gt  ${planned_values_label_length} ]; then
            cat ${file_to_write_keys_from_ps_json} | jq -Mr '.|@csv' |  sed 's/\,/|/g' | sed 's/\"//g' > ${file_to_write_json_pipe}
            cat ${file_to_write_values_from_ps_json} | jq -Mr '.' | sed 's/{/[/' | sed 's/}/]/' | cut -d ":" -f 2  | jq -Mr '.|@csv' | sed 's/\,/|/g' | sed 's/\"//g' >> ${file_to_write_json_pipe}
       else
            cat ${file_to_write_keys_from_pv_json} | jq -Mr '.|@csv' |  sed 's/\,/|/g' | sed 's/\"//g' > ${file_to_write_json_pipe}
            cat ${file_to_write_values_from_pv_json} | jq -Mr '.' | sed 's/{/[/' | sed 's/}/]/' | cut -d ":" -f 2  | jq -Mr '.|@csv' | sed 's/\,/|/g' | sed 's/\"//g' >> ${file_to_write_json_pipe}

       fi

       ECHO "INFO: process_resources_from_resource_changes file ${tfp_planned_values_file_name}"
#process_resources_from_resource_changes_and_planned_values -Start
       #if [ "${root_module_chk}" != "NONE" ]; then
       #    cat ${tfp_planned_values_file_name} | jq -Mr  '.root_module.child_modules[].child_modules[].resources[]|[.address?]|@csv' | sed 's/\"\"/\"/g' | sed 's/^\"//' | sed 's/\"$//' > ${daily_date_format_dir}/tfp/resources_from_pv_info_${1}.pipe
       #else
       #    touch ${daily_date_format_dir}/tfp/resources_from_pv_info_${1}.pipe
       #fi
   
       ECHO "INFO: process_resources_from_resource_changes file ${tfp_resource_changes_file_name}"
       #cat ${tfp_resource_changes_file_name} | jq -Mr '.[]?|[.address,.change.actions[0]]|join("|")' > ${daily_date_format_dir}/tfp/resources_from_rc_info_${1}.pipe

#process_resources_from_resource_changes_and_planned_values -End
       echo "INFO: TAG_FILE-NAME tag_file_to_write  ${file_to_write_key_json}"
       read SSSSS
}

tfp_tag_process_for_aws_clouds ()
{

    ECHO "INFO: FUNCTION_NAME tfp_tag_process_for_aws_clouds"
      file_to_write_json=$(echo "${daily_date_format_dir}/tfp/tag_info_${1}.json")
      file_to_write_key_json=$(echo "${daily_date_format_dir}/tfp/tag_key_info_${1}.json")
      file_to_write_json_pipe=$(echo "${daily_date_format_dir}/tfp/tag_info_${1}.pipe")
      tfp_configuration_file_name=$(echo "${2}")
      tfp_planned_values_file_name=$(echo "${2}" | sed 's/configuration/planned_values/')
      tfp_prior_state_file_name=$(echo "${2}" | sed 's/configuration/prior_state/')
      tfp_relevant_attributes_file_name=$(echo "${2}" | sed 's/configuration/relevant_attributes/')
      tfp_resource_changes_file_name=$(echo "${2}" | sed 's/configuration/resource_changes/')

      ECHO "INFO: tag_file_to_write ${file_to_write_key_json} ${file_to_write_json}"
      ECHO "INFO: tfp_planned_values_file_name=${tfp_planned_values_file_name}"
      ECHO "INFO: tfp_prior_state_file_name=${tfp_prior_state_file_name}"
      ECHO "INFO: tfp_resource_changes_file_name=${tfp_resource_changes_file_name}"

    

}

tfp_tag_process_for_azure_clouds ()
{

    ECHO "INFO: FUNCTION_NAME tfp_tag_process_for_azure_clouds"
    echo "INFO_DEBUG: p1, p2 ${1}, ${2} ${3}"
    file_to_write_pv_json=$(echo "${daily_date_format_dir}/tfp/tag_pv_info_${1}.json")
    file_to_write_ps_json=$(echo "${daily_date_format_dir}/tfp/tag_ps_info_${1}.json")
    file_in_question=$(echo "${2}")
    #process planned_values tag -Start
    pv_tags=$(cat ${file_in_question} |  jq '[.planned_values|.root_module|.child_modules[]|.resources[]|.values]|[.[]|.tags| select( .!= null)]|.[0]' | jq 'select(.!=null)')
    pv_tags=${pv_tags:-NONE}
    if [ "${pv_tags}" != "NONE" ]; then
       echo "${pv_tags}" > ${file_to_write_pv_json}
    fi
    #process planned_values tag -End

    #process prior_states tag -Start
    ps_tags_max_values_ct=$(cat ${file_in_question} | jq  '[.prior_state.values?|.root_module?|.child_modules[]?|.resources[]?|.values?]|[.[].tags?|select( .!= null)]' | jq '[select( .!= null)|.[]]' | jq '.' | tr '\n' ' ' | sed 's/\[/\[\n/' | sed 's/\}\,/\}\,\n/g' | sed 's/\]/\n\]\n/' | sed 's/ //g' | sed "s/{},//" | sort -u | grep -v "\[" | grep -v "\]" | awk -F "," '{ OFS=","; print NF;}' | sort -ur | head -1)
    let ps_tags_max_values_ct=${ps_tags_max_values_ct}-1
    ps_tags=$(cat ${file_in_question} | jq  '[.prior_state.values?|.root_module?|.child_modules[]?|.resources[]?|.values?]|[.[].tags?|select( .!= null)]' | jq '[select( .!= null)|.[]]' | jq '.' | tr '\n' ' ' | sed 's/\[/\[\n/' | sed 's/\}\,/\}\,\n/g' | sed 's/\]/\n\]\n/' | sed 's/ //g' | sed "s/{},//" | sort -u | grep -v "\[" | grep -v "\]" | awk -F "," -v lc="${ps_tags_max_values_ct}"  '{ OFS=","; if ( NF > lc ) { print $0;};}')
    ps_tags=$(cat ${file_in_question} |  jq  '[.prior_state.values?|.root_module?|.child_modules[]?|.resources[]?|.values?]|[.[].tags?|select( .!= null)]' | jq '[select( .!= null)|.[]]' | jq '.' | tr '\n' ' ' | sed 's/\[/\[\n/' | sed 's/\}\,/\}\,\n/g' | sed 's/\]/\n\]\n/' | sed 's/ //g' | sed "s/{},//" | sort -u | grep -v "\[" | grep -v "\]" | awk -F "," -v lc="${ps_tags_max_values_ct}"  '{ OFS=","; if ( NF > lc ) {print $0;}}' | tr '\n' ' ' | sed 's/^/\[\n/' | sed 's/\, $/\n\]\n/' | jq '.' | grep -v "createdondate" | jq '.|unique|.[0]')
    ps_tags=${ps_tags:-NONE}

    if [ "${ps_tags}" != "NONE" ]; then
       echo "${ps_tags}" > ${file_to_write_ps_json}
    fi

    echo "INFO_DEBUG: file ${file_to_write_ps_json} ${file_to_write_pv_json}"
    #process prior_states tag -End

}
tfp_tag_process_for_azure_clouds_dummy ()
{

    ECHO "INFO: FUNCTION_NAME tfp_tag_process_for_azure_clouds"
      file_to_write_json=$(echo "${daily_date_format_dir}/tfp/tag_info_${1}.json")
      file_to_write_key_json=$(echo "${daily_date_format_dir}/tfp/tag_key_info_${1}.json")
      file_to_write_json_pipe=$(echo "${daily_date_format_dir}/tfp/tag_info_${1}.pipe")
      tfp_configuration_file_name=$(echo "${2}")
      tfp_planned_values_file_name=$(echo "${2}" | sed 's/configuration/planned_values/')
      tfp_prior_state_file_name=$(echo "${2}" | sed 's/configuration/prior_state/')
      tfp_relevant_attributes_file_name=$(echo "${2}" | sed 's/configuration/relevant_attributes/')
      tfp_resource_changes_file_name=$(echo "${2}" | sed 's/configuration/resource_changes/')

      ECHO "INFO: tag_file_to_write ${file_to_write_key_json} ${file_to_write_json}"
      ECHO "INFO: tfp_planned_values_file_name=${tfp_planned_values_file_name}"
      ECHO "INFO: tfp_prior_state_file_name=${tfp_prior_state_file_name}"
      ECHO "INFO: tfp_resource_changes_file_name=${tfp_resource_changes_file_name}"
      ECHO "DEBUG: tfp_planned_values_file_name=${tfp_planned_values_file_name} root_module_chk Start"
      root_module_chk=$(cat ${tfp_planned_values_file_name} | jq '.root_module' | sed 's/{}//' | grep tags | cut -d ":" -f 1 | sed 's/ //g' | sort -u | jq -Mr '.')
      root_module_chk=${root_module_chk:-NONE}
      ECHO "DEBUG: tfp_planned_values_file_name=${tfp_planned_values_file_name} root_module_chk=${root_module_chk}  root_module_chk End"
      SOFT_DEPLOYMENT=$(echo "N")
               if [ "${root_module_chk}" != "NONE" ]; then
                                #get_tags=$(cat ${planned_values_file} | jq '.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq 'keys,values|join("|")' | tr '\n' '^'| sed 's/\^/|resource_name|subscription_id|scan_date|report_run_date|pipeline_name|app_id|terraform_id\^/')
                                cat ${tfp_planned_values_file_name} | jq '.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' > ${file_to_write_json}
                                cat ${tfp_planned_values_file_name} | jq '.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq 'keys' > ${file_to_write_key_json}
               else
                                ECHO "INFO: NO_TAGS_FROM_PLANNED_VALUES, PICKING_FROM_PRIOR_STATE"
                                #get_tags=$(cat ${tfp_prior_state_file_name} | jq '.values.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq 'keys,values|join("|")' | tr '\n' '^'| sed 's/\^/|resource_name|subscription_id|scan_date|report_run_date|pipeline_name|app_id|terraform_id\^/')
                                cat ${tfp_prior_state_file_name} | jq '.values.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' > ${file_to_write_json}
                                cat ${tfp_prior_state_file_name} | jq '.values.root_module.child_modules[].resources[].values.tags' | grep -v "null" | sed 's/}/},/' | tr '\n' ' ' | sed 's/^/{\n\"all_tags\":{\n \"t1\":/' | sed 's/, $/\n}\n}/' | sed 's/}\, {/}, \n \"t1\":{/g'  | jq . | jq '.all_tags.t1' | jq 'keys' > ${file_to_write_key_json}
               fi
       cat ${file_to_write_key_json} | jq -Mr '.|@csv' |  sed 's/\,/|/g' | sed 's/\"//g' > ${file_to_write_json_pipe}
       cat ${file_to_write_json} | jq -Mr '.' | sed 's/{/[/' | sed 's/}/]/' | cut -d ":" -f 2  | jq -Mr '.|@csv' | sed 's/\,/|/g' | sed 's/\"//g' >> ${file_to_write_json_pipe}

       ECHO "INFO: process_resources_from_resource_changes file ${tfp_planned_values_file_name}"
#process_resources_from_resource_changes_and_planned_values -Start
       
       if [ "${root_module_chk}" != "NONE" ]; then 
          cat ${tfp_planned_values_file_name} | jq -Mr '.root_module.child_modules[].resources[]|[.address?]|@csv' | sed 's/\"\"/\"/g' | sed 's/^\"//' | sed 's/\"$//' > ${daily_date_format_dir}/tfp/resources_from_pv_info_${1}.pipe
       else
           touch ${daily_date_format_dir}/tfp/resources_from_pv_info_${1}.pipe
       fi
       ECHO "INFO: process_resources_from_resource_changes file ${tfp_resource_changes_file_name}"
       cat ${tfp_resource_changes_file_name} | jq -Mr '.[]?|[.address,.change.actions[0]]|join("|")' > ${daily_date_format_dir}/tfp/resources_from_rc_info_${1}.pipe
#process_resources_from_resource_changes_and_planned_values -End
       ECHO "INFO: TAG_FILE-NAME ${file_to_write_key_json}"
}

find_tag ()
{
    ECHO "INFO: FUNCTION_NAME find_tag"
    for all_root_key in `echo "${tfp_root_keys_ar[@]}"`
    do
        get_root_key=(`echo "${tfp_root_keys_hash[${all_root_key}]}"`)
        get_root_key=${get_root_key:-NONE}
        case "${get_root_key}" in
        "planned_values")
               echo "INFO: filtering splitting plan files ${get_root_key}"
               if [ "${2}" == "Y" ]; then
                    ${get_root_key} "${1}" "${3}"
               fi
        ;;
        *)
               ${get_root_key} "${1}" "${3}"
        ;;
        esac
    done
}

tfp_files_loop ()
{
    ECHO "INFO: FUNCTION_NAME tfp_files_loop"

      for all in `echo "${!tfp_files_hash[@]}"`
      do
            ECHO "INFO: ${all}"
            file_tfp=$(echo "${all}")
            base_name=$(echo "${all}")
            file_in_question=$(echo "${tfp_files_hash[${all}]}")
            tfp_root_keys_ar=$(cat ${file_in_question} | jq 'keys|join("|")'  2>/dev/null | sed 's/\"//g' | tr '|' ' ')
            any_keys=$(echo "${#tfp_root_keys_ar[@]}")
            if [ ${any_keys} -gt 0 ]; then
                  #echo "INFO: CALLING_FN- find_tag ${all}"
                  find_tag ${file_in_question} "${1}" "${base_name}" 
                  get_current_configuration_file=$(echo "${tfp_configuration_hash[${all}]}")
                  ECHO "INFO: CALLING_FN-  ${all} ${get_current_configuration_file}"
                  clip_cloud=$(echo "${all}" | cut -d "_" -f 3)
                  ECHO "INFO: CALLING- tfp_tag_process_for_${clip_cloud}_clouds ${all} ${get_current_configuration_file}"
                  tfp_tag_process_for_${clip_cloud}_clouds ${all} ${get_current_configuration_file}
            else
                  ECHO "INFO: NOT_A_TERRAFORM_FILE(NOT_A_JSON)"
            fi
      done
}

archieve_tfp_files ()
{
    ECHO "INFO: FUNCTION_NAME archieve_tfp_files"
    cd ${tfp_root} 1>/dev/null  2>/dev/null
    for all_pjs in `echo "${tfp_hash[@]}"`
    do
        #echo "INFO: all_pjs ${all_pjs}"
        tfp_based_ct=$(ls -C1 *_${all_pjs}* 2>/dev/null | wc -l)
        if [ ${tfp_based_ct} -gt 0 ]; then
            ECHO "INFO: CMD tar -zcvf ${global_info_dir}/ppf_tfp_${all_pjs}_${build_id}.gz ./STAR_${all_pjs}"
            tar_rc=$(tar -zcvf ${global_info_dir}/ppf_tfp_${all_pjs}_${build_id}.gz ./*_${all_pjs}* 2>/dev/null)
            files_from_tar_ct=$(tar -ztvf ${global_info_dir}/ppf_tfp_${all_pjs}_${build_id}.gz 2>/dev/null | wc -l)
            if [ ${files_from_tar_ct} -eq ${tfp_based_ct} ]; then
                ECHO "INFO: PACKAGE_DONE_READY_TO_LOAD (${files_from_tar_ct},${tfp_based_ct})"
                tfp_post_processed_zip_files_hash["${all_pjs}"]="ppf_tfp_${all_pjs}_${build_id}.gz"
            fi
        else
            ECHO "INFO: NO_POST_PROCESS_FILES_FOUND"
        fi
    done
    cd - 1>/dev/null 2>/dev/null 
}

PROCESS_TFP_METADATA ()
{
    ECHO "INFO: FUNCTION_NAME PROCESS_TFP_METADATA"
      p1=$(echo "${1}")
      p1=${p1:-NONE}
      if [ "${p1}" == "NONE" ]; then
         create_tfp_dir
      else 
         ECHO "INFO: running_as_function"
      fi
      p2=${2:-Y}
      cd ${tfp_daily_dir} 1>/dev/null 2>/dev/null
      tfp_file_list_collected_ar=()
      #ECHO "INFO: ${daily_date_format_dir}/daily_tfp/*.tfplan"
      ECHO "INFO: ${daily_date_format_dir}/daily_tfp/*.json"
      #tfp_file_list_collected=(`ls -C1 ${daily_date_format_dir}/daily_tfp/*.tfplan`) # | tr '\n' ' ')
      tfp_file_list_collected=(`ls -C1 ${daily_date_format_dir}/daily_tfp/*.json`) # | tr '\n' ' ')
      #echo "INFO: FILES_TO_PROCESS_CT ${#tfp_file_list_collected[@]}"
      for all_tfp_files_found in `echo "${tfp_file_list_collected[@]}"`
      do
         base_name=$(basename ${all_tfp_files_found})
         #echo "INFO: basename ${base_name} and ${all_tfp_files_found}"
         base_name=${base_name:-NONE}
           if [ "${base_name}" != "NONE" ]; then
              #clean_bnm=$(echo "${base_name}" | sed 's/\.tfplan$//' | cut -d "." -f 1)
              clean_bnm=$(echo "${base_name}" | sed 's/\.json$//' | cut -d "." -f 1)
              ECHO "INFO: clean_bnm ${clean_bnm}"
              tfp_hash[${clean_bnm}]="${clean_bnm}"
              tfp_files_hash[${clean_bnm}]="${all_tfp_files_found}"
           fi
       done
       cd -  1>/dev/null 2>/dev/null
       #tfp_files_loop ${p2}
       archieve_tfp_files
       #echo_unique_keys
}
