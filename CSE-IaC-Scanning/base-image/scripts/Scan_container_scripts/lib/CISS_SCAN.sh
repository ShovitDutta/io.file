    declare -A property_sig_rel_hash
    sarif_processed_ar=()
    success_tfp_rec_prefix=$(echo '"0.1.1.1"|"0000-0000-0000-0000-0000"|"S29715_1"|"no_rules_found"|"Ciss_Scan_Result"|"INFO"')
    success_tfp_rec_colm=$(echo '"CISS"|"CISS"|"CISS"|"CISS"|"CISS"|"CISS"|"CISS"|"CISS"|"CISS"')
    successful_scan_rec_for_this_tfp=$(echo "CISS")
    sarif_keys=$(echo "actual_value,category,cloud_provider,description,description_id,expected_value,issue_type,platform,query_id,query_name,remediation,remediation_type,resource_name,resource_type,search_key,search_value,severity,similatiry_id,terraform_plan_file_name,tsm,cvsid,additionalfd,tfpid")

PROCESS_JSON_FILE ()
{
    ECHO "INFO: TYPE INDIRECT FN-NAME PROCESS_JSON_FILE"
    #/workspace/scan/R-20241002-13_53_48-1727877228-402024-276-1727877228-CSE-Q3-CONTAINER/pre_summary_S50655_817_azure_R-S50655_817_azure-20241002-13_53_48-1727877228-402024-276-1727877228-CSE-Q3-CONTAINER.pipe
    pre_sum_file=$(echo "${2}" | sed 's/^R//')
    file_to_write=$(echo "pre_sum-${pre_sum_file}_${5}.pipe")
    scan_file_to_write=$(echo "flatten_scan_result_file-${pre_sum_file}_${5}.pipe")
    cat ${1} | jq  ' def n: if . == "" then "NO_VALUE" else . end; def nk: if . == null then "KEY_NOT_DEFINED" else . end;[.queries[]|{"query_id":(.query_id|nk|n),"query_name":(.query_name|nk|n),"severity":(.severity|nk|n),"platform":(.platform|nk|n),"cloud_provider":(.cloud_provider|nk|n),"category":(.category|nk|n),"description":(.description|nk|n),"description_id":(.description_id|nk|n),"terraform_plan_file_name":(.files[0].file_name|nk|n),"similatiry_id":(.files[0].similarity_id|nk|n),"resource_type":(.files[0].resource_type|nk|n),"resource_name":(.files[0].resource_name|nk|n),"issue_type":(.files[0].issue_type|nk|n),"search_key":(.files[0].search_key|nk|n),"search_value":(.files[0].search_value|nk|n),"expected_value":(.files[0].expected_value|nk|n),"actual_value":(.files[0].actual_value|nk|n),"remediation":(.files[0].remediation|nk|n),"remediation_type":(.files[0].remediation_type|nk|n)}]|sort|unique'  | jq  '.' > ${global_info_dir}/${scan_file_to_write}

    cat ${1} | jq  ' def n: if . == "" then "NO_VALUE" else . end; def nk: if . == null then "KEY_NOT_DEFINED" else . end;[.queries[]|{"QI":(.query_id|nk|n),"QN":(.query_name|nk|n),"QS":(.severity|nk|n),"QP":(.platform|nk|n),"QC":(.cloud_provider|nk|n),"QY":(.category|nk|n),"QD":(.description|nk|n),"QE":(.description_id|nk|n),"QTFPFN":(.files[0].file_name|nk|n),"QTFPSI":(.files[0].similarity_id|nk|n),"QTFPRT":(.files[0].resource_type|nk|n),"QTFPRN":(.files[0].resource_name|nk|n),"QTFPIT":(.files[0].issue_type|nk|n),"QTFPSK":(.files[0].search_key|nk|n),"QTFPSV":(.files[0].search_value|nk|n),"QTFPEV":(.files[0].expected_value|nk|n),"QTFPAV":(.files[0].actual_value|nk|n),"QTFPRM":(.files[0].remediation|nk|n),"QTFPRE":(.files[0].remediation_type|nk|n),"QTPFRK":.files[0]|keys_unsorted,"QTPFRV":.files[0]|values}]|sort|unique'  | jq  '.' > ${global_info_dir}/${file_to_write}

    ECHO "INFO: pre_summary_file ${global_info_dir}/${file_to_write}, ${global_info_dir}/${scan_file_to_write}  written"
    sarif_colunms=()
    ECHO "INFO_DEBUG: CUT FILE ${global_info_dir}/${scan_file_to_write}"

    sarif_file_processed=$(echo "${global_info_dir}/${scan_file_to_write}")
    sarif_buffer=$(cat ${sarif_file_processed} | jq '.' | sed 's/\t//g' | sed 's/\n//g')

         total_records=$(echo "${sarif_buffer}" | jq 'length')
         #echo "INFO:SARIF_PROCESSING_MARKER total_records ${total_records} ${sarif_buffer}"
         declare -A sarif_columns_hash
         declare -A sarif_columns_from_scan_hash
         
         for all_keys in `echo "${sarif_keys}" | tr ',' ' '` 
         do
            sarif_columns_hash[${all_keys}]="${all_keys}"
         done
         total_fields=$(echo "${#sarif_columns_hash[@]}")
         current_rec=0
    
         sarif_temp_ar=()
         sarif_processed_ar=()
      
         current_cld=$(echo "${2}" | tr '[a-z]' '[A-Z]') 
         ECHO "INFO: total_fields ${total_fields} and total_rec ${total_records}"
         let all_severity_ct=${all_severity_ct}+${total_records}
         tfp_id_as_key=$(echo "${3}")
         REC_ID=1
         default_severity_if_not_found=$(echo "LOW")
         #echo "INFO_COUNT_DEBUG: total_fields ${total_fields} and total_rec ${total_records} logic ${current_rec} -lt  ${total_records}"
         rm -rf ${global_info_dir}/${3}_${2}_${5}.pipe 2>/dev/null 1>/dev/null
         while  [ $current_rec -lt $total_records ]
         do 
            #echo "INFO_DEBUG: $current_rec -lt $total_records INSIDE WHILE"
            sarif_temp_ar[${current_rec}]=$(cat ${sarif_file_processed} | jq --arg rc "${current_rec}" '.[$rc|tonumber]|values'| sed 's/\t//g' | sed 's/\n//g')
            #echo "INFO: rc=${current_rec} and value ${sarif_temp_ar[${current_rec}]}"
            ECHO "INFO: BEFORE Modifications sarif reports"
            declare -A sarif_columns_from_scan_hash
            for all_keys_processed in `echo "${sarif_columns_hash[@]}"`
            do
                sarif_columns_from_scan_hash_all_keys_processed_value=$(echo "${sarif_temp_ar[${current_rec}]}" | jq --arg KY "${all_keys_processed}" '.|.[$KY]' | tr '\n' '^' | tr '\t' '^' | sed 's/\^//g')
                #sarif_columns_from_scan_hash[${all_keys_processed}]=$(echo "${sarif_temp_ar[${current_rec}]}" | jq --arg KY "${all_keys_processed}" '.|.[$KY]')
                sarif_columns_from_scan_hash[${all_keys_processed}]=$(echo "${sarif_columns_from_scan_hash_all_keys_processed_value}")
                ECHO "INFO: INDEX current_rec ${current_rec} out of total_records ${total_records} PROCESSED Keys and Values ${all_keys_processed} ${sarif_columns_from_scan_hash[${all_keys_processed}]}"
            done
                PLATFORM=$(echo "${sarif_columns_from_scan_hash[paltform]}" | sed 's/\"//g')
                UUID=$(echo "${sarif_columns_from_scan_hash[query_id]}" | sed 's/\"//g')
                GET_QUERY_NAME=$(echo "${sarif_columns_from_scan_hash[query_name]}")
                default_severity_if_not_found=$(echo "${sarif_columns_from_scan_hash[severity]}" |  sed 's/\"//g' | tr '[a-z]' '[A-Z]')
                GET_CLOUD_PROVIDER=$(echo "${sarif_columns_from_scan_hash[cloud_provider]}" | sed 's/\"//g')
                CVSID_BASED_UUID=$(echo "0.0.0.0")
                tfp_id_as_key=$(echo "${3}")
                cur_date=$(date '+%Y-%m-%d %H:%M:%S') 
                unique_column_sig=$(echo "${sarif_columns_from_scan_hash[query_name]}" | sed 's/^\"//' | sed 's/\"$//' |  tr '[A-Z]' '[a-z]' | sed -r  's/ +/ /g' | tr ' ' '_' | sum | sed -r 's/ +/_/g'| sed 's/^/S/')
                unique_column_sig_val=$(echo "${sarif_columns_from_scan_hash[query_name]}" | sed 's/^\"//' | sed 's/\"$//') #| tr '_' ' ')
                property_sig_rel_hash["${unique_column_sig}"]="${unique_column_sig_val}"
           
                if [ "${GET_CLOUD_PROVIDER}" == "COMMON" ]; then
                     ECHO "INFO_DEBUG: SECRETS_AND_PASSWORDS: ${GET_QUERY_NAME}"
                     get_common_id=$(echo "${GET_QUERY_NAME}" | sed 's/\"//g' | sed -r  's/ +//g' | sed 's/-CN/\nCN/' | grep "^CN-" | cut -d ":" -f 1)
                     get_common_id=${get_common_id:-NONE}
                     lcase_cld=$(echo "${current_cld}" | tr '[A-Z]' '[a-z]')
                     cn_key=$(echo "${get_common_id}_${lcase_cld}")
                     get_uuid=$(echo "${cn_common_cloud_map[${cn_key}]}")
                     ECHO "INFO: SECRET UUID ${UUID}  get_common_id ${get_common_id}, cn_key ${cn_key}, get_uuid ${get_uuid} , hash cn_common_cloud_map, current_cld ${current_cld}, default_severity_if_not_found ${default_severity_if_not_found}"
                     case "${current_cld}" in
                       "AZURE")
                              CVSID_BASED_UUID=$(echo "${CSE_AZURE_RULES_HASH[${get_uuid}]}" | cut -d "|" -f 1)
                              default_severity_if_not_found=$(echo "${CSE_AZURE_RULES_HASH[${get_uuid}]}" | cut -d "|" -f 4 | tr '[a-z]' '[A-Z]')
                                ;;
                       "AWS")
                              CVSID_BASED_UUID=$(echo "${CSE_AWS_RULES_HASH[${get_uuid}]}" | cut -d "|" -f 1)
                              default_severity_if_not_found=$(echo "${CSE_AWS_RULES_HASH[${get_uuid}]}" | cut -d "|" -f 4 |  tr '[a-z]' '[A-Z]')
                             ;;
                       "GCP")
                              CVSID_BASED_UUID=$(echo "${CSE_GCP_RULES_HASH[${get_uuid}]}" | cut -d "|" -f 1)
                              default_severity_if_not_found=$(echo "${CSE_GCP_RULES_HASH[${get_uuid}]}" | cut -d "|" -f 4 | tr '[a-z]' '[A-Z]')
                             ;;
                        esac
                      CVSID_BASED_UUID=${CVSID_BASED_UUID:-0.0.0.0}
                      default_severity_if_not_found=${default_severity_if_not_found:-LOW}
                      tfp_id_as_key=$(echo "${tfp_id_as_key}_${CVSID_BASED_UUID}_${current_rec}")
                      #let current_rec=${current_rec}+1
                      let pwd_secrets_tokens_severity_ct=${pwd_secrets_tokens_severity_ct}+1
                      let total_severity_low_ct=${total_severity_low_ct}+1
                      sarif_columns_from_scan_hash[query_id]="${get_uuid}"
                      sarif_columns_from_scan_hash[cvsid]="${CVSID_BASED_UUID}"
                      sarif_columns_from_scan_hash[cloud_provider]="${current_cld}"
                      sarif_columns_from_scan_hash[severity]="${common_passwd_secrets_severity_flg}"
                      sarif_columns_from_scan_hash[tsm]="${cur_date}"
                      sarif_columns_from_scan_hash[tfpid]="${tfp_id_as_key}"
                      sarif_columns_from_scan_hash[additionalfd]="${4}"
                      sarif_columns_from_scan_hash[remediation_type]="sensitive_data_visibility"
                      sarif_columns_from_scan_hash[remediation]="encryption_required"
                      sarif_columns_from_scan_hash[resource_name]="virtual"
                      sarif_columns_from_scan_hash[resource_type]="virtual"
                      final_row=$(echo "\"${sarif_columns_from_scan_hash[cvsid]}\"|\"${sarif_columns_from_scan_hash[query_id]}\"|\"${unique_column_sig}\"|${sarif_columns_from_scan_hash[query_name]}|${sarif_columns_from_scan_hash[category]}|\"${sarif_columns_from_scan_hash[severity]}\"|\"${current_cld}\"|${sarif_columns_from_scan_hash[terraform_plan_file_name]}|${sarif_columns_from_scan_hash[similatiry_id]}|\"${sarif_columns_from_scan_hash[resource_type]}\"|\"${sarif_columns_from_scan_hash[resource_name]}\"|${sarif_columns_from_scan_hash[issue_type]}|${sarif_columns_from_scan_hash[search_key]}|${sarif_columns_from_scan_hash[expected_value]}|${sarif_columns_from_scan_hash[actual_value]}|\"${sarif_columns_from_scan_hash[remediation]}\"|\"${sarif_columns_from_scan_hash[remediation_type]}\"|${sarif_columns_from_scan_hash[additionalfd]}|\"${sarif_columns_from_scan_hash[tsm]}\"|\"${sarif_columns_from_scan_hash[tfpid]}\"")
                      sarif_processed_ar[${current_rec}]=$(echo "{\"cvsid\":\"${sarif_columns_from_scan_hash[cvsid]}\",\"query_id\":\"${sarif_columns_from_scan_hash[query_id]}\",\"ciss_unique_key\":\"${unique_column_sig}\",\"query_name\":${sarif_columns_from_scan_hash[query_name]},\"category\":${sarif_columns_from_scan_hash[category]},\"severity\":\"${sarif_columns_from_scan_hash[severity]}\",\"cloud_provider\":\"${current_cld}\",\"ciss_scan_info\":{\"terraform_file\":${sarif_columns_from_scan_hash[terraform_plan_file_name]},\"resource_name\":\"${sarif_columns_from_scan_hash[resource_name]}\",\"resource_type\":\"${sarif_columns_from_scan_hash[resource_type]}\",\"issue_type\":${sarif_columns_from_scan_hash[issue_type]},\"search_key\":${sarif_columns_from_scan_hash[search_key]},\"expected_value\":${sarif_columns_from_scan_hash[expected_value]},\"actual_value\":${sarif_columns_from_scan_hash[actual_value]},\"remediation\":\"${sarif_columns_from_scan_hash[remediation]}\",\"remediation_type\":\"${sarif_columns_from_scan_hash[remediation_type]}\"}}")
                else
                      case "${current_cld}" in
                      "AZURE")
                            CVSID_BASED_UUID=$(echo "${CSE_AZURE_RULES_HASH[${UUID}]}" | cut -d "|" -f 1)
                            default_severity_if_not_found=$(echo "${CSE_AZURE_RULES_HASH[${UUID}]}" | cut -d "|" -f 4 | tr '[a-z]' '[A-Z]')
                              ;;
                      "AWS")
                            CVSID_BASED_UUID=$(echo "${CSE_AWS_RULES_HASH[${UUID}]}" | cut -d "|" -f 1)
                            default_severity_if_not_found=$(echo "${CSE_AWS_RULES_HASH[${UUID}]}" | cut -d "|" -f 4 |  tr '[a-z]' '[A-Z]')
                           ;;
                      "GCP")
                            CVSID_BASED_UUID=$(echo "${CSE_GCP_RULES_HASH[${UUID}]}" | cut -d "|" -f 1)
                            default_severity_if_not_found=$(echo "${CSE_GCP_RULES_HASH[${UUID}]}" | cut -d "|" -f 4 | tr '[a-z]' '[A-Z]')
                           ;;
                       esac
                       CVSID_BASED_UUID=${CVSID_BASED_UUID:-0.0.0.0}
                       default_severity_if_not_found=${default_severity_if_not_found:-LOW}
                       #tfp_id_as_key=$(echo "${tfp_id_as_key}_${CVSID_BASED_UUID}_${REC_ID}")
                       tfp_id_as_key=$(echo "${tfp_id_as_key}_${CVSID_BASED_UUID}_${current_rec}")
                       sarif_columns_from_scan_hash[query_id]="${UUID}"
                       sarif_columns_from_scan_hash[cvsid]="${CVSID_BASED_UUID}"
                       sarif_columns_from_scan_hash[severity]="${default_severity_if_not_found}"
                       sarif_columns_from_scan_hash[tsm]="${cur_date}"
                       sarif_columns_from_scan_hash[tfpid]="${tfp_id_as_key}"
                       sarif_columns_from_scan_hash[additionalfd]="${4}"
                      final_row=$(echo "\"${sarif_columns_from_scan_hash[cvsid]}\"|\"${sarif_columns_from_scan_hash[query_id]}\"|\"${unique_column_sig}\"|${sarif_columns_from_scan_hash[query_name]}|${sarif_columns_from_scan_hash[category]}|\"${sarif_columns_from_scan_hash[severity]}\"|\"${current_cld}\"|${sarif_columns_from_scan_hash[terraform_plan_file_name]}|${sarif_columns_from_scan_hash[similatiry_id]}|${sarif_columns_from_scan_hash[resource_type]}|${sarif_columns_from_scan_hash[resource_name]}|${sarif_columns_from_scan_hash[issue_type]}|${sarif_columns_from_scan_hash[search_key]}|${sarif_columns_from_scan_hash[expected_value]}|${sarif_columns_from_scan_hash[actual_value]}|${sarif_columns_from_scan_hash[remediation]}|${sarif_columns_from_scan_hash[remediation_type]}|${sarif_columns_from_scan_hash[additionalfd]}|\"${sarif_columns_from_scan_hash[tsm]}\"|\"${sarif_columns_from_scan_hash[tfpid]}\"")
                      sarif_processed_ar[${current_rec}]=$(echo "{\"cvsid\":\"${sarif_columns_from_scan_hash[cvsid]}\",\"query_id\":\"${sarif_columns_from_scan_hash[query_id]}\",\"ciss_unique_key\":\"${unique_column_sig}\",\"query_name\":${sarif_columns_from_scan_hash[query_name]},\"category\":${sarif_columns_from_scan_hash[category]},\"severity\":\"${sarif_columns_from_scan_hash[severity]}\",\"cloud_provider\":\"${current_cld}\",\"ciss_scan_info\":{\"terraform_file\":${sarif_columns_from_scan_hash[terraform_plan_file_name]},\"resource_name\":${sarif_columns_from_scan_hash[resource_name]},\"resource_type\":${sarif_columns_from_scan_hash[resource_type]},\"issue_type\":${sarif_columns_from_scan_hash[issue_type]},\"search_key\":${sarif_columns_from_scan_hash[search_key]},\"expected_value\":${sarif_columns_from_scan_hash[expected_value]},\"actual_value\":${sarif_columns_from_scan_hash[actual_value]},\"remediation\":${sarif_columns_from_scan_hash[remediation]},\"remediation_type\":${sarif_columns_from_scan_hash[remediation_type]}}}")
                   fi 
                   ECHO "INFO: After Modifications sarif reports"
                   for all_keys_processed in `echo "${!sarif_columns_hash[@]}"`
                   do
                       ECHO "INFO: PROCESSED Keys and Values ${all_keys_processed} ${sarif_columns_from_scan_hash[${all_keys_processed}]}"
                   done
                      ECHO "${sarif_processed_ar[${current_rec}]}"
                      ECHO "${sarif_processed_ar[${current_rec}]}" | jq '.'
                      ECHO "${final_row}"
                   echo "${final_row}|\"FAIL\"" >> ${global_info_dir}/${3}_${2}_${5}.pipe
                   current_rec=`expr ${current_rec} + 1`
                   REC_ID=`expr ${REC_ID} + 1`
         done #> ${global_info_dir}/${3}_${2}_${5}.pipe 
         ECHO "INFO: END_OF_RECORD_PROCESSING SARIF_RULES_VIOLATED_COUNT-current_rec=${current_rec} and REC_ID=${REC_ID}"
#1.8.6.999|9bb3c639-5edf-458c-8ee5-30c17c7d671d|Function_App_Client_Certificates_Unrequired|Insecure_Configurations|MEDIUM|AZURE|Azure_Function_App_should_have_'client_cert_mode'_set_to_required|../../tmp/iac_scan_status/tfp/2024/20241004-40-278/ciss/ciss_tfp_pv_S50655_817_azure.json|azurerm_function_app|myFunctionApp|IncorrectValue|CSE|Q3-CONTAINER|1728062407|redi|ba9be349-ed04-4822-98ff-b7d53acd1232|2024-10-04 17:20:45|S50655_817_1.8.6.999_2
         ECHO "INFO: RPT_FILE_FROM_KICS_JASON-${global_info_dir}/${3}_${2}_${5}.pipe"
         if [ ${current_rec} -gt 0 ]; then
             sarif_rules_count_from_hash=$(echo "${sarif_processed_ar[@]}" | jq -s '.' | jq 'length')
             if [ ${sarif_rules_count_from_hash} -gt 0 ]; then 
                echo "${sarif_processed_ar[@]}" | jq -s '.' > ${global_info_dir}/non_complaint_rules_info_${3}_${2}_${5}.pipe
                ECHO "INFO: non_complaint_rules_final_file_info-${global_info_dir}/non_complaint_rules_info_${3}_${2}_${5}.pipe written"
             else
                ECHO "INFO: SARIF_RULES_VIOLATED_COUNT-current_rec=${current_rec} and REC_ID=${REC_ID}"
                ECHO "INFO: NO_RULES_FOUND"
             fi
         fi
         let non_common_rules_violation_ct=${non_common_rules_violation_ct}+${total_rec}-${pwd_secrets_tokens_severity_ct}
         ECHO  "INFO: total_rec ${total_rec}"
         ECHO  "INFO: file ${global_info_dir}/${3}_${2}_${3}.pipe written"
         ECHO "INFO: all_severity_ct=${all_severity_ct}"
         ECHO  "INFO: (non_common_rules_violation_ct,pwd_secrets_tokens_severity_ct) (${non_common_rules_violation_ct},${pwd_secrets_tokens_severity_ct})"
         pipe_key=$(echo "${3}_${2}")
         pipe_non_complaint_rules_file_info_key=$(echo "pipe_non_complaint_rules_file_info_${3}_${2}")
         tfp_pipe_file_hash["${pipe_non_complaint_rules_file_info_key}"]="${global_info_dir}/${non_complaint_rules_final_file_info}"
         ECHO "INFO: file name- ./${3}_${2}_${5}.pipe key ${3}_${2}"
         rule_violation_summary_file_list["${3}_${2}_${5}"]="${global_info_dir}/${3}_${2}_${5}.pipe"

         tfp_pipe_file_hash["${pipe_key}"]="./${3}_${2}_${5}.pipe"
         ECHO "INFO: END _OF_PROCESS_JSON_FILE"
}

CISS_SCAN ()
{
            ECHO "INFO: TYPE INDIRECT FN-NAME CISS_SCAN"
            #$1 is file to scan, $2 is report_dir,  $3 is tfp_file $4 is tfp_check_sum $5 is tfp_root  $6 cloud $7 unique_build_id (R-${4}_${6}
            cd /apps/kics 1>/dev/null 2>/dev/null
            ECHO "INFO: CMD kics scan -p ${1} --disable-full-descriptions ${SCAN_CN_OPTION} --log-level ${llv} -o ${2} --report-formats \"json,sarif,html,pdf,csv\" --output-name \"${7}\" 1>>/tmp/${build_id}.std_01 2>>/tmp/${build_id}.std_02"
            #echo "INFO: CMD kics scan -p ${1} --disable-full-descriptions --secrets-regexes-path ${SP_CN_PATH} --log-level ${llv} -o ${2} --report-formats \"json,sarif,html,pdf,csv\" --output-name \"${7}\" 1>>/tmp/${build_id}.std_01 2>>/tmp/${build_id}.std_02"
            #ECHO "INFO: CMD kics scan -p ${get_pv_file} --disable-full-descriptions --secrets-regexes-path ${SP_CN_PATH} --log-level ${llv} -o ${report_dir} --report-formats \"json,sarif,html,pdf,csv\" --output-name \"${build_id}\" 1>>/tmp/${build_id}.std_01 2>>/tmp/${build_id}.std_02"
                    kics scan -p ${1} --disable-full-descriptions ${SCAN_CN_OPTION} --log-level ${llv} -o ${2} --report-formats "json,sarif,html,pdf,csv" --output-name "${7}" 1>>/tmp/${build_id}.std_01 2>>/tmp/${build_id}.std_02
                    #kics scan -p ${1} --disable-full-descriptions --secrets-regexes-path ${SP_CN_PATH} --log-level ${llv} -o ${2} --report-formats "json,sarif,html,pdf,csv" --output-name "${7}" 1>>/tmp/${build_id}.std_01 2>>/tmp/${build_id}.std_02
            kics_rc=(`echo "$?"`)
            cd - 1>/dev/null 2>/dev/null
            #echo "INFO: kics run result ${kics_rc}"
            ciss_tfp_scan_rc_hash[${4}]="${kics_rc}"
            #STD_OUT_CAPTURE_START
            #echo "DEBUG: scan_verbose_level=${scan_verbose_level}"
            if [ "${scan_verbose_level}" != "error" ]; then
               ECHO "INFO: STD_OUT_01_FOR_FILE ${tfp_file_to_process}"
               cat /tmp/${build_id}.std_01
               ECHO "INFO: STD_OUT_02_FOR_FILE ${tfp_file_to_process}"
               cat /tmp/${build_id}.std_02 | tr '%' '\n' | grep -v "Executing queries"
            fi
            ECHO "INFO: DELETING_STD_OUT"
            if [ "${scan_rc_file_out_delete_flg}" == "Y" ]; then
               rm -rf /tmp/${build_id}.std_01 /tmp/${build_id}.std_02
            else
               ECHO "INFO: SCAN_OUTPUT_FILE /tmp/${build_id}.std_01 /tmp/${build_id}.std_02"
            fi
            #STD_OUT_CAPTURE_END
            processed_tf_plan_files[${4}]="${4}|${1}|${kics_rc}"
            get_sarif_file_generated=$(ls -C1 ${2}/${7}.sarif 2>/dev/null)
            get_json_file_generated=$(ls -C1 ${2}/${7}.json 2>/dev/null)
            #kics_report_dir_hash[${2}]=${2}
                get_sarif_file_generated=${get_sarif_file_generated:-NONE}
                if [ "${get_sarif_file_generated}" != "NONE" ]; then
                    ECHO "INFO: sarif_output_found ${get_sarif_file_generated}"
                    #rules_violated_cdst=$(cat ${get_sarif_file_generated} | jq '.runs[].results|length')
                    tfp_pv_srp_details=$(echo "${tfp_data_info_hash[${4}_${6}_tfp_pv_srp]}")
                    tfp_pv_srp_details=${tfp_pv_srp_details:-0}
                    #echo "${tfp_pv_srp_details}" | jq '.'
                    get_acct_id=$(echo "${tfp_data_info_hash[${4}_${6}_tfp_acctid_value]}")
                    get_appid=$(echo "${tfp_data_info_hash[${4}_${6}_tfp_appid]}")
                    get_appid=${get_appid:-NONE}
                    tag_status=$(echo "tag_not_defined")
                    let total_tag=$(echo "${tfp_data_info_hash[${4}_${6}_tfp_tag_len]}")
                    tag_keys=$(echo "tag_keys_not_defined")
                    tag_properties=$(echo "tag_properties_not_defined")
                    #if [ "${get_appid}" != "NONE" ]; then
                    if [ ${total_tag} -gt 0 ]; then
                       tag_status=$(echo "tag_defined")
                       tag_keys=$(echo "${tfp_data_info_hash[${4}_${6}_tfp_tag_keys]}")
                       tag_properties=$(echo "${tfp_data_info_hash[${4}_${6}_tfp_tag_values]}")
                    fi
                    utc_time=$(echo "${build_id}" | cut -d "-" -f 4)
                    cur_date=$(date '+%Y-%m-%d %H:%M:%S')
                    cur_date1=$(date '+%Y-%m-%d_%H:%M:%S')
                    tf_version=$(echo "${tfp_terraform_version_hash[${4}]}" | sed 's/\"//g')
                    tf_format=$(echo "${tfp_format_version_hash[${4}]}" | sed 's/\"//g')
                    clean_app_nm=$(echo "${app_nm}" | sed 's/\"//g')
                    clean_pipeline_nm=$(echo "${pipeline_nm}" | sed 's/\"//g')
                    clean_utc_time=$(echo "${utc_time}" | sed 's/\"//g')
                    clean_real_appnm=$(echo "${real_appnm}" | sed 's/\"//g')
                    clean_get_acct_id=$(echo "${get_acct_id}" | sed 's/\"//g')
                    clean_infra=$(echo "${infra}" | sed 's/\"//g')
                    clean_cld=$(echo "${6}" | tr '[a-z]' '[A-Z]')
                    additional_fields=$(echo "\"${clean_app_nm}\"|\"${clean_pipeline_nm}\"|\"${clean_utc_time}\"|\"${clean_real_appnm}\"|\"${clean_get_acct_id}\"|\"${clean_infra}\"")
                    successful_scan_rec_for_this_tfp=$(echo "${success_tfp_rec_prefix}|\"${clean_cld}\"|\"${1}\"|${success_tfp_rec_colm}|${additional_fields}|\"${cur_date}\"|\"${4}_0.1.1.1_${utc_time}\"|\"PASS\"")
                    #additional_fields=$(echo "${app_nm}|${pipeline_nm}|${utc_time}|${real_appnm}|${get_acct_id}|${infra}" | sed 's/\"//g')
                    PROCESS_JSON_FILE ${get_json_file_generated} ${6} ${4} "${additional_fields}" "${7}" 
                    #read SSSSS
                    ECHO "INFO_DEBUG: JQ_PROCESS ${get_json_file_generated} cld as arg START"
                    ECHO "INFO_DEBUG: JQ_PROCESS ${get_json_file_generated} tf_version START"
                    sarif_info=$(cat ${get_sarif_file_generated} | jq --arg tfv ${tf_version} --arg tff ${tf_format} --arg rrules_info "${scan_json_resource_property_info}"  --arg cld "${6}" --arg tagst "${tag_status}" --arg tagct "${total_tag}" --arg tagk "${tag_keys}" --arg tagv "${tag_properties}" --arg curt "${cur_date}" --arg utc_ck "${utc_time}" --arg appnm "${infra}" --arg pipeln "${pipeline_nm}" --arg lob "${LOB}" --arg ram "${real_appnm}" --arg envi "${ENVI}" --arg loc "${LOC}"  --arg dwaf "${DIRECTORY_WITH_APPNM_FOLDER}" --arg acct "${get_acct_id}" --arg fm  "${get_sarif_file_generated}"  --arg tfp "${1}" --arg pvcs "${8}" --arg tfpsum "${4}" '.|.runs[]|{ "CLOUD_PROVIDER": $cld, "TERRAFORM_VERSION": $tfv, "TERRAFORM_FORMAT": $tff, "TIME": $utc_ck, "TS": $curt, "TFP": $tfp, "TFP_CHECK_SUM": $tfpsum,  "CISS_CHECK_SUM": $pvcs, "TAG_STATUS": $tagst, "TOTAL_TAG": $tagct,  "TAG_KEYS": $tagk, "TAG_VALUES": $tagv, "ACCTID": $acct, "APPLICATION": $ram, "INFRA": $appnm, "PIPELINE": $pipeln, "LDAP": $dwaf,  "LOB": $lob, "LOC": $loc, "ENVIRONMENT": $envi,  "FILE": $fm,"TOTAL_RULEIDS":[.results[].ruleId]|length,"RULEIDS":[.results[].ruleId]|sort|join(","),"TOTAL_UNIQUE_RULEIDS":[.results[].ruleId]|sort|unique|length,"UNIQUE_RULEIDS":[.results[].ruleId]|sort|unique|join(","), "RESOURCE_PROPERTIES_NON_COMPLAINT":77777}')
                    echo "${sarif_info}" > ${global_info_dir}/${7}_tmp_sarif_info.pipe
                    ECHO "INFO_DEBUG: tmp file for sarif_info and scan_json_resource_property_info  written. ${global_info_dir}/${7}_tmp_sarif_info.pipe, ${global_info_dir}/${7}_sarif_rpt_info.pipe"
                    ECHO "INFO_DEBUG: JQ_PROCESS ${get_json_file_generated} tf_version END"
                    #echo "INFO: sarif_info ${sarif_info}" |  tr '\n' ' ' 
                    ECHO "INFO_DEBUG: JQ_PROCESS single_line_sarif_info scan_json_resource_property_info START"
                    #single_line_sarif_info=$(echo "${sarif_info}" | tr '\n' ' ' | sed  's/77777}//') # | sed 's/\} $//')
                    single_line_sarif_info=$(echo "${sarif_info}" | jq '.' |  sed 's/77777//' | sed 's/^}$//')
                    
                    ECHO "INFO: MEMORY_BUFFER PRINT single_line_sarif_info and scan_json_resource_property_info START"
                    ECHO "INFO: PLAN_FILE_INFO ${tfp_pv_srp_details}"
                    sarif_rules_count_from_hash=$(echo "${sarif_processed_ar[@]}" | jq -s '.' | jq 'length')
                    if [ ${sarif_rules_count_from_hash} -gt 0 ]; then
                        rvfc=$(echo "${sarif_processed_ar[@]}" | jq -s '.' | tr '\n' ' ')
                        ECHO "INFO_RVFC rvfc ${rvfc}"
                        echo "${single_line_sarif_info}${rvfc},\"PLAN_FILE_INFO\":${tfp_pv_srp_details}}" > ${global_info_dir}/${7}_sarif_summary.pipe
                        ECHO "INFO: sarif_summary_file-${global_info_dir}/${7}_sarif_summary.pipe complete"
                    else
                        echo "${single_line_sarif_info}\"NO_DATA_GENERATED_ERROR\",\"PLAN_FILE_INFO\":${tfp_pv_srp_details}}" > ${global_info_dir}/${7}_sarif_summary.pipe
                        echo "${successful_scan_rec_for_this_tfp}" > ${global_info_dir}/${4}_${6}_${7}.pipe
                        ECHO "INFO: CISS_SCAN_NO_RULES_FOUND FILE ${global_info_dir}/${4}_${6}_${7}.pipe"
                    fi
                    ECHO "INFO: MEMORY_BUFFER PRINT single_line_sarif_info and scan_json_resource_property_info END"
                    ECHO "INFO_DEBUG: file ${2}/${7}_sarif_summary.pipe and ${2}/${7}_sarif_summary.pipe"
                    ECHO "INFO_DEBUG: JQ_PROCESS single_line_sarif_info scan_json_resource_property_info END"
                    ECHO "INFO_DEBUG: JQ_PROCESS rules_violated_ct START"
                    rules_violated_ct=$(echo "${sarif_info}" | jq '.TOTAL_UNIQUE_RULEIDS')
                    ECHO "INFO_DEBUG: JQ_PROCESS rules_violated_ct END"
                    ECHO "INFO_DEBUG: JQ_PROCESS unique_rules_violated START"
                    unique_rules_violated=$(echo "${sarif_info}" | jq -Mr  '.UNIQUE_RULEIDS')
                    ECHO "INFO_DEBUG: JQ_PROCESS unique_rules_violated END"
                    processed_tf_plan_files[${4}]="${4}|${8}|${1}|${get_sarif_file_generated}|${kics_rc}|${rules_violated_ct}|${unique_rules_violated}|${app_nm}|${pipeline_nm}|${utc_time}|${cur_date1}|${get_acct_id}|${LOB}|${real_appnm}|${ENVI}|${LOC}|${DIRECTORY_WITH_APPNM_FOLDER}"
                else
                    echo "INFO: tfplan_file_issue.debug with kics vendor"
                    error_key=$(echo "err_kics_${all}")
                    err_file_name=$(echo "/tmp/${error_key}.tfplan")
                    echo "ERR:TF" >${err_file_name}
                    processed_tf_plan_files[${4}]="${4}|${8}|${1}|ERR|${kics_rc}|-1|NONE|${app_nm}|${pipeline_nm}|${utc_time}|${cur_date1}|${get_acct_id}|${LOB}|${real_appnm}|${ENVI}|${LOC}|${DIRECTORY_WITH_APPNM_FOLDER}"
                    processed_tf_plan_files[${error_key}]="${err_file_name}"
                    ECHO "INFO: tfplan_file_issue.debug with kics vendor flag_file: ${err_file_name}"
                fi
                ECHO "INFO: END_OF_CISS_SCAN"

}
