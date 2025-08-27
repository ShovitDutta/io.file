#!/usr/bin/env sh


 ciss_rules_tracker_tb=${1:-NONE}
 already_done=${2:-Y}
 DEBUG=${3:-n}

   if  [ "${ciss_rules_tracker_tb}" == "NONE" ]; then
         echo "ERROR: Parameter daily_date_format_dir required."
         echo "INFO: Usage- $0 /data/ws_2024/metadata/ciss_rules_tracker_tb.pipe"
         exit 100
   fi

   chk_file=$(ls -C1 ${ciss_rules_tracker_tb} 2>/dev/null)
   chk_file=${chk_file:-NONE}

   if  [ "${chk_file}" == "NONE" ]; then
         echo "ERROR: ciss_rules_tracker_tb not_found"
         exit 101
   else
        #echo "INFO: ${chk_dir}"
        echo "INFO: FILES_TO_PROCESS_CT ${ciss_rules_tracker_tb}"
   fi


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

   target_dir=$(echo "/data/iac_scan_status/metadata")
   mkdir -p ${target_dir}


      metadata_for_db_writer_header=$(echo '{"truncate_all":false,"truncate_rule_id":false,"dev_db":false,"email":"cse@cvshealth.com","tablename":"css_iac_rule","schema":"cssapp","data":[')

      #echo "INFO: metadata ${metadata_for_db_writer_header}"
      #echo_vars
      #echo "vendor_rule_id,rule_name,pipeline_id,appname,timestamp,terraform_key,utc_time,result" >${buk_all_buk_dir}/SCAN_RESULT_ALL_${date_to_keep}.csv
      echo "INFO: final ${target_dir}/css_iac_header_rule.json"
      echo "${metadata_for_db_writer_header}" >${target_dir}/css_iac_header_rule.json
      let rule_ct=0
            echo "INFO: file - ${ciss_rules_tracker_tb}"
            for all_fields in `cat ${ciss_rules_tracker_tb} | sed 's/ /^/g'`
            do
                 let rule_ct=${rule_ct}+1
                 #echo "${all_fields}"
                 echo "${all_fields}" | sed 's/^/{\"rule_id\":\"/' | sed 's/|/\"\,\"secondary_rule_id\":\"/' | sed 's/|/\"\,\"rule_name\":\"/' | sed 's/|/\"\,\"severity\":\"/' | sed 's/|/\"\,\"category\":\"/' | sed 's/|/\"\,\"rule_type\":\"/' | sed 's/|/\"\,\"cloud_type\":\"/'| sed 's/|/\"\,\"rule_detail_desc\":\"/'| sed 's/|/\"\,\"resource_name\":\"/' | sed 's/|/\"\,\"vendor_rule_id\":\"/' | sed 's/|/\"\,\"terraform_resource_url\":\"/'| sed 's/$/\"}\,/'
                 #echo "${all_fields}" | sed 's/^/{\"rule_id\":\"/' | sed 's/|\"\,\"secondary_rule_id\":\"/'| sed 's/|/\"\,\"rule_name\":\"/' | sed 's/|/\"\,\"severity\":\"/' | sed 's/|/\"\,\"category\":\"/' | sed 's/|/\"\,\"rule_type\":\"/' | sed 's/|/\"\,\"cloud_type\":\"/'| sed 's/|/\"\,\"rule_detail_desc\":\"/'| sed 's/|/\"\,\"resource_name\":\"/' | sed 's/|/\"\,\"vendor_rule_id\":\"/' | sed 's/|/\"\,\"terraform_resource_url\":\"/'| sed 's/$/\"}/'
            done > ${target_dir}/CSS_IAC_RULE_TRACKER.json

            echo "INFO: rule_ct ${rule_ct}"
            cat ${target_dir}/CSS_IAC_RULE_TRACKER.json | tr '\n' ' ' |  sed 's/\, $/]}/' | sed 's/\^/ /g' >> ${target_dir}/css_iac_header_rule.json

            echo "INFO: file name to chk- ${target_dir}/css_iac_header_rule.json"
            ls -ltr ${target_dir}/css_iac_header_rule.json







