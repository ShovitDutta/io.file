#!/usr/bin/env sh
     export PATH=${PATH}:/apps/bin:/apps/lib:/apps/kics/bin:/apps/snyk/bin:/apps/opa/bin:/apps/gcp/google-cloud-sdk/bin:/apps/hc/tf:/apps/hc/vault:/apps/hc/consul:/apps/hc/bin
     echo "INFO: Running $0 script"
   . /apps/bin/.env
   p1=${1:-NONE}
   p2=${2:-N}
   p3=${3:-N}
   p4=${4:-N}
   pg_to_run=${5:-1}
   target_dir=$(echo "/data")
   storage_folder=$(echo "iac_scan_status")
   process_sts_files_metadata_run=${PROCESS_STS_FILES_METADATA_RUN:-Y}
   day_date_format_yyyymmdd=$(echo "NONE")
   month_date_format_yyyymm=$(echo "NONE")
   year_date_format_yyyy=$(echo "NONE")

   if [[ "${p1}" != "NONE" ]]; then
       echo "INFO: DATE ${1}"
   else
       echo "INFO: Total number of parameters  $#. Minimum Required is 1"
       echo "INFO: USAGE $0 DATE  Required."
       exit 100
   fi
   storage_target_dir=$(echo "${target_dir}/${storage_folder}/rpt" | sed   's/\/\/*/\//g')
   echo "INFO: DATE is ${p1}, LOCAL_OBJ_FOLDER_PUSH ${p2}, DBWRITTER_PUSH ${p3}  and and target directory is ${storage_target_dir} rerun ${rerun}"
   rerun=$(echo "${RERUN}")
   rerun=${rerun:-N}
#DPC-Function chk_none_value -Definition Start
## this function will check for a given variable name, has vaule set or not
## if the variable is mandatory, it will exit with error code passed to this function
## else echo to screen about the status.( Valid). for security purpose
## no value of the variable is echoed to screep, only it name. 
## parameters are variable value, error code, to exit or not
## example chk_none_value "E" "$SNYK_TOKEN" "snyn_token" "100"

chk_none_value ()
{
    echo "INFO: TYPE OPT-INDIRECT FN-NAME chk_none_value"

    pass_or_fail=${1}
    variable_to_chk=${2}

    if [ "${variable_to_chk}" == 'NONE' ]; then

          if [ ${pass_or_fail} == 'E' ]; then
               
              echo "EXIT: Mandatory variable ${3} is not passed. Exiting with error code ${4}"
              echo "ERROR: exit_code=${4}"
              exit ${4}
          else
              echo "WARN: Mandatory variable ${3} is not passed. let me try from .env file"
              echo "WARN: if .env file not found or APP_NM and PIPELINE_NM and SNYK_TOKEN defined"
              echo "WARN: exit with 127"
          fi 

    else
          echo "INFO: variable name ${3} is valid" 
    fi
}     

#DPC-Function chk_none_value -Definition End

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

#DPC-help display to clients how to run this container. Start
help ()
{
     echo "INFO: TYPE INDIRECT FN-NAME help"
     echo "INFO: current date -${STORAGE_FOLDER_KEY1}"
     echo "INFO: current day -${DAY_OF_YEAR}"
     echo "INFO: OBJ_FOLDER_ARCH=/root_bucket_name/FOLDER01/STORAGE_FOLDER_KEY1/HOUR_KEY/APPID/PIPELINE"
     echo "INFO: OBJ_FOLDER_ARCH=/root_bucket_name/iac_scan_status/20231031-44-304/rpt_"
     echo "HELP: Usage $0 DATE_AS_KEY"
}
#DPC-help display to clients how to run this container. End

  if [ ${DAY_OF_YEAR} -lt 100 ]; then
    DAY_OF_YEAR=$(echo "${DAY_OF_YEAR}" | cut -c2-3)
    let YESTERDAY=${DAY_OF_YEAR}-1
    YESTERDAY=$(printf "%03d\n" ${YESTERDAY})
  else
    let YESTERDAY=${DAY_OF_YEAR}-1
  fi
  echo "INFO: Processed YESTERDAY: ${YESTERDAY}"

  let LASTWEEK=${WEEK}-1
  let LASTHOUR=${HR}-1
  let LASTMONTH=${HR}-1

     help
     echo ""

  dw_dir=(`echo "/data"`)
  gcloud_context=(`echo "storage"`)
  echo "INFO: day=${DAY} week=${WEEK} current=${STORAGE_FOLDER_KEY1} yesterday=${YESTERDAY} lastweek=${LASTWEEK}"
#DPC-Global Variables -End

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

          gcloud_acct_if_any=$(gcloud info | grep "Account:" | cut -d ":" -f 2 | sed 's/\[//' | sed 's/\]//' | sed 's/^ //')
          gcloud_acct_if_any=${gcloud_acct_if_any:-NONE}

          echo "INFO: service acct Used: ${gcloud_acct_if_any}"

          if [ "${my_proj_based_service_acct_fqdn}" != "${gcloud_acct_if_any}" ]; then
              GCLOUD_STORAGE_PUSH=(`echo "N"`)
          fi
          echo "INFO: ROOT_FOLDER: ${my_current_buk_data}"
}


CSRV_OK=$(echo "NONE")

 status_flag_get_cmd=$(echo "gs://my_current_buk_data/iac_scan_status/${status_flag_file}")
check_cloud_obj_srv ()
{
    /apps/bin/gcp_srv_acct_stp.sh 1>>/tmp/gcp_login.std01 2>>/tmp/gcp_login.std02

   cat /tmp/gcp_login.std01
   cat /tmp/gcp_login.std02

   rm -rf /tmp/gcp_login.std01 /tmp/gcp_login.std02
   process_proj_name
   status_flag_get_cmd=$(echo "gs://${my_current_buk_data}/iac_scan_status/${status_flag_file}")
}

    processed_dir=$(echo "iac_scan_status")
    mkdir -p ${dw_dir}/${processed_dir}
    status_flag_file=$(echo "current_status.info")
    current_status_processed=${current_status_processed:-NONE}
    init_status=${init_status:-00000000-00-000}
    filter_last_hr=${filter_last_hr:-00000000-00-000}
    filter_limit=${filter_limit:-00000}

#for all in `cat ${tfplan_file} | jq  '[paths(type == "object")|join(".") ]' | sed -e 's/\.\([0-9]\+\)/\[\1\]/g' | sed 's/\"/\./' | sed 's/\"//g'`; do echo ${all} ; done

    get_all_ls=()

    get_date_folder_from_obj_ar=()
    get_date_hh_folder_from_obj_ar=()
    declare -A get_date_folder_from_obj_hash
    declare -A get_date_hh_folder_from_obj_hash
    declare -a collect_rpt_gz_files_already_present_ar
    declare -a collect_rpt_files_already_present_ar
    declare -a reports_to_pull_tfp
    declare -a reports_to_pull_obj
    declare -a reports_to_pull_scn
    declare -a reports_to_pull_sts
    declare -a collect_tfp_files_already_present
    declare -a collect_obj_files_already_present
    declare -a collect_scn_files_already_present
    declare -a collect_sts_files_already_present

    tfp_check_file=$(echo "NONE")
    rpt_check_file=$(echo "NONE")
    scn_check_file=$(echo "NONE")
    sts_check_file=$(echo "NONE")
    tfp_search_pattern=$(echo "NONE")
    rpt_search_pattern=$(echo "NONE")
    scn_search_pattern=$(echo "NONE")
    sts_search_pattern=$(echo "NONE")
    let collect_tfp_files_already_present_ct=0
    let collect_obj_files_already_present_ct=0
    let collect_scn_files_already_present_ct=0
    let collect_sts_files_already_present_ct=0
get_status_of_processed_rpt ()
{
    echo "INFO: FN-NAME get_status_of_processed_rpt"
    choice=$(echo "rpt")
    DATE=${1:-NONE}
    LOAD_OPT1=${2:-N} # push into local s3
    LOAD_OPT2=${3:-N} # send to reporting tool
    RERUN_ALL=${rerun:-N}
    FORCE_REPROCESS=${6:-Y} # force re-process


    if [ "${DATE}" == "NONE" ]; then
         echo "ERROR: Usage $0 Missing Parameter Date. EXIT_WITH_ERR_CODE=100"
         echo "ERROR: Usage $0 ${STORAGE_FOLDER_KEY1}. EXIT_WITH_ERR_CODE=100"
         exit 100
    else
         echo "INFO: P2 ${1} (DATE)"
    fi

    if [ "${HOUR}" == "NONE" ]; then
         #echo "INFO: NO_HOUR_PASSED"
         HOUR=(`echo "STAR"`)
    fi
         echo "INFO: P3 ${HOUR} (TIME)"

    if [ "${LOAD_OPT1}" == "N" ]; then
         echo "INFO: P2 LOAD_OPT1, DFAULT=N. (N -> DONT_SEND_DATA_TO_S3, Y -> SEND_DATA_TO_S3)"
    else
         echo "INFO: P2 LOAD_OPT1 ${LOAD_OPT1}. (N -> DONT_SEND_DATA_TO_S3, Y -> SEND_DATA_TO_S3)"
    fi

    if [ "${LOAD_OPT2}" == "N" ]; then
         echo "INFO: P3 LOAD_OPT2, DFAULT=N. (N -> NO_REPPORT_TO_TOOL, Y SEND_DATA_TO_REPORTING_TOOLS)"
    else
         echo "INFO: P3 LOAD_OPT2 ${LOAD_OPT2}. (N -> NO_REPPORT_TO_TOOL, Y SEND_DATA_TO_REPORTING_TOOLS)"
    fi
    if [ "${RERUN_ALL}" == "N" ]; then
         echo "INFO: RERUN_VAR_ENV RERUN, DFAULT=N. (N -> NO_DOWNLOAD_FROM_OBJ, NO_PROCESS, Y RERUN ALL STEPS)"
    else
         echo "INFO: P3 LOAD_OPT2 ${LOAD_OPT2}. (N -> NO_REPPORT_TO_TOOL, Y SEND_DATA_TO_REPORTING_TOOLS)"
    fi
    if [ "${FORCE_REPROCESS}" == "N" ]; then
         echo "INFO: P6  FORCE_REPROCESS, DFAULT=N. (if Y -> no force, N -> force reprocess)"
    else
         echo "INFO: P6  FORCE_REPROCESS ${FORCE_REPROCESS} (if Y -> no force, N -> force reprocess)"
    fi

   day_date_format_yyyymmdd=$(echo "${DATE}" | cut -d "-" -f 1)
   week_date_format_yyyyww=$(echo "${DATE}" | cut -d "-" -f 2)
   month_date_format_yyyymm=$(echo "${day_date_format_yyyymmdd}" | cut -c 1-6)
   year_date_format_yyyy=$(echo "${day_date_format_yyyymmdd}" | cut -c 1-4)

    case "${choice}" in

    "rpt")
          echo "INFO: cloud obj pull rpt_start_`date '+%H_%M_%S-%s-%W_%j'`"
          out_put_file=$(echo "rpt_folder_file_process.info")
          search_pattern=$(echo "gs://${my_current_buk_data}/${storage_folder}/${DATE}/")
          tfp_search_pattern=(`echo "gs://${my_current_buk_data}/iac_scan_tf_plan/${DATE}/*/*/*"`)
          sts_search_pattern=(`echo "gs://${my_current_buk_data}/iac_scan_processed/${year_date_format_yyyy}*-${week_date_format_yyyyww}-*/"`)
          obj_search_pattern=(`echo "gs://${my_current_buk_data}/iac_scan_rpt_bucket/${DATE}/*/*/*"`)
          scn_search_pattern=(`echo "gs://${my_current_buk_data}/iac_scan_rpt_kics/${DATE}/*/*/*"`)
             dir_nm=$(echo "${target_dir}/iac_scan_status/rpt/${YEAR}/${DATE}")
             out_put_file=$(echo "${HOUR}_rpt_folder_file_process.info")
             date_based_root_dir=$(echo "${target_dir}/iac_scan_status/rpt/${YEAR}/${DATE}")
             date_based_tfp_dir=$(echo "${target_dir}/iac_scan_status/tfp/${YEAR}/${DATE}")
             date_based_obj_dir=$(echo "${target_dir}/iac_scan_status/obj/${YEAR}/${DATE}")
             date_based_sts_dir=$(echo "${target_dir}/iac_scan_status/sts/${YEAR}/${DATE}")
             date_based_scn_dir=$(echo "${target_dir}/iac_scan_status/scn/${YEAR}/${DATE}")
             mkdir -p ${date_based_root_dir}
             mkdir -p ${date_based_tfp_dir}
             mkdir -p ${date_based_obj_dir}
             mkdir -p ${date_based_sts_dir}
             mkdir -p ${date_based_scn_dir}
             if [ "${RERUN_ALL}" != "N" ]; then
                 echo "INFO: DELETING DIR: ${target_dir}/iac_scan_status/rpt/${YEAR}/${DATE}"
                 rm -rf ${target_dir}/iac_scan_status/rpt/${YEAR}/${DATE}
                 rm -rf ${target_dir}/iac_scan_status/sts/${YEAR}/${DATE}
                 rm -rf ${target_dir}/iac_scan_status/tfp/${YEAR}/${DATE}
                 rm -rf ${target_dir}/iac_scan_status/obj/${YEAR}/${DATE}
                 rm -rf ${target_dir}/iac_scan_status/scn/${YEAR}/${DATE}
                 
             fi
             echo "INFO: cloud obj pull rpt_end_`date '+%H_%M_%S-%s-%W_%j'`"
             collect_rpt_gz_files_already_present_ar=(`ls -C1 ${date_based_root_dir}/daily_rpt/*.gz 2>/dev/null`)
             collect_rpt_files_already_present_ar=(`ls -C1 ${date_based_root_dir}/all_rpt/summary_rules_violated_file_*.pipe. 2>/dev/null`)
             #${1}/rpt_${2}_process.info
             process_file_info_ct=$(cat ${date_based_root_dir}/rpt_${DATE}_process.info 2>/dev/null | wc -l)
             process_file_info_ct=${process_file_info_ct:-0}
             pipe_file_info_ct=$(cat ${date_based_root_dir}/rpt_${DATE}_pipe.info 2>/dev/null | wc -l)
             tfp_files_only=(`echo "tfp_files_to_process.info"`)
             obj_files_only=(`echo "obj_${DATE}_process.info"`)
             scn_files_only=(`echo "scn_${DATE}_process.info"`)
             sts_files_only=(`echo "sts_${DATE}_process.info"`)
             tfp_check_file=(`ls -C1 ${date_based_tfp_dir}/${tfp_files_only} 2>/dev/null`)
             tfp_check_file=${tfp_check_file:-NONE}
             collect_tfp_files_already_present=(`ls -C1 ${date_based_tfp_dir}/daily_tfp/*.tfplan 2>/dev/null`)
             collect_tfp_files_already_present_ct=$(echo "${#collect_tfp_files_already_present[@]}")
             collect_tfp_files_already_present_ct=${collect_tfp_files_already_present_ct:-0}
             echo "INFO: TFP_FILES_COUNT ${collect_tfp_files_already_present_ct}"
             obj_check_file=(`ls -C1 ${date_based_obj_dir}/${obj_files_only} 2>/dev/null`)
             obj_check_file=${obj_check_file:-NONE}
             echo "INFO: OBJ date_based_obj_dir ${date_based_obj_dir}  ls -C1 ${date_based_obj_dir}/all_obj/*.json"
             collect_obj_files_already_present=(`ls -C1 ${date_based_obj_dir}/all_obj/*.json 2>/dev/null`)
             collect_obj_files_already_present_ct=$(echo "${#collect_obj_files_already_present[@]}")
             collect_obj_files_already_present_ct=${collect_obj_files_already_present_ct:-0}
             echo "INFO: OBJ_FILES_COUNT ${collect_obj_files_already_present_ct}"
             scn_check_file=(`ls -C1 ${date_based_scn_dir}/${scn_files_only} 2>/dev/null`)
             scn_check_file=${scn_check_file:-NONE}
             collect_scn_files_already_present=(`ls -C1 ${date_based_scn_dir}/all_scn/*.json 2>/dev/null`)
             collect_scn_files_already_present_ct=$(echo "${#collect_scn_files_already_present[@]}")
             collect_scn_files_already_present_ct=${collect_scn_files_already_present_ct:-0}
             echo "INFO: SCN_FILES_COUNT ${collect_scn_files_already_present_ct}"
             sts_check_file=(`ls -C1 ${date_based_sts_dir}/sts_all_files.info 2>/dev/null`)
             sts_check_file=${sts_check_file:-NONE}
             collect_sts_files_already_present=(`ls -C1 ${date_based_sts_dir}/sts_all_files.info 2>/dev/null`)
             collect_sts_files_already_present_ct=$(echo "${#collect_sts_files_already_present[@]}")
             collect_scn_files_already_present_ct=${collect_sts_files_already_present_ct:-0}
             echo "INFO: STS_FILES_COUNT ${collect_sts_files_already_present_ct}"
             let process_num=0
             . /apps/lib/PROCESS_ST_255.sh
             . /apps/lib/PROCESS_OBJ.sh
             . /apps/lib/PROCESS_SCN.sh
             . /apps/lib/PROCESS_STS.sh

             declare -A p1_hash
             declare -A p2_hash
             declare -A p3_hash

             p1_hash[ST_255]="${date_based_root_dir}"
             p2_hash[ST_255]="${DATE}"
             p3_hash[ST_255]="rpt"
             p4_hash[ST_255]="rpt"

             echo "INFO: collect_rpt_gz_files_already_present_ar ${#collect_rpt_gz_files_already_present_ar[@]}"
             echo "INFO: collect_rpt_files_already_present_ar ${#collect_rpt_files_already_present_ar[@]}"

             #for all_rpt in `echo "ST_255"`   # ST_7 ST_15 ST_31 ST_63 ST_127 ST_255"`
             #do
                 #echo "INFO: Calling Function PROCESS_${all_rpt} ${p1_hash[${all_rpt}]}  ${p2_hash[${all_rpt}]} ${p3_hash[${all_rpt}]} ${p4_hash[${rpt}]}"
                 #PROCESS_${all_rpt} ${p1_hash[${all_rpt}]}  ${p2_hash[${all_rpt}]} ${p3_hash[${all_rpt}]} ${p4_hash[${all_rpt}]}
             #done
             echo "#************************* MAIN_PROCESS_START ***********************#"
             case "${pg_to_run}" in
             "1") 
                  echo "INFO: Calling Function with parameters pg_to_run ${pg_to_run}   ${date_based_root_dir} ${DATE} rpt rpt"
                  PROCESS_ST_255 "${date_based_root_dir}" "${DATE}" "rpt" "rpt"
                  ;;
             "2") 
                  echo "INFO: Calling Function with parameters pg_to_run ${pg_to_run}   ${date_based_root_dir} ${DATE} obj obj"
                  process_obj "${date_based_obj_dir}" "${DATE}" "obj" "obj"
                  exit 0
                  ;;
             "4") 
                  echo "INFO: Calling Function with parameters pg_to_run ${pg_to_run}   ${date_based_root_dir} ${DATE} scn scn"
                  process_scn "${date_based_scn_dir}" "${DATE}" "scn" "scn"
                  exit 0
                  ;;
             "8") 
                  echo "INFO: Calling Function with parameters pg_to_run ${pg_to_run}   ${date_based_root_dir} ${DATE} sts sts"
                  process_sts "${date_based_scn_dir}" "${DATE}" "sts" "sts"
                  exit 0
                  ;;
             "3")
                  echo "INFO: Calling Function with parameters pg_to_run ${pg_to_run}   ${date_based_root_dir} ${DATE} rpt,obj"
                  PROCESS_ST_255 "${date_based_root_dir}" "${DATE}" "rpt" "rpt"
                  process_obj "${date_based_obj_dir}" "${DATE}" "obj" "obj"
                  ;;
             "5")
                  echo "INFO: Calling Function with parameters pg_to_run ${pg_to_run}   ${date_based_root_dir} ${DATE} rpt,scn"
                  PROCESS_ST_255 "${date_based_root_dir}" "${DATE}" "rpt" "rpt"
                  process_scn "${date_based_scn_dir}" "${DATE}" "scn" "scn"
                  ;;
             "7")
                  echo "INFO: Calling Function with parameters pg_to_run ${pg_to_run}   ${date_based_root_dir} ${DATE} rpt,obj,scn"
                  PROCESS_ST_255 "${date_based_root_dir}" "${DATE}" "rpt" "rpt"
                  process_obj "${date_based_obj_dir}" "${DATE}" "obj" "obj"
                  process_scn "${date_based_scn_dir}" "${DATE}" "scn" "scn"
                  ;;
              15)
                  echo "INFO: Calling Function with parameters pg_to_run ${pg_to_run}   ${date_based_root_dir} ${DATE} rpt,obj,scn,sts"
                  PROCESS_ST_255 "${date_based_root_dir}" "${DATE}" "rpt" "rpt"
                  process_obj "${date_based_obj_dir}" "${DATE}" "obj" "obj"
                  process_scn "${date_based_scn_dir}" "${DATE}" "scn" "scn"
                  process_sts "${date_based_scn_dir}" "${DATE}" "sts" "sts"
                  ;;
              *)
                  echo "INFO: Calling Function with parameters pg_to_run all   ${date_based_root_dir} ${DATE} rpt,obj,scn,sts"
                  PROCESS_ST_255 "${date_based_root_dir}" "${DATE}" "rpt" "rpt"
                  process_obj "${date_based_obj_dir}" "${DATE}" "obj" "obj"
                  process_scn "${date_based_scn_dir}" "${DATE}" "scn" "scn"
                  ;;
              esac
              ;;
      *)
             echo "INFO: NO_PARAMETER_PASSED_DEFAULT_CONDITION"
             ;;
      esac

}


all_run ()
{
    echo "INFO: FN-NAME all_run"
    echo_vars
    check_cloud_obj_srv
    echo "INFO: CALLING get_status_of_processed_rpt ${1} ${2} ${3} ${4} ${5}"
    get_status_of_processed_rpt ${1} ${2} ${3} ${4} ${5}
    if [ "${process_sts_files_metadata_run}" == "Y" ]; then
       /apps/bin/process_sts_files_metadata.sh ${1} ${2} ${3} ${4} ${5}
    fi
}

NONE ()
{
    echo "INFO: FN-NAME NONE"
    echo "INFO: NOTHING_TO_EXECUTE"
}

start_web_server ()
{
    echo "INFO: FN-NAME start_web_server"
    python3 -m http.server 1>/tmp/web.log 2>/tmp/web_err.log &
}
        all_run ${p1} ${p2} ${p3} ${p4} ${5}
        echo "#************************* MAIN_PROCESS_END ***********************#"

#DPC-Function push_report_to_s3  -Definition End
