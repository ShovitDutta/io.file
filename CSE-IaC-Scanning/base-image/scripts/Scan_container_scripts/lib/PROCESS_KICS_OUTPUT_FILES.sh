
process_kics_output_files ()
{

      ECHO "INFO: TYPE INDIRECT FN-NAME process_kics_output_files"
      #cat ${report_dir}/${build_id}.sarif
      sarif_file=(`echo "${1}/${2}.sarif"`)
      ECHO "INFO: JSON_FILE_TO_OPEN ${1}/${2}.json"
      json_file=(`echo "${1}/${2}.json"`)
#time,app_nm, pipeline, terraform file signature, cloud processing. Start
            timestamp=()
            #timestamp=$(echo "${2}" | cut -d "-" -f 2-3 | sed 's/-/ /' | sed 's/_/:/g' | sed -E 's,([0-9]{4})([0-9]{2})([0-9]{2}),\1-\2-\3,g')
            #timestamp=$(echo "${2}" | cut -d "-" -f 2-3 | sed 's/-/ /' | sed 's/_/:/g' | sed -E 's,([0-9]{4})([0-9]{2})([0-9]{2})(.)([0-9]{2}:)([0-9]{2}:)([0-9]{2}),\1-\2-\3\4\5\600,g')
            utc_time=$(echo "${2}" | cut -d "-" -f 4)
            tail_clip=$(echo "${2}" | cut -d "-" -f 8- | cut -d "." -f 1)
            appname_and_pipelineid=$(echo "${tail_clip}" | sed 's/-'${appname}'/|'${appname}'/')
            just_pipeline_id=$(echo "${appname_and_pipelineid}" | cut -d "|" -f 2)
            just_appname=$(echo "${appname_and_pipelineid}" | cut -d "|" -f 1)

            #echo "INFO: Additional Field=${2}"
            #echo "INFO: timestamp ${timestamp}, utc_time ${utc_time}, just_appname ${just_appname}, appname_and_pipelineid ${appname_and_pipelineid}, just_pipeline_id ${just_pipeline_id}"
            #additional_fields=$(echo "${just_appname}|${just_pipeline_id}|${utc_time}|REALAPPNAME|ACCTID|${timestamp}")
            GET_ACCTID=$(echo "${tfp_acctid_hash[${3}]}")
            #additional_fields=$(echo "${just_appname}|${just_pipeline_id}|${utc_time}|${real_appnm}|${GET_ACCTID}|${timestamp}")
            additional_fields=$(echo "${just_appname}|${just_pipeline_id}|${utc_time}|${real_appnm}|${GET_ACCTID}")
            #echo "INFO: additional_fields ${additional_fields}"
            #read SSSSS
#time,app_nm, pipeline, terraform file signature, cloud processing. End
      temp_arr=()
      #ECHO "INFO:temp_arr=(cat ${json_file} | jq .queries[] | jq -r  '.|[ .query_id,.query_name,.files[0].resource_type,.severity,.cloud_provider,.files[0].issue_type,.files[0].expected_value,.files[0].remediation_type,.files[0].line,.description] | join(\"|\")' | tr ' ' '_' |  sed 's/\,//g' | tr '\n' ' ')"
      #temp_arr=(`cat ${json_file} | jq .queries[] | jq -r  '.|[ .query_id,.query_name,.files[0].resource_type,.severity,.cloud_provider,.files[0].issue_type,.files[0].expected_value,.files[0].remediation_type,.files[0].line,.description] | join("|")' | tr ' ' '_' |  sed 's/\,//g' | tr '\n' ' '`)
      #temp_arr=(`cat ${json_file} | jq .queries[] | jq -r  '.|[ .query_id,.query_name,.files[0].resource_type,.severity,.cloud_provider,.files[0].issue_type,.files[0].expected_value,.files[0].remediation_type,.files[0].line,.description] | join("|")' | tr ' ' '_' |  sed 's/\,//g' | tr '\n' ' '`)
      #temp_arr=(`cat ${json_file} | jq -r '.queries[]|[ { query_id : .query_id?,query_name: .query_name?,severity:.severity?,cloud_provider: .cloud_provider, category: .category, description: .description?, file: .files[] }]' | jq '.[]|{ query_id:.query_id, query_name: .query_name, category:.category, severity:.severity, cloud_provider: .cloud_provider, file_name: .file.file_name, similarity_id: .file.similarity_id, line: .file.line, resource_type: .file.resource_type, resource_name: .file.resource_name, issue_type: .file.issue_type, search_key: .file.search_key, search_line: .file.search_line, expected_value: .file.expected_value, actual_value: .file.actual_value, remediation: .file.remediation, remediation_type: .file.remediation_type }' | jq -Mr '.|join("|")' | tr ' ' '_' |  sed 's/\,//g' | tr '\n' ' '`)
      temp_arr=(`cat ${json_file} | jq -r '.queries[]|[ { query_id : .query_id?,query_name: .query_name?,severity:.severity?,cloud_provider: .cloud_provider, category: .category, description: .description?, file: .files[] }]' | jq '.[]|{ query_id:.query_id, query_name: .query_name, category:.category, severity:.severity, cloud_provider: .cloud_provider, file_name: .file.file_name, similarity_id: .file.similarity_id, line: .file.line, resource_type: .file.resource_type, resource_name: .file.resource_name, issue_type: .file.issue_type, search_key: .file.search_key, search_line: .file.search_line, expected_value: .file.expected_value, actual_value: .file.actual_value, remediation: .file.remediation, remediation_type: .file.remediation_type }' | jq -Mr '.|join("|")' | tr ' ' '_' |  sed 's/\,//g' | tr '\n' ' '  | sed 's/\t//g' | sed 's/{ /{/' | sed 's/ \} /\}/'`)
       ct=(`echo "${#temp_arr[@]}"`)
         current_cld=$(echo "${tfp_terraform_cloud_hash[${3}]}")
         total_fields=$(echo "${temp_arr[0]}" | awk -F "|" '{ OFS="|"; print NF;}')
         total_rec=$(echo "${#temp_arr[@]}")
         ECHO "INFO: total_fields ${total_fields} and total_rec ${total_rec}"
         let all_severity_ct=${all_severity_ct}+${total_rec}
         tfp_id_as_key=$(echo "${3}")
         let REC_ID=1
         for all_ct in `echo "${temp_arr[@]}"`
         do
           UUID=$(echo "${all_ct}" | cut -d "|" -f 1)
           CVSID_BASED_UUID=$(echo "0.0.0.0")
           tfp_id_as_key=$(echo "${3}")
           cur_date=$(date '+%Y-%m-%d %H:%M:%S')
           case "${get_ucld}" in
           "AZURE")
                    CVSID_BASED_UUID=$(echo "${CSE_AZURE_RULES_HASH[${UUID}]}" | cut -d "|" -f 1)
                      ;;
           "AWS")
                    CVSID_BASED_UUID=$(echo "${CSE_AWS_RULES_HASH[${UUID}]}" | cut -d "|" -f 1)
                   ;;
           "GCP")
                    CVSID_BASED_UUID=$(echo "${CSE_GCP_RULES_HASH[${UUID}]}" | cut -d "|" -f 1)
                   ;;
            esac
            CVSID_BASED_UUID=${CVSID_BASED_UUID:-0.0.0.0}
            tfp_id_as_key=$(echo "${tfp_id_as_key}_${CVSID_BASED_UUID}_${REC_ID}")
         
           get_common_id=$(echo "${all_ct}" | grep "|COMMON|" | cut -d "|" -f 2 | cut -d ":" -f 1 | sed 's/_CN/\nCN/' | grep "^CN-")
           get_common_id=${get_common_id:-NONE}
           if [ "${get_common_id}" != "NONE" ]; then
             cn_key=$(echo "${get_common_id}_${current_cld}") 
             get_uuid=$(echo "${cn_common_cloud_map[${cn_key}]}")
             case "${get_ucld}" in
             "AZURE")
                    CVSID_BASED_UUID=$(echo "${CSE_AZURE_RULES_HASH[${get_uuid}]}" | cut -d "|" -f 1)
                      ;;
             "AWS")
                    CVSID_BASED_UUID=$(echo "${CSE_AWS_RULES_HASH[${get_uuid}]}" | cut -d "|" -f 1)
                   ;;
             "GCP")
                    CVSID_BASED_UUID=$(echo "${CSE_GCP_RULES_HASH[${get_uuid}]}" | cut -d "|" -f 1)
                   ;;
              esac
            CVSID_BASED_UUID=${CVSID_BASED_UUID:-0.0.0.0}
            tfp_id_as_key=$(echo "${tfp_id_as_key}_${CVSID_BASED_UUID}_${REC_ID}")
             #echo "${all_ct}" | grep "|COMMON|" | sed "s/|COMMON|/|${get_ucld}|/" | cut -d "|" -f 2- |  awk -F "|"  -v CVSID="${CVSID_BASED_UUID}" -v UUID=${get_uuid} -v ADDITIONALFD="${additional_fields}" '{ OFS="|"; print CVSID,UUID,$0,ADDITIONALFD;}' | sed "s/|HIGH|/|${common_passwd_secrets_severity_flg}|/" | sed "s/|MEDIUM|/|${common_passwd_secrets_severity_flg}|/" | sed "s/|CRITICAL|/|${common_passwd_secrets_severity_flg}|/" | sed "s/|INFO|/|${common_passwd_secrets_severity_flg}|/" | sed "s/|TRACE|/|${common_passwd_secrets_severity_flg}|/" | sed 's/|||/|virtual|virtual|/' | sed 's/||/|sensitive_data_visibility|/'
             echo "${all_ct}" | grep "|COMMON|" | sed "s/|COMMON|/|${get_ucld}|/" | cut -d "|" -f 2- |  awk -F "|" -v TFPID="${tfp_id_as_key}" -v TSM="${cur_date}"  -v CVSID="${CVSID_BASED_UUID}" -v UUID=${get_uuid} -v ADDITIONALFD="${additional_fields}" '{ OFS="|"; print CVSID,UUID,$0,ADDITIONALFD,TSM,TFPID;}' | sed "s/|HIGH|/|${common_passwd_secrets_severity_flg}|/" | sed "s/|MEDIUM|/|${common_passwd_secrets_severity_flg}|/" | sed "s/|CRITICAL|/|${common_passwd_secrets_severity_flg}|/" | sed "s/|INFO|/|${common_passwd_secrets_severity_flg}|/" | sed "s/|TRACE|/|${common_passwd_secrets_severity_flg}|/" | sed 's/|||/|virtual|virtual|/' | sed 's/||/|sensitive_data_visibility|/'
             let pwd_secrets_tokens_severity_ct=${pwd_secrets_tokens_severity_ct}+1
           else
             echo "${all_ct}" | grep -v  "|COMMON|" |  awk -F "|" -v TFPID="${tfp_id_as_key}" -v TSM="${cur_date}" -v CVSID="${CVSID_BASED_UUID}" -v ADDITIONALFD="${additional_fields}" '{ OFS="|"; print CVSID,$0,ADDITIONALFD,TSM,TFPID;}'
             clip_only_severity=$(echo "${all_ct}" | grep -v  "|COMMON|" |  awk -F "|" '{ OFS="|"; print $4}')
             case "${clip_only_severity}" in
             "LOW")
                       let total_severity_low_ct=${total_severity_low_ct}+1
                     ;;
             "MEDIUM")
                       let total_severity_medium_ct=${total_severity_medium_ct}+1
                        ;;
             "HIGH")
                       let total_severity_hi_ct=${total_severity_hi_ct}+1
                     ;;
             "CRITICAL")
                       let total_severity_critical_ct=${total_severity_critical_ct}+1
                         ;;
             *)
                echo "INFO_OR_TRACE" >/dev/null
                    ;;
             esac 

           fi
         let REC_ID=${REC_ID}+1
         done > ${global_info_dir}/${3}_${get_ucld}_${2}.pipe
         ECHO "INFO: RPT_FILE_FROM_KICS_JASON-${global_info_dir}/${3}_${get_ucld}_${2}.pipe"
         let non_common_rules_violation_ct=${non_common_rules_violation_ct}+${total_rec}-${pwd_secrets_tokens_severity_ct}
         ECHO  "INFO: total_rec ${total_rec}"
         ECHO  "INFO: file ${global_info_dir}/${3}_${get_ucld}_${2}.pipe written"
         ECHO "INFO: all_severity_ct=${all_severity_ct}"
         ECHO  "INFO: (non_common_rules_violation_ct,pwd_secrets_tokens_severity_ct) (${non_common_rules_violation_ct},${pwd_secrets_tokens_severity_ct})"
         pipe_key=$(echo "${3}_${get_ucld}")
         ECHO "INFO: file name- ./${3}_${get_ucld}_${2}.pipe key ${3}_${get_ucld}"
         rule_violation_summary_file_list["${3}_${get_ucld}_${2}"]="${global_info_dir}/${3}_${get_ucld}_${2}.pipe"
         tfp_pipe_file_hash["${pipe_key}"]="./${3}_${get_ucld}_${2}.pipe"
         #${global_info_dir}
}                       

