


tfplan_output_file_and_resources ()
{
      ECHO "INFO: TYPE DIRECT  FN-NAME tfplan_output_file_and_resources"
      for validated_plan in `echo "${!tf_plan_files_resources[@]}"`
      do
           get_file=(`echo "${tf_plan_files_to_process[${validated_plan}]}"`)
           chk_sum=(`echo "${tf_plan_files_check_sum[${validated_plan}]}"`)
           ECHO "INFO: Plan dir: /scan/${validated_plan}, tfplan: ${get_file}, chk_sum: ${chk_sum}"
           ECHO "INFO: Resources: ${tf_plan_files_resources[${validated_plan}]}"
      done

      for all in `echo "${!tf_plan_dir_to_process[@]}"`
      do
          get_file=(`echo "${tf_plan_files_to_process[${all}]}"`)
          get_dir=(`echo "${tf_plan_dir_to_process[${all}]}"`)
          get_file=${get_file:-NONE}
          if [ ${get_file} != "NONE" ]; then
                ECHO "INFO: sarif output result -Start"
                ECHO "INFO: sarif output result -End"
          fi
      done
}


all_validated_tf_json_files ()
{
      ECHO "INFO: TYPE OPT-DIRECT FN-NAME all_validated_tf_json_files"

      total_project_based_tfut_files_ct=(`echo "${#tf_plan_file_unique_hash[@]}"`)
      ECHO "INFO: Total Projects based files Count - ${total_project_based_tfut_files_ct}"
      for all in `echo "${tf_plan_file_unique_hash[@]}"`
      do
         ECHO "INFO: key-${all}"
         ECHO "INFO: file_location- ${tf_plan_file_key_name_hash[${all}]}"
         ECHO "INFO: dir-${tf_plan_file_key_dir_hash[${all}]}"
         ECHO "INFO: base-${tf_plan_file_key_just_file_hash[${all}]}"
         ECHO "INFO: uniquekey-${tf_plan_file_report_hash[${all}]}"
         ECHO "INFO: report_key-${tf_plan_file_rpt_hash[${all}]}"
         pjnm=(`echo "${tf_plan_file_key_dir_hash[${all}]}" | sed 's/tfut//'`)
         report_info_hash[${tf_plan_file_report_hash[${all}]}]=`echo "${app_nm},${pipeline_nm},TTTTT,${build_id_run},${ID},${build_id},${all}_TTTTT,${all},${tf_plan_file_key_just_file_hash[${all}]},${tf_plan_file_key_name_hash[${all}]},${tf_plan_file_report_hash[${all}]},${tf_plan_file_rpt_hash[${all}]},SSSSS"`
         cr_report_info_hash[${tf_plan_file_report_hash[${all}]}]=`echo "${app_nm},${pipeline_nm},TTTTT,${pjnm}"`
      done
}


validate_tf_files ()
{
      ECHO "INFO: TYPE INDIRECT FN-NAME validate_tf_files $@"
      #prepare_unique_key_for_plan "$@" 

}

prepare_unique_key_for_plan ()
{
      ECHO "INFO: TYPE INDIRECT FN-NAME prepare_unique_key_for_plan"

      #normalise the file. single line, multiline, content resources etc
      tf_plan_unique_hash=(`cat ${1} | jq . | sum | awk '{print $1,$2}' | tr ' ' '_'| awk '{ print "S"$1}'`)
      get_key=(`echo "${tf_plan_file_unique_hash[${tf_plan_unique_hash}]}"`)
      get_key=${get_key:-NONE}
      if [ "${get_key}" == "NONE" ]; then
         ECHO "INFO: NEW_TF  terraform plan file ready to scan"
         tf_plan_file_unique_hash[${tf_plan_unique_hash}]=${tf_plan_unique_hash}
         tf_plan_file_key_name_hash[${tf_plan_unique_hash}]=${1}
         tf_plan_file_key_dir_hash[${tf_plan_unique_hash}]=${2}
         base_nm=`echo "${1}" | cut -d "/" -f 4 | sed 's/\.json//g'`
         tf_plan_file_key_just_file_hash[${tf_plan_unique_hash}]=${base_nm}
         tf_plan_file_report_hash[${tf_plan_unique_hash}]=`echo "A:${3}|P:${4}|D:${2}|K:${tf_plan_unique_hash}|B:${base_nm}"`
         tf_plan_file_rpt_hash[${tf_plan_unique_hash}]=`echo "A${3}_P${4}_D${2}_K${tf_plan_unique_hash}_B${base_nm}"`
      else
           ECHO "INFO: DUPLICATE_TF terraform plan file or ALREADY_SCANNED"
      fi
}



find_all_json_files()
{
      ECHO "INFO: TYPE DIRECT FN-NAME find_all_json_files"
      dir_to_match_tool_types=(`ls -C ${SCAN_DIR}/ | grep tfut`)
      for all in `echo "${dir_to_match_tool_types[@]}"`
      do
         remove_other_dir_or_files=(`echo "${all}" | grep tfut`)
         remove_other_dir_or_files=${remove_other_dir_or_files:-NONE}
         if [ "${remove_other_dir_or_files}" != "NONE" ]; then
             file_plan_json=(`ls -C ${SCAN_DIR}/${all}/*.json`)
             for all_multiple_files in `echo "${file_plan_json[@]}"`
             do
                   ECHO "INFO: JSON_FILE_NM=${all_multiple_files}"
                   tfversion=(`cat ${all_multiple_files} | jq .terraform_version 2>/dev/null | sed 's/null//g'`)
                   tfversion=${tfversion:-NONE}
                   if [ "${tfversion}" != "NONE" ]; then
                      #ECHO "INFO: tfversion= ${tfversion} dir ${all} file ${all_multiple_files}"
                      prepare_unique_key_for_plan ${all_multiple_files} ${all} ${app_nm} ${pipeline_nm}
                   else
                        if [ "${file_type}" == "TF" ]; then
                            echo "INFO: FILE_TYPE ${file_type}"
                            #Validate and load to avoid core dump.
                            validate_tf_files ${all_multiple_files} ${all} ${app_nm} ${pipeline_nm}
                        else
                           echo "INFO: file ${all_multiple_files} is not terraform plan output. or ill-formatted json. ignoring"
                        fi
                   fi
             done
         fi
      done
      all_validated_tf_json_files
      if [ ${total_project_based_tfut_files_ct} -lt 1 ]; then
            echo "INFO: No validated terraform plan output files are valid. Nothing to Scan. Exiting with Error Code = 127"
            exit 127
      else
            echo "INFO: Total_files-${total_project_based_tfut_files_ct}"
      fi
}

