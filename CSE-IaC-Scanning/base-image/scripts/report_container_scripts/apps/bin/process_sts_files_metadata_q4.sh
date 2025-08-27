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
   all_date_buk_daily_file_name_with_time=$(echo "time_processed_sum_${daily_date_format}_all.pipe")
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
   echo "INFO: f1_rule_id f2_vendor_rule_id f3_unique_property_id f4_rule_name f5_category f6_severity f7_cloud_type f8_plan_file_nm f9_remediation_similar_id f10_resource_name f11_resource_type f12_resource_issue_type f13_resource_search_key f14_resource_key_expected_value f15_resource_key_mismatch_value f16_resource_remediation f17_resource_property_remediation_type f18_env_appnm f19_pipeline_name f20_pipeline_scan_timestamp_utc f21_app_name f22_acct_id f23_infra_app_nm f24_pipeline_scan_timestamp f25_iac_terraform_key f26_scan_result"
   rule_id=$(echo '"rule_id"')
   secondary_rule_id=$(echo '"secondary_rule_id"')
   unique_property_id=$(echo '"unique_property_id"')
   rule_name=$(echo '"rule_name"')
   rule_detail_desc=$(echo '"rule_detail_desc"')
   resource_name=$(echo '"resource_name "')
   plan_file_nm=$(echo '"plan_file_nm"')
   remediation_similar_id=$(echo '"remediation_similar_id"')
   resource_type=$(echo '"resource_type"')
   resource_property_issue_type=$(echo '"resource_property_issue_type"')
   resource_property_search_key=$(echo '"resource_property_search_key"')
   resource_property_key_expected_value=$(echo '"resource_property_key_expected_value"')
   resource_property_key_mismatch_value=$(echo '"resource_property_key_mismatch_value"')
   resource_property_remediation=$(echo '"resource_property_remediation"')
   resource_property_remediation_type=$(echo '"resource_property_remediation_type"')
   infra_app_nm=$(echo '"infra_app_nm"')  
   acct_id=$(echo '"acct_id"')
   vendor_rule_id=$(echo '"vendor_rule_id"')
   env_app_name=$(echo '"env_app_name"')
   app_name=$(echo '"app_name"')
   pipeline_name=$(echo '"pipeline_name"')
   pipeline_scan_timestamp=$(echo '"pipeline_scan_timestamp"')
   iac_terraform_key=$(echo '"terraform_key"')
   pipeline_scan_timestamp_utc=$(echo '"pipeline_scan_timestamp_utc"')
   scan_result=$(echo '"scan_result"')
   rule_id=$(echo '"rule_id"')
   resource_property_severity=$(echo '"severity"')
   terraform_resource_url=$(echo '"terraform_resource_url"')
   resource_cloud_type=$(echo '"cloud_type"')
   category=$(echo '"category"')
   for all_summary_rpt in `echo "${rpt_pipe_processed_file_list_collected_ar[@]}"` 
   do
       echo "INFO: FILE ${all_date_rpt_dir}/${all_summary_rpt}"
       fields_26_files_only=$(echo "${all_date_rpt_dir}/${all_summary_rpt}" | grep "summary_rules_violated_file_26_")
       fields_26_files_only=${fields_26_files_only:-NONE}
       if [ "${fields_26_files_only}" != "NONE" ]; then
          get_total_fields=$(cat ${all_date_rpt_dir}/${all_summary_rpt} | awk -F "|" '{ OFS="|"; print NF;}' | sort -u | tr '\n' ' '| cut -d " " -f 1)
          get_total_fields=${get_total_fields:-0}
          let tsecs=1000
          if [ ${get_total_fields} -gt 25 ]; then
              while IFS="|"; read f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26
              do
                 #echo "INFO: FIELD_PROCESS_START"
                 utc_field=$(echo "${f20}" | sed 's/\"//g')
                 let utc_field_q=${utc_field}%1000
                 let utc_field=${utc_field}+${utc_field_q}+${tsecs}
                 let tsecs=${tsecs}+1
                 f20=$(echo "\"${utc_field}\"")
                 SC_RC=$(echo "FAIL")
                 result=$(echo "${f1}" | sed 's/\"//g')
                 signature=$(echo "${f25}" | sed 's/\"//g')
                 signature=${signature:-NONE}
                 f22=$(echo "${f22}" | sed 's/\"//g' | sed 's/null/NONE/')
                 f22=${f22:-NONE}
                 if [ "${signature}" != "NONE" ]; then
                      tfpid=$(echo "${signature}" |  cut -d "_" -f1-2)
                      if [ "${f22}" == "NONE" ]; then
                        f22=$(echo "0000-0000-0000-0000-0000")
                        if [ "${f22}" != "0000-0000-0000-0000-0000" ]; then
                           acct_tfpid_hash["${tfpid}"]=$(echo "${f22}")
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
                      f22=$(echo "\"${f22}\"")
                      f26=$(echo "\"${SC_RC}\"")
                      f2=${f2:-NONE}
                      f3=${f3:-NONE}
                      f4=${f4:-NONE}
                      f5=${f5:-NONE}
                      f6=${f6:-NONE}
                      f7=${f7:-NONE}
                      f8=${f8:-NONE}
                      f9=${f9:-NONE}
                      f10=${f10:-NONE}
                      f11=${f11:-NONE}
                      f12=${f12:-NONE}
                      f13=${f13:-NONE}
                      f14=${f14:-NONE}
                      f15=${f15:-NONE}
                      f16=${f16:-NONE}
                      f17=${f17:-NONE}
                      f18=${f18:-NONE}
                      f19=${f19:-NONE}
                      f20=${f20:-NONE}
                      f21=${f21:-NONE}
                      f23=${f23:-NONE}
                      f24=${f24:-NONE}
                      f25=${f25:-NONE}
                      #echo "1.acct_id,2.vendor_rule_id,3.app_name,4.pipeline_name,5.pipeline_scan_timestamp,6.terraform_key,7.pipeline_scan_timestamp_utc,8.scan_result"
                      #echo "INFO: FIELDS: ${f1},${f2},${f3},${f5},${f22},${f19},${f24},${f25},${hf9}:${f20},${hf10}:${f26}"
                      #INFO: FIELDS: "1.27.5.1","CSE-PC-AZURE-MYSQLFLEXIBLESERVER-12751","S08857_1","Governance","ba9be349-ed04-4822-98ff-b7d53acd1232","ECS","2024-11-26 14:49:38","S40954_1390_1.27.5.1_2",:"1732634077",:"FAIL"
                      echo "{${acct_id}:${f22},${vendor_rule_id}:${f2},${app_name}:${f21},${pipeline_name}:${f19},${pipeline_scan_timestamp}:${f24},${iac_terraform_key}:${f25},${pipeline_scan_timestamp_utc}:${f20},${scan_result}:${f26}}"
                 else
                      echo "INFO: Field 25 Signature is missing. ignoring this record"
                 fi
                 #echo "INFO: FIELD_PROCESS_END"
                 #cat ${all_date_rpt_dir}/${all_summary_rpt} | awk -F "|" '{ OFS="|"; print $22,$2,$23,$19,$24,$25,$20,$26;}' | sed 's/\"//g'
              done < ${all_date_rpt_dir}/${all_summary_rpt}
              read SSSSS
          fi
       else
            :
       fi
   done #> ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time}
   read SSSSS
   echo "INFO: output file- ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time}"
   echo "INFO: post-process-output file- ${all_date_buk_dir}/${all_date_buk_daily_file_name}"
   #done > ${daily_date_buk_dir}/${daily_date_buk_daily_file_name}
#duplicate records avoid until new release Start
#  last_tfp_id=$(echo "NONE")
   let tsecs=1000
   while IFS="|"; read  f1 f2 f3 f4 f5 f6 f7 f8  
   do 
      let secs=${f7}+${tsecs}
      echo  "$f1|$f2|$f3|$f4|$f5|$f6|$secs|$f8" 
      let tsecs=${tsecs}+1
   done < ${all_date_buk_dir}/${all_date_buk_daily_file_name_with_time}  > ${all_date_buk_dir}/${all_date_buk_daily_file_name} 
   echo "INFO: FILE_COMPLETED- ${all_date_buk_dir}/${all_date_buk_daily_file_name}"
   ls -C1 ${all_date_buk_dir}/${all_date_buk_daily_file_name}
#duplicate records avoid until new release End
   total_rec_ct=$(cat ${all_date_buk_dir}/${all_date_buk_daily_file_name} | wc -l)
   echo "INFO: CONSOLIDATED_FILE: ${all_date_buk_dir}/${all_date_buk_daily_file_name}, CT ${total_rec_ct}"
   read SSSS
   metadata_for_db_writer_header=$(echo '{"truncate_all":false,"truncate_rule_id":false,"dev_db":false,"email":"cse@cvshealth.com","tablename":"css_iac_compliance_history","schema":"cssapp","data":[')
   if [ "${total_rec_ct}" -gt 0 ]; then
           #echo "INFO: metadata ${metadata_for_db_writer_header}"
           echo "acct_id,vendor_rule_id,app_name,pipeline_name,pipeline_scan_timestamp,terraform_key,pipeline_scan_timestamp_utc,scan_result" > ${daily_date_buk_dir}/${csv_css_iac_compliance_history_tb_nm}
           echo "acct_id\tvendor_rule_id\tapp_name\tpipeline_name\tpipeline_scan_timestamp\tterraform_key\tpipeline_scan_timestamp_utc\tscan_result" > ${daily_date_buk_dir}/${tab_css_iac_compliance_history_tb_nm}
           echo "${metadata_for_db_writer_header}" >${daily_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}

        #echo "INFO: total_rec_ct ${daily_date_buk_dir}/${daily_date_buk_daily_file_name}  ${total_rec_ct}"
           #"account_id": "e33df5d1-ae22-417d-b794-8d9b6f338409",
           #"vendor_rule_id": "38c71c00-c177-4cd7-8d36-cd1007cdb190",
           #"app_name": "RX-Perso",
           #"pipeline_name": "ECS",
           #"pipeline_scan_timestamp": "2024-05-14 20:55:41",
           #"terraform_key": "S03349_1478",
           #"pipeline_scan_timestamp_utc": "1715720141",
           #"scan_result": "FAIL"
        cat ${all_date_buk_dir}/${all_date_buk_daily_file_name} | awk -F "|" '{ OFS="|"; print $0;}' > ${all_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm}
        cat ${all_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm} | awk -F "|" '{ OFS="\t"; print $0;}' >> ${all_date_buk_dir}/${tab_css_iac_compliance_history_tb_nm}
        cat ${all_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm} | awk -F "|" '{ OFS=","; print $0;}' >> ${all_date_buk_dir}/${csv_css_iac_compliance_history_tb_nm}
        cat ${all_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm} | awk -F "|" '{ OFS="|"; print $0;}' | sed 's/^/{ \"account_id\":\"/' | sed 's/|/\"\,\"vendor_rule_id\":\"/' | sed 's/|/\"\,\"app_name\":\"/' | sed 's/|/\"\,\"pipeline_name\":\"/' | sed 's/|/\"\,\"pipeline_scan_timestamp\":\"/' | sed 's/|/\"\,\"terraform_key\":\"/' | sed 's/|/\"\,\"pipeline_scan_timestamp_utc\":\"/' | sed 's/|/\"\,\"scan_result\":\"/' | sed 's/$/\" }\,/' | tr '\n' ' ' | sed 's/}\, $/} ]}/'   >> ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}
   else
        echo "${metadata_for_db_writer_header}]}" >${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}
   fi
        echo "INFO: FINAL_JSON_FILE ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}"
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

 debug=$(echo "${DEBUG}")

break_step ()
{
    echo "INFO: FUNCTION_NAME break_step"
    if [ "${debug}" == "t" ]; then
         read SSSSS
    fi
}

      echo "INFO: file name to chk- ${all_date_buk_dir}/SCAN_RESULT_${date_to_keep}.json"
      ls -ltr ${all_date_buk_dir}/${all_date_buk_daily_file_name}
      ls -ltr ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}
      ls -ltr ${all_date_buk_dir}/${csv_css_iac_compliance_history_tb_nm}
      ls -ltr ${all_date_buk_dir}/${tab_css_iac_compliance_history_tb_nm}
      ls -ltr ${all_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm}

  my_current_buk_data=$(echo "current_data")
  my_proj_based_service_acct_fqdn=$(echo "current_buk_scan")
  my_proj_jq_json=$(echo '{"current_buk_data":"current_buk_data","my_proj_based_service_acct_fqdn":"my_proj_based_service_acct_fqdn"}')
process_proj_name ()
{
          echo "INFO: TYPE DIRECT FN-NAME process_proj_name"
          #echo "${my_proj_json_info}" | jq '.'
          my_proj_jq_json_from_file=$(cat /apps/.config/proj_info.json 2>/dev/null)
          my_proj_jq_json_from_file=${my_proj_jq_json_from_file:-NONE}
          if [ "${my_proj_jq_json_from_file}" != "NONE" ]; then
             my_current_buk_exp=$(echo "${my_proj_jq_json_from_file}" | jq -Mr '.current_buk_exp') # | sed 's/\"//g')
             my_current_buk_scan=$(echo "${my_proj_jq_json_from_file}" | jq -Mr '.current_buk_scan') # | sed 's/\"//g')
             my_proj_based_service_acct_fqdn=$(echo "${my_proj_jq_json_from_file}" | jq -Mr '.current_srv_acct_fqdn') # | sed 's/\"//g')
          else
             my_proj_jq_json=$(echo '{"current_buk_data":"current_buk_data","my_proj_based_service_acct_fqdn":"my_proj_based_service_acct_fqdn"}')
             my_current_buk_data=$(echo "${my_proj_jq_json}" | jq -Mr '.current_buk_data') # | sed 's/\"//g')
             my_proj_based_service_acct_fqdn=$(echo "${my_proj_jq_json}" | jq -Mr '.current_srv_acct_fqdn') # | sed 's/\"//g')
          fi
          echo "INFO: BUCKET_INFO_DATA ${my_current_buk_data}"

          gcloud_acct_if_any=$(gcloud info | grep "Account:" | cut -d ":" -f 2 | sed 's/\[//' | sed 's/\]//' | sed 's/^ //')
          gcloud_acct_if_any=${gcloud_acct_if_any:-NONE}

          echo "INFO: service acct Used: ${gcloud_acct_if_any}"

          if [ "${my_proj_based_service_acct_fqdn}" != "${gcloud_acct_if_any}" ]; then
              GCLOUD_STORAGE_PUSH=(`echo "N"`)
          fi
}


load_dbw_gcp ()
{
      echo "INFO: FUNCTION_NAME load_gcp"
      #rec_ct_from_file=$(cat ${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json | jq . | grep "vendor_rule_id" | wc -l)

      if [ "${total_rec_ct}" == "${id_count_from_json_file}" ]; then
           echo "INFO: JSON_VALIDATION-${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json OK"
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${all_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}  gs://css-cloud-security-engineering/dbwriter/input/CISS_SCAN_RESULT_${date_to_keep}.json
      else
           echo "ERROR: FEED_PRODUCTION_OF_JSON_FAIL."
           exit 100
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

      if [ "${total_rec_ct}" == "${id_count_from_json_file}" ]; then
           echo "INFO: JSON_VALIDATION-${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json OK"
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${daily_date_buk_dir}/${daily_date_buk_daily_file_name}  gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.ppf.pipe
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${daily_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm}  gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.pipe
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${daily_date_buk_dir}/${csv_css_iac_compliance_history_tb_nm}  gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.csv
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${daily_date_buk_dir}/${tab_css_iac_compliance_history_tb_nm}  gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.tab
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${daily_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}  gs://${my_current_buk_data}/iac_scan_processed/${daily_date_format}/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.json
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
}
     if [ "${load_dbwriter}" == "Y" ]; then
        echo "INFO: LOADING_DBWRITTER"
        /apps/bin/gcp_srv_acct_stp.sh
        process_proj_name
        load_dbw_gcp
     else
         echo "INFO: NO_DBWRITER_LOAD"
     fi

     if [ "${load_ciss_cse}" == "Y" ]; then
        echo "INFO: LOADING CISS_CSE_GCP"
        /apps/bin/gcp_srv_acct_stp.sh
        process_proj_name
        load_cse_ciss_gcp
     else
         echo "INFO: NO_CSE_CISS_LOAD"
     fi
