#!/usr/bin/env sh

     export PATH=${PATH}:/apps/bin:/apps/lib:/apps/kics/bin:/apps/snyk/bin:/apps/opa/bin:/apps/gcp/google-cloud-sdk/bin:/apps/hc/tf:/apps/hc/vault:/apps/hc/consul:/apps/hc/bin
     echo "INFO: Running $0 script"

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
     echo "INFO: OBJ_FOLDER_ARCH=/${my_current_buk_data}/FOLDER01/STORAGE_FOLDER_KEY1/HOUR_KEY/APPID/PIPELINE"
     echo "INFO: OBJ_FOLDER_ARCH=/${my_current_buk_data}/iac_scan_tf_plan/20231031-44-304/14/rphaic-ptc/ECS"
     echo "HELP: Usage $0 DATE_AS_KEY"
     #echo "HELP: Usage Example  $0 20231031-42-304 (YYYYMMDD-WEEK-DAY_OF_YEAR)"
     echo "HELP: Usage Example  $0 (default will use last hour)"
     #echo "HELP: Usage Example  $0 today (from 00-lasthour)"
     #echo "HELP: Usage Example  $0 yesterday (from 00-23)"
     #echo "HELP: Usage Example  $0 lastweek (week before current week)"
     #echo "HELP: Usage Example  $0 week (current week)"
     #echo "HELP: Usage Example  $0 month (current month)"
     #echo "HELP: Usage Example  $0 lostmonth (month before current month)"
     #echo "HELP: Usage Example  $0 qtr (last 3 month)"
     #echo "HELP: Usage Example  $0 year (current year)"
     #echo "HELP: Usage Example  $0 all (current year: from 01/01/YYYY until last hour)"
}
#DPC-help display to clients how to run this container. End

  #build_id_run=$(date '+%Y%m%d%H%M%S-%W%Y-%j')
  #ID=$(date '+%s')
  #WEEK=$(date '+%W')
  #RUN_DATE=$(date '+%Y%m%d')
  #DAY=$(date '+%j')
  #RPT_KEY=$(date '+%Y%m%d-%W-%j')
  #HR=$(date '+-%H')
  #MONTH=$(date '+%Y%m')

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

  #dw_dir=(`echo "/data/R-${build_id_run}"`)
  #dw_dir=(`echo "/data/${STORAGE_FOLDER_KEY1}"`)
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

CSRV_OK=$(echo "NONE")

check_cloud_obj_srv ()
{
    /apps/bin/gcp_srv_acct_stp.sh 1>>/tmp/gcp_login.std01 2>>/tmp/gcp_login.std02

   cat /tmp/gcp_login.std01
   cat /tmp/gcp_login.std02

   rm -rf /tmp/gcp_login.std01 /tmp/gcp_login.std02
   process_proj_name
}

    files_to_download_list=()
    files_to_download_tf_list=()
    reports_to_pull_tf_files=()
    reports_to_pull_snyk_gz=()
    reports_to_pull_kics_gz=()
    reports_to_pull_csv_gz=()
    reports_to_pull_bucket_gz=()
    reports_to_pull_sm=()
    reports_to_pull_cr=()
    reports_to_pull_rr=()
    declare -A sm_file_key
    declare -A cr_file_key
    declare -A rr_file_key
    declare -A all_file_key
    declare -A three_set_rpt_files_hash
    declare -A csv_unzip_appnm_dir_hash
    declare -A csv_unzip_appnm_rpt_dir_hash
    declare -A csv_unzip_appnm_rpt_dir_target_hash
    declare -A bucket_unzip_appnm_dir_hash
    declare -A bucket_unzip_appnm_rpt_dir_hash
    declare -A all_tf_plan_folder_list_hash
    declare -A all_tf_plan_folder_file_list_hash
    declare -A all_tf_plan_folder_file_list_rhash
    declare -A all_tf_plan_folder_file_list_chash
    declare -A all_tf_plan_folder_file_list_fhash

#DPC-Function push_report_to_bucket  -Definition Start
## this function will push all the reports to bucket with key $build_id

csv_to_xls_with_ws ()
{
    echo "INFO: FN-NAME csv_to_xls_with_ws"
    let index=0
    for all_csv_final_gz_dir_key in `echo "${!csv_unzip_appnm_rpt_dir_hash[@]}"`
    do
        all_csv_final_gz_dir=${csv_unzip_appnm_rpt_dir_hash[${all_csv_final_gz_dir_key}]}
#gs://${my_current_buk_data}/iac_scan_rpt_csv/CSET3/JITHUB/20230921-38-264/13/csv_1695302544-20230921-38-264_13.CSET3.JITHUB.gz
        target_dir=${csv_unzip_appnm_rpt_dir_target_hash[${all_csv_final_gz_dir_key}]}
        tgt_dir_to_create_clip=(`echo "${target_dir}" | cut -d "/" -f 5,6,7,8`)
        tgt_dir_to_create=(`echo "/workspace/dw/${tgt_dir_to_create_clip}"`)
        echo "INFO: -dir_to_process ${all_csv_final_gz_dir}"
        echo "INFO: -target_dir_to_create ${target_dir}"
        echo "INFO: -target_dir_to_create ${tgt_dir_to_create}"
        echo "INFO: creating_target_dir ${tgt_dir_to_create}"
        mkdir -p ${tgt_dir_to_create}
        echo "INFO: -collecting files ls -C1 ${all_csv_final_gz_dir}"
        cd ${all_csv_final_gz_dir}
        echo "INFO: current_dir `pwd`"
        sheet1_rpt=(`ls -C1 cr_*`)
        sheet2_rpt=(`ls -C1 sm_*`)
        sheet3_rpt=(`ls -C1 rr_*`)
        echo "INFO: sheet1 csv file ${sheet1_rpt}"
        echo "INFO: sheet2 csv file ${sheet2_rpt}"
        echo "INFO: sheet3 csv file ${sheet3_rpt}"
        xlsx_file=(`echo "${sheet1_rpt}" | cut -d "." -f 1 | sed 's/cr_//'`)
        echo "INFO: Producing file ${xlsx_file}.xlsx"
        #echo "INFO: Deleting file if exists /workspace/dw/${xlsx_file}.xlsx"
        echo "INFO: Deleting file if exists ${tgt_dir_to_create}/${xlsx_file}.xlsx"
        #file_to_delete=(`ls -C1 /workspace/dw/${xlsx_file}.xlsx 2>/dev/null`)
        file_to_delete=(`ls -C1 ${tgt_dir_to_create}/${xlsx_file}.xlsx 2>/dev/null`)
        file_to_delete=${file_to_delete:-NONE}
        if [ "${file_to_delete}" != "NONE" ]; then
            echo "INFO: Deleting file ${tgt_dir_to_create}/${xlsx_file}.xlsx"
            rm -rf ${tgt_dir_to_create}/${xlsx_file}.xlsx
        fi
        echo "INFO: executing_python3 -python3 /apps/bin/convert_files_to_xls.py ${sheet1_rpt} ${sheet2_rpt} ${sheet3_rpt} ${tgt_dir_to_create}/${xlsx_file}.xlsx"
        python3 /apps/bin/convert_files_to_xls.py ${sheet1_rpt} ${sheet2_rpt} ${sheet3_rpt} ${tgt_dir_to_create}/${xlsx_file}.xlsx
        final_file=(`ls -C1 ${tgt_dir_to_create}/${xlsx_file}.xlsx`)
        echo "INFO: url http://127.0.0.1/${final_file}"
        cd -
        #read SSSSS
    done
}
another_bug ()
{
    for all_rpts_found in `echo "${three_set_rpt_files_hash[@]}"`
    do
          f1_sm=(`echo "${all_rpts_found}" | cut -d "," -f 1`)
          f2_cr=(`echo "${all_rpts_found}" | cut -d "," -f 2`)
          f3_rr=(`echo "${all_rpts_found}" | cut -d "," -f 3`)
          reports_to_pull_sm[$index]=${f1_sm}
          reports_to_pull_cr[$index]=${f2_cr}
          reports_to_pull_rr[$index]=${f3_rr}
          let index=${index}+1
    done

    for all in {1..3}
    do
       echo "${all}"
       case "${all}" in
       1)
           for all_sm in `echo "${reports_to_pull_sm[@]}"`
           do
                   cat ${all_sm}
           done
           ;;
       2)
           for all_cr in `echo "${reports_to_pull_cr[@]}"`
           do
                   cat ${all_cr}
           done
            ;;
       3)
           for all_rr in `echo "${reports_to_pull_rr[@]}"`
           do
                   cat ${all_rr}
           done
           ;;
       *)
           echo "INFO: default case"
            ;;
       esac
    done
}

    all_csv_rpt_folder_list=$(echo "${STORAGE_FOLDER_KEY1}_csv_folder.info")
    all_csv_rpt_folder_file_list=$(echo "${STORAGE_FOLDER_KEY1}_csv_folder_file.info")
    all_csv_rpt_folder_file_list_process=$(echo "${STORAGE_FOLDER_KEY1}_csv_folder_file_process.info")
    
    all_snyk_rpt_folder_list=$(echo "${STORAGE_FOLDER_KEY1}_snyk_folder.info")
    all_snyk_rpt_folder_file_list=$(echo "${STORAGE_FOLDER_KEY1}_snyk_folder_file.info")
    all_snyk_rpt_folder_file_list_process=$(echo "${STORAGE_FOLDER_KEY1}_snyk_folder_file_process.info")

    all_kics_rpt_folder_list=$(echo "${STORAGE_FOLDER_KEY1}_kics_folder.info")
    all_kics_rpt_folder_file_list=$(echo "${STORAGE_FOLDER_KEY1}_kics_folder_file.info")
    all_kics_rpt_folder_file_list_process=$(echo "${STORAGE_FOLDER_KEY1}_kics_folder_file_process.info")

    processed_dir=$(echo "iac_scan_status")
    mkdir -p ${dw_dir}/${processed_dir}
    status_flag_file=$(echo "current_status.info")
    status_flag_get_cmd=$(echo "gs://${my_current_buk_data}/iac_scan_status/${status_flag_file}")
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
    get_date_folder_from_obj_csv_root=(`echo "gs://${my_current_buk_data}/iac_scan_rpt_csv/"`)

get_date_folder_from_obj ()
{
    echo "INFO: FN-NAME get_date_folder_from_obj"
    #gs://${my_current_buk_data}/iac_scan_rpt_csv/20230928-39-271/
    get_date_folder_from_obj_ar=(`gcloud storage ls gs://${my_current_buk_data}/iac_scan_tf_plan/* |  tr ' ' '\n' | grep -v ":$"`)
    for all_date_key in `echo "${get_date_folder_from_obj_ar[@]}" | tr ' ' '\n' | cut -d "/" -f 5-6'`
    do
      echo "INFO: all_date_key ${all_date_key}"
      new_key_fyyyymmddww=(`echo "${all_date_key}" | cut -d "-" -f 1-2`)
      new_key_fwwj=(`echo "${all_date_key}" | cut -d "-" -f 1-2`)
      echo "INFO: VAL=${all_date_key}"
      get_date_folder_from_obj_hash[${all_date_key}]="${all_date_key}"
    done
    for all_date_key in `echo "${!get_date_folder_from_obj_hash[@]}"`
    do
       val=(`echo "${get_date_folder_from_obj_hash[${all_date_key}]}"`)
       echo "INFO: KEY=${all_date_key}, VAL - ${val}"
       get_date_hh_folder_from_obj_ar=(`gcloud storage ls gs://${my_current_buk_data}/iac_scan_rpt_csv/${val} |  tr ' ' '\n'`)
       for all_hh_keys in `echo "${get_date_hh_folder_from_obj_ar[@]}" | tr ' ' '\n' | cut -d "/" -f 5-6`
       do
         get_date_hh_folder_from_obj_hash[${all_date_key}]="${all_hh_keys}"
       done
    done
    for all_hr in `echo "${!get_date_hh_folder_from_obj_hash[@]}"`
    do
       get_val=(`echo "${get_date_hh_folder_from_obj_hash[${all_hr}]}"`)
       echo "INFO: KEY=${all_hr}, VAL=${get_val}"
    done
    
}
get_status_of_processed_rpt ()
{
    echo "INFO: FN-NAME get_status_of_processed_rpt"
    choice=${1:-NONE}
    DATE=${2:-NONE}
    HOUR=${3:-NONE}
    LOAD_OPT1=${4:-N} # push into local s3
    LOAD_OPT2=${5:-N} # send to reporting tool
    FORCE_REPROCESS=${6:-Y} # force re-process
    

    if [ "${choice}" == "NONE" ]; then
         echo "ERROR: Usage $0 Missing Parameter type (tfp/csv/buk). EXIT_WITH_ERR_CODE=100"
         exit 100
    else
         echo "INFO: P1  ${1} (choice)"
    fi

    if [ "${DATE}" == "NONE" ]; then
         echo "ERROR: Usage $0 Missing Parameter Date. EXIT_WITH_ERR_CODE=100"
         echo "ERROR: Usage $0 ${STORAGE_FOLDER_KEY1}. EXIT_WITH_ERR_CODE=100"
         exit 100
    else
         echo "INFO: P2 ${2} (DATE)"
    fi

    if [ "${HOUR}" == "NONE" ]; then
         #echo "INFO: NO_HOUR_PASSED"
         HOUR=(`echo "STAR"`)
    fi
         echo "INFO: P3 ${HOUR} (TIME)"

    if [ "${LOAD_OPT1}" == "N" ]; then
         echo "INFO: P4 LOAD_OPT1, DFAULT=N. (N -> DONT_SEND_DATA_TO_S3, Y -> SEND_DATA_TO_S3)"
    else
         echo "INFO: P4 LOAD_OPT1 ${LOAD_OPT1}. (N -> DONT_SEND_DATA_TO_S3, Y -> SEND_DATA_TO_S3)"
    fi

    if [ "${LOAD_OPT2}" == "N" ]; then
         echo "INFO: P5 LOAD_OPT2, DFAULT=N. (N -> NO_REPPORT_TO_TOOL, Y SEND_DATA_TO_REPORTING_TOOLS)"
    else
         echo "INFO: P5 LOAD_OPT2 ${LOAD_OPT2}. (N -> NO_REPPORT_TO_TOOL, Y SEND_DATA_TO_REPORTING_TOOLS)"
    fi

    if [ "${FORCE_REPROCESS}" == "N" ]; then
         echo "INFO: P6  FORCE_REPROCESS, DFAULT=N. (if Y -> no force, N -> force reprocess)"
    else
         echo "INFO: P6  FORCE_REPROCESS ${FORCE_REPROCESS} (if Y -> no force, N -> force reprocess)"
    fi

    case "${choice}" in

    "tfp")
          echo "INFO: cloud obj pull csv_start_`date '+%H_%M_%S-%s-%W_%j'`"
          out_put_file=(`echo "tfp_folder_file_process.info"`)
          tfp_files_only=(`echo "tfp_files_to_process.info"`)
          sts_files_only=(`echo "sts_files_to_process.info"`)
          dir_nm=(`echo "${dw_dir}/iac_scan_status"`)
          date_based_root_dir=(`echo "${dw_dir}/iac_scan_status"`)
          search_pattern=(`echo "gs://${my_current_buk_data}/iac_scan_tf_plan/${DATE}/"`)
          if [ "${HOUR}" == "STAR" ]; then
             #echo "INFO: executing cmd - gcloud storage ls gs://${my_current_buk_data}/iac_scan_tf_plan/${DATE}/*/*/* |  tr ' ' '\n'"
             #reports_to_pull_csv_gz=(`gcloud storage ls gs://${my_current_buk_data}/iac_scan_tf_plan/${DATE}/*/*/* |  tr ' ' '\n'`)
             dir_nm=(`echo "${dw_dir}/iac_scan_status/tfp/${YEAR}/${DATE}"`)
             out_put_file=(`echo "${DATE}_tfp_folder_file_process.info"`)
             date_based_root_dir=(`echo "${dw_dir}/iac_scan_status/tfp/${YEAR}/${DATE}"`)
             date_sts_based_root_dir=(`echo "${dw_dir}/iac_scan_status/sts/${YEAR}/${DATE}"`)
             search_pattern=(`echo "gs://${my_current_buk_data}/iac_scan_tf_plan/${DATE}/*/*/*"`)
          else
             dir_nm=(`echo "${dw_dir}/iac_scan_status/tfp/${YEAR}/${DATE}/${HOUR}"`)
             out_put_file=(`echo "${HOUR}_tfp_folder_file_process.info"`)
             date_based_root_dir=(`echo "${dw_dir}/iac_scan_status/tfp/${YEAR}/${DATE}"`)
             date_sts_based_root_dir=(`echo "${dw_dir}/iac_scan_status/sts/${YEAR}/${DATE}"`)
             search_pattern=(`echo "gs://${my_current_buk_data}/iac_scan_tf_plan/${DATE}/${HOUR}/*/*"`)
          fi
             echo "INFO: cloud obj pull tfp_end_`date '+%H_%M_%S-%s-%W_%j'`"
             out_put_sts_file=(`echo "${DATE}_sts_folder_file_process.info"`)
             check_file=(`ls -C1 ${dir_nm}/${tfp_files_only} 2>/dev/null`)
             check_sts_file=(`ls -C1 ${dir_nm}/${sts_files_only} 2>/dev/null`)
             check_file=${check_file:-NONE}
             check_sts_file=${check_sts_file:-NONE}
             collect_tfp_files_already_present=(`ls -C1 ${date_based_root_dir}/daily_tfp/*.tfplan 2>/dev/null`)
             collect_sts_files_already_present=(`ls -C1 ${date_sts_based_root_dir}/daily_sts/rpt_*.gz 2>/dev/null`)
             rpt_daily_csv_ar=(`ls -C1 ${date_based_root_dir}/all_tfp/*csv 2>/dev/null`)
             rpt_daily_sts_ar=(`ls -C1 ${date_based_root_dir}/all_sts/*csv 2>/dev/null`)
             echo "INFO: BUCKET_TFP_FILE_PULL_DECISION_VALIDATION_CT var_name=check_file, value=${check_file}"
             echo "INFO: BUCKET_TFP_FILE_PULL_DECISION_VALIDATION_CT var_name=collect_tfp_files_already_present, value=${#collect_zip_files_already_present[@]}"
             echo "INFO: BUCKET_TFP_FILE_PULL_DECISION_VALIDATION_CT var_name=rpt_daily_csv_ar, value=${#rpt_daily_csv_ar}"
             echo "INFO: BUCKET_STS_FILE_PULL_DECISION_VALIDATION_CT var_name=check_sts_file, value=${#rpt_daily_sts_ar}"
             
             let process_num=0
             process_ct=(`echo "ST_0"`)
             if [ "${check_file}" != "NONE" ]; then
                 let process_num=${process_num}+1
                 process_ct=(`echo "ST_${process_num}"`)
             fi
             if [ ${#collect_tfp_files_already_present[@]} -gt 0 ]; then
                 let process_num=${process_num}+2
                 process_ct=(`echo "ST_${process_num}"`)
             fi
             if [ ${#rpt_daily_csv_ar[@]} -gt 0 ]; then
                 let process_num=15
                 process_ct=(`echo "ST_${process_num}"`)
             fi

             . /apps/lib/PROCESS_ST_0.sh
             . /apps/lib/PROCESS_ST_1.sh
             . /apps/lib/PROCESS_ST_3.sh
             #. /apps/lib/PROCESS_ST_7.sh
             . /apps/lib/PROCESS_ST_15.sh
             . /apps/lib/PROCESS_ST_31.sh
             . /apps/lib/PROCESS_ST_63.sh
             . /apps/lib/PROCESS_ST_127.sh
             . /apps/lib/PROCESS_ST_255.sh

             declare -A p1_hash
             declare -A p2_hash
             declare -A p3_hash

             p1_hash[ST_0]="tfp"
             p2_hash[ST_0]="NONE"
             p3_hash[ST_0]="NONE"
             p4_hash[ST_0]="NONE"

             p1_hash[ST_1]="tfp"
             p2_hash[ST_1]="NONE"
             p3_hash[ST_1]="NONE"
             p4_hash[ST_1]="NONE"

             p1_hash[ST_3]="tfp"
             p2_hash[ST_3]="NONE"
             p3_hash[ST_3]="TEST"
             p4_hash[ST_3]="TEST"

             #p1_hash[ST_7]="${date_based_root_dir}/daily_csv"
             #p2_hash[ST_7]="all"

             p1_hash[ST_15]="${date_sts_based_root_dir}"
             p2_hash[ST_15]="${DATE}"
             p3_hash[ST_15]="sts"
             p4_hash[ST_15]="sts"

             p1_hash[ST_31]="tfp"
             p2_hash[ST_31]="${DATE}"
             p3_hash[ST_31]="tfp"
             p4_hash[ST_31]="${FORCE_REPROCESS}"

             p1_hash[ST_63]="tfp"
             p2_hash[ST_63]="${DATE}"
             p3_hash[ST_63]="tfp"
             p4_hash[ST_63]="${FORCE_REPROCESS}"

             p1_hash[ST_127]="${DATE}"
             p2_hash[ST_127]="${LOAD_OPT1}"
             p3_hash[ST_127]="${LOAD_OPT2}"
             p4_hash[ST_127]="${FORCE_REPROCESS}"

             echo "INFO: PARAMETERS: 127 ${p1_hash[ST_127]}, ${p2_hash[ST_127]},${p3_hash[ST_127]}"
             #p1_hash[ST_255]="tfp"
             #p2_hash[ST_255]="sts"

             for all_sts in `echo "ST_0 ST_1 ST_3 ST_15 ST_31 ST_63 ST_127"`   # ST_7 ST_15 ST_31 ST_63 ST_127 ST_255"`
             do
                 #PROCESS_${process_ct} ${p1_hash[${process_ct}]}  ${p2_hash[${process_ct}]}
                 echo "INFO: CALLING_PROCESS_${all_sts} ${p1_hash[${all_sts}]}  ${p2_hash[${all_sts}]} ${p3_hash[${all_sts}]} ${p4_hash[${all_sts}]}"
                 PROCESS_${all_sts} ${p1_hash[${all_sts}]}  ${p2_hash[${all_sts}]} ${p3_hash[${all_sts}]} ${p4_hash[${all_sts}]}
             done
              ;;
    "buk")
          echo "INFO: cloud obj pull buk_start_`date '+%H_%M_%S-%s-%W_%j'`"
          out_put_file=(`echo "folder_file_process.info"`)
          gz_files_only=(`echo "zip_files_to_process.info"`)
          dir_nm=(`echo "${dw_dir}/iac_scan_status"`)
          date_based_root_dir=(`echo "${dw_dir}/iac_scan_status"`)
          search_pattern=(`echo "gs://${my_current_buk_data}/iac_scan_rpt_bucket/${DATE}/"`)
          if [ "${HOUR}" == "STAR" ]; then
             dir_nm=(`echo "${dw_dir}/iac_scan_status/buk/${YEAR}/${DATE}"`)
             out_put_file=(`echo "${DATE}_buk_folder_file_process.info"`)
             date_based_root_dir=(`echo "${dw_dir}/iac_scan_status/buk/${YEAR}/${DATE}"`)
             search_pattern=(`echo "gs://${my_current_buk_data}/iac_scan_rpt_bucket/${DATE}/*/*/*"`)
          else
             dir_nm=(`echo "${dw_dir}/iac_scan_status/buk/${YEAR}/${DATE}/${HOUR}"`)
             out_put_file=(`echo "${HOUR}_buk_folder_file_process.info"`)
             date_based_root_dir=(`echo "${dw_dir}/iac_scan_status/buk/${YEAR}/${DATE}"`)
             search_pattern=(`echo "gs://${my_current_buk_data}/iac_scan_rpt_bucket/${DATE}/${HOUR}/*/*"`)
          fi
             echo "INFO: cloud obj pull buk_end_`date '+%H_%M_%S-%s-%W_%j'`"
             check_file=(`ls -C1 ${dir_nm}/${gz_files_only} 2>/dev/null`)
             check_file=${check_file:-NONE}
             collect_zip_files_already_present=(`ls -C1 ${date_based_root_dir}/daily_zip/*.gz 2>/dev/null`)
             zip_ar_files_list_ar=(`cat ${dir_nm}/${out_put_file} 2>/dev/null| sort |  grep "\.gz$"`)
             rpt_daily_csv_ar=(`ls -C1 ${date_based_root_dir}/all_buk/*csv 2>/dev/null`)
             daily_buk_ar=(`ls -C1 ${date_based_root_dir}/daily_buk/*.bucket 2>/dev/null`)
             echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT var_name=check_file, value=${check_file}"
             echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT var_name=collect_zip_files_already_present, value=${#collect_zip_files_already_present[@]}"
             echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT var_name=zip_ar_files_list_ar, value=${#zip_ar_files_list_ar[@]}"
             echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT var_name=rpt_daily_csv_ar, value=${#rpt_daily_csv_ar}"
             echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT var_name=daily_csv_ar, value=${#daily_csv_ar[@]}"
             echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT var_name=date_based_root_dir, value=${date_based_root_dir}"
             let process_num=0
             process_ct=(`echo "ST_0"`)
             if [ "${check_file}" != "NONE" ]; then
                 let process_num=${process_num}+1
                 process_ct=(`echo "ST_${process_num}"`)
             fi
             if [ ${#zip_ar_files_list_ar[@]} -gt 0 ]; then
                 let process_num=${process_num}+2
                 process_ct=(`echo "ST_${process_num}"`)
             fi
             if [ ${#daily_buk_ar[@]} -gt 0 ]; then
                 let process_num=${process_num}+4
                 process_ct=(`echo "ST_${process_num}"`)
             fi
             if [ ${#rpt_daily_csv_ar[@]} -gt 0 ]; then
                 let process_num=${process_num}+8
                 process_ct=(`echo "ST_${process_num}"`)
             fi

             . /apps/lib/untar.sh
             . /apps/lib/PROCESS_ST_0.sh
             . /apps/lib/PROCESS_ST_1.sh
             . /apps/lib/PROCESS_ST_3.sh
             . /apps/lib/PROCESS_ST_7.sh
             . /apps/lib/PROCESS_ST_15.sh
             . /apps/lib/PROCESS_ST_31.sh
             . /apps/lib/PROCESS_ST_63.sh
             . /apps/lib/PROCESS_ST_127.sh
             . /apps/lib/PROCESS_ST_255.sh

             declare -A p1_hash
             declare -A p2_hash

             p1_hash[ST_0]="buk"
             p2_hash[ST_0]="NONE"

             p1_hash[ST_1]="buk"
             p2_hash[ST_1]="NONE"

             p1_hash[ST_3]="buk"
             p2_hash[ST_3]="NONE"

             p1_hash[ST_7]="${date_based_root_dir}/daily_csv"
             p2_hash[ST_7]="all"

             p1_hash[ST_15]="buk"
             p2_hash[ST_15]="NONE"

             p1_hash[ST_31]="buk"
             p2_hash[ST_31]="NONE"

             p1_hash[ST_63]="buk"
             p2_hash[ST_63]="NONE"

             p1_hash[ST_127]="buk"
             p2_hash[ST_127]="NONE"

             p1_hash[ST_255]="buk"
             p2_hash[ST_255]="NONE"

             for all_sts in `echo "ST_0 ST_1 ST_3 ST_15"`  #ST_15 ST_31 ST_63 ST_127 ST_255"`
             do
                 #PROCESS_${process_ct} ${p1_hash[${process_ct}]}  ${p2_hash[${process_ct}]}
                 PROCESS_${all_sts} ${p1_hash[${all_sts}]}  ${p2_hash[${all_sts}]}
             done

              ;;
    "csv")
          echo "INFO: cloud obj pull csv_start_`date '+%H_%M_%S-%s-%W_%j'`"
          out_put_file=(`echo "folder_file_process.info"`)
          gz_files_only=(`echo "zip_files_to_process.info"`)
          dir_nm=(`echo "${dw_dir}/iac_scan_status"`)
          date_based_root_dir=(`echo "${dw_dir}/iac_scan_status"`)
          search_pattern=(`echo "gs://${my_current_buk_data}/iac_scan_rpt_csv/${DATE}/"`)
          if [ "${HOUR}" == "STAR" ]; then
             dir_nm=(`echo "${dw_dir}/iac_scan_status/csv/${YEAR}/${DATE}"`)
             out_put_file=(`echo "${DATE}_csv_folder_file_process.info"`)
             date_based_root_dir=(`echo "${dw_dir}/iac_scan_status/csv/${YEAR}/${DATE}"`)
             search_pattern=(`echo "gs://${my_current_buk_data}/iac_scan_rpt_csv/${DATE}/*/*/*"`)
          else
             dir_nm=(`echo "${dw_dir}/iac_scan_status/csv/${YEAR}/${DATE}/${HOUR}"`)
             out_put_file=(`echo "${HOUR}_csv_folder_file_process.info"`)
             date_based_root_dir=(`echo "${dw_dir}/iac_scan_status/csv/${YEAR}/${DATE}"`)
             search_pattern=(`echo "gs://${my_current_buk_data}/iac_scan_rpt_csv/${DATE}/${HOUR}/*/*"`)
          fi
             echo "INFO: cloud obj pull csv_end_`date '+%H_%M_%S-%s-%W_%j'`"
             check_file=(`ls -C1 ${dir_nm}/${gz_files_only} 2>/dev/null`)
             check_file=${check_file:-NONE}  
             collect_zip_files_already_present=(`ls -C1 ${date_based_root_dir}/daily_zip/*.gz 2>/dev/null`)
             zip_ar_files_list_ar=(`cat ${dir_nm}/${out_put_file} 2>/dev/null| sort |  grep "\.gz$"`)
             rpt_daily_csv_ar=(`ls -C1 ${date_based_root_dir}/all_csv/*csv 2>/dev/null`)
             daily_csv_ar=(`ls -C1 ${date_based_root_dir}/daily_csv/*csv 2>/dev/null`)
             echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT var_name=check_file, value=${check_file}"
             echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT var_name=collect_zip_files_already_present, value=${#collect_zip_files_already_present[@]}"
             echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT var_name=zip_ar_files_list_ar, value=${#zip_ar_files_list_ar[@]}"
             echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT var_name=rpt_daily_csv_ar, value=${#rpt_daily_csv_ar}"
             echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT var_name=daily_csv_ar, value=${#daily_csv_ar[@]}"
             echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT var_name=date_based_root_dir, value=${date_based_root_dir}"
             let process_num=0
             process_ct=(`echo "ST_0"`)
             if [ "${check_file}" != "NONE" ]; then
                 let process_num=${process_num}+1
                 process_ct=(`echo "ST_${process_num}"`)
             fi
             if [ ${#zip_ar_files_list_ar[@]} -gt 0 ]; then
                 let process_num=${process_num}+2
                 process_ct=(`echo "ST_${process_num}"`)
             fi
             if [ ${#daily_csv_ar[@]} -gt 0 ]; then
                 let process_num=${process_num}+4
                 process_ct=(`echo "ST_${process_num}"`)
             fi
             if [ ${#rpt_daily_csv_ar[@]} -gt 0 ]; then
                 let process_num=${process_num}+8
                 process_ct=(`echo "ST_${process_num}"`)
             fi
             
             . /apps/lib/untar.sh
             . /apps/lib/PROCESS_ST_0.sh
             . /apps/lib/PROCESS_ST_1.sh
             . /apps/lib/PROCESS_ST_3.sh
             . /apps/lib/PROCESS_ST_7.sh
             . /apps/lib/PROCESS_ST_15.sh
             . /apps/lib/PROCESS_ST_31.sh
             . /apps/lib/PROCESS_ST_63.sh
             . /apps/lib/PROCESS_ST_127.sh
             . /apps/lib/PROCESS_ST_255.sh

             declare -A p1_hash
             declare -A p2_hash

             p1_hash[ST_0]="csv"
             p2_hash[ST_0]="NONE"

             p1_hash[ST_1]="csv"
             p2_hash[ST_1]="NONE"

             p1_hash[ST_3]="csv"
             p2_hash[ST_3]="NONE"

             p1_hash[ST_7]="${date_based_root_dir}/daily_csv"
             p2_hash[ST_7]="all"

             p1_hash[ST_15]="csv"
             p2_hash[ST_15]="NONE"

             p1_hash[ST_31]="csv"
             p2_hash[ST_31]="NONE"

             p1_hash[ST_63]="csv"
             p2_hash[ST_63]="NONE"

             p1_hash[ST_127]="csv"
             p2_hash[ST_127]="NONE"

             p1_hash[ST_255]="csv"
             p2_hash[ST_255]="NONE"

             for all_sts in `echo "ST_0 ST_1 ST_3 ST_7"`  #ST_15 ST_31 ST_63 ST_127 ST_255"`
             do
                 #PROCESS_${process_ct} ${p1_hash[${process_ct}]}  ${p2_hash[${process_ct}]}
                 PROCESS_${all_sts} ${p1_hash[${all_sts}]}  ${p2_hash[${all_sts}]}
             done
             
             #if [ "${check_file}" == "NONE" ]; then
             #     echo "INFO: executing cmd - gcloud storage ls ${search_pattern}"
             #     reports_to_pull_csv_gz=(`gcloud storage ls ${search_pattern} |  tr ' ' '\n'`)
             #     if [ "${#reports_to_pull_csv_gz[@]}" -gt 0 ]; then
             #        mkdir -p ${dir_nm}
             #        mkdir -p ${date_based_root_dir}/daily_csv
             #        mkdir -p ${date_based_root_dir}/daily_zip
             #        mkdir -p ${date_based_root_dir}/all_csv
             #        echo "${reports_to_pull_csv_gz[@]}" | tr ' ' '\n' | sort  > ${dir_nm}/${out_put_file}
             #        echo "${reports_to_pull_csv_gz[@]}" | tr ' ' '\n' | sort |  grep "\.gz$" > ${dir_nm}/${gz_files_only}
             #        let process_num=${process_num}+1
             #        process_ct=(`echo "ST_${process_num}"`)
             #     else
             #        echo "INFO: NO_FILES_FOUND_IN_BUCKET EXITING_WITH_ZERO"
             #        exit 0
             #     fi
             #else
             #     echo "INFO: FILE_LIST_CREATED"
             #     reports_to_pull_csv_gz=(`cat ${dir_nm}/${out_put_file}`)
             #     echo "INFO: Records from file ${#reports_to_pull_csv_gz[@]}"
             #     #if [ "${#reports_to_pull_csv_gz[@]}" -gt 0 ]; then
             #     #   let process_num=${process_num}+1
             #     #   process_ct=(`echo "ST_${process_num}"`)
             #     #fi
             #fi
             #if [ "${#reports_to_pull_csv_gz[@]}" -gt 0 ]; then
             #     echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT already_present ${#collect_zip_files_already_present[@]} count_from_file ${#zip_ar_files_list_ar[@]}"
             #     zip_ar_files_list_ar=(`echo "${reports_to_pull_csv_gz[@]}" | tr ' ' '\n' | sort |  grep "\.gz$"`)
             #     if [ ${#collect_zip_files_already_present[@]} -lt 1 ]; then
             #         mkdir -p ${date_based_root_dir}/daily_zip
             #         for all_zips in `echo "${zip_ar_files_list_ar[@]}"`
             #         do
#gs://${my_current_buk_data}/iac_scan_rpt_csv/20231208-49-342/15/createscainsgprod/ECS/csv_1702047748-20231208-49-342_15.createscainsgprod.ECS.gz
#gs://${my_current_buk_data}/iac_scan_rpt_csv/20231208-49-342/15/createscainsgprod/ECS/csv_1702050583-20231208-49-342_15.createscainsgprod.ECS.gz
#gs://${my_current_buk_data}/iac_scan_rpt_csv/20231208-49-342/16/createSUB-RTL-PCC-coe-pt-centralus/ECS/csv_1702053537-20231208-49-342_16.createSUB-RTL-PCC-coe-pt-centralus.ECS.gz
#gs://${my_current_buk_data}/iac_scan_rpt_csv/20231208-49-342/16/createSUB-RTL-PCC-coe-pt-eastus2/ECS/csv_1702054087-20231208-49-342_16.createSUB-RTL-PCC-coe-pt-eastus2.ECS.gz
#gs://${my_current_buk_data}/iac_scan_rpt_csv/20231208-49-342/16/featureuatjumpboxdb/ECS/csv_1702052033-20231208-49-342_16.featureuatjumpboxdb.ECS.gz

             #             echo "INFO: zip files ${all_zips}"
             #             zip_file=(`echo "${all_zips}" | cut -d "/" -f 9`)
             #             echo "INFO: BUCKET_PULL_CMD- gcloud storage cp ${all_zips} ${date_based_root_dir}/daily_zip/${zip_file}"
             #             gcloud storage cp ${all_zips} ${date_based_root_dir}/daily_zip/${zip_file}
             #             untar_csv_files ${date_based_root_dir}/daily_zip/${zip_file}  ${date_based_root_dir}/daily_csv
             #         done
             #         mkdir -p ${date_based_root_dir}/all_csv
             #         let process_num=${process_num}+2
             #         process_ct=(`echo "ST_${process_num}"`)
             #         process_rr_rpt ${date_based_root_dir}/daily_csv all
             #         let process_num=${process_num}+4
             #         process_ct=(`echo "ST_${process_num}"`)
             #     else 
             #        echo "INFO: BUCKET_ZIP_OPS_DONE"
             #        echo "INFO: CURRENT_STAT ${process_num}:${process_ct}"
             #     fi
             #fi
             ##echo "INFO: CURRENT_STAT ${process_num}:${process_ct}"
             ##cd -
          ;;
     "snyk")
             echo "INFO: cloud obj pull snyk_start_`date '+%H_%M_%S-%s-%W_%j'`"
             reports_to_pull_snyk_gz=(`gcloud storage ls gs://${my_current_buk_data}/iac_scan_rpt_snyk/${DATE}/${HOUR}/*/*`)
             echo "INFO: cloud obj pull snyk_end_`date '+%H_%M_%S-%s-%W_%j'`"
             echo "${reports_to_pull_snyk_gz[@]}" >> ${all_snyk_rpt_folder_file_list}
             prepare_file_list "snyk"
             ;;
     "kics")
             echo "INFO: cloud obj pull kics_start_`date '+%H_%M_%S-%s-%W_%j'`"
             reports_to_pull_kics_gz=(`gcloud storage ls gs://${my_current_buk_data}/iac_scan_rpt_kics/${DATE}/${HOUR}/*/*`)
             echo "INFO: cloud obj pull kics_end_`date '+%H_%M_%S-%s-%W_%j'`"
             echo "${reports_to_pull_kics_gz[@]}" >> ${all_kics_rpt_folder_file_list}
             prepare_file_list "kics"
             ;;
      *)
             echo "INFO: NO_PARAMETER_PASSED_DEFAULT_CONDITION"
             ;;
      esac
             
}

prepare_file_list ()
{

    echo "INFO: FN-NAME prepare_file_list"
    cd ${dw_dir}/${processed_dir}
    echo "INFO: current_dir `pwd`"

    #all_csv_rpt_folder_list=$(echo "${STORAGE_FOLDER_KEY1}_csv_folder.info")
    #all_csv_rpt_folder_file_list=$(echo "${STORAGE_FOLDER_KEY1}_csv_folder_file.info")
    #all_csv_rpt_folder_file_list_process=$(echo "${STORAGE_FOLDER_KEY1}_csv_folder_file_process.info")

    #all_snyk_rpt_folder_list=$(echo "${STORAGE_FOLDER_KEY1}_snyk_folder.info")
    #all_snyk_rpt_folder_file_list=$(echo "${STORAGE_FOLDER_KEY1}_snyk_folder_file.info")
    #all_snyk_rpt_folder_file_list_process=$(echo "${STORAGE_FOLDER_KEY1}_snyk_folder_file_process.info")

    #all_kics_rpt_folder_list=$(echo "${STORAGE_FOLDER_KEY1}_kics_folder.info")
    #all_kics_rpt_folder_file_list=$(echo "${STORAGE_FOLDER_KEY1}_kics_folder_file.info")
    #all_kics_rpt_folder_file_list_process=$(echo "${STORAGE_FOLDER_KEY1}_kics_folder_file_process.info")
    
    case "${1}" in 

    "tfplan")
             echo "INFO: tfplan file processing"
             echo "${reports_to_pull_tf_files[@]}" | egrep -v "${filter_last_hr}" >> ${all_tf_plan_folder_file_list}
             cd -
             ;;
    "csv")
             echo "INFO: csv file processing"
             rm -rf ${all_csv_rpt_folder_file_list}
             echo "${reports_to_pull_csv_gz[@]}" | egrep -v "${filter_last_hr}" >> ${all_csv_rpt_folder_file_list}
             cd -
             ;;
    "snyk")
             echo "INFO: snyk file processing"
             rm -rf ${all_snyk_rpt_folder_file_list}
             echo "${reports_to_pull_snyk_gz[@]}" | egrep -v "${filter_last_hr}" >> ${all_snyk_rpt_folder_file_list}
             cd -
             ;;
    "kics")
             echo "INFO: kics file processing"
             rm -rf ${all_kics_rpt_folder_file_list}
             echo "${reports_to_pull_kics_gz[@]}" | egrep -v "${filter_last_hr}" >> ${all_kics_rpt_folder_file_list}
             cd -
             ;;
     *)
             echo "INFO: NO_PARAMETER_PASSED_DEFAULT_CONDITION"
             ;;
     esac
     read SSSSSS
    #get_run_ct "${dw_dir}/${processed_dir}/${all_tf_plan_folder_file_list}"
}

    declare -A hr_based_ct
    declare -A hr_based_key_hash
    declare -A hr_app_based_ct
    declare -A hr_app_based_key_hash
    declare -A day_app_based_ct
    declare -A day_app_based_key_hash
    declare -A week_app_based_ct
    declare -A week_app_based_key_hash
    declare -A month_app_based_ct
    declare -A month_app_based_key_hash
    declare -A year_app_based_ct
    declare -A year_app_based_key_hash
    declare -A cal_day_of_year_lk_hash
    declare -A cal_day_of_year_lk_key_hash
    declare -A cal_week_of_year_lk_hash
    declare -A cal_week_of_year_lk_key_hash

#files to be created ----- Start

        hourly_all_app_based_file=(`echo "${STORAGE_FOLDER_KEY1}_hourly_file_process.info"`)
        hourly_app_based_file=(`echo "${STORAGE_FOLDER_KEY1}_hour_app_file_process.info"`)
        day_app_based_file=(`echo "${STORAGE_FOLDER_KEY1}_day_app_file_process.info"`)
        week_app_based_file=(`echo "${STORAGE_FOLDER_KEY1}_week_app_file_process.info"`)
        month_app_based_file=(`echo "${STORAGE_FOLDER_KEY1}_month_app_file_process.info"`)
        year_app_based_file=(`echo "${STORAGE_FOLDER_KEY1}_year_app_file_process.info"`)
        xls_file=(`echo "${STORAGE_FOLDER_KEY1}_rpt.xlsx"`)
#files to be created ----- End

get_csv_files ()
{
    echo "INFO: FN-NAME get_csv_files"

    #echo "INFO: files to get ${reports_to_pull_sm[@]}"
    #echo "INFO: files to get ${reports_to_pull_cr[@]}"
    #echo "INFO: files to get ${reports_to_pull_rr[@]}"
    mkdir -p ${dw_dir}
    cd ${dw_dir}
    echo "INFO: current_dir `pwd`"
    for all_files in `echo "${reports_to_pull_csv_gz[@]}"`
    do
       echo "INFO: File Processing Start ${all_files}"
       just_dir=(`echo "${all_files}" | grep -v ":$"`)
       just_dir=${just_dir:-NONE}
       if [ "${just_dir}" == "NONE" ]; then
            echo "INFO: Dir ${all_files}"
            csv_dir_local=(`echo "${all_files}" | cut -d "/" -f 7`)
            echo "INFO: Directory ${csv_dir_local} Creation"
            mkdir -p ${csv_dir_local}
            full_dir=(`echo "${dw_dir}/${csv_dir_local}"`)
            csv_unzip_appnm_dir_hash[${csv_dir_local}]=${full_dir}
       fi
    done
    for all_files in `echo "${reports_to_pull_csv_gz[@]}"`
    do
       just_dir=(`echo "${all_files}" | grep -v ":$"`)
       just_dir=${just_dir:-NONE}
       if [ "${just_dir}" != "NONE" ]; then
            echo "INFO: CMD gcloud ${gcloud_context} cp ${all_files} ." 
            csv_dir_local=(`echo "${all_files}" | cut -d "/" -f 7`)
            csv_gz_file_with_no_ext=(`echo "${all_files}" | cut -d "/" -f 9 | cut -d "." -f 1`)
            csv_gz_file_with_no_ext_as_key=(`echo "${all_files}" | cut -d "/" -f 9 | cut -d "." -f 1,2,3 | sed 's/\./_/g'`)
            csv_unzip_appnm_rpt_dir_hash_key=(`echo "${csv_dir_local}_${csv_gz_file_with_no_ext_as_key}"`)
            csv_gz_file=(`echo "${all_files}" | cut -d "/" -f 9`)
            full_dir=(`echo "${dw_dir}/${csv_dir_local}/${csv_gz_file_with_no_ext}"`)
#gs://${my_current_buk_data}/iac_scan_rpt_csv/CSETEST/container/20230920-38-263/04/csv_1695184899-20230920-38-263_04.CSETEST.container.gz
#INFO: csv_dir_local 20230920-38-263, csv_gz_file_with_no_ext , csv_gz_file  and full_dir /data/R-20230920135924-382023-263/20230920-38-263/
            echo "INFO: csv_dir_local ${csv_dir_local}, csv_gz_file_with_no_ext ${csv_gz_file_with_no_ext}, csv_gz_file ${csv_gz_file} and full_dir ${full_dir}"
            #csv_unzip_appnm_rpt_dir_hash[${csv_dir_local}]=${full_dir}
            csv_unzip_appnm_rpt_dir_hash[${csv_unzip_appnm_rpt_dir_hash_key}]=${full_dir}
            csv_unzip_appnm_rpt_dir_target_hash[${csv_unzip_appnm_rpt_dir_hash_key}]=${just_dir}
            cd ${csv_dir_local}
            echo "INFO: current_dir `pwd`"
            gcloud  ${gcloud_context} cp ${all_files} .
            mkdir -p ${csv_gz_file_with_no_ext}
            cd -
            cd ${csv_dir_local}/${csv_gz_file_with_no_ext}
            echo "INFO: current_dir `pwd`"
            echo "INFO: untarring file ${csv_gz_file}"
            tar -zxvf ../${csv_gz_file}
            #gs://${my_current_buk_data}/iac_scan_rpt_bucket/CSES3/gcbuild/1695067883-20230918-38-261/20/bucket_1695067883-20230918-38-261_20.gz
            ls -C1 *.csv
            cd -
       fi
    done
    csv_to_xls_with_ws
}

pull_report_from_bucket()
{
    echo "INFO: FN-NAME pull_report_from_bucket"
        echo "INFO:getting_list"
        echo "INFO: CMD gcloud ${gcloud_context} ls gs://${my_current_buk_data}/iac_scan_tf_rpt"
        files_to_download_tf_list=(`gcloud ${gcloud_context} ls gs://${my_current_buk_data}/iac_scan_tf_plan/*/*/*/*`)
    for all_files_dw in `echo "${files_to_download_csv_list[@]}"`
    do
         echo "INFO: files Downloaded. ${all_files_dw}"
    done
         case "${OPT}" in

         "DAY")
                   echo "INFO: Todays Scan: $DAY" 
                   ;;
         "YESTERDAY")
                   echo "INFO: Yesterday Scan: $YESTERDAY" 
                      ;;
         "LASTWEEK")
                   echo "INFO: Lastweek  Scan: $YESTERDAY" 
                       ;;
         *)
                       echo "INFO: Until Today, this hour Scan: ${MONTH}" 
                       #echo "${files_to_download_csv_list[@]}" | tr ' ' '\n'
                       #reports_to_pull_csv_gz=(`echo "${files_to_download_csv_list[@]}" | tr ' ' '\n' | egrep "${MONTH}"`)
                       reports_to_pull_tf_files=(`echo "${files_to_download_tf_list[@]}" | tr ' ' '\n' | egrep "${MONTH}"`)
                       #reports_to_pull_cr=(`echo "${files_to_download_list[@]}" | tr ' ' '\n' | grep "/cr_" `)
                       #reports_to_pull_rr=(`echo "${files_to_download_list[@]}" | tr ' ' '\n' | grep "/rr_" `)
                       get_run_ct
                       #get_csv_files 
                   ;;
         esac
}

all_run ()
{
    echo "INFO: FN-NAME all_run"
    echo_vars
    check_cloud_obj_srv
    # 1 choice 2 date 3 hour
    #if [[ "${1}" == "NONE" ]]  &&  [[ "${2}" == "NONE" ]] && [[ "${3}" == "NONE" ]] && [[ "${4}" == "NONE" ]] && [[ "${5}" == "NONE" ]] ; then
    echo "INFO: CALLING get_status_of_processed_rpt ${1} ${2} ${3} ${4} ${5}"
    if [ $# -gt 4 ]; then
          get_status_of_processed_rpt ${1} ${2} ${3} ${4} ${5}
    else
          echo "INFO: MINUMUM 5 PARAMETERS REQUIRED ($#)"
          echo "INFO: Usage-$0 (tfp/csv/buk) DATE TIME (Y/N) (Y/N) (Y/N)"
          echo "INFO: Usage-$0 tfp=plan files, csv=sarif reports, buk=sarif reports in json, Y/N load the reports to s3 bucket CISS, Y/N load reports to tools, force re-process"
          exit 100 
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
        all_run ${1} ${2} ${3} ${4} ${5}

#DPC-Function push_report_to_s3  -Definition End
