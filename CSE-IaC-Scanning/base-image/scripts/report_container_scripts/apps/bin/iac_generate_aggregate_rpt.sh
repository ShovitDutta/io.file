#!/usr/bin/env sh

     export PATH=${PATH}:/apps/bin:/apps/kics/bin:/apps/snyk/bin:/apps/opa/bin:/apps/gcp/google-cloud-sdk/bin:/apps/hc/tf:/apps/hc/vault:/apps/hc/consul:/apps/hc/bin
     echo "INFO: Running $0 script"

#DPC-Global Variables -Start

#2023_10_13-15_46_50-1697212010-41_2023-286
  build_id_run_str=$(date '+%Y_%m_%d-%H_%M_%S-%s-%W_%Y-%j')
#20231013-15_46_50-1697212010-41_2023-286
  Ymd=$(echo "${build_id_run_str}" | cut -d "-" -f 1)
  YEAR=$(echo "${Ymd}" | cut -d "_" -f 1)
  MONTH=$(echo "${Ymd}" | cut -d "_" -f 2)
  DAY_OF_MONTH=$(echo "${Ymd}" | cut -d "_" -f 3)
#20231013
  RUN_DATE=$(echo "${YEAR}${MONTH}${DAY_OF_MONTH}")
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

  let YESTERDAY=${DAY_OF_YEAR}-1
  let LASTWEEK=${WEEK}-1
  let LASTHOUR=${HR}-1
  let LASTMONTH=${MONTH}-1
  let LASTYEAR=${YEAR}-1
  echo ""

  dw_dir=(`echo "/data"`)
  gcloud_context=(`echo "storage"`)
  processed_dir=$(echo "iac_scan_status")
  echo "INFO: day=${DAY} week=${WEEK} current=${STORAGE_FOLDER_KEY1} yesterday=${YESTERDAY} lastweek=${LASTWEEK}"

echo_vars ()
{
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


   week_1=$(date --date "yesterday" +"%V")
   week_2=$(date --date "today" +"%V")
   week_2=$(date --date "tomorrow" +"%V")
   day_1=$(date --date "yesterday" +"%a")
   day_2=$(date --date "today" +"%a")
   day_3=$(date --date "tomorrow" +"%a")
   marker_date_year_end=$(date --date "12/31/${LASTYEAR}" +"%V")
   marker_date_year_start=$(date --date "01/01/${YEAR}" +"%V")
   let  week_to_process=(`echo "${week_2}"`)

  let max_week=0

calculate_which_week_of_year_to_process ()
{
   echo "INFO: FN-NAME calculate_which_week_of_year_to_process"
   let  week_to_process=(`echo "${week_2}"`)
   if [ "${day_2}" == "Mon" ]; then
       let  week_to_process=${week_to_process}-1
       if [ ${week_to_process} -eq 0 ]; then
          let week_to_process=52
       fi
       let max_week=${week_to_process}
   else
      echo "INFO: this script should be run only on Mon of every Week."
      echo "INFO: week number is required. this is parameter 1."
      input_week_to_process=${1:-0}
      echo "INFO: input_week_to_process=${input_week_to_process}"
   fi
   echo "INFO: Week data Processing, week is set ${week_to_process}"
}


   root_dir=(`echo "${dw_dir}/${processed_dir}/${YEAR}"`)
   declare -A status_files_week_hash
   declare -A rr1_files_week_hash
   declare -a rr1_files_week_ar
   declare -A rr2_files_week_hash
   declare -a rr2_files_week_ar
   declare -A sm_kics_files_week_hash
   declare -a sm_kics_files_week_ar
   declare -A sm_snyk_files_week_hash
   declare -a sm_snyk_files_week_ar
   let status_files_ct=0
   get_processed_csv_files=()
   status_files_ar=()
   let get_processed_csv_files_ct=0
   #rr1_files_week_list=()
   #rr2_files_week_list=()
   #sm_kics_files_week_list=()
   #sm_snyk_files_week_list=()
   let rr1_files_week_ct=0
   let rr2_files_week_ct=0
   let sm_kics_files_week_ct=0
   let sm_snyk_files_week_ct=0
   let csv_ct=0
   let csv_files_by_type_total_ct=0

   cal_week_ar=()
   declare -A cal_week_hash
   declare -A cal_start_of_the_week_hash
   declare -A cal_end_of_the_week_hash
   declare -A cal_week_date_hash
   declare -A cal_date_week_hash


prepare_report_calander ()
{
   echo "INFO: FN-NAME prepare_report_calander"
   for all_weeks in {1..52}
   do
     cal_week_hash[${all_weeks}]="${all_weeks}"
   done
    
   for each_month_marker in {1..12}
   do 
        for each_day_max_month in {1..31}
        do
              date_key=(`echo "${each_month_marker}/${each_day_max_month}/${YEAR}"`)
              #echo "INFO: DATE_FORMAT-${date_key}"
              week_m=$(date --date "${date_key}" +"%V" 2>/dev/null) 
              week_m=${week_m:-NONE}
              #echo "INFO: before ${date_key}=${week_m}"
              if [ "${week_m}" != "NONE" ]; then
                  Day=$(date --date "${date_key}" +"%a" 2>/dev/null) 
                  day_of_the_year=$(date --date "${date_key}" +"%j" 2>/dev/null) 
                  #echo "INFO: ${date_key}=${week_m} DAY=${Day}"
                  cal_week_date_hash[${week_m}]="${date_key}"
                  cal_date_week_hash[${date_key}]="${week_m}"
                  if [ "${Day}" == "Mon" ]; then
                     cal_start_of_the_week_hash[${week_m}]="${date_key}"
                  fi
                  if [ "${Day}" == "Sun" ]; then
                     cal_end_of_the_week_hash[${week_m}]="${date_key}"
                  fi
              #else
              #    echo "INFO: ${date_key}=${week_m} DAY=NO_DAY "
              fi
        done
   done
   #for all_day in `echo "${!cal_start_of_the_week_hash[@]}" | sort`
   #do
        #echo "INFO: week# ${all_day}"
        #get_start_day=(`echo "${cal_start_of_the_week_hash[${all_day}]}"`)
        #get_end_day=(`echo "${cal_end_of_the_week_hash[${all_day}]}"`)
        #echo "INFO: start_date=${get_start_day} and end_date=${get_end_day}"
   #done
}

collect_data ()
{
   echo "INFO: FN-NAME collect_data"
   cd ${root_dir}
   get_processed_csv_files=(`ls -C1R ??/csv_all/??.*.csv`)
   get_processed_csv_files_ct=(`echo "${#get_processed_csv_files[@]}"`)
   echo "${get_processed_csv_files[@]} and ${get_processed_csv_files_ct}"
   for all_weeks_found in  `echo "${!status_files_week_hash[@]}"`
   do
      #ls -C1R ??/csv_all/??.*.csv
      ##./43/csv_all/43.kics.sm.csv ./43/csv_all/43.snyk.sm.csv ./43/csv_all/43.rr.csv ./43/csv_all/43.rr.detail.unique.rules.csv
      sm_kics_files_week_ar+=(`ls -C1 ./${all_weeks_found}/csv_all/${all_weeks_found}.kics.sm.csv 2>/dev/null`)
      let csv_ct=${csv_ct}+1
      sm_snyk_files_week_ar+=(`ls -C1 ./${all_weeks_found}/csv_all/${all_weeks_found}.snyk.sm.csv 2>/dev/null`)
      let csv_ct=${csv_ct}+1
      rr1_files_week_ar+=(`ls -C1 ./${all_weeks_found}/csv_all/${all_weeks_found}.rr.csv 2>/dev/null`)
      let csv_ct=${csv_ct}+1
      rr2_files_week_ar+=(`ls -C1 ./${all_weeks_found}/csv_all/${all_weeks_found}.rr.detail.unique.rules.csv 2>/dev/null`)
      let csv_ct=${csv_ct}+1
   done
      let rr1_files_week_ct=(`echo "${#rr1_files_week_ar[@]}"`)
      let rr2_files_week_ct=(`echo "${#rr2_files_week_ar[@]}"`)
      let sm_kics_files_week_ct=(`echo "${#sm_kics_files_week_ar[@]}"`)
      let sm_snyk_files_week_ct=(`echo "${#sm_snyk_files_week_ar[@]}"`)

      #echo "INFO: CSV- `echo ${rr1_files_week_ar[@]}`"
      #echo "INFO: CSV- `echo ${rr2_files_week_ar[@]}`"
      #echo "INFO: CSV- `echo ${sm_kics_files_week_ar[@]}`"
      #echo "INFO: CSV- `echo ${sm_snyk_files_week_ar[@]}`"
      let csv_files_by_type_total_ct=${rr1_files_week_ct}+${rr2_files_week_ct}+${sm_kics_files_week_ct}+${sm_snyk_files_week_ct}


      if [ ${csv_files_by_type_total_ct} -eq ${get_processed_csv_files_ct} ]; then
           echo "INFO: FILE_CT and PROCESSED_CSV_FILES_CT MATCH"
      else
           echo "INFO: FILE_CT and PROCESSED_CSV_FILES_CT MISMATCH (${csv_files_by_type_total_ct},${get_processed_csv_files_ct})"
      fi
     
      #./41/csv_all/41.kics.sm.csv
      for all_sms in `echo "${sm_kics_files_week_ar[@]}" | sort -u`
      do
          #echo "INFO: Only sm_files kics. ${all_sms}"
          kics_sm_key=(`echo "${all_sms}" | cut -d "/" -f 2-3 | tr '/' '_'`)
          only_file=(`echo "${all_sms}" | cut -d "/" -f 4`)
          sm_kics_files_week_hash[${kics_sm_key}]="${only_file}"
      done

      #./41/csv_all/41.snyk.sm.csv
      for all_sms in `echo "${sm_snyk_files_week_ar[@]}" | sort -u`
      do
          #echo "INFO: Only sm_files snyk. ${all_sms}"
          snyk_sm_key=(`echo "${all_sms}" | cut -d "/" -f 2-3 | tr '/' '_'`)
          only_file=(`echo "${all_sms}" | cut -d "/" -f 4`)
          sm_snyk_files_week_hash[${snyk_sm_key}]="${only_file}"
      done
      for all_rrs in `echo "${rr1_files_week_ar[@]}" | sort -u`
      do
          #echo "INFO: Only rr1_files. ${all_rrs}"
          rr1_key=(`echo "${all_rrs}" | cut -d "/" -f 2-3 | tr '/' '_'`)
          only_file=(`echo "${all_rrs}" | cut -d "/" -f 4`)
          rr1_files_week_hash[${rr1_key}]="${only_file}"
      done
      for all_rrs in `echo "${rr2_files_week_ar[@]}" | sort -u`
      do
          #echo "INFO: Only rr2_files. ${all_rrs}"
          rrs_key=(`echo "${all_rrs}" | cut -d "/" -f 2-3 | tr '/' '_'`)
          only_file=(`echo "${all_rrs}" | cut -d "/" -f 4`)
          rr2_files_week_hash[${rrs_key}]="${only_file}"
      done
   cd -
}


   declare -A sm_kics_data_unique_hash
   declare -A sm_kics_data_key_unique_key_hash
   declare -A sm_snyk_data_unique_hash
   declare -A sm_snyk_data_key_unique_key_hash
   declare -A rr1_data_unique_hash
   declare -A rr1_data_key_unique_key_hash
   declare -A rr2_data_unique_key_hash
   declare -A rr2_data_key_unique_key_hash

   sm_kics_header_prefix=(`echo "Scan Results/Week"`)
   sm_kics_header_suffix=(`echo ""`)
   sm_kics_file_prefix=(`echo "agg_data"`)
   sm_kics_file_suffix=(`echo ""`)

   sm_snyk_header_prefix=(`echo "Scan Results/Week"`)
   sm_snyk_header_suffix=(`echo ""`)
   sm_snyk_file_prefix=(`echo "agg_data"`)
   sm_snyk_file_suffix=(`echo ""`)
   rr1_header_prefix=(`echo "RuleId,Rule Desc,Rule Type,Resource,Severity"`)
   rr1_header_suffix=(`echo ""`)
   rr1_file_prefix=(`echo "agg_data"`)
   rr1_file_suffix=(`echo ""`)
   rr2_file_prefix=(`echo "agg_data"`)
   rr1_final_file_agg_data_csv=(`echo "agg_data_rr.csv"`)
   rr1_final_file_agg_data=(`echo "agg_data_rr.data"`)

process_sm_snyk_agg_data ()
{

   echo "INFO: FN-NAME process_p1sm_snyk_data"
   header=(`echo "${sm_snyk_header_prefix}${sm_snyk_header_suffix}"`)
   final_sm_snyk_file=(`echo "${sm_snyk_file_prefix}${sm_snyk_file_suffix}_sm_snyk.csv"`)
   echo "INFO: final_file name- ${final_sm_snyk_file}"
   cd ${root_dir}
   mkdir -p agg_data
   cd agg_data
   echo "${header}" > ${final_sm_snyk_file}
   filter_rules=(`echo ""`)
   for all_items in `echo "${!sm_snyk_data_key_unique_key_hash[@]}" | grep -v  "^Scan Results"`
   do
       get_val=(`echo "${sm_snyk_data_unique_hash[${all_items}]}"`)
       if [ "${all_items}" != "#snyk_rules" ]; then
          echo "${all_items},${get_val}"
       else
          filter_rules=(`echo "${all_items},${get_val}"`)
       fi
   #done
   done >> ${final_sm_snyk_file}
   echo "${filter_rules}" >> ${final_sm_snyk_file}
}

process_p1sm_snyk_data ()
{
   echo "INFO: FN-NAME process_p1sm_snyk_data"
            sm_snyk_header_suffix=(`echo "${sm_snyk_header_suffix},week_of_year(${1})"`)
            sm_snyk_file_suffix=(`echo "${sm_snyk_file_suffix}.${1}"`)
            for all_rows_in_snyk_sm in  `cat "./${split_week}/csv_all/${get_sm_snyk_file_nm}" | grep -v "^Scan Results"`
            do
                 #echo "INFO: Col ${all_rows_in_snyk_sm}"
                 key=(`echo "${all_rows_in_snyk_sm}" | cut -d "," -f 1`)
                 ct=(`echo "${all_rows_in_snyk_sm}" | cut -d "," -f 2`)
                 get_key=(`echo "${sm_snyk_data_key_unique_key_hash[${key}]}"`)
                 get_key=${get_key:-NONE}
                 #echo "INFO: 1. ${key},2. ${ct}, 3.  ${get_key}"
                 if [ "${get_key}" == "NONE" ]; then
                    sm_snyk_data_key_unique_key_hash[${key}]="${key}"
                    sm_snyk_data_unique_hash[${key}]="${ct}"
                 else
                    get_current_val=(`echo "${sm_snyk_data_unique_hash[${key}]}"`)
                    new_current_val=(`echo "${get_current_val},${ct}"`)
                    sm_snyk_data_unique_hash[${key}]="${new_current_val}"
                    get_val=(`echo "${sm_snyk_data_unique_hash[${key}]}"`)
                    #echo "INFO: ADATA: ${key} and val=${get_val}"
                 fi
            done
}


process_sm_kics_agg_data ()
{

   echo "INFO: FN-NAME process_p1sm_kics_data"
   header=(`echo "${sm_kics_header_prefix}${sm_kics_header_suffix}"`)
   final_sm_kics_file=(`echo "${sm_kics_file_prefix}${sm_kics_file_suffix}_sm_kics.csv"`)
   echo "INFO: final_file name- ${final_sm_kics_file}"
   cd ${root_dir}
   mkdir -p agg_data
   cd agg_data
   echo "${header}" > ${final_sm_kics_file}
   filter_rules=(`echo ""`)
   for all_items in `echo "${!sm_kics_data_key_unique_key_hash[@]}" | grep -v "^Scan Results"`
   do
       get_val=(`echo "${sm_kics_data_unique_hash[${all_items}]}"`)
       if [ "${all_items}" != "#kics_rules" ]; then
         echo "${all_items},${get_val}"
       else
         filter_rules=(`echo "${all_items},${get_val}"`)
       fi
   done >> ${final_sm_kics_file}
   echo "${filter_rules}" >> ${final_sm_kics_file}
}

process_p1sm_kics_data ()
{
   echo "INFO: FN-NAME process_p1sm_kics_data"
            sm_kics_header_suffix=(`echo "${sm_kics_header_suffix},week_of_year(${1})"`)
            sm_kics_file_suffix=(`echo "${sm_kics_file_suffix}.${1}"`)
            for all_rows_in_kics_sm in  `cat "./${split_week}/csv_all/${get_sm_kics_file_nm}" | grep -v "^Scan Results"`
            do
                 #echo "INFO: Col ${all_rows_in_kics_sm}"
                 key=(`echo "${all_rows_in_kics_sm}" | cut -d "," -f 1`)
                 ct=(`echo "${all_rows_in_kics_sm}" | cut -d "," -f 2`)
                 get_key=(`echo "${sm_kics_data_key_unique_key_hash[${key}]}"`)
                 get_key=${get_key:-NONE}
                 #echo "INFO: 1. ${key},2. ${ct}, 3.  ${get_key}"
                 if [ "${get_key}" == "NONE" ]; then
                    sm_kics_data_key_unique_key_hash[${key}]="${key}"
                    sm_kics_data_unique_hash[${key}]="${ct}"
                 else
                    get_current_val=(`echo "${sm_kics_data_unique_hash[${key}]}"`)
                    new_current_val=(`echo "${get_current_val},${ct}"`)
                    sm_kics_data_unique_hash[${key}]="${new_current_val}"
                    get_val=(`echo "${sm_kics_data_unique_hash[${key}]}"`)
                    #echo "INFO: ADATA: ${key} and val=${get_val}"
                 fi
            done
}

process_rr2_agg_data ()
{
   echo "INFO: FN-NAME process_rr2_agg_data"
   header=(`echo "RuleId,Rule_desc,Terraform_Resource"`)
   final_rr2_file=(`echo "${rr2_file_prefix}.rr.detail.unique.rules.csv"`)
   final_rr2_file_sort=(`echo "${rr2_file_prefix}.rr.detail.unique.rules.sort"`)
   echo "INFO: final_file name- ${final_rr2_file}"
   cd ${root_dir}
   mkdir -p agg_data
   cd agg_data
   echo "${header}" > ${final_rr2_file}
   cat ${root_dir}/agg_data/${final_rr2_file_sort} | sort -u >>${final_rr2_file}
}

process_p1rr_rr2_data ()
{

   echo "INFO: FN-NAME process_p1rr_rr2_data"
        #echo "INFO: p1=${1} and p2=${2}"
        mkdir -p ${root_dir}/agg_data
        agg_data_sort_file=(`echo "${rr2_file_prefix}.rr.detail.unique.rules.sort"`)
        for all_rows_in_rr2 in  `cat "./${1}/csv_all/${2}" | grep -v  "^RuleId"`
        do
           echo "${all_rows_in_rr2}"
        done >> ${root_dir}/agg_data/${agg_data_sort_file}
}

process_rr1_agg_data ()
{
   echo "INFO: FN-NAME process_rr1_agg_data"
   echo "RuleId,Rule Desc,Rule Type,Resource,Severity,Count" > ${root_dir}/agg_data/${rr1_final_file_agg_data_csv}
   cat ${root_dir}/agg_data/agg_data_rr.data >> ${root_dir}/agg_data/${rr1_final_file_agg_data_csv}
   
}
process_rr1_agg_data_dum ()
{
   echo "INFO: FN-NAME process_rr1_agg_data"
   header=(`echo "${rr1_header_prefix}${rr1_header_suffix}"`)
   final_rr1_file=(`echo "${rr1_file_prefix}${rr1_file_suffix}_rr.csv"`)
   echo "INFO: final_file name- ${final_rr1_file}"
   cd ${root_dir}
   mkdir -p agg_data
   cd agg_data
   #echo "${header}" > ${final_rr1_file}
   echo "${header}" #  > ${final_rr1_file}

   for all_items in `echo "${!rr1_data_key_unique_key_hash[@]}"`
   do
       get_val=(`echo "${rr1_data_unique_hash[${all_items}]}"`)
         echo "${all_items},${get_val}"
   done
   #done >> ${final_rr1_file}
}

process_p1rr_rr1_data ()
{
   echo "INFO: FN-NAME process_p1rr_rr1_data"
       rr1_header_suffix=(`echo "${rr1_header_suffix},week_of_year(${1})"`)
       rr1_file_suffix=(`echo "${rr1_file_suffix}.${1}"`)
       for all_rows_in_rr1 in  `cat "./${1}/csv_all/${2}" | grep -v  "^RuleId"`
       do
           echo "INFO: Col ${all_rows_in_rr1}"
           key=(`echo "${all_rows_in_rr1}" | cut -d "," -f 1,4 | tr ',' '_'`)
           col_2_3_4_5=(`echo "${all_rows_in_rr1}" | cut -d "," -f 2-5`)
           ct=(`echo "${all_rows_in_rr1}" | cut -d "," -f 6`)
           mark_wirh_week=(`echo "${col_2_3_4_5}.${split_week}.${ct}"`)
           echo "INFO: marker ${mark_wirh_week}"
           get_key=(`echo "${rr1_data_key_unique_key_hash[${key}]}"`)
           get_key=${get_key:-NONE}
           echo "INFO: key ${key} and get_key = ${get_key}"
           if [ "${get_key}" == "NONE" ]; then
                  rr1_data_key_unique_key_hash[${key}]="${key}"
                  rr1_data_unique_hash[${key}]="${mark_wirh_week}"
           else
                  get_current_val=(`echo "${rr1_data_unique_hash[${key}]}"`)
                  new_current_val=(`echo "${get_current_val},${mark_wirh_week}"`)
                  rr1_data_unique_hash[${key}]="${new_current_val}"
                  get_val=(`echo "${rr1_data_unique_hash[${key}]}"`)
                  #echo "INFO: AGG_DATA  key= ${key},  AGG_DATA ${get_val}"
           fi
       done
}

aggegate_data ()
{
   echo "INFO: FN-NAME aggegate_data"
   for all_kics in `echo "${!sm_kics_files_week_hash[@]}" | sort -u`
   do
       kval=(`echo "${sm_kics_files_week_hash[${all_kics}]}"`)
       #echo "INFO: key-${all_kics} and kval=${kval}"
   done

   for all_snyk in `echo "${!sm_snyk_files_week_hash[@]}" | sort -u`
   do
       sval=(`echo "${sm_snyk_files_week_hash[${all_snyk}]}"`)
       #echo "INFO: key-${all_snyk} and sval=${sval}"
   done

   for all_rr1 in `echo "${!rr1_files_week_hash[@]}" | sort -u`
   do
       r1val=(`echo "${rr1_files_week_hash[${all_rr1}]}"`)
       #echo "INFO: key-${all_rr1} and sval=${r1val}"
   done

   for all_rr2 in `echo "${!rr2_files_week_hash[@]}" | sort -u`
   do
       r2val=(`echo "${rr2_files_week_hash[${all_rr2}]}"`)
       #echo "INFO: key-${all_rr2} and sval=${r2val}"
   done

#INFO: week start: 41.p1rr.done
#INFO: week start: 41.p1sm.done
#INFO: week start: 42.p1rr.done
#INFO: week start: 42.p1sm.done
#INFO: week start: 43.p1rr.done
#INFO: week start: 43.p1sm.done
rm -rf ${root_dir}/agg_data/agg_data_rr.data
   cd ${root_dir}
   
   echo "INFO: `pwd`"
   for all_unique_weeks in `echo "${status_files_ar[@]}" | sort -u`
   do
          #echo "INFO: week start: ${all_unique_weeks}"
          split_week=(`echo "${all_unique_weeks}" | cut -d "." -f 1`)
          split_type=(`echo "${all_unique_weeks}" | cut -d "." -f 2`)
          split_status=(`echo "${all_unique_weeks}" | cut -d "." -f 3`)
          key=(`echo "${split_week}_csv_all"`)

   case "${split_type}" in
   "p1sm")
   #sm_kics_data_unique_key_hash
   #41.kics.sm.csv
   #sm_snyk_data_unique_key_hash
   #41.snyk.sm.csv
            get_sm_kics_file_nm=(`echo "${sm_kics_files_week_hash[${key}]}"`)
            get_sm_snyk_file_nm=(`echo "${sm_snyk_files_week_hash[${key}]}"`)
            ####echo "INFO: file names - 1.${get_sm_kics_file_nm} 2.${get_sm_snyk_file_nm}"
            #process_kics"
            process_p1sm_kics_data "${split_week}" "${get_sm_kics_file_nm}"
            #process_snyk"
            process_p1sm_snyk_data "${split_week}" "${get_sm_snyk_file_nm}"
            ;;
   "p1rr")
   #rr1_data_unique_key_hash
   #rr1_data_key_unique_key_hash
   #41.rr.csv
   #rr2_data_unique_key_hash
   #41.rr.detail.unique.rules.csv
            get_rr1_file_nm=(`echo "${rr1_files_week_hash[${key}]}"`)
            get_rr2_file_nm=(`echo "${rr2_files_week_hash[${key}]}"`)
            #echo "INFO: file names - 1.${get_rr1_file_nm} 2.${get_rr2_file_nm}"
            #process_rr"
            #process_p1rr_rr1_data "${split_week}" "${get_rr1_file_nm}"
            for all_rows_in_rr1 in  `cat "./${split_week}/csv_all/${get_rr1_file_nm}" | grep -v  "^RuleId"`
            do
               echo "${all_rows_in_rr1}"
               #fields_1_to_5=(`echo "${all_rows_in_rr1}" | cut -d "," -f 1-5`)
               #fields_1_4_as_key=(`echo "${all_rows_in_rr1}" | cut -d "," -f 1,4 | tr ',' '|'`)
               #fields_6=(`echo "${all_rows_in_rr1}" | cut -d "," -f 6`)
               #echo "${fields_1_to_5}|${split_week}.${fields_6}"
               #rr1_data_key_unique_key_hash[${fields_1_4_as_key}]="${fields_1_4_as_key}"
            done >> ${root_dir}/agg_data/agg_data_rr.data
            #for all_rows_in_rr1 in  `cat "./${split_week}/csv_all/${get_rr1_file_nm}" | grep -v  "^RuleId"`
            #do
                 #echo "INFO: Col ${all_rows_in_rr1}"
                 #key=(`echo "${all_rows_in_rr1}" | cut -d "," -f 1,5 | tr ',' '_'`)
                 #ct=(`echo "${all_rows_in_rr1}" | cut -d "," -f 6`)
                 #mark_wirh_week=(`echo "${split_week}.${ct}"`)
                 #get_key=(`echo "${rr1_data_key_unique_key_hash[${key}]}"`)
                 #get_key=${get_key:-NONE}
                 #if [ "${get_key}" == "NONE" ]; then
                 #   rr1_data_unique_key_hash[${key}]="${key}"
                 #   rr1_data_unique_key_hash[${key}]="${mark_wirh_week}"
                 #else
                 #   get_current_val=(`echo "${rr1_data_unique_key_hash[${key}]}"`)
                 #   new_current_val=(`echo "${get_current_val},${mark_wirh_week}"`)
                 #   rr1_data_unique_key_hash[${key}]="${new_current_val}"
                 #fi
            #done
            #process_detail.unique.rules"
            #echo "INFO: calling FN- process_p1rr_rr2_data ${split_week} ${get_rr2_file_nm}"
            process_p1rr_rr2_data "${split_week}" "${get_rr2_file_nm}"
             ;;
    *)
           echo "INFO: type unknown"
           ;;
    esac
   done
   process_sm_kics_agg_data
   process_sm_snyk_agg_data
   process_rr2_agg_data
   process_rr1_agg_data
       #echo "INFO: END_OF_FILE_PROCESSING"
       #read read_s
   #echo "RuleId,Rule Desc,Rule Type,Resource,Severity,Count" > ${root_dir}/agg_data/${rr1_final_file_agg_data_csv}
   #cat ${root_dir}/agg_data/agg_data_rr.data >> ${root_dir}/agg_data/${rr1_final_file_agg_data_csv}
   #for all_unique_keys in `echo "${rr1_data_key_unique_key_hash[@]}" | sort`
   #do
   #    echo "INFO:all_unique_keys ${all_unique_keys}"
   #    f1=(`echo "${all_unique_keys}" | cut -d "|" -f 1`)
   ##    f2=(`echo "${all_unique_keys}" | cut -d "|" -f 2`)
   #    echo "INFO: filter key: ${f1} and ${f2}"
   #    first_5_cols=$(cat ${root_dir}/agg_data/agg_data_rr.data | egrep "${f1}" | egrep "${f2}" | cut -d "|" -f 1 | sort -u)
   #    last_6_col=$(cat ${root_dir}/agg_data/agg_data_rr.data | egrep "${f1}" | egrep "${f2}" | sort -u -k 1,6 |  cut -d "|" -f 2 | tr '\n' ',')
   #    echo "INFO: 5_col ${first_5_cols}, last_col ${last_6_col}"
   #    read read_s
   #done
   #cat ${root_dir}/agg_data/agg_data_rr.data >> ${root_dir}/agg_data/${rr1_final_file_agg_data_csv}
}

available_data ()
{
   echo "INFO: FN-NAME available_data"
   cd ${root_dir}
   status_files_ar=(`ls -C1R ??.p1??.done 2>/dev/null | grep -v gz`)
   let status_files_ct=(`echo "${#status_files_ar[@]}"`)
   if [ ${status_files_ct} -gt 0 ]; then
      echo "INFO: available_data_process_start file_ct ${status_files_ct}"
      for all_unique_weeks in `echo "${status_files_ar[@]}" | sort -u`
      do
          week_key=(`echo "${all_unique_weeks}" | cut -d "." -f 1`)
          status_files_week_hash[${week_key}]=${week_key}
      done
      
   else
      echo "INFO: NO_FILES_FOUND. ERROR_CONDITION"
      echo "ERROR: NO_FILES_TO_PROCESS EXIT_WITH_ERROR_CODE=100"
      exit 100
   fi
  cd -

}
     
  echo_vars
  calculate_which_week_of_year_to_process
  #prepare_report_calander
  available_data
  collect_data
  aggegate_data
