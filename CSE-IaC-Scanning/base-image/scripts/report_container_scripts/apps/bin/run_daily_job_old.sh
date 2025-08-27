#!/usr/bin/env sh

      script_to_run=${1:-sim_scripts}
      date_format=${2:-NONE}
      load_dbwriter=${3:-Y}
      load_ciss_cse=${4:-Y}
      already_done=${5:-N}

#DPC-Global Variables -Start


   declare -A fn

   #fn["execute_csv"]="execute_csv"
   #fn["execute_buk"]="execute_buk"
   #fn["execute_tfp"]="execute_tfp"
   #fn["execute_mta"]="execute_mta"
   #fn["execute_cfm"]="execute_cfm"
   #fn["execute_tfm"]="execute_tfm"
   fn["execute_scripts"]="execute_scripts"
   fn["no_load"]="no_load"
   fn["sim_scripts"]="sim_scripts"

   run_fn=$(echo "${fn[${script_to_run}]}")

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

check_cloud_obj_srv ()
{
    /apps/bin/gcp_srv_acct_stp.sh 1>>/tmp/gcp_login.std01 2>>/tmp/gcp_login.std02

   cat /tmp/gcp_login.std01
   cat /tmp/gcp_login.std02

   rm -rf /tmp/gcp_login.std01 /tmp/gcp_login.std02
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
    date_list=$(/apps/gcp/google-cloud-sdk/bin/gcloud storage ls gs://dev-cvs-scan-reports/iac_scan_rpt_bucket)
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

#execute_csv ()
#{
#      ./iac_daily_rpt_xls.sh csv ${1}
#}

#execute_buk ()
#{
#      ./iac_daily_rpt_xls.sh buk ${1}
#}

execute_tfp ()
{
      ./iac_daily_rpt_xls.sh tfp ${1}
}

#execute_mta ()
#{
#      ./process_tfp_files_metadata.sh ${1}
#}

#execute_cfm ()
#{
#      ./process_tfp_configuration_metadata.sh ${1}
#}

#execute_tfm ()
#{
#      ./process_buk_files_metadata.sh ${1} ${2} ${3} ${4}
#}

execute_scripts ()
{
      #./iac_daily_rpt_xls.sh csv ${1}
      #./iac_daily_rpt_xls.sh buk ${1}
      ./iac_daily_rpt_xls.sh tfp ${1}
      #./process_tfp_files_metadata.sh ${1}
      #./process_tfp_configuration_metadata.sh ${1}
      #./process_buk_files_metadata.sh ${1} ${2} ${3} ${4}
}

no_load ()
{
      ./iac_daily_rpt_xls.sh tfp ${1} NONE N N Y
}

sim_scripts ()
{
      echo "INFO: ./iac_daily_rpt_xls.sh tfp ${1}"
}

      #${script_to_run} ${date_format} ${load_dbwriter} ${load_ciss_cse} ${already_done}
      ${run_fn} ${date_format} NONE ${load_dbwriter} ${load_ciss_cse} ${already_done}
 
