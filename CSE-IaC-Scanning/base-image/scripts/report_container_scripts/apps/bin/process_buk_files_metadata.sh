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


   if  [ "${daily_date_format}" == "NONE" ]; then
         echo "ERROR: Parameter daily_date_format required."
         #echo "INFO: Usage- $0 /data/iac_scan_status/buk/2024/20240125-04-025"
         echo "INFO: Usage- $0 20240125-04-025"
         exit 100
   fi

   year_to_keep=$(echo "${daily_date_format}" | cut -c1-4)
   date_to_keep=$(echo "${daily_date_format}" |cut -c1-8)
   echo "INFO: year -${year_to_keep}"
   echo "INFO: date_to_keep=${date_to_keep}"
   
   daily_date_format_dir=$(echo "/data/iac_scan_status/buk/${year_to_keep}/${daily_date_format}")
   chk_dir=$(ls -C1 ${daily_date_format_dir} 2>/dev/null)
   chk_dir=${chk_dir:-NONE}

   buk_file_list_collected=()
   buk_file_tfpid_list_collected=()
   collect_all_tfp_app_name_subid_files=()

   declare -A buk_file_tfpid_list_collected_hash
   declare -A tfp_file_tfpid_list_collected_hash
   declare -A collect_all_tfp_app_name_subid_files_hash

   if  [ "${chk_dir}" == "NONE" ]; then
         echo "ERROR: daily_date_format_dir not_found"
         exit 101
   else
        #echo "INFO: ${chk_dir}"
        buk_file_list_collected=(`ls -C1 ${daily_date_format_dir}/daily_buk | grep _tfplan | grep _json`) # | tr '\n' ' ')
        buk_file_tfpid_list_collected=(`ls -C1 ${daily_date_format_dir}/daily_buk | grep _tfplan | grep _json | cut -d "_" -f1-2 | sort -u`) # | tr '\n' ' ')
       
        echo "INFO: FILES_TO_PROCESS_CT ${#buk_file_list_collected[@]}"
   fi
    buk_files_ct_to_process=$(echo "${#buk_file_list_collected[@]}")

    mkdir -p ${daily_date_format_dir}/all_buk/errors
    mkdir -p ${daily_date_format_dir}/all_buk/processed

    rm -rf ${daily_date_format_dir}/all_buk/errors/${daily_date_format}.err
    rm -rf ${daily_date_format_dir}/all_buk/processed/${daily_date_format}.processed


 tfp_processed_files_dir=$(echo "/data/iac_scan_status/tfp/${year_to_keep}/${daily_date_format}/${date_to_keep}/tfp")

 collect_all_tfp_app_name_subid_files=(`ls -C1 ${tfp_processed_files_dir}/S*.info`)

 for all_tfps in `echo "${collect_all_tfp_app_name_subid_files[@]}"`
 do
    #echo "INFO: FILE ${all_tfps}"
    test_size=$([ -s ${all_tfps} ] && echo "${all_tfps}")
    test_size=${test_size:-NONE}
    if [ "${test_size}" != "NONE" ]; then
        tfp_bsn=$(basename ${all_tfps} | cut -d "." -f 1)
        tfp_file_tfpid_list_collected_hash[${tfp_bsn}]=${all_tfps}
    else
        echo "INFO: zero_byte_file ${all_tfps}"
    fi
 done
 
    tfp_unique_keys_ct=$(echo "${#tfp_file_tfpid_list_collected_hash[@]}")
    echo "INFO: tfpid_from_tfp_dir count tfp_unique_keys_ct ${tfp_unique_keys_ct}"

    processed_tfp_subid_rel_ct=$(echo "${#collect_all_tfp_app_name_subid_files[@]}")

    echo "INFO: processed_tfp_subid_rel_ct ${processed_tfp_subid_rel_ct}"

   #for all_buks in `echo "${buk_file_tfpid_list_collected[@]}"`
   for all_buks in `echo "${buk_file_list_collected[@]}"`
   do
        #echo "INFO: buk_file ${all_buks}"
        #cat ${daily_date_format_dir}/daily_buk/${all_buks} | jq '.runs[]'| jq '.results[0]'
        check_result_null=$(cat ${daily_date_format_dir}/daily_buk/${all_buks} | jq '.queries[0]')
        if [ "${check_result_null}" != "null" ]; then
           #echo "INFO: check_result_null ${check_result_null}"
           clip_tfpid=$(echo "${all_buks}" | cut -d"_" -f 1-2)
           buk_file_tfpid_list_collected_hash[${clip_tfpid}]=${all_buks}
        else
           echo "INFO: result_sarif ${all_buks} ${check_result_null}"
        fi
   done
   buk_unique_keys_ct=$(echo "${#buk_file_tfpid_list_collected_hash[@]}")

   echo "INFO: tfpid_from_buk_dir count buk_unique_keys_ct ${buk_unique_keys_ct}"

   #for all_tfps in `echo "${collect_all_tfp_app_name_subid_files[@]}"`
   #for all_tfps in `echo "${!tfp_file_tfpid_list_collected_hash[@]}"`
   for all_tfps in `echo "${!buk_file_tfpid_list_collected_hash[@]}"`
   do
        #echo "INFO: all_tfps ${all_tfps}"
        get_file=$(echo "${tfp_file_tfpid_list_collected_hash[${all_tfps}]}")
        #echo "INFO: FILE_FROM_TFP_DIR ${get_file}"
        bsn=$(basename ${get_file})
        tfpid_only=$(echo "${bsn}" | cut -d "." -f 1)
        #echo "INFO: bsn ${tfpid_only}"
        get_processed_buk=$(echo "${buk_file_tfpid_list_collected_hash[${tfpid_only}]}")
        #get_processed_buk=$(echo "${[${tfpid_only}]}")
        get_processed_buk=${get_processed_buk:-NONE}
        if [ "${get_processed_buk}" != "NONE" ]; then
           collect_all_tfp_app_name_subid_files_hash[${all_tfps}]=${all_tfps}
           #echo "INFO: FILE_TFP_PROCESSED_${all_tfps} ${get_file}" 
           echo "INFO: FILE_TFP_PROCESSED_${all_tfps} ${get_file}" >> ${daily_date_format_dir}/all_buk/processed/${daily_date_format}.processed
        else
           #echo "INFO: FILE_TFP_NOT_PROCESSED_${all_tfps} ${get_file}"
           echo "INFO: FILE_TFP_NOT_PROCESSED_${all_tfps} ${get_file}" >> ${daily_date_format_dir}/all_buk/errors/${daily_date_format}.err
        fi
   done
   tfp_buk_unique_keys_ct=$(echo "${#collect_all_tfp_app_name_subid_files_hash[@]}")
   echo "INFO: tfp_buk_verified_dir count tfp_buk_unique_keys_ct ${tfp_buk_unique_keys_ct}"

   error_file_inf_any=$(ls -C1 ${daily_date_format_dir}/all_buk/errors/${daily_date_format}.err 2>/dev/null)
   error_file_inf_any=${error_file_inf_any:-NONE}
   if [ "${error_file_inf_any}" != "NONE" ]; then
        echo "INFO: error_file ${error_file_inf_any}"
        echo "INFO: buk_processed_result_file ${daily_date_format_dir}/all_buk/processed/${daily_date_format}.processed"
   else
        echo "INFO: buk_processed_result_file ${daily_date_format_dir}/all_buk/processed/${daily_date_format}.processed"
   fi
 if [ ${#collect_all_tfp_app_name_subid_files_hash[@]} -eq ${#buk_file_tfpid_list_collected_hash[@]} ]; then
     echo "INFO: tfp_info and pipeline count match."
 else
     echo "INFO: COUNT_COMPARISON- tfp_location:  ${#collect_all_tfp_app_name_subid_files_hash[@]} buk_location ${#buk_file_tfpid_list_collected_hash[@]}"
     echo "ERROR: tfp_info and pipeline count mis_match"
     exit 130
 fi

 declare -A buk_hash
 declare -A buk_files_hash
 declare -A tfp_buk_rel_hash

#2023_10_13-15_46_50-1697212010-41_2023-286
  build_id_run_str=$(date '+%Y_%m_%d-%H_%M_%S-%s-%W_%Y-%j')
#20231013-15_46_50-1697212010-41_2023-286
  Ymd=$(echo "${build_id_run_str}" | cut -d "-" -f 1)
  YEAR=$(echo "${Ymd}" | cut -d "_" -f 1)
  MONTH=$(echo "${Ymd}" | cut -d "_" -f 2)
  DAY_OF_MONTH=$(echo "${Ymd}" | cut -d "_" -f 3)
#20231013
  RUN_DATE=$(echo "${YEAR}${MONTH}${DAY_OF_MONTH}")
  RUN_DATE_DB=$(echo "${YEAR}-${MONTH}-${DAY_OF_MONTH}")
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

 buk_root=$(echo "${daily_date_format_dir}/${date_to_keep}/buk")
 buk_info_root=$(echo "${daily_date_format_dir}/${date_to_keep}/buk/info")
 buk_status_root=$(echo "${daily_date_format_dir}/${date_to_keep}/buk/status")
 buk_key_root=$(echo "${daily_date_format_dir}/${date_to_keep}/buk/keys")
 buk_all_buk_dir=$(echo "${daily_date_format_dir}/all_buk")
 buk_daily_dir=$(echo "${daily_date_format_dir}/daily_buk")

 #mkdir -p ${buk_root}
 #mkdir -p ${buk_info_root}
 #mkdir -p ${buk_status_root}
 #mkdir -p ${buk_key_root}

 #process_completed=()
 #process_completed=(`cat ${buk_status_root}/buk_root_key_process_status.info 2>/dev/null | wc -l`)
 process_completed=$(ls -C1  ${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json 2>/dev/null)
 process_completed=${process_completed:-NONE}

   if [ "${already_done}" == "Y" ]; then
 
       if [ ${process_completed} != "NONE" ]; then
         tfp_key_ct=$(cat ${process_completed} | jq .data[].terraform_key | sort -u | wc -l)
         #if [ ${buk_files_ct_to_process} -eq ${tfp_key_ct} ]; then
         if [ ${buk_unique_keys_ct} -eq ${tfp_key_ct} ]; then
            echo "INFO: PROCESS_ALREADY_COMPLETED_NOTHING_TO_DO (${process_completed},${buk_files_ct_to_process})"
            exit 0
         else
            echo "INFO: FILE ${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json, YET_TO_CREATE, DUE_TO_MIS_MATCH_REC_CT"
         fi
      else
         echo "INFO: FILE ${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json, YET_TO_CREATE"
         echo "INFO: $0 PROCESS_WILL_CONTINUE (${process_completed},${buk_files_ct_to_process})"
      fi 
   else
      echo "INFO: over_rule-reprocess"
   fi
 
 appnm=$(echo "NONE")

 debug=$(echo "${DEBUG}")

break_step ()
{
    echo "INFO: FUNCTION_NAME break_step"
    if [ "${debug}" == "t" ]; then
         read SSSSS
    fi
}

create_buk_tfp_rel ()
{
   echo "INFO: FUNCTION_NAME create_buk_tfp_rel"
   for all_buk_tfp_files in `echo "${collect_all_tfp_app_name_subid_files[@]}"`
   do
      clip_tfp_nm=$(basename ${all_buk_tfp_files} | cut -d "." -f 1)
      #echo "INFO: KEY ${clip_tfp_nm} and file ${all_buk_tfp_files}"
      tfp_buk_rel_hash[${clip_tfp_nm}]=${all_buk_tfp_files}
   done

}

  create_buk_tfp_rel
# sed 's/-'${SS}'/\,'${SS}'/' awk -F "-" '{ print $NF;}'
#vendor_rule_id,rule_name,pipeline_id,appname,timestamp,terraform_key,utc_time,result

      metadata_for_db_writer_header=$(echo '{"truncate_all":false,"truncate_rule_id":false,"dev_db":false,"email":"cse@cvshealth.com","tablename":"css_iac_compliance_history","schema":"cssapp","data":[')

      #echo "INFO: metadata ${metadata_for_db_writer_header}"
      cd ${buk_daily_dir}
      echo_vars
      rm -rf ${buk_all_buk_dir}/SCAN_RESULT_ALL_PRE_${date_to_keep}.json
      SCAN_RESULT_ALL_CSV=()
      #echo "vendor_rule_id,rule_name,appname,pipeline_id,timestamp,terraform_key,utc_time,result" >${buk_all_buk_dir}/SCAN_RESULT_ALL_${date_to_keep}.csv
      echo "acct_id,vendor_rule_id,app_name,pipeline_name,pipeline_scan_timestamp,terraform_key,pipeline_scan_timestamp_utc,scan_result" >${buk_all_buk_dir}/SCAN_RESULT_WITH_ACCTID_${date_to_keep}.csv
      echo "${metadata_for_db_writer_header}" >${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json
      let rule_ct=0
      #for all in `echo "${buk_file_list_collected[@]}"`
      for all in `echo "${buk_file_tfpid_list_collected_hash[@]}"`
      do
            #echo "INFO: ${all}"
            file_buk=$(echo "${all}")
            #S64180_988_tfplan.kics_json.R-20240305-21_40_55-1709674855-102024-065-1709674855-Alexei-Simons-patch-1-ECS.bucket
            fields_needed=()
            terraform_key=$(echo "${all}" | cut -d "_" -f 1-2)
            tfp_rel_file=$(echo "${tfp_buk_rel_hash[${terraform_key}]}")
            tfp_rec=()
            tfp_rec=$(cat ${tfp_rel_file})
            #echo "INFO: tfp_rec ${tfp_rec}"
            #read_application=()
            real_application=$(echo "${tfp_rec}" | cut -d "|" -f 3)
            subscription_id=$(echo "${tfp_rec}" | cut -d "|" -f 4 | sed 's/\"//g')
            timestamp=()
            timestamp=$(echo "${all}" | cut -d "-" -f 2-3 | sed 's/-/ /' | sed 's/_/:/g' | sed -E 's,([0-9]{4})([0-9]{2})([0-9]{2}),\1-\2-\3,g')
            utc_time=$(echo "${all}" | cut -d "-" -f 4)
            tail_clip=$(echo "${all}" | cut -d "-" -f 8- | cut -d "." -f 1)
            appname=$(echo "${tail_clip}" | awk -F "-" '{ print $NF;}')
            pipeline_id_and_appname=$(echo "${tail_clip}" | sed 's/-'${appname}'/|'${appname}'/')
            just_pipeline_id=$(echo "${pipeline_id_and_appname}" | cut -d "|" -f 2)
            #pipeline_id_and_appname=$(echo "${tail_clip}" | sed 's/-'${appname}'/|'${real_application}'/')
            #suffix_fields=$(echo "${pipeline_id_and_appname}|${timestamp[@]}|${terraform_key}|${utc_time}|FAIL")
            suffix_fields=$(echo "${real_application}|${just_pipeline_id}|${timestamp[@]}|${terraform_key}|${utc_time}|FAIL")

            #echo "INFO: real_application ${real_application}, ${subscription_id}, ${pipeline_id_and_appname}"
            tmp_ar=()
            #echo "INFO: CMD cat ${daily_date_format_dir}/daily_buk/${all}"
            tmp_ar=$(cat ${daily_date_format_dir}/daily_buk/${all}  | jq .queries[] | jq -r  '.|[ .query_id,.query_name,.files[0].resource_type,.severity,.cloud_provider,.files[0].issue_type,.files[0].expected_value,.files[0].remediation_type,.files[0].line,.description] | join("|")' | tr ' ' '_' |  sed 's/\,//g' | cut -d "|" -f 1)
            last_row=$(echo "${#tmp_ar[@]}")
            for all_fields in `echo "${tmp_ar[@]}"`
            do
                 #echo "${all_fields}|${suffix_fields}" | sed 's/|/\,/g' | sed 's/_/ /g' >>${buk_all_buk_dir}/SCAN_RESULT_ALL_${date_to_keep}.csv
                 let rule_ct=${rule_ct}+1 
                 #echo "INFO XXXXXXXXXXXXXX rule_ct = ${rule_ct}  total_rule_ct =${last_row}"
                 #echo "{\"run_date\":\"${RUN_DATE_DB}\"|${all_fields}|${suffix_fields}" | sed 's/|/\,\"vendor_rule_id\":\"/' | sed 's/|/\"\,\"app_name\":\"/' | sed 's/|/\"\,\"pipeline_name\":\"/' | sed 's/|/\"\,\"pipeline_scan_timestamp\":\"/' | sed 's/|/\"\,\"terraform_key\":\"/' | sed 's/|/\"\,\"pipeline_scan_timestamp_utc\":\"/' | sed 's/|/\"\,\"scan_result\":\"/' | sed 's/$/\"\},/'
                 #echo "${all_fields}|${suffix_fields}" | sed 's/^/{\"vendor_rule_id\":\"/' | sed 's/|/\"\,\"app_name\":\"/' | sed 's/|/\"\,\"pipeline_name\":\"/' | sed 's/|/\"\,\"pipeline_scan_timestamp\":\"/' | sed 's/|/\"\,\"terraform_key\":\"/' | sed 's/|/\"\,\"pipeline_scan_timestamp_utc\":\"/' | sed 's/|/\"\,\"scan_result\":\"/' | sed 's/$/\"\},/'
                 echo "${subscription_id}|${all_fields}|${suffix_fields}" | sed 's/^/{\"account_id\":\"/' | sed 's/|/\"\,\"vendor_rule_id\":\"/' | sed 's/|/\"\,\"app_name\":/' | sed 's/|/\,\"pipeline_name\":\"/' | sed 's/|/\"\,\"pipeline_scan_timestamp\":\"/' | sed 's/|/\"\,\"terraform_key\":\"/' | sed 's/|/\"\,\"pipeline_scan_timestamp_utc\":\"/' | sed 's/|/\"\,\"scan_result\":\"/' | sed 's/$/\"\},/'
                 echo "${subscription_id}|${all_fields}|${suffix_fields}" >> ${buk_all_buk_dir}/SCAN_RESULT_WITH_ACCTID_${date_to_keep}.pipe
                 echo "${subscription_id}|${all_fields}|${suffix_fields}" | sed 's/|/\,/g' >> ${buk_all_buk_dir}/SCAN_RESULT_WITH_ACCTID_${date_to_keep}.csv
                 echo "${subscription_id}|${all_fields}|${suffix_fields}" | sed 's/|/\t/g' >> ${buk_all_buk_dir}/SCAN_RESULT_WITH_ACCTID_${date_to_keep}.tab
            done >> ${buk_all_buk_dir}/SCAN_RESULT_ALL_PRE_${date_to_keep}.json
            
      done  #>> ${buk_all_buk_dir}/SCAN_RESULT_ALL_PRE_${date_to_keep}.csv
      echo "INFO: rule_ct ${rule_ct}"
      cat ${buk_all_buk_dir}/SCAN_RESULT_ALL_PRE_${date_to_keep}.json | tr '\n' ' ' |  sed 's/\, $/]}/' >> ${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json

      echo "INFO: file name to chk- ${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json"
      ls -ltr ${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json
      ls -ltr ${buk_all_buk_dir}/SCAN_RESULT_WITH_ACCTID_${date_to_keep}.csv
      ls -ltr ${buk_all_buk_dir}/SCAN_RESULT_WITH_ACCTID_${date_to_keep}.pipe
      ls -ltr ${buk_all_buk_dir}/SCAN_RESULT_WITH_ACCTID_${date_to_keep}.tab

      rec_ct_from_file=$(cat ${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json | jq . | grep "vendor_rule_id" | wc -l)

load_dbw_gcp ()
{
      echo "INFO: FUNCTION_NAME load_gcp"
      #rec_ct_from_file=$(cat ${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json | jq . | grep "vendor_rule_id" | wc -l)

      if [ "${rec_ct_from_file}" == "${rule_ct}" ]; then
           echo "INFO: JSON_VALIDATION-${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json OK"
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json  gs://css-cloud-security-engineering/dbwriter/input/CISS_SCAN_RESULT_${date_to_keep}.json
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
      #rec_ct_from_file=$(cat ${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json | jq . | grep "vendor_rule_id" | wc -l)

      if [ "${rec_ct_from_file}" == "${rule_ct}" ]; then
           echo "INFO: JSON_VALIDATION-${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json OK"
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${buk_all_buk_dir}/SCAN_RESULT_WITH_ACCTID_${date_to_keep}.pipe  gs://dev-cvs-scan-reports/iac_scan_processed/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.pipe
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${buk_all_buk_dir}/SCAN_RESULT_WITH_ACCTID_${date_to_keep}.csv  gs://dev-cvs-scan-reports/iac_scan_processed/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.csv
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${buk_all_buk_dir}/SCAN_RESULT_WITH_ACCTID_${date_to_keep}.tab  gs://dev-cvs-scan-reports/iac_scan_processed/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.tab
           /apps/gcp/google-cloud-sdk/bin/gcloud storage  cp ${buk_all_buk_dir}/SCAN_RESULT_${date_to_keep}.json  gs://dev-cvs-scan-reports/iac_scan_processed/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.json
      else
           echo "ERROR: FEED_PRODUCTION_OF_JSON_FAIL."
           exit 100
      fi

      loaded_file=$(/apps/gcp/google-cloud-sdk/bin/gcloud storage ls gs://dev-cvs-scan-reports/iac_scan_processed/CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}.*)
      loaded_file=${loaded_file:-NONE}

      if [ "${loaded_file}" != "NONE" ]; then
          echo "INFO: FILE CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep} LOADED -GCP"
      else
         echo "ERROR: GCP LOAD ERROR- CISS_SCAN_RESULT_WITH_ACCTID_${date_to_keep}"
      fi
}
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
