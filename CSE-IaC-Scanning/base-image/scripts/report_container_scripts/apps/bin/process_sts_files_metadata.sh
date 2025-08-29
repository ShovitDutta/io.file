#!/usr/bin/env sh


 daily_date_format=${1:-NONE}
 load_dbwriter=${2:-N}
 load_ciss_cse=${3:-N}
 already_done=${4:-Y}
 DEBUG=${5:-n}

chk_already_done ()
{
      echo "INFO: FUNCTION_NAME chk_already_done"    
      if [ "${already_done}" == "Y" ]; then
           echo "INFO: CHECK_JSON_FILE ${1}"
           file_to_check=$(ls -C1 ${1} 2>/dev/null)
           file_to_check=${file_to_check:-NONE}
           echo "INFO: file_to_check ${file_to_check}"
           if [ "${file_to_check}" == "NONE" ]; then
               echo "INFO: NO_JSON_FILE_FOUND. PROCESS_WILL_CONTINE"
           else
               echo "INFO: PROCESS_ALREADY_DONE. EXIT 0"
               exit 0
           fi
      else
           echo "INFO: OVER_RIDE. PROCESS_WILL_CONTINE"
      fi
}

   if  [ "${daily_date_format}" == "NONE" ]; then
         echo "ERROR: Parameter daily_date_format required."
         echo "INFO: Usage- $0 20240125-04-025"
         exit 100
   fi
   let cloud_ct=0
   if [ "${load_dbwriter}" == "Y" ]; then
         let cloud_ct=${cloud_ct}+1
   fi
   if [ "${load_ciss_cse}" == "Y" ]; then
         let cloud_ct=${cloud_ct}+2
   fi
   gcp_sdk_dir=$(echo "apps/gcp/google-cloud-sdk/bin")
   GCLOUD_STORAGE_PUSH=(`echo "Y"`)
   year_to_keep=$(echo "${daily_date_format}" | cut -c1-4)
   date_to_keep=$(echo "${daily_date_format}" |cut -c1-8)
   echo "INFO: year -${year_to_keep}"
   echo "INFO: date_to_keep=${date_to_keep}"
   buk_all_buk_dir=$(echo "/data/iac_scan_status/buk/${year_to_keep}/${daily_date_format}/daily_buk")  
   all_date_buk_dir=$(echo "/data/iac_scan_status/buk/${year_to_keep}/${daily_date_format}/all_buk")
   all_date_rpt_dir=$(echo "/data/iac_scan_status/rpt/${year_to_keep}/${daily_date_format}/all_rpt")
   rpt_pipe_processed_file_list_collected_file=$(ls -C1 "/data/iac_scan_status/rpt/${year_to_keep}/${daily_date_format}/rpt_${daily_date_format}_pipe.info")
   rpt_pipe_processed_file_list_collected_file=${rpt_pipe_processed_file_list_collected_file:-NONE}
   if [ "${rpt_pipe_processed_file_list_collected_file}" == "NONE" ]; then
      echo "ERROR: REPORT_PROCESS_DOWNLOAD_INCOMPLETE. ERROR_CODE 100"
      exit 100
   fi
   #CISS_SCAN_RESULT_${date_to_keep}.json
   csv_css_iac_compliance_history_tb_nm=$(echo "CISS_SCAN_RESULT_${date_to_keep}.csv")
   pipe_css_iac_compliance_history_tb_nm=$(echo "CISS_SCAN_RESULT_${date_to_keep}.pipe")
   tab_css_iac_compliance_history_tb_nm=$(echo "CISS_SCAN_RESULT_${date_to_keep}.tab")
   json_css_iac_compliance_history_tb_nm=$(echo "CISS_SCAN_RESULT_${date_to_keep}.json")
   json_css_iac_compliance_history_tb_nm1=$(echo "CISS_SCAN_RESULT_RESOURCE_HISTORY_${date_to_keep}.json")
   all_date_buk_daily_file_name_with_time=$(echo "time_processed_sum_${daily_date_format}_all.pipe")
   col_26_all_date_buk_daily_file_name_with_time=$(echo "time_processed_sum_${daily_date_format}_all_26.pipe")
   all_date_buk_daily_file_name_with_time_data_json=$(echo "time_processed_sum_data_${daily_date_format}_all.json")
   col_26_all_date_buk_daily_file_name_with_time_data_json=$(echo "time_processed_sum_data_${daily_date_format}_all_26.json")
   all_date_buk_daily_file_name=$(echo "final_file_${daily_date_format}_all.pipe")
   declare -a rpt_pipe_processed_file_list_collected_ar
   echo "INFO: CHK_FILE ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}"
   chk_already_done "${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}"
   echo "INFO: FILE_CHK ${rpt_pipe_processed_file_list_collected_file} | grep \"summary_rules_violated_file_26_\""
   rpt_pipe_processed_file_list_collected_ar=$(cat ${rpt_pipe_processed_file_list_collected_file} | grep "summary_rules_violated_file_26_") 
      mkdir -p ${all_date_buk_dir} 
   declare -A time_stamp_unique_keys_hash
   let secs=1
   declare -A acct_tfpid_hash
#"0.0.0.0"|"dafe30ec-325d-4516-85d1-e8e6776f012c"|"S49810_1"|"Azure Instance Using Basic Authentication"|"Best Practices"|"LOW"|"AZURE"|"../../tmp/iac_scan_status/tfp/2024/20241126-48-331/ciss/ciss_tfp_pv_S30624_2076_azure.json"|"1d4132888c7d13b7b750971721a81b43466f5f70a033b2ae7b65b39665f921c2"|"azurerm_linux_virtual_machine"|"eac2staadl10v"|"MissingAttribute"|"azurerm_linux_virtual_machine[vms].admin_ssh_key"|"'azurerm_linux_virtual_machine[vms]' should be using SSH keys for authentication"|"'azurerm_linux_virtual_machine[vms]' is using username and password for authentication"|"KEY_NOT_DEFINED"|"KEY_NOT_DEFINED"|"new-micro20241126164621273-SUB-CORP-EXPCLD-NONPROD-statech-dev-eastus2-vm"|"ECS"|"1732642951"|"statech"|"b7794b7f-d693-4f12-9d55-ff5c9e0d40e2"|"CSE"|"2024-11-26 17:43:12"|"S30624_2076_0.0.0.0_0"|"FAIL"
#cat ${daily_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm} | awk -F "|" '{ OFS="|"; print $0;}' | sed 's/^/{ \"account_id\":\"/' | sed 's/|/\"\,\"vendor_rule_id\":\"/' | sed 's/|/\"\,\"app_name\":\"/' | sed 's/|/\"\,\"pipeline_name\":\"/' | sed 's/|/\"\,\"pipeline_scan_timestamp\":\"/' | sed 's/|/\"\,\"terraform_key\":\"/' | sed 's/|/\"\,\"pipeline_scan_timestamp_utc\":\"/' | sed 's/|/\"\,\"scan_result\":\"/' 
   echo "INFO: f1_rule_id f2_vendor_rule_id f3_unique_property_id f4_rule_name f5_category f6_severity f7_cloud_type f8_plan_file_nm f9_remediation_similar_id f10_resource_name f11_resource_type f12_resource_issue_type f13_resource_search_key f14_resource_key_expected_value f15_resource_key_mismatch_value f16_resource_remediation f17_resource_property_remediation_type f18_env_appnm f19_pipeline_name f20_pipeline_scan_timestamp_utc f21_app_name f22_account_id f23_infra_app_nm f24_pipeline_scan_timestamp f25_iac_terraform_key f26_scan_result"
   #columns of feed. Start 
   #Simulated_Column_from_other_Columns. Start

   secondary_rule_id=$(echo '"secondary_rule_id"')
   terraform_resource_url=$(echo '"terraform_resource_url"')
   rule_detail_desc=$(echo '"rule_detail_desc"')

   #Simulated_Column_from_other_Columns. End
   #Actual_Columns_Name. Start

   rule_id=$(echo '"rule_id"') #col1 
   vendor_rule_id=$(echo '"vendor_rule_id"') #col2
   unique_property_id=$(echo '"unique_property_id"')
   rule_name=$(echo '"rule_name"')
   category=$(echo '"category"')
   resource_property_severity=$(echo '"severity"')
   resource_cloud_type=$(echo '"cloud_type"')
   plan_file_nm=$(echo '"plan_file_nm"')
   remediation_similar_id=$(echo '"remediation_similar_id"')
   resource_name=$(echo '"resource_name"')
   resource_type=$(echo '"resource_type"')
   resource_property_issue_type=$(echo '"resource_issue_type"')
   resource_property_search_key=$(echo '"resource_search_key"')
   resource_property_key_expected_value=$(echo '"resource_key_expected_value"')
   resource_property_key_mismatch_value=$(echo '"resource_key_mismatch_value"')
   resource_property_remediation=$(echo '"resource_remediation"')
   resource_property_remediation_type=$(echo '"resource_property_remediation_type"')
   env_appnm=$(echo '"env_appnm"')
   pipeline_name=$(echo '"pipeline_name"')
   pipeline_scan_timestamp_utc=$(echo '"pipeline_scan_timestamp_utc"')
   app_name=$(echo '"app_name"')
   account_id=$(echo '"account_id"')
   infra_app_nm=$(echo '"infra_app_nm"')  
   pipeline_scan_timestamp=$(echo '"pipeline_scan_timestamp"')
   iac_terraform_key=$(echo '"iac_terraform_key"')
   terraform_key=$(echo '"terraform_key"')
   scan_result=$(echo '"scan_result"') #col26

   #Actual_Columns_Name. Start
   #columns of feed. Start 

   set_adj_key_num=${SET_ADJ_KEY_NUM:-2000}

   rm -rf ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time}
   rm -rf ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time_data_json}
   rm -rf ${all_date_buk_dir}/${col_26_all_date_buk_daily_file_name_with_time}
   rm -rf ${all_date_buk_dir}/${col_26_all_date_buk_daily_file_name_with_time_data_json}
   for all_summary_rpt in `echo "${rpt_pipe_processed_file_list_collected_ar[@]}"` 
   do
       echo "INFO: FILE ${all_date_rpt_dir}/${all_summary_rpt}"
       fields_26_files_only=$(echo "${all_date_rpt_dir}/${all_summary_rpt}" | grep "summary_rules_violated_file_26_")
       fields_26_files_only=${fields_26_files_only:-NONE}
       if [ "${fields_26_files_only}" != "NONE" ]; then
          get_total_fields=$(cat ${all_date_rpt_dir}/${all_summary_rpt} | awk -F "|" '{ OFS="|"; print NF;}' | sort -u | tr '\n' ' '| cut -d " " -f 1)
          get_total_fields=${get_total_fields:-0}
          let tsecs=${set_adj_key_num}
#echo "INFO: f1_rule_id f2_vendor_rule_id f3_unique_property_id f4_rule_name f5_category f6_severity f7_cloud_type f8_plan_file_nm f9_remediation_similar_id f10_resource_name f11_resource_type f12_resource_issue_type f13_resource_search_key f14_resource_key_expected_value f15_resource_key_mismatch_value f16_resource_remediation f17_resource_property_remediation_type f18_env_appnm f19_pipeline_name f20_pipeline_scan_timestamp_utc f21_app_name f22_account_id f23_infra_app_nm f24_pipeline_scan_timestamp f25_iac_terraform_key f26_scan_result"
          if [ ${get_total_fields} -gt 25 ]; then
              while IFS="|"; read f1_rule_id f2_vendor_rule_id f3_unique_property_id f4_rule_name f5_category f6_severity f7_cloud_type f8_plan_file_nm f9_remediation_similar_id f10_resource_name f11_resource_type f12_resource_issue_type f13_resource_search_key f14_resource_key_expected_value f15_resource_key_mismatch_value f16_resource_remediation f17_resource_property_remediation_type f18_env_appnm f19_pipeline_name f20_pipeline_scan_timestamp_utc f21_app_name f22_account_id f23_infra_app_nm f24_pipeline_scan_timestamp f25_iac_terraform_key f26_scan_result #f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26
              do
                 discard_flag=$(echo "N")
                 #echo "INFO: FIELD_PROCESS_START"
                 utc_field=$(echo "${f20_pipeline_scan_timestamp_utc}" | sed 's/\"//g')
                 let utc_field_q=${utc_field}%1000
                 let utc_field=${utc_field}+${utc_field_q}+${tsecs}
                 let tsecs=${tsecs}+1
                 f20_pipeline_scan_timestamp_utc=$(echo "\"${utc_field}\"")
                 SC_RC=$(echo "FAIL")
                 result=$(echo "${f1_rule_id}" | sed 's/\"//g')
                 signature=$(echo "${f25_iac_terraform_key}" | sed 's/\"//g')
                 signature=${signature:-NONE}
                 f22_account_id=$(echo "${f22_account_id}" | sed 's/\"//g' | sed 's/null/NONE/')
                 f22_account_id=${f22_account_id:-NONE}
                 if [ "${signature}" != "NONE" ]; then
                      f25_iac_terraform_key=$(echo "\"${signature}_${utc_field}\"")
                      tfpid=$(echo "${signature}" |  cut -d "_" -f1-2)
                      if [ "${f22_account_id}" == "NONE" ]; then
                        f22_account_id=$(echo "0000-0000-0000-0000-0000")
                        if [ "${f22_account_id}" != "0000-0000-0000-0000-0000" ]; then
                           acct_tfpid_hash["${tfpid}"]=$(echo "${f22_account_id}")
                        fi
                      fi
                      case "${result}" in
                      "0.1.1.1")
                                SC_RC=$(echo "PASS")
                                   ;;
                      "0.0.0.0")
                               SC_RC=$(echo "PASS")
                                   ;;
                      esac
                      f22_account_id=$(echo "\"${f22_account_id}\"")
                      f26_scan_result=$(echo "\"${SC_RC}\"")
                      #echo "1.account_id,2.vendor_rule_id,3.app_name,4.pipeline_name,5.pipeline_scan_timestamp,6.terraform_key,7.pipeline_scan_timestamp_utc,8.scan_result"
                      #echo "INFO: FIELDS: ${f1},${f2},${f3},${f5},${f22},${f19},${f24},${f25},${hf9}:${f20},${hf10}:${f26}"
                      #INFO: FIELDS: "1.27.5.1","CSE-PC-AZURE-MYSQLFLEXIBLESERVER-12751","S08857_1","Governance","ba9be349-ed04-4822-98ff-b7d53acd1232","ECS","2024-11-26 14:49:38","S40954_1390_1.27.5.1_2",:"1732634077",:"FAIL"
#echo "INFO: f1_rule_id f2_vendor_rule_id f3_unique_property_id f4_rule_name f5_category f6_severity f7_cloud_type f8_plan_file_nm f9_remediation_similar_id f10_resource_name f11_resource_type f12_resource_issue_type f13_resource_search_key f14_resource_key_expected_value f15_resource_key_mismatch_value f16_resource_remediation f17_resource_property_remediation_type f18_env_appnm f19_pipeline_name f20_pipeline_scan_timestamp_utc f21_app_name f22_account_id f23_infra_app_nm f24_pipeline_scan_timestamp f25_iac_terraform_key f26_scan_result"
                      col1=$(echo "${f1_rule_id}" | sed 's/\"//g') #Primary_key
                      col1=${col1:-0.0.0.0}
                      col1=$(echo "\"${col1}\"")
                      col2=$(echo "${f2_vendor_rule_id}" | sed 's/\"//g')
                      col2=${col2:-NOT_DEFINED}
                      col2=$(echo "\"${col2}\"")
                      col3=$(echo "${f3_unique_property_id}" | sed 's/\"//g')
                      col3=${col3:-NOT_DEFINED}
                      col3=$(echo "\"${col3}\"")
                      col4=$(echo "${f4_rule_name}" | sed 's/\"//g')
                      col4=${col4:-NOT_DEFINED}
                      col4=$(echo "\"${col4}\"")
                      col5=$(echo "${f5_category}" | sed 's/\"//g')
                      col5=${col5:-NOT_DEFINED}
                      col5=$(echo "\"${col5}\"")
                      col6=$(echo "${f6_severity}" | sed 's/\"//g')
                      col6=${col6:-NOT_DEFINED}
                      col6=$(echo "\"${col6}\"")
                      col7=$(echo "${f7_cloud_type}" | sed 's/\"//g')
                      col7=${col7:-NOT_DEFINED}
                      col7=$(echo "\"${col7}\"")
                      col8=$(echo "${f8_plan_file_nm}" | sed 's/\"//g')
                      col8=${col8:-NOT_DEFINED}
                      col8=$(echo "\"${col8}\"")
                      col9=$(echo "${f9_remediation_similar_id}" | sed 's/\"//g')
                      col9=${col9:-NOT_DEFINED}
                      col9=$(echo "\"${col9}\"")
                      col10=$(echo "${f10_resource_name}" | sed 's/\"//g')
                      col10=${col10:-NOT_DEFINED}
                      col10=$(echo "\"${col10}\"")
                      col11=$(echo "${f11_resource_type}" | sed 's/\"//g')
                      col11=${col11:-NOT_DEFINED}
                      col11=$(echo "\"${col11}\"")
                      col12=$(echo "${f12_resource_issue_type}" | sed 's/\"//g')
                      col12=${col12:-NOT_DEFINED}
                      col12=$(echo "\"${col12}\"")
                      col13=$(echo "${f13_resource_search_key}" | sed 's/\"//g')
                      col13=${col13:-NOT_DEFINED}
                      col13=$(echo "\"${col13}\"")
                      col14=$(echo "${f14_resource_key_expected_value}" | sed 's/\"//g')
                      col14=${col14:-NOT_DEFINED}
                      col14=$(echo "\"${col14}\"")
                      col15=$(echo "${f15_resource_key_mismatch_value}" | sed 's/\"//g')
                      col15=${col15:-NOT_DEFINED}
                      col15=$(echo "\"${col15}\"")
                      col16=$(echo "${f16_resource_remediation}" | sed 's/\"//g')
                      col16=${col16:-NOT_DEFINED}
                      col16=$(echo "\"${col16}\"")
                      col17=$(echo "${f17_resource_property_remediation_type}" | sed 's/\"//g')
                      col17=${col17:-NOT_DEFINED}
                      col17=$(echo "\"${col17}\"")
                      col18=$(echo "${f18_env_appnm}" | sed 's/\"//g')
                      col18=${col18:-NOT_DEFINED}
                      col18=$(echo "\"${col18}\"")
                      col19=$(echo "${f19_pipeline_name}" | sed 's/\"//g')
                      col19=${col19:-NOT_DEFINED}
                      col19=$(echo "\"${col19}\"")
                      col20=$(echo "${f20_pipeline_scan_timestamp_utc}" | sed 's/\"//g') #primary_key
                      col20=${col20:-NOT_DEFINED}
                      col20=$(echo "\"${col20}\"")
                      if [ "${col20}" == "\"NOT_DEFINED\"" ]; then
                            discard_flag=$(echo "Y")
                      fi
                      col21=$(echo "${f21_app_name}" | sed 's/\"//g')
                      col21=${col21:-NOT_DEFINED}
                      col21=$(echo "\"${col21}\"")
                      col22=$(echo "${f22_account_id}" | sed 's/\"//g')
                      col22=${col22:-NOT_DEFINED}
                      col22=$(echo "\"${col22}\"")
                      col23=$(echo "${f23_infra_app_nm}" | sed 's/\"//g')
                      col23=${col23:-NOT_DEFINED}
                      col23=$(echo "\"${col23}\"")
                      col24=$(echo "${f24_pipeline_scan_timestamp}" | sed 's/\"//g') #Primary_key
                      col24=${col24:-NOT_DEFINED}
                      col24=$(echo "\"${col24}\"")
                      if [ "${col24}" == "\"NOT_DEFINED\"" ]; then
                            discard_flag=$(echo "Y")
                      fi
                      col25=$(echo "${f25_iac_terraform_key}" | sed 's/\"//g') #Primary_key
                      col25=${col25:-NOT_DEFINED}
                      col25=$(echo "\"${col25}\"")
                      if [ "${col25}" == "\"NOT_DEFINED\"" ]; then
                            discard_flag=$(echo "Y")
                      fi
                      col26=$(echo "${f26_scan_result}" | sed 's/\"//g')
                      col26=${col26:-NOT_DEFINED}
                      col26=$(echo "\"${col26}\"")

                      #CONSTRAINT css_iac_rule_scan_rc_pk PRIMARY KEY(pipeline_scan_timestamp_utc,pipeline_scan_timestamp,rule_id,iac_terraform_key
                      echo "{${account_id}:${f22_account_id},${vendor_rule_id}:${f2_vendor_rule_id},${app_name}:${f21_app_name},${pipeline_name}:${f19_pipeline_name},${pipeline_scan_timestamp}:${f24_pipeline_scan_timestamp},${terraform_key}:${f25_iac_terraform_key},${pipeline_scan_timestamp_utc}:${f20_pipeline_scan_timestamp_utc},${scan_result}:${f26_scan_result}}" >> ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time}
#{"rule_id":"1.1.1.998","vendor_rule_id":"339ceb82-1fe5-4c95-af17-045c952d1cc0","unique_property_id":"S32836_1","rule_name":""S32836_1"","category":"Secret Management","severity":"LOW","cloud_type":"AZURE", "plan_file_nm":"../../tmp/iac_scan_status/tfp/2024/20241211-50-346/ciss/ciss_tfp_pv_S15894_1832_azure.json","remediation_similar_id":"a7432fb0fe71fc56fe83955e389fd882e0005d09fdbf3126b45bac3f368b9853","resource_name ":"virtual","resource_type":{col11},"resource_property_issue_type":"RedundantAttribute","resource_property_search_key":"NO_VALUE","resource_property_key_expected_value":"Hardcoded secret key should not appear in source","resource_property_key_mismatch_value":"Hardcoded secret key appears in source","resource_property_remediation":"encryption_required","resource_property_remediation_type":"sensitive_data_visibility",:"new-micro20241211215621376-SUB-CORP-EXPCLD-NONPROD-flvms-dev-centralus-vm","pipeline_name":"ECS","pipeline_scan_timestamp_utc":"1733956816","app_name":"flvms","account_id":"b7794b7f-d693-4f12-9d55-ff5c9e0d40e2","infra_app_nm":"CSE","pipeline_scan_timestamp":"2024-12-11 22:00:53","iac_terraform_key":"S15894_1832_1.1.1.998_0_1733956816","scan_result":"FAIL"}
                      if [ "${discard_flag}" == "N" ]; then
                          echo "{${rule_id}:${col1},${vendor_rule_id}:${col2},${unique_property_id}:${col3},${rule_name}:${col4},${category}:${col5},${resource_property_severity}:${col6},${resource_cloud_type}:${col7}, ${plan_file_nm}:${col8},${remediation_similar_id}:${col9},${resource_name}:${col10},${resource_type}:${col11},${resource_property_issue_type}:${col12},${resource_property_search_key}:${col13},${resource_property_key_expected_value}:${col14},${resource_property_key_mismatch_value}:${col15},${resource_property_remediation}:${col16},${resource_property_remediation_type}:${col17},${env_appnm}:${col18},${pipeline_name}:${col19},${pipeline_scan_timestamp_utc}:${col20},${app_name}:${col21},${account_id}:${col22},${infra_app_nm}:${col23},${pipeline_scan_timestamp}:${col24},${iac_terraform_key}:${col25},${scan_result}:${col26}}" >> ${all_date_buk_dir}/${col_26_all_date_buk_daily_file_name_with_time}
                      #echo "" >> ${all_date_buk_dir}/${col_26_all_date_buk_daily_file_name_with_time}
                      fi
                 else
                      echo "INFO: Field 25 Signature is missing. ignoring this record"
                 fi
                 #echo "INFO: FIELD_PROCESS_END"
                 #cat ${all_date_rpt_dir}/${all_summary_rpt} | awk -F "|" '{ OFS="|"; print $22,$2,$23,$19,$24,$25,$20,$26;}' | sed 's/\"//g'
              done < ${all_date_rpt_dir}/${all_summary_rpt}
          fi
       else
            :
       fi
   done #> ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time}
   echo "INFO: output file- ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time}"
   echo "INFO: post-process-output file- ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time_data_json}"
   echo "INFO: all_columns_output file-${all_date_buk_dir}/${col_26_all_date_buk_daily_file_name_with_time}"

   cat ${all_date_buk_dir}/${col_26_all_date_buk_daily_file_name_with_time} | jq '.' | sed 's/}/\}\,/' | tr '\n' ' '  | sed 's/^/{\"data\":\[/' | sed 's/\}\, $/\}\]\}/' | jq '.' > ${all_date_buk_dir}/${col_26_all_date_buk_daily_file_name_with_time_data_json}
   total_all_rec_ct=$(cat ${all_date_buk_dir}/${col_26_all_date_buk_daily_file_name_with_time_data_json} | jq '.data|length')
   col_26_metadata_for_db_writer_header=$(echo '{"truncate_all":false,"truncate_rule_id":false,"dev_db":false,"email":"cse@cvshealth.com","tablename":"css_iac_rule_resource_scan_rc","schema":"cssapp","data":[')
   rm -rf ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm1}
   echo "INFO: CONSOLIDATED_FILE: ${all_date_buk_dir}/${col_26_all_date_buk_daily_file_name_with_time_data_json}, CT ${total_all_rec_ct}"
   if [ "${total_all_rec_ct}" -gt 0 ]; then
           #echo "INFO: metadata ${col_26_metadata_for_db_writer_header}"
           echo "${col_26_metadata_for_db_writer_header}" >${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm1}
           cat ${all_date_buk_dir}/${col_26_all_date_buk_daily_file_name_with_time} | jq '.' | sed 's/}/\}\,/' | tr '\n' ' ' | sed 's/\}\, $/\}\]\}/' >> ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm1}
        ls -C1 ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm1}
        #cat ${all_date_buk_dir}/${all_date_buk_daily_file_name} | awk -F "|" '{ OFS="|"; print $0;}' > ${all_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm}
        #cat ${all_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm} | awk -F "|" '{ OFS="\t"; print $0;}' >> ${all_date_buk_dir}/${tab_css_iac_compliance_history_tb_nm}
        #cat ${all_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm} | awk -F "|" '{ OFS=","; print $0;}' >> ${all_date_buk_dir}/${csv_css_iac_compliance_history_tb_nm}
   else
        echo "${col_26_metadata_for_db_writer_header}]}" >${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm1}
   fi



   cat ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time} | jq '.' | sed 's/}/\}\,/' | tr '\n' ' '  | sed 's/^/{\"data\":\[/' | sed 's/\}\, $/\}\]\}/' | jq '.' > ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time_data_json}
   total_rec_ct=$(cat ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time_data_json} | jq '.data|length')
   metadata_for_db_writer_header=$(echo '{"truncate_all":false,"truncate_rule_id":false,"dev_db":false,"email":"cse@cvshealth.com","tablename":"css_iac_compliance_history","schema":"cssapp","data":[')
   rm -rf ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}
   echo "INFO: CONSOLIDATED_FILE: ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time_data_json}, CT ${total_rec_ct}"
   if [ "${total_rec_ct}" -gt 0 ]; then
           #echo "INFO: metadata ${metadata_for_db_writer_header}"
           #echo "account_id,vendor_rule_id,app_name,pipeline_name,pipeline_scan_timestamp,terraform_key,pipeline_scan_timestamp_utc,scan_result" > ${daily_date_buk_dir}/${csv_css_iac_compliance_history_tb_nm}
           #echo "account_id\tvendor_rule_id\tapp_name\tpipeline_name\tpipeline_scan_timestamp\tterraform_key\tpipeline_scan_timestamp_utc\tscan_result" > ${daily_date_buk_dir}/${tab_css_iac_compliance_history_tb_nm}
           echo "${metadata_for_db_writer_header}" >${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}
           cat ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time} | jq '.' | sed 's/}/\}\,/' | tr '\n' ' ' | sed 's/\}\, $/\}\]\}/' >> ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}
        ls -C1 ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}
        #cat ${all_date_buk_dir}/${all_date_buk_daily_file_name} | awk -F "|" '{ OFS="|"; print $0;}' > ${all_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm}
        #cat ${all_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm} | awk -F "|" '{ OFS="\t"; print $0;}' >> ${all_date_buk_dir}/${tab_css_iac_compliance_history_tb_nm}
        #cat ${all_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm} | awk -F "|" '{ OFS=","; print $0;}' >> ${all_date_buk_dir}/${csv_css_iac_compliance_history_tb_nm}
   else
        echo "${metadata_for_db_writer_header}]}" >${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}
   fi
        #echo "INFO: FINAL_JSON_FILE ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}"
        id_count_from_json_file=$(cat ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm} | jq '.data[].vendor_rule_id' | wc -l)
        if [ "${total_rec_ct}" == "${id_count_from_json_file}" ]; then
             echo "INFO: JSON_FILE_CREATED_AND_VALIDATED. FILE-${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}"
             if [ ${id_count_from_json_file} -eq 0 ]; then
                 echo "INFO: JSON_FILE_CREATED_AND_VALIDATE.Count ${id_count_from_json_file}. NOT_AN_ERROR. NO_SUMMARY_FILES_PROCESSED"
                 exit 0 
             else
                 echo "INFO: LOADING_OPS_WILL_CONTINUE"
             fi
        else
             echo "INFO: JSON_FILE_CREATED_AND_VALIDATE_FAILED. EXIT 110"
             exit 110 
        fi

        id_count_from_all_json_file=$(cat ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm1} | jq '.data[].vendor_rule_id' | wc -l)
        if [ "${total_all_rec_ct}" == "${id_count_from_all_json_file}" ]; then
             echo "INFO: JSON_ALL_FILE_CREATED_AND_VALIDATED. FILE-${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm1}"
             if [ ${id_count_from_all_json_file} -eq 0 ]; then
                 echo "INFO: JSON_ALL_FILE_CREATED_AND_VALIDATE.Count ${id_count_from_all_json_file}. NOT_AN_ERROR. NO_SUMMARY_FILES_PROCESSED"
                 exit 0
             else
                 echo "INFO: LOADING_OPS_WILL_CONTINUE"
             fi
        else
             echo "INFO: JSON_FILE_CREATED_AND_VALIDATE_FAILED. EXIT 110"
             exit 110
        fi


 debug=$(echo "${DEBUG}")

break_step ()
{
    echo "INFO: FUNCTION_NAME break_step"
    if [ "${debug}" == "t" ]; then
        read SSSSS
    fi
}

      echo "INFO: file name to chk- ${all_date_buk_dir}/CISS_SCAN_RESULT_${date_to_keep}.json, ${all_date_buk_dir}/CISS_SCAN_RESULT_RESOURCE_HISTORY_${date_to_keep}.json"
      #ls -ltr ${all_date_buk_dir}/${all_date_buk_daily_file_name}
      ls -ltr ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}
      ls -ltr ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm1}
      #ls -ltr ${all_date_buk_dir}/${csv_css_iac_compliance_history_tb_nm}
      #ls -ltr ${all_date_buk_dir}/${tab_css_iac_compliance_history_tb_nm}
      #ls -ltr ${all_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm}
  my_current_buk_data=$(echo "current_data")
  my_proj_based_service_acct_fqdn=$(echo "current_buk_scan")
  my_proj_jq_json=$(echo '{"current_buk_data":"current_buk_data","my_proj_based_service_acct_fqdn":"my_proj_based_service_acct_fqdn"}')
process_proj_name ()
{
          echo "INFO: TYPE DIRECT FN-NAME process_proj_name"
          #echo "${my_proj_json_info}" | jq '.'
          my_proj_jq_json_from_file=$(cat /apps/.config/proj_info.json 2>/dev/null)
          my_proj_jq_json_from_file=${my_proj_jq_json_from_file:-NONE}
          echo "INFO: my_proj_jq_json_from_file ${my_proj_jq_json_from_file}"
          if [ "${my_proj_jq_json_from_file}" != "NONE" ]; then
             my_current_buk_data=$(echo "${my_proj_jq_json_from_file}" | jq -Mr '.current_buk_data') # | sed 's/\"//g')
             my_proj_based_service_acct_fqdn=$(echo "${my_proj_jq_json_from_file}" | jq -Mr '.current_srv_acct_fqdn') # | sed 's/\"//g')
          else
             my_proj_jq_json=$(echo '{"current_buk_data":"current_buk_data","my_proj_based_service_acct_fqdn":"my_proj_based_service_acct_fqdn"}')
             my_current_buk_data=$(echo "${my_proj_jq_json}" | jq -Mr '.current_buk_data') # | sed 's/\"//g')
             my_proj_based_service_acct_fqdn=$(echo "${my_proj_jq_json}" | jq -Mr '.current_srv_acct_fqdn') # | sed 's/\"//g')
          fi
          echo "INFO: BUCKET_INFO_DATA ${my_current_buk_data}"

          gcloud_acct_if_any=$(/apps/gcp/google-cloud-sdk/bin/gcloud info | grep "Account:" | cut -d ":" -f 2 | sed 's/\[//' | sed 's/\]//' | sed 's/^ //')
          gcloud_acct_if_any=${gcloud_acct_if_any:-NONE}

          echo "INFO: service acct Used: ${gcloud_acct_if_any}"

          if [ "${my_proj_based_service_acct_fqdn}" != "${gcloud_acct_if_any}" ]; then
              GCLOUD_STORAGE_PUSH=(`echo "N"`)
          fi
          echo "INFO: ROOT_FOLDER: ${my_current_buk_data}"
}

load_dbw_gcp ()
{
      echo "INFO: FUNCTION_NAME load_gcp"
      #rec_ct_from_file=$(cat ${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json | jq . | grep "vendor_rule_id" | wc -l)

      if [ "${total_all_rec_ct}" == "${id_count_from_all_json_file}" ]; then
           echo "INFO: JSON_VALIDATION-${all_date_buk_dir}/SCAN_RESULT_${date_to_keep}.json OK"
           echo "INFO: JSON_VALIDATION-${all_date_buk_dir}/CISS_SCAN_RESULT_RESOURCE_HISTORY_${date_to_keep}.json OK"
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}  gs://css-cloud-security-engineering/dbwriter/input/CISS_SCAN_RESULT_${date_to_keep}.json
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm1}  gs://css-cloud-security-engineering/dbwriter/input/CISS_SCAN_RESULT_RESOURCE_HISTORY_${date_to_keep}.json
      else
           echo "ERROR: FEED_PRODUCTION_OF_JSON_FAIL."
           exit 100
      fi
      
      loaded_file=$(/apps/gcp/google-cloud-sdk/bin/gcloud storage ls gs://css-cloud-security-engineering/dbwriter/input/CISS_SCAN_RESULT_RESOURCE_HISTORY_${date_to_keep}.json)
      loaded_file=${loaded_file:-NONE}

      if [ "${loaded_file}" != "NONE" ]; then
          echo "INFO: FILE CISS_SCAN_RESULT_RESOURCE_HISTORY_${date_to_keep}.json LOADED -GCP"
      else
         echo "ERROR: GCP LOAD ERROR- CISS_SCAN_RESULT_RESOURCE_HISTORY_${date_to_keep}.json"
      fi
      loaded_file=$(/apps/gcp/google-cloud-sdk/bin/gcloud storage ls gs://css-cloud-security-engineering/dbwriter/input/CISS_SCAN_RESULT_${date_to_keep}.json)
      loaded_file=${loaded_file:-NONE}

      if [ "${loaded_file}" != "NONE" ]; then
          echo "INFO: FILE CISS_SCAN_RESULT_${date_to_keep}.json LOADED -GCP"
      else
         echo "ERROR: GCP LOAD ERROR- CISS_SCAN_RESULT_${date_to_keep}.json"
      fi
}

load_cse_ciss_gcp ()
{
      echo "INFO: FUNCTION_NAME load_gcp"

      if [ "${total_all_rec_ct}" == "${id_count_from_all_json_file}" ]; then
           echo "INFO: JSON_VALIDATION-${all_date_buk_dir}/SCAN_RESULT_${date_to_keep}.json OK"
           #/apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${daily_date_buk_dir}/${daily_date_buk_daily_file_name}  gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.ppf.pipe
           #/apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${daily_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm}  gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.pipe
           #/apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${daily_date_buk_dir}/${csv_css_iac_compliance_history_tb_nm}  gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.csv
           #/apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${daily_date_buk_dir}/${tab_css_iac_compliance_history_tb_nm}  gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.tab
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}  gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.json
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time_data_json}  gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_WITH_ACCTID_DATA_${date_to_keep}.json

           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm1}  gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_RESOURCE_HISTORY_${date_to_keep}.json
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${all_date_buk_dir}/${col_26_all_date_buk_daily_file_name_with_time_data_json}  gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_RESOURCE_HISTORY_DATA_${date_to_keep}.json
      else
           echo "ERROR: FEED_PRODUCTION_OF_JSON_FAIL."
           exit 100
      fi

      loaded_file=$(/apps/gcp/google-cloud-sdk/bin/gcloud storage ls gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.*)
      loaded_file=${loaded_file:-NONE}

      if [ "${loaded_file}" != "NONE" ]; then
          echo "INFO: FILE CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep} LOADED -GCP"
      else
         echo "ERROR: GCP LOAD ERROR- CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}"
      fi
      loaded_file=$(/apps/gcp/google-cloud-sdk/bin/gcloud storage ls gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_RESOURCE_HISTORY_DATA_${date_to_keep}.*)
      loaded_file=${loaded_file:-NONE}

      if [ "${loaded_file}" != "NONE" ]; then
          echo "INFO: FILE CISS_SCAN_RESULT_RESOURCE_HISTORY_DATA_${date_to_keep} LOADED -GCP"
      else
         echo "ERROR: GCP LOAD ERROR- CISS_SCAN_RESULT_RESOURCE_HISTORY_DATA_${date_to_keep}"
      fi
}
   process_proj_name
   if [ ${cloud_ct} -gt 0 ]; then
         if [ "${GCLOUD_STORAGE_PUSH}" == "N" ]; then
             /apps/bin/gcp_srv_acct_stp.sh
             process_proj_name
         fi
   fi
   if [ "${GCLOUD_STORAGE_PUSH}" == "Y" ]; then
     if [ "${load_dbwriter}" == "Y" ]; then
        echo "INFO: LOADING_DBWRITTER"
        load_dbw_gcp
     else
         echo "INFO: NO_DBWRITER_LOAD"
     fi

     if [ "${load_ciss_cse}" == "Y" ]; then
        echo "INFO: LOADING CISS_CSE_GCP"
        load_cse_ciss_gcp
     else
         echo "INFO: NO_CSE_CISS_LOAD"
     fi
   fi
