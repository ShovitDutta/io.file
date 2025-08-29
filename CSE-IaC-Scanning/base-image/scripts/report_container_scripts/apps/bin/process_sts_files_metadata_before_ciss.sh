#!/usr/bin/env sh


 daily_date_format=${1:-NONE}
 load_dbwriter=${2:-N}
 load_ciss_cse=${3:-N}
 already_done=${4:-Y}
 DEBUG=${5:-n}

#all_tf_list.info
#dups_tf_list.info
#ecs_tf_list.info
#err_tf_list.info
#gcp_tf_list.info
#tf_list.info

chk_already_done ()
{
      echo "INFO: FUNCTION_NAME chk_already_done"    
      if [ "${already_done}" == "Y" ]; then
           #echo "INFO: CHECK_JSON_FILE ${1}"
           file_to_check=$(ls -C1 ${1} 2>/dev/null)
           file_to_check=$file_to_check:-NONE}
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
   
   daily_date_format_dir=$(echo "/data/iac_scan_status/sts/${year_to_keep}/${daily_date_format}/all_sts/post_processed")
   daily_date_sts_dir=$(echo "/data/iac_scan_status/sts/${year_to_keep}/${daily_date_format}/all_sts")
   daily_date_buk_dir=$(echo "/data/iac_scan_status/buk/${year_to_keep}/${daily_date_format}/daily_buk")
   daily_date_buk_daily_file_name=$(echo "ppf_${daily_date_format}_all.pipe")
   daily_date_buk_daily_file_name_with_time=$(echo "time_processed_ppf_${daily_date_format}_all.pipe")
   #CISS_SCAN_RESULT_${date_to_keep}.json
   csv_css_iac_compliance_history_tb_nm=$(echo "CISS_SCAN_RESULT_${date_to_keep}.csv")
   pipe_css_iac_compliance_history_tb_nm=$(echo "CISS_SCAN_RESULT_${date_to_keep}.pipe")
   tab_css_iac_compliance_history_tb_nm=$(echo "CISS_SCAN_RESULT_${date_to_keep}.tab")
   json_css_iac_compliance_history_tb_nm=$(echo "CISS_SCAN_RESULT_${date_to_keep}.json")

   chk_already_done "${daily_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}"
   chk_post_processed_file_ct=$(ls -C1 ${daily_date_format_dir} 2>/dev/null | wc -l)
   chk_sts_files_ct=$(ls -C1 ${daily_date_sts_dir}/S*.pipe 2>/dev/null | grep -v "_tf.pipe" 2>/dev/null | wc -l)

   
   echo "INFO: (chk_post_processed_file_ct,chk_sts_files_ct),(${chk_post_processed_file_ct},${chk_sts_files_ct})"
   if [ "${chk_post_processed_file_ct}" == "${chk_sts_files_ct}" ]; then
      echo "INFO: PRE_POST_VALIDATION_OK"
      mkdir -p ${daily_date_buk_dir} 
      rm -rf ${daily_date_buk_dir}/${daily_date_buk_daily_file_name}
   else
      mkdir -p ${daily_date_buk_dir} 
      rm -rf ${daily_date_buk_dir}/${daily_date_buk_daily_file_name}
      #echo "ERROR: PRE_POST_VALIDATION_ERROR. COUNT_MISMATCH. EXIT 100"
      #exit 100
   fi
   sts_post_processed_file_list_collected=()
   #sts_post_processed_file_list_collected=$(ls -C1 ${daily_date_format_dir})
   sts_post_processed_file_list_collected=$(ls -C1 ${daily_date_sts_dir} 2>/dev/null | grep "summary_rules_violated_file_")
   echo "INFO: sts_post_processed_file_list_collected ${sts_post_processed_file_list_collected[@]}"
   declare -A time_stamp_unique_keys_hash
   let secs=1
   for all_ppf in `echo "${sts_post_processed_file_list_collected[@]}"` 
   do
       fields_26_files_only=$(echo "${daily_date_sts_dir}/${all_ppf}" | grep "_26_")
       fields_26_files_only=${fields_26_files_only:-NONE}
       if [ "${fields_26_files_only}" != "NONE" ]; then
          get_total_fields=$(cat ${daily_date_sts_dir}/${all_ppf} | awk -F "|" '{ OFS="|"; print NF;}' | sort -u | tr '\n' ' '| cut -d " " -f 1)
          get_total_fields=${get_total_fields:-0}
          if [ ${get_total_fields} -gt 24 ]; then
               #cat ${daily_date_sts_dir}/${all_ppf} | grep "|AZURE|" | awk -F "|" '{ OFS="|"; print $23,$2,$22,$19,$24,$25,$21;}'
               cat ${daily_date_sts_dir}/${all_ppf} | awk -F "|" '{ OFS="|"; print $22,$2,$23,$19,$24,$25,$21,$26;}' | sed 's/\"//g'
          else
            : 
          fi
       else
            :
       fi
   #done > ${daily_date_buk_dir}/${daily_date_buk_daily_file_name_with_time}
   done > ${daily_date_buk_dir}/${daily_date_buk_daily_file_name}
#duplicate records avoid until new release Start
#  last_tfp_id=$(echo "NONE")
#   while IFS="|"; read  f1 f2 f3 f4 f5 f6 f7  
#   do 
#      if [ "${last_tfp_id}" == "NONE" ]; then
#            last_tfp_id=$(echo "${f6}")
#      else
#            if [ "${f6}" == "${last_tfp_id}" ]; then
#                   :
#            else
#                last_tfp_id=$(echo "${f6}")
#                let secs=1
#            fi
#      fi
#      y=$(let secs=${secs}%60; printf "%02d" $secs)
#      mf5=$(echo "$f5" | cut -d ":" -f 1-2)
#      echo  "$f1|$f2|$f3|$f4|$mf5:$y|$f6|$f7" 
#      let secs=${secs}+1
#   done < ${daily_date_buk_dir}/${daily_date_buk_daily_file_name_with_time} > ${daily_date_buk_dir}/${daily_date_buk_daily_file_name} 
#duplicate records avoid until new release End
   total_rec_ct=$(cat ${daily_date_buk_dir}/${daily_date_buk_daily_file_name} | wc -l)
   echo "INFO: CONSOLIDATED_FILE: ${daily_date_buk_dir}/${daily_date_buk_daily_file_name}, CT ${total_rec_ct}"

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
        cat ${daily_date_buk_dir}/${daily_date_buk_daily_file_name} | awk -F "|" '{ OFS="|"; print $0;}' > ${daily_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm}
        cat ${daily_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm} | awk -F "|" '{ OFS="\t"; print $0;}' >> ${daily_date_buk_dir}/${tab_css_iac_compliance_history_tb_nm}
        cat ${daily_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm} | awk -F "|" '{ OFS=","; print $0;}' >> ${daily_date_buk_dir}/${csv_css_iac_compliance_history_tb_nm}
        cat ${daily_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm} | awk -F "|" '{ OFS="|"; print $0;}' | sed 's/^/{ \"account_id\":\"/' | sed 's/|/\"\,\"vendor_rule_id\":\"/' | sed 's/|/\"\,\"app_name\":\"/' | sed 's/|/\"\,\"pipeline_name\":\"/' | sed 's/|/\"\,\"pipeline_scan_timestamp\":\"/' | sed 's/|/\"\,\"terraform_key\":\"/' | sed 's/|/\"\,\"pipeline_scan_timestamp_utc\":\"/' | sed 's/|/\"\,\"scan_result\":\"/' | sed 's/$/\" }\,/' | tr '\n' ' ' | sed 's/}\, $/} ]}/'   >> ${daily_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}
   else
        echo "${metadata_for_db_writer_header}]}" >${daily_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}
   fi
        echo "INFO: FINAL_JSON_FILE ${daily_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}"
        id_count_from_json_file=$(cat ${daily_date_buk_dir}/${json_css_iac_compliance_history_tb_nm} | jq '.data[].vendor_rule_id' | wc -l)
        if [ "${total_rec_ct}" == "${id_count_from_json_file}" ]; then
             echo "INFO: JSON_FILE_CREATED_AND_VALIDATED. FILE-${daily_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}"
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

      echo "INFO: file name to chk- ${daily_date_buk_dir}/SCAN_RESULT_${date_to_keep}.json"
      ls -ltr ${daily_date_buk_dir}/${daily_date_buk_daily_file_name}
      ls -ltr ${daily_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}
      ls -ltr ${daily_date_buk_dir}/${csv_css_iac_compliance_history_tb_nm}
      ls -ltr ${daily_date_buk_dir}/${tab_css_iac_compliance_history_tb_nm}
      ls -ltr ${daily_date_buk_dir}/${pipe_css_iac_compliance_history_tb_nm}

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
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${daily_date_buk_dir}/${json_css_iac_compliance_history_tb_nm}  gs://css-cloud-security-engineering/dbwriter/input/CISS_SCAN_RESULT_${date_to_keep}.json
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
        process_proj_name
        /apps/bin/gcp_srv_acct_stp.sh
        load_cse_ciss_gcp
     else
         echo "INFO: NO_CSE_CISS_LOAD"
     fi
