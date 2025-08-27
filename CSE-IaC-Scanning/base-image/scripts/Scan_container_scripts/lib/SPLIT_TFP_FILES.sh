
final_result_of_tfp_info ()
{
    ECHO "INFO: FUNCTION_NAME final_result_of_tfp_info"
    #echo "INFO_DEBUG: p1=${1}, p2=${2}, p3=${3}, p4=${4} - Start"
    #echo "INFO_DEBUG: p1=${1} tfp_file, p2=${2} tfp_signature, p3=${3} directory, p4=${4} cloud - Start"
    tfp_root_key=$(echo "${2}_${4}")

    processed_keys=$(echo "${tfp_info_hash[${tfp_root_key}]}")
    
             #echo "INFO: processed_keys ${processed_keys}"
#processed_keys S11986_26_gcp|tfp_pv_srp|tfp_pc_rcp
             #ls -ltr ${3}/${tfp_root_key}_tfp_*.json
             for all_keys in `echo "${processed_keys}" | cut -d "|" -f2- | tr '|' '\n'`
             do
               #ECHO "INFO: Calling_function ${all_keys} ${tfp_root_key}"
               #fn_tfp_pv_srp
               fn_${all_keys} ${tfp_root_key} ${1} ${2} ${3} ${4}
               #read SSSSS
             done 
             #for all_data in `echo "${tfp_data_info_hash[@]}"`
             #do
             #  echo "INFO: ${all_data}"
             #done
    #read SSSSS
}

configuration_init ()
{
    ECHO "INFO: FUNCTION_NAME configuration"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    pc_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    #tfp_configuration_hash[${pop_base}]="${pop_base}"
    #get_config_keys=$(cat ${1} | | jq '.configuration' | jq 'keys|join("|")' | sed 's/\"//g')
    #appnm=$(echo "${1}" | awk -F "/" '{ APPNM=NF-1; print $APPNM;}')
    ##echo "INFO: pop_base=${pop_base},APPNM=${appnm}"
    config_filenm=$(echo "${root_dir}/configuration_${pop_base}_${pc_cloud}.json")
    chk_file=$(ls -C1 ${config_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.configuration' > ${config_filenm}
    else
         ECHO "INFO: key-configuration-already-done,${chk_file}"
    fi
    tfp_configuration_hash[${pop_base}]="${config_filenm}"
    #echo "INFO: configuration=${tfp_configuration_hash[${pop_base}]}"
}

planned_values_init ()
{
    ECHO "INFO: FUNCTION_NAME  planned_values"
    ##echo "INFO: trp is ${1}, version ${ver}"
    #pop_base=$(echo "${tfp_hash[${base_name}]}")
    pop_base=$(echo "${2}")
    pv_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    #ECHO "INFO: parameters Passed ${1}, ${2}, pop_base ${pop_base} my_cld ${get_my_cld}"
    #tfp_hash[${pop_base}_${get_my_cld}]="${pop_base}_${get_my_cld}"
    planned_values_filenm=$(echo "${root_dir}/planned_values_${pop_base}_${pv_cloud}.json")
    ciss_planned_values_filenm=$(echo "${tfp_ciss_root}/ciss_tfp_pv_${pop_base}_${pv_cloud}.json")
    chk_file=$(ls -C1 ${planned_values_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.planned_values' > ${planned_values_filenm}
         #cat ${1} | jq '.| { "format_version":.format_version,"terraform_version":.terraform_version,"planned_values":.planned_values,"resource_changes":[],"configuration":{},"checks":{},"timestamp":.timestamp,"errored":.errored}' > ${ciss_planned_values_filenm}
         #cat ${1} | jq '.| { "format_version":.format_version,"terraform_version":.terraform_version,"planned_values":.planned_values,"relevant_attributes":[],"resource_changes":[],"configuration":.configuration,"checks":.checks,"timestamp":.timestamp,"errored":.errored}' > ${ciss_planned_values_filenm}
         cat ${1} | jq '.| { "format_version":.format_version?,"terraform_version":.terraform_version?,"planned_values":.planned_values?,"relevant_attributes":[],"resource_changes":[],"configuration":.configuration?,"checks":.checks?,"timestamp":.timestamp?,"errored":.errored?}' > ${ciss_planned_values_filenm}
    else
         ECHO "INFO: key-planned_values-already-done,${chk_file}"
    fi
    tfp_planned_values_hash[${pop_base}]="${planned_values_filenm}"
    ciss_tfp_pv_hash[${pop_base}]="${ciss_planned_values_filenm}"
    ECHO "INFO: planned_values=${tfp_planned_values_hash[${pop_base}_${get_my_cld}]}"

}


prior_state_init ()
{
    ECHO "INFO: FUNCTION_NAME prior_state"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    ps_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    prior_state_filenm=$(echo "${root_dir}/prior_state_${pop_base}_${ps_cloud}.json")
    chk_file=$(ls -C1 ${prior_state_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.prior_state' > ${prior_state_filenm}
    else
         ECHO "INFO: key-prior_state-already-done,${chk_file}"
    fi
    tfp_prior_state_hash[${pop_base}]="${prior_state_filenm}"
    ECHO "INFO: prior_state=${tfp_prior_state_hash[${pop_base}]}"

}


relevant_attributes_init ()
{
    ECHO "INFO: FUNCTION_NAME relevant_attributes"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    ra_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    relevant_attributes_filenm=$(echo "${root_dir}/relevant_attributes_${pop_base}_${ra_cloud}.json")
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

resource_changes_init ()
{
    ECHO "INFO: FUNCTION_NAME resource_changes"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    rc_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    resource_changes_filenm=$(echo "${root_dir}/resource_changes_${pop_base}_${rc_cloud}.json")
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


resource_drift_init ()
{
    ECHO "INFO: FUNCTION_NAME resource_drift"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    rd_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    resource_drift_filenm=$(echo "${root_dir}/resource_drift_${pop_base}_${rd_cloud}.json")
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

applyable_init ()
{
    ECHO "INFO: FUNCTION_NAME applayable"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    tv_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    get_applyable=(`cat ${1} | jq '.applyable'`)
    tfp_applyable_hash[${pop_base}]="${get_applyable}"
    #echo "INFO: SIGNATURE=${pop_base} applayable=${tfp_applyable_hash[${pop_base}]}"
}
terraform_version_init ()
{
    ECHO "INFO: FUNCTION_NAME terraform_version"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    tv_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    get_terraform_version=(`cat ${1} | jq '.terraform_version'`)
    tfp_terraform_version_hash[${pop_base}]="${get_terraform_version}"
    #echo "INFO: SIGNATURE=${pop_base} terraform_version=${tfp_terraform_version_hash[${pop_base}]}"
}

checks_init ()
{
    ECHO "INFO: FUNCTION_NAME checks"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    ck_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    checks_filenm=$(echo "${root_dir}/checks_${pop_base}_${ck_cloud}.json")
    chk_file=$(ls -C1 ${checks_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.checks' > ${checks_filenm}
    else
         ECHO "INFO: key-checks-already-done,${chk_file}"
    fi
    tfp_checks_hash[${pop_base}]="${checks_filenm}"
    ECHO "INFO: checks=${tfp_checks_hash[${pop_base}]}"
    break_step
}


format_version_init ()
{
    ECHO "INFO: FUNCTION_NAME format_version"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    fv_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    fv=$(cat ${1} | jq '.format_version')
    tfp_format_version_hash[${pop_base}]="${fv}"
    #echo "INFO: SIGNATURE=${pop_base} tfp_format_version=${tfp_format_version_hash[${pop_base}]}"

}

errored_init ()
{
    ECHO "INFO: FUNCTION_NAME errored"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    er_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    fv=$(cat ${1} | jq '.errored')
    tfp_errored_hash[${pop_base}]="${fv}"
    ECHO "INFO: errored=${tfp_errored_hash[${pop_base}]}"

}

timestamp_init ()
{
    ECHO "INFO: FUNCTION_NAME timestamp"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    ts_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    fv=$(cat ${1} | jq '.timestamp')
    tfp_timestamp_hash[${pop_base}]="${fv}"
    ECHO "INFO: timestamp=${tfp_timestamp_hash[${pop_base}]}"

}


variables_init ()
{
    ECHO "INFO: FUNCTION_NAME  variables"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    vs_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    variables_filenm=$(echo "${root_dir}/variables_${pop_base}_${vs_cloud}.json")
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



split_tfp_files_into_keys ()
{
      ECHO "INFO: TYPE INDIRECT FN-NAME split_tfp_files_into_keys"
   
      M3ID=$(date '+%s')
      echo "INFO: TIME ${M3ID}-TFP_STAGE_03-TFP_SPLIT-SCAN-RPT-START"
      for all in `echo "${tf_plan_file_unique_hash[@]}"`
      do
         ECHO "INFO: key-${all}"
         get_file=(`echo "${tf_plan_file_key_name_hash[${all}]}"`)
         get_dir=(`echo "${SCAN_DIR}/${tf_plan_file_key_dir_hash[${all}]}"`)
         ECHO "INFO: base-${tf_plan_file_key_just_file_hash[${all}]}"
         ECHO "INFO: uniquekey-${tf_plan_file_report_hash[${all}]}"
         ECHO "INFO: report_key-${tf_plan_file_rpt_hash[${all}]}"
         base_id_clip=(`echo "${tf_plan_file_key_just_file_hash[${all}]}" | sed 's/tfut//'`)
         base_id=(`echo "${all}_${base_id_clip}"`)
         kics_tfplan_signature_hash[${base_id}]=${base_id_clip}
         chk_cloud ${get_file} ${all}
         get_my_cld=$(echo "${tfp_terraform_cloud_hash[${all}]}")
         cat ${get_file} | jq '.' > ${tfp_daily_dir}/${all}_${get_my_cld}.json
         tfp_file_to_process=$(echo "${tfp_daily_dir}/${all}_${get_my_cld}.json")
         tf_plan_check_sum_files_list_hash[${all}]="${tfp_file_to_process}"
      done
      get_my_cld=$(echo "NONE")
      for all_files_from_tf_plan_check_sum_files_list_hash in `echo "${!tf_plan_check_sum_files_list_hash[@]}"`
      do
          get_file=$(echo "${tf_plan_check_sum_files_list_hash[$all_files_from_tf_plan_check_sum_files_list_hash]}")
          get_my_cld=$(echo "${tfp_terraform_cloud_hash[${all_files_from_tf_plan_check_sum_files_list_hash}]}")
          get_dir=(`echo "${SCAN_DIR}/${tf_plan_file_key_dir_hash[${all_files_from_tf_plan_check_sum_files_list_hash}]}"`)
          if [ "${output_dir}" != "NONE" ]; then
             report_dir=(`echo "/tmp/results/kics/${build_id_run}/${case_type}/${tf_plan_file_rpt_hash[${all_files_from_tf_plan_check_sum_files_list_hash}]}"`)
          else
             report_dir=(`echo "${get_dir}/results/kics/${build_id_run}/${case_type}/${tf_plan_file_rpt_hash[${all_files_from_tf_plan_check_sum_files_list_hash}]}"`)
          fi 
          M3ID=$(date '+%s')
          echo "INFO: TIME ${M3ID}-TFP_STAGE_03.1-TFP_SPLIT- ${get_file},check_sum ${all_files_from_tf_plan_check_sum_files_list_hash} -Start"
          ECHO "INFO: report_dir ${report_dir}"
          #kics_report_dir_hash[${report_dir}]=${report_dir}
          #echo "INFO_DEBUG: KEYS-${all_files_from_tf_plan_check_sum_files_list_hash} FILE- ${get_file} CLOUD=${get_my_cld} DIR=${get_dir} report_dir=${report_dir}"
          #------- keys_loop ---------
          #  tfp_root_keys_ar=$(cat ${get_file} | jq 'keys|join("|")'  2>/dev/null | sed 's/\"//g' | tr '|' ' ')
          #  any_keys=$(echo "${#tfp_root_keys_ar[@]}")
          #  if [ ${any_keys} -gt 0 ]; then
          #        #echo "INFO: CALLING_FN- find_tag ${all}"
          #        for all_root_key in `echo "${tfp_root_keys_ar[@]}"`
          #        do   
          #           ${all_root_key}_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld}
          #        done
          #        get_current_configuration_file=$(echo "${tfp_configuration_hash[${all_files_from_tf_plan_check_sum_files_list_hash}]}")
          #        echo "INFO: CALLING_FN-  ${all_files_from_tf_plan_check_sum_files_list_hash} ${get_current_configuration_file}"
          #        echo "INFO: CALLING- tfp_tag_process_for_${get_my_cld}_clouds ${all} ${get_current_configuration_file}"
          #        tfp_tag_process_for_${get_my_cld}_clouds ${all_files_from_tf_plan_check_sum_files_list_hash} ${get_current_configuration_file}
          #        #tfp_tag_process_for_${clip_cloud}_clouds
          #  else
          #        echo "INFO: NOT_A_TERRAFORM_FILE(NOT_A_JSON)"
          #  fi
          #------- keys_loop ---------
          #ECHO "INFO_DEBUG: KEYS-${all_files_from_tf_plan_check_sum_files_list_hash} FILE- ${get_file} CLOUD=${get_my_cld}"
          terraform_version_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld}
          format_version_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld}
          applyable_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld}
          planned_values_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          configuration_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          prior_state_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          relevant_attributes_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          resource_drift_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          resource_changes_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          checks_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          errored_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          timestamp_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          variables_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          process_${get_my_cld}_cloud_tfp_file ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld}
          #get_current_configuration_file=$(echo "${tfp_configuration_hash[${all_files_from_tf_plan_check_sum_files_list_hash}]}")
          #tfp_tag_process_for_${get_my_cld}_clouds ${all_files_from_tf_plan_check_sum_files_list_hash} ${get_file} ${get_current_configuration_file}
          final_result_of_tfp_info ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld}
          mkdir -p ${report_dir}
          planned_values_filenm=$(echo "${ciss_tfp_pv_hash[${all_files_from_tf_plan_check_sum_files_list_hash}]}")
          planned_values_filenm=${planned_values_filenm:-NONE}
          scan_file=$(echo "${planned_values_filenm}")
          tfp_ciss_checksum=$(cat ${scan_file} | jq . | sum | awk '{print $1,$2}' | tr ' ' '_'| awk '{ print "S"$1}')
          if [ "${pv_process}" == "N" ]; then
              scan_file=$(echo "${get_file}")
              tfp_ciss_checksum=$(echo "${all_files_from_tf_plan_check_sum_files_list_hash}")
          fi
          let kics_rc=1
          unique_build_id=$(echo "${build_id}" | sed "s/R-/R-${all_files_from_tf_plan_check_sum_files_list_hash}_${get_my_cld}-/")
          kics_report_dir_hash[${report_dir}]="${report_dir}|${unique_build_id}"
          #echo "INFO: build_id ${build_id} unique_build_id ${unique_build_id}"
          M3ID=$(date '+%s')
          echo "INFO: TIME ${M3ID}-TFP_STAGE_03.1-TFP_SPLIT- ${get_file},check_sum ${all_files_from_tf_plan_check_sum_files_list_hash} -End"
          M4ID=$(date '+%s')
          echo "INFO: TIME ${M4ID}-TFP_STAGE_03.2-SCAN-${scan_file},check_sum ${all_files_from_tf_plan_check_sum_files_list_hash} -Start"
          if [ "${planned_values_filenm}" != "NONE" ]; then
                   ECHO "INFO: calling_fn CISS_SCAN ${scan_file} ${report_dir} ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} ${tfp_ciss_checksum}"
                   CISS_SCAN ${scan_file} ${report_dir} ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} ${unique_build_id} ${tfp_ciss_checksum}               
          else
               ECHO "INFO: File: ${get_file} has no planned_values ${planned_values_filenm}."
               ECHO "INFO: calling_fn CISS_SCAN ${get_file} ${report_dir} ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} ${unique_build_id} ${tfp_ciss_checksum}"
               CISS_SCAN ${get_file} ${report_dir} ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} ${unique_build_id} ${tfp_ciss_checksum}               
          fi
          M4ID=$(date '+%s')
          echo "INFO: TIME ${M4ID}-TFP_STAGE_03.2-SCAN-${scan_file},check_sum ${all_files_from_tf_plan_check_sum_files_list_hash} -End"
          #read SSSSS
      done
      SCAN_RPT ${global_info_dir} ${build_id}
      M3ID=$(date '+%s')
      echo "INFO: TIME ${M3ID}-TFP_STAGE_03-TFP_SPLIT-SCAN-RPT-End"
      #for all_rc in `echo "${processed_tf_plan_files[@]}"`
      #do
      #      echo "INFO: CISS_SCAN_RESULT_BY_KICS-${all_rc}"
      #done
      #echo "INFO_DEBUG: -DONE"
      #exit 0
      #read SSSSS
}
