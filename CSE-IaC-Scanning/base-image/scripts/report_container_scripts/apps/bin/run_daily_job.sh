#!/usr/bin/env sh

      script_to_run=${1:-sim_scripts}
      date_format=${2:-NONE}
      load_dbwriter=${3:-Y}
      load_ciss_cse=${4:-Y}
      already_done=${5:-N}

#DPC-Global Variables -Start


   declare -A fn

   fn["execute_scripts"]="execute_scripts"
   fn["no_load"]="no_load"

   run_fn=$(echo "${fn[${script_to_run}]}")

   GCLOUD_STORAGE_PUSH=(`echo "Y"`)

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

  let LASTYEAR=${YEAR}-1
   week_1=$(date --date "yesterday" +"%V")
   week_for_yesterday=$(date --date "yesterday" +"%V")
   week_2=$(date --date "today" +"%V")
   today_yyyymmdd_ww_ddd=$(date --date "today" +"%Y%m%d-%V-%j")
   week_2=$(date --date "tomorrow" +"%V")
   day_1=$(date --date "yesterday" +"%a")
   yesterday_as_num=$(date --date "yesterday" +"%j")
   yesterday_yyyymmdd_ww_ddd=$(date --date "yesterday" +"%Y%m%d-%V-%j")
   day_2=$(date --date "today" +"%a")
   day_3=$(date --date "tomorrow" +"%a")
   marker_date_last_year_start_as_yyyymmdd_ww_ddd=$(date --date "01/01/${LASTYEAR}" +"%Y%m%d-%V-%j")
   marker_date_last_year_end_as_yyyymmdd_ww_ddd=$(date --date "12/31/${LASTYEAR}" +"%Y%m%d-%V-%j")
   marker_date_year_end=$(date --date "12/31/${YEAR}" +"%V")
   marker_date_year_start=$(date --date "01/01/${YEAR}" +"%V")
   marker_date_year_end_as_yyyymmdd_ww_ddd=$(date --date "12/31/${YEAR}" +"%Y%m%d-%V-%j")
   marker_date_year_start_as_yyyymmdd_ww_ddd=$(date --date "01/01/${YEAR}" +"%Y%m%d-%V-%j")
   marker_date_last_week_as_yyyymmdd_ww_ddd=$(date --date "12/31/${YEAR}" +"%Y%m%d-%V-%j")
   marker_date_start_week_as_yyyymmdd_ww_ddd=$(date --date "01/01/${YEAR}" +"%Y%m%d-%V-%j")
   today_as_epoh_num=$(date --date "today" +"%s")
   yesterday_as_epoh_num=$(date --date "yesterday" +"%s")

   let today_yesterday=${today_as_epoh_num}-${yesterday_as_epoh_num}
   let today_yesterday_driff=${today_yesterday}%86400
   echo "INFO: drift ${today_yesterday_driff}"
   if [ ${today_yesterday_driff} -gt 0 ]; then
      #let actual_diff=${today_yesterday}-${today_yesterday_drift}
      let actual_diff=0 # sometimes NTP drift will give less seconds per day < 86400.
      echo "INFO: DONT_WANT_TO_SET_RTC_TO_CST. LEAVING_UTC"
   else
      let actual_diff=${today_yesterday}
   fi

  let max_week=0

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

          gcloud_acct_if_any=$(/apps/gcp/google-cloud-sdk/bin/gcloud  info | grep "Account:" | cut -d ":" -f 2 | sed 's/\[//' | sed 's/\]//' | sed 's/^ //')
          gcloud_acct_if_any=${gcloud_acct_if_any:-NONE}

          echo "INFO: service acct Used: ${gcloud_acct_if_any}"

          if [ "${my_proj_based_service_acct_fqdn}" != "${gcloud_acct_if_any}" ]; then
              GCLOUD_STORAGE_PUSH=(`echo "N"`)
          fi
          echo "INFO: ROOT_FOLDER: ${my_current_buk_data}"
}

check_cloud_obj_srv ()
{
    /apps/bin/gcp_srv_acct_stp.sh 1>>/tmp/gcp_login.std01 2>>/tmp/gcp_login.std02

   cat /tmp/gcp_login.std01
   cat /tmp/gcp_login.std02

   rm -rf /tmp/gcp_login.std01 /tmp/gcp_login.std02
   process_proj_name
}

check_cloud_obj_srv
#date_format=$(echo "00000000-00-000")
create_yesterday_date_format ()
{
   echo "INFO: FN-NAME create_yesterday_date_format"
   echo "INFO: today ${today_yyyymmdd_ww_ddd}"
   echo "INFO: yesterday ${yesterday_yyyymmdd_ww_ddd}"
   echo "INFO: marker_date_year_end ${marker_date_year_end_as_yyyymmdd_ww_ddd}"
   echo "INFO: marker_date_year_start ${marker_date_year_start_as_yyyymmdd_ww_ddd}"
   echo "INFO: marker_date_start_week_as_yyyymmdd_ww_ddd ${marker_date_start_week_as_yyyymmdd_ww_ddd}"
   echo "INFO: marker_date_last_week_as_yyyymmdd_ww_ddd ${marker_date_last_week_as_yyyymmdd_ww_ddd}"
   echo "INFO: actual_diff ${actual_diff}"
   if [ ${actual_diff} -eq 86400 ]; then
        date_format=$(echo "${yesterday_yyyymmdd_ww_ddd}")
   else
        echo "ERROR: NOT_ABLE_TO_GENERATE_DATE. exiting_with_rc=125"
        exit 125
   fi
}

   if [ "${date_format}" == "NONE" ]; then
        date_format=$(echo "00000000-00-000")
        create_yesterday_date_format
   fi

    date_list=()
    date_list=$(/apps/gcp/google-cloud-sdk/bin/gcloud storage ls gs://${my_current_buk_data}/iac_scan_rpt_bucket)
    #echo "INFO: ${date_list[@]}"
    declare -A date_list_hash

    for all_dates in `echo "${date_list[@]}"`
    do
       basename_date=$(basename ${all_dates})
       date_list_hash[${basename_date}]=${basename_date}
    done


check_for_weekend ()
{

   echo "INFO: FUNCTION_NAME date_cal"
   if [ "${day_1}" == "Sun" ]; then
      echo "INFO: WEEKEND_SUNDAY_OK"
      exit 0
   else
      echo "INFO: HOLIDAY_OR_NO_DEPLOYMENT_FOUND. MANUAL_INVESTIGATION_NEEDED"
   fi
}

date_cal ()
{
   echo "INFO: FUNCTION_NAME date_cal"
   get_date=$(echo "${date_list_hash[${1}]}")
   get_date=${get_date:-NONE}
   if [ "${get_date}" == "NONE" ]; then
      echo "ERROR: PARAMETER_PASSED_AS_DATE_NOT_FOUND"
      check_for_weekend
      exit 110
   else
      echo "INFO: DATE ${1} VALIDATED_AND_FOUND"
   fi
}
    date_cal ${date_format}

execute_scripts ()
{
      # ./iac_get_rpt_obj.sh 20241209-50-344 Y Y Y
      echo "INFO: Executing Script ./iac_get_rpt_obj.sh ${1} ${2} ${3} ${4}"
      ./iac_get_rpt_obj.sh ${1} ${2} ${3} ${4}
      #./iac_daily_rpt_xls.sh tfp ${1} ${2} ${3} ${4} ${5}
}

no_load ()
{
      #./iac_daily_rpt_xls.sh tfp ${1} NONE N N Y
      :
}

      #${script_to_run} ${date_format} ${load_dbwriter} ${load_ciss_cse} ${already_done}
      ${run_fn} ${date_format} ${load_dbwriter} ${load_ciss_cse} ${already_done}
 
