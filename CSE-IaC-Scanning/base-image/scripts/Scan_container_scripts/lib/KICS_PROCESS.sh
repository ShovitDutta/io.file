


sim_iac_kics_tools()
{
      ECHO "INFO: TYPE INDIRECT FN-NAME sim_iac_kics_tools"
      for all in `echo "${tf_plan_file_unique_hash[@]}"`
      do
         ECHO "INFO: key-${all}"
         get_file=(`echo "${tf_plan_file_key_name_hash[${all}]}"`)
         get_dir=(`echo "${SCAN_DIR}/${tf_plan_file_key_dir_hash[${all}]}"`)
         ECHO "INFO: base-${tf_plan_file_key_just_file_hash[${all}]}"
         ECHO "INFO: uniquekey-${tf_plan_file_report_hash[${all}]}"
         ECHO "INFO: report_key-${tf_plan_file_rpt_hash[${all}]}"

         report_dir=$(echo "/tmp/reports")
         #report_dir=(`echo "${get_dir}/results/kics/${tf_plan_file_rpt_hash[${all}]}"`)
         ECHO "INFO: report_dir ${report_dir}"
         ECHO "INFO: Running kics command file ${get_file}"
                mkdir -p ${report_dir}

                if [ "${custom_lib}" == "Y" ]; then
                    ECHO "INFO: CMD kics scan -p ${get_file} --secrets-regexes-path ${SP_CN_PATH}  -o ${report_dir} --report-formats \"json,sarif,html,pdf,csv\" --output-name \"${build_id}\""
                    kics scan -p ${get_file} --secrets-regexes-path ${SP_CN_PATH}  -o ${report_dir} --report-formats "json,sarif,html,pdf,csv" --output-name "${build_id}" 1>>/tmp/reports/${build_id}.std_01 2>>/tmp/reports/${build_id}.std_02
                else
                    ECHO "INFO: CMD kics scan -p ${get_file} -q /apps/custom/common/assets,/apps/kics/assets --secrets-regexes-path ${SP_CN_PATH}   -o ${report_dir} --report-formats \"json,sarif,html,pdf,csv\" --output-name \"${build_id}\""
                    kics scan -p ${get_file} --secrets-regexes-path ${SP_CN_PATH}    -o ${report_dir} --report-formats "json,sarif,html,pdf,csv" --output-name "${build_id}" 1>>/tmp/reports/${build_id}.std_01 2>>/tmp/reports/${build_id}.std_02
                fi
                kics_rc=(`echo "$?"`)
                let kics_all_rc=${kics_all_rc}+${kics_rc}
                ECHO "INFO: kics run result ${kics_rc}"
                #ECHO "INFO: CMD kics scan -p ${get_file}  -o ${report_dir} --report-formats \"json,sarif,html,pdf,csv\" --output-name \"${build_id}\""
                ECHO "INFO: sarif output result -Start"
                ECHO "INFO: cat ${report_dir}/${build_id}.sarif"
                ECHO "INFO: sarif output result -End"
                #STD_OUT_CAPTURE_START
                #echo "DEBUG: scan_verbose_level=${scan_verbose_level}"
                if [ "${scan_verbose_level}" != "error" ]; then
                   ECHO "INFO: STD_OUT_01_FOR_FILE ${get_file}"
                   cat /tmp/reports/${build_id}.std_01
                   ECHO "INFO: STD_OUT_02_FOR_FILE ${get_file}"
                   cat /tmp/reports/${build_id}.std_02 | tr '%' '\n' | grep -v "Executing queries"
                fi
                ECHO "INFO: DELETING_STD_OUT"
                rm -rf /tmp/reports/${build_id}.std_01 /tmp/reports/${build_id}.std_02
                #STD_OUT_CAPTURE_END

      done
}


dummy ()
{
/apps/kics/bin/kics scan -p /workspace/scan/tfuts3/secrets_passwd_fix.json --disable-full-descriptions -q /apps/kics/assets -q /apps/custom/kics/assets -q /apps/custom/common/assets --disable-secrets --secrets-regexes-path /apps/custom/common/assets/queries/terraform/azure/passwords_and_secrets/regex_rules.json --secrets-regexes-path /apps/custom/common/assets/queries/terraform/aws/passwords_and_secrets/regex_rules.json --secrets-regexes-path /apps/custom/common/assets/queries/terraform/gcp/passwords_and_secrets/regex_rules.json  -o /workspace/scan/tfuts3/results/kics/ACSE_PPASSWD_SECRET_Dtfuts3_KS52645_4686_Btfuts3 --report-formats "json,sarif,html,pdf,csv" --output-name "R-20240502-21_20_31-1714684831-182024-123-1714684831-CSE-PASSWD_SECRET"

}

run_iac_kics_tools()
{
      ECHO "INFO: TYPE INDIRECT FN-NAME run_iac_kics_tools"
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
         if [ "${output_dir}" != "NONE" ]; then
             report_dir=(`echo "/tmp/results/kics/${tf_plan_file_rpt_hash[${all}]}"`)
         else
             report_dir=(`echo "${get_dir}/results/kics/${tf_plan_file_rpt_hash[${all}]}"`)
         fi
         ECHO "INFO: report_dir ${report_dir}"
         kics_report_dir_hash[${report_dir}]=${report_dir}
         ECHO "INFO: Running kics command file ${get_file}"
         ECHO "INFO: Calling pv${get_file} ${all}"
         chk_cloud ${get_file} ${all}
         get_my_cld=$(echo "${tfp_terraform_cloud_hash[${all}]}")
         cat ${get_file} | jq '.' > ${tfp_daily_dir}/${all}_${get_my_cld}.json
         tfp_file_to_process=$(echo "${tfp_daily_dir}/${all}_${get_my_cld}.json")
         if [ ${pv_process} == "Y" ]; then
            planned_values_init ${tfp_file_to_process} ${all} ${tfp_root} ${get_my_cld}                          # ${get_file} ${all} ${tfp_root} ${get_my_cld}
            get_pv_file=$(echo "${tfp_planned_values_hash[${all}_${get_my_cld}]}")
         fi
               mkdir -p ${report_dir}
                 if [ ${pv_process} == "N" ]; then   
                    #get_file_replaced.
                    ECHO "INFO: CMD kics scan -p ${tfp_file_to_process} --disable-full-descriptions --secrets-regexes-path ${SP_CN_PATH} --log-level ${llv} -o ${report_dir} --report-formats \"json,sarif,html,pdf,csv\" --output-name \"${build_id}\" 1>>/tmp/${build_id}.std_01 2>>/tmp/${build_id}.std_02"
                    kics scan -p ${tfp_file_to_process} --disable-full-descriptions --secrets-regexes-path ${SP_CN_PATH} --log-level ${llv} -o ${report_dir} --report-formats "json,sarif,html,pdf,csv" --output-name "${build_id}" 1>>/tmp/${build_id}.std_01 2>>/tmp/${build_id}.std_02
                    #kics scan -p ${get_file} --disable-full-descriptions --secrets-regexes-path ${SP_CN_PATH} --log-level ${llv} -o ${report_dir} --report-formats "json,sarif,html,pdf,csv" --output-name "${build_id}" 1>>/tmp/${build_id}.std_01 2>>/tmp/${build_id}.std_02
                 else
                    ECHO "INFO: CMD kics scan -p ${get_pv_file} --disable-full-descriptions --secrets-regexes-path ${SP_CN_PATH} --log-level ${llv} -o ${report_dir} --report-formats \"json,sarif,html,pdf,csv\" --output-name \"${build_id}\" 1>>/tmp/${build_id}.std_01 2>>/tmp/${build_id}.std_02"
                    kics scan -p ${get_pv_file} --disable-full-descriptions --secrets-regexes-path ${SP_CN_PATH} --log-level ${llv} -o ${report_dir} --report-formats "json,sarif,html,pdf,csv" --output-name "${build_id}" 1>>/tmp/${build_id}.std_01 2>>/tmp/${build_id}.std_02
                 fi

                kics_rc=(`echo "$?"`)
                ECHO "INFO: kics run result ${kics_rc}"
                #STD_OUT_CAPTURE_START
                #echo "DEBUG: scan_verbose_level=${scan_verbose_level}"
                if [ "${scan_verbose_level}" != "error" ]; then
                   ECHO "INFO: STD_OUT_01_FOR_FILE ${tfp_file_to_process}"
                   cat /tmp/${build_id}.std_01
                   ECHO "INFO: STD_OUT_02_FOR_FILE ${tfp_file_to_process}"
                   cat /tmp/${build_id}.std_02 | tr '%' '\n' | grep -v "Executing queries"
                fi
                ECHO "INFO: DELETING_STD_OUT"
                rm -rf /tmp/${build_id}.std_01 /tmp/${build_id}.std_02
                #STD_OUT_CAPTURE_END

                if [ ${pv_process} == "Y" ]; then
                   processed_tf_plan_files[${all}]="${get_pv_file}"
                else
                   processed_tf_plan_files[${all}]="${tfp_file_to_process}"
                   #processed_tf_plan_files[${all}]="${tget_file}"
                fi

                get_sarif_file_generated=$(ls -C1 ${report_dir}/${build_id}.sarif 2>/dev/null)
                get_sarif_file_generated=${get_sarif_file_generated:-NONE}
                if [ "${get_sarif_file_generated}" != "NONE" ]; then
                    ECHO "INFO: sarif_output_found"
                else
                    ECHO "INFO: tfplan_file_issue.debug with kics vendor"
                    error_key=$(echo "err_kics_${all}")
                    err_file_name=$(echo "/tmp/${error_key}.tfplan")
                    echo "ERR:TF" >${err_file_name}
                    processed_tf_plan_files[${error_key}]="${err_file_name}"
                    ECHO "INFO: tfplan_file_issue.debug with kics vendor flag_file: ${err_file_name}"
                fi
                
                final_report_row=(`echo "${report_info_hash[${tf_plan_file_report_hash[${all}]}]}"`)
                cr_final_report_row=(`echo "${cr_report_info_hash[${tf_plan_file_report_hash[${all}]}]}"`)
                all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]=`echo "${final_report_row}" | sed 's/TTTTT/kics/g'`
                cr_all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]=`echo "${cr_final_report_row}" | sed 's/TTTTT/kics/g'`
                if [ "${kics_rc}" -gt 0 ]; then
                   all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]=`echo "${all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]}" | sed 's/SSSSS/FAIL/'`
                else
                   all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]=`echo "${all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]}" | sed 's/SSSSS/PASS/'`
                fi 
                target_json_bucket_file=(`echo "${global_info_dir}/${base_id}.kics_json.${build_id}.bucket"`)
                target_sarif_bucket_file=(`echo "${global_info_dir}/${base_id}.kics_sarif.${build_id}.bucket"`)

                ECHO "INFO: BACKUP_COPY_JSON_FILE ${target_json_bucket_file}"
                ECHO "INFO: BACKUP_COPY_SARIF_FILE ${target_sarif_bucket_file}"
                cp ${report_dir}/${build_id}.sarif ${target_sarif_bucket_file}
                cp ${report_dir}/${build_id}.json ${target_json_bucket_file}
                unique_json_rpt_result_key=(`echo "kics_json_${base_id}"`)
                unique_sarif_rpt_result_key=(`echo "kics_sarif${base_id}"`)
                tfplan_signature_hash[${unique_json_rpt_result_key}]="${target_json_bucket_file}"
                tfplan_signature_hash[${unique_sarif_rpt_result_key}]="${target_sarif_bucket_file}"

                if [ "${scan_verbose_level}" != "error" ]; then
                   ECHO "INFO: sarif output result -Start"
                   cat ${report_dir}/${build_id}.sarif
                fi
                all_rules_applied=(`cat ${report_dir}/${build_id}.json | jq .queries[].query_id | tr ' ' '\n'`)
                all_violations_found=(`cat ${report_dir}/${build_id}.json | jq .queries[].query_name | tr ' ' '_' | tr ' ' '\n'`)
                all_rules_text_found=(`cat ${report_dir}/${build_id}.json | jq .queries[].description | tr ' ' '_' | tr ' ' '\n'`)
                all_rules_properties_tag=(`cat ${report_dir}/${build_id}.json | jq .queries[].category | tr ' ' '_' |  tr ' ' '\n'`)
                all_severity_found=(`cat ${report_dir}/${build_id}.json | jq .queries[].severity | tr ' ' '\n'`)
                 kics_severity_high_ct=(`echo "${all_severity_found[@]}" | tr ' ' '\n' | grep -i High | wc -l`)
                 kics_severity_medium_ct=(`echo "${all_severity_found[@]}" | tr ' ' '\n' | grep -i Medium | wc -l`)


                 let kics_hi_ct=${sm_report_info_hash[kics_severity_high]}+kics_severity_high_ct
                 let kics_mi_ct=${sm_report_info_hash[kics_severity_medium]}+kics_severity_medium_ct
                 sm_report_info_hash[kics_severity_high]=${kics_hi_ct}
                 sm_report_info_hash[kics_severity_medium]=${kics_mi_ct}
                custom_rules_applied=(`echo "${all_rules_applied[@]}" | tr ' ' '\n' |  grep "CSE-"`)
                rule_ct=(`echo "${#all_rules_applied[@]}"`)
                let kics_rule_total_ct=${sm_report_info_hash[kics_rules]}+${rule_ct}
                sm_report_info_hash[kics_rules]=${kics_rule_total_ct}
                custom_rule_ct=(`echo "${#custom_rules_applied[@]}"`)
                let standard_rules=${rule_ct}-${custom_rule_ct}
                join_all_rules=(`echo "${all_rules_applied[@]}" | tr ' ' '.'`)
                join_custom_rules=(`echo "${custom_rules_applied[@]}" | tr ' ' '.'`)
                join_all_violations_found=(`echo "${all_violations_found[@]}" | tr ' ' '.'`)
                join_all_severity_found=(`echo "${all_severity_found[@]}" | tr ' ' '.'`)
                join_all_rules_properties_tag1=(`echo "${all_rules_properties_tag[@]}" | sed 's/\[ //g' | sed 's/ \]//g' | sed 's/, /,/g' | tr ' ' '.'`)
                if [ "${rule_ct}" -gt 0 ]; then 
                   echo "INFO: NON_COMPLIANT_RULES_FOUND ${tfp_file_to_process} ${all} ${rule_ct}"
                   #echo "INFO: NON_COMPLIANT_RULES_FOUND ${get_file} ${all} ${rule_ct}"
                   for all_rules in `echo "${join_all_rules}" | tr '.' '\n' | sed 's/\"//g'`
                   do
                       all_rules_tr=(`echo "${all_rules}" | tr '-' '_'`)
                       rulesid_kics_hash[${all_rules_tr}]=${all_rules} 
                       rulesid_hash[${all_rules_tr}]=${all_rules}
                   done
                   col1_key=(`echo "${all}_kics_col1"`)
                   col2_key=(`echo "${all}_kics_col2"`)
                   col3_key=(`echo "${all}_kics_col3"`)
                   col4_key=(`echo "${all}_kics_col4"`)
                   rr_report_info_hash[${col1_key}]=${join_all_rules}
                   rr_report_info_hash[${col2_key}]=${join_all_violations_found}
                   rr_report_info_hash[${col3_key}]=${join_all_rules_properties_tag1}
                   rr_report_info_hash[${col4_key}]=${join_all_severity_found}
                   rr_report_info_keys_hash[${all}]=${all}
                   ECHO "INFO: kics_processing- ${tfp_file_to_process} ${all} ${build_id} ${report_dir} ${global_info_dir}"
                   cloud_tfp_obj_key_process "${tfp_file_to_process}" "${all}"
                   post_process_obj_key_process "${report_dir}"  "${build_id}" "${all}" "${global_info_dir}"
                   process_kics_output_files  "${report_dir}"  "${build_id}" "${all}"
                else
                    #echo "INFO: NO_NON_COMPLAINT_RULES_FOUND. ${get_file} ${all} 0"
                    echo "INFO: NO_NON_COMPLAINT_RULES_FOUND. ${tfp_file_to_process} 0"
                fi


                if [ "${custom_rule_ct}" -gt 0 ]; then
                    all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]=`echo "${all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]},${join_all_rules},${join_custom_rules},${join_all_violations_found},${rule_ct}"`
                    cr_all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]=`echo "${cr_all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]},${standard_rules},${custom_rule_ct}"`
                else
                    if [ "${rule_ct}" -gt 0 ]; then
                        all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]=`echo "${all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]},${join_all_rules},NO_CUSTOM_RULES_APPLIED,${join_all_violations_found},${rule_ct}"`
                        cr_all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]=`echo "${cr_all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]},${standard_rules},0"`
                    else
                        all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]=`echo "${all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]},NO_RULES_APPLIED,NO_CUSTOM_RULES_APPLIED,NONE,0"`
                        cr_all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]=`echo "${cr_all_scan_report_info_hash[${tf_plan_file_report_hash[${all}]}]},0,0"`
                    fi
                fi
                ECHO "INFO: sarif output result -End"
      done
      SCAN_RPT ${global_info_dir} ${build_id}
      PROCESS_TFP_METADATA ${daily_date_format_dir} Y
}

