#!/usr/bin/env sh

     export PATH=${PATH}:/apps/bin:/apps/kics/bin:/apps/snyk/bin:/apps/opa/bin:/apps/gcp/google-cloud-sdk/bin:/apps/hc/tf:/apps/hc/vault:/apps/hc/consul:/apps/hc/bin
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
     echo "INFO: OBJ_FOLDER_ARCH=/dev-cvs-scan-reports/FOLDER01/STORAGE_FOLDER_KEY1/HOUR_KEY/APPID/PIPELINE"
     echo "INFO: OBJ_FOLDER_ARCH=/dev-cvs-scan-reports/iac_scan_tf_plan/20231031-44-304/14/rphaic-ptc/ECS"
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

  let YESTERDAY=${DAY_OF_YEAR}-1
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


CSRV_OK=$(echo "NONE")

check_cloud_obj_srv ()
{
    /apps/bin/gcp_srv_acct_stp.sh 1>>/tmp/gcp_login.std01 2>>/tmp/gcp_login.std02

   cat /tmp/gcp_login.std01
   cat /tmp/gcp_login.std02

   rm -rf /tmp/gcp_login.std01 /tmp/gcp_login.std02
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
#gs://dev-cvs-scan-reports/iac_scan_rpt_csv/CSET3/JITHUB/20230921-38-264/13/csv_1695302544-20230921-38-264_13.CSET3.JITHUB.gz
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
    all_tf_plan_folder_list=$(echo "${STORAGE_FOLDER_KEY1}_tfplan_folder.info")
    all_tf_plan_folder_file_list=$(echo "${STORAGE_FOLDER_KEY1}_tfplan_folder_file.info")
    all_tf_plan_folder_file_list_process=$(echo "${STORAGE_FOLDER_KEY1}_tfplan_folder_file_process.info")

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
    status_flag_get_cmd=$(echo "gs://dev-cvs-scan-reports/iac_scan_status/${status_flag_file}")
    current_status_processed=${current_status_processed:-NONE}
    init_status=${init_status:-00000000-00-000}
    filter_last_hr=${filter_last_hr:-00000000-00-000}
    filter_limit=${filter_limit:-00000}

#for all in `cat ${tfplan_file} | jq  '[paths(type == "object")|join(".") ]' | sed -e 's/\.\([0-9]\+\)/\[\1\]/g' | sed 's/\"/\./' | sed 's/\"//g'`; do echo ${all} ; done

    get_all_ls=()
get_status_of_processed_rpt ()
{
    echo "INFO: FN-NAME get_status_of_processed_rpt"
    cd ${dw_dir}/${processed_dir}
    echo "INFO: pulling status file from gcloud"
    echo "INFO: Executing gcloud ${gcloud_context} cp ${status_flag_get_cmd} ."
    cd /apps/config
    gcloud ${gcloud_context} cp ${status_flag_get_cmd} .
    current_status_processed=$(cat "${status_flag_file}")
    current_status_processed=${current_status_processed:-NONE}
    echo "INFO: STATUS_PROCESSED ${current_status_processed}"
    rm -rf ${status_flag_file}
    cd -
    #reports_to_pull_snyk_gz=()
    #reports_to_pull_kics_gz=()
    #reports_to_pull_csv_gz=()

    #get_all_ls=$(gcloud storage ls gs://dev-cvs-scan-reports/*/*/*/*/*)
    #echo "INFO: ${get_all_ls[@]}"
    echo "INFO: cloud obj pull tfplan_start_`date '+%H_%M_%S-%s-%W_%j'`"
    reports_to_pull_tf_files=(`gcloud storage ls gs://dev-cvs-scan-reports/iac_scan_tf_plan/*/*/*/*`)
    echo "INFO: cloud obj pull tfplan_end_`date '+%H_%M_%S-%s-%W_%j'`"
    filter_last_hr=$(echo "${reports_to_pull_tf_files[@]}" |  cut -d "/" -f 5,6 | sort -u | tail -n 1)
    filter_limit=$(echo "${filter_last_hr}" | cut -d "-" -f 3 | sed 's/\///') 
    echo "INFO: filtering date ${filter_last_hr} and limit ${filter_limit}"
    #echo "INFO: ${reports_to_pull_tf_files[@]}"
    prepare_file_list "tfplan"
    echo "INFO: cloud obj pull csv_start_`date '+%H_%M_%S-%s-%W_%j'`"
    reports_to_pull_csv_gz=(`gcloud storage ls gs://dev-cvs-scan-reports/iac_scan_rpt_csv/*/*/*/*`)
    echo "INFO: cloud obj pull csv_end_`date '+%H_%M_%S-%s-%W_%j'`"
    #echo "INFO: ${reports_to_pull_csv_gz[@]}"
    prepare_file_list "csv"
    echo "INFO: cloud obj pull snyk_start_`date '+%H_%M_%S-%s-%W_%j'`"
    reports_to_pull_snyk_gz=(`gcloud storage ls gs://dev-cvs-scan-reports/iac_scan_rpt_snyk/*/*/*/*`)
    echo "INFO: cloud obj pull snyk_end_`date '+%H_%M_%S-%s-%W_%j'`"
    #echo "INFO: ${reports_to_pull_snyk_gz[@]}"
    prepare_file_list "snyk"
    echo "INFO: cloud obj pull kics_start_`date '+%H_%M_%S-%s-%W_%j'`"
    reports_to_pull_kics_gz=(`gcloud storage ls gs://dev-cvs-scan-reports/iac_scan_rpt_kics/*/*/*/*`)
    echo "INFO: cloud obj pull kics_end_`date '+%H_%M_%S-%s-%W_%j'`"
    #echo "INFO: ${reports_to_pull_kics_gz[@]}"
    prepare_file_list "kics"
}

prepare_file_list ()
{

    echo "INFO: FN-NAME prepare_file_list"
    cd ${dw_dir}/${processed_dir}
    echo "INFO: current_dir `pwd`"
    
    case "${1}" in 

    "tfplan")
             echo "INFO: tfplan file processing"
             rm -rf ${all_tf_plan_folder_file_list}
             echo "INFO: filtering date ${filter_last_hr} and limit ${filter_limit}"
             echo "${reports_to_pull_tf_files[@]}" | egrep -v "${filter_last_hr}" >> ${all_tf_plan_folder_file_list}
             cd -
             ;;
    "csv")
             echo "INFO: csv file processing"
             rm -rf ${all_csv_rpt_folder_file_list}
             echo "INFO: filtering date ${filter_last_hr} and limit ${filter_limit}"
             echo "${reports_to_pull_csv_gz[@]}" | egrep -v "${filter_last_hr}" >> ${all_csv_rpt_folder_file_list}
             cd -
             ;;
    "snyk")
             echo "INFO: snyk file processing"
             rm -rf ${all_snyk_rpt_folder_file_list}
             echo "INFO: filtering date ${filter_last_hr} and limit ${filter_limit}"
             echo "${reports_to_pull_snyk_gz[@]}" | egrep -v "${filter_last_hr}" >> ${all_snyk_rpt_folder_file_list}
             cd -
             ;;
    "kics")
             echo "INFO: kics file processing"
             rm -rf ${all_kics_rpt_folder_file_list}
             echo "INFO: filtering date ${filter_last_hr} and limit ${filter_limit}"
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
get_run_ct ()
{
    echo "INFO: FN-NAME get_run_ct"
    processed_dir=$(echo "iac_scan_status")
    mkdir -p ${dw_dir}/${processed_dir}
    cd ${dw_dir}/${processed_dir}
    echo "INFO: current_dir `pwd`"
    cd ${dw_dir}
    #filter_last_hr=$(cat ${all_tf_plan_folder_list} | grep -v "###" |  cut -d "/" -f 5,6 | sort -u | tail -n 1)
    if [ "${1}" == "NONE" ]; then
         echo "HELP: Usage - $0 get_run_ct:file_location"
         echo "ERROR: EXITING_WITH_ERROR_CODE 100"
         exit 100
    fi
    #all_tf_plan_folder_file_list_process
    #echo "### LIST_OF_TFPLAN_FOLDERS_FILES ###" >${all_tf_plan_folder_file_list_process}
    local_ar=()
    local_ar=$(cat "${1}")
    echo  "INFO: RPT_RUN_CT_START_`date '+%H_%M_%S-%s-%W_%j'`"
    for all_files in `echo "${local_ar[@]}"`
    do
       #echo "INFO: File Processing Start ${all_files}"
       just_dir=(`echo "${all_files}" | grep -v ":$"`)
       just_dir=${just_dir:-NONE}
       if [ "${just_dir}" == "NONE" ]; then
            #echo "INFO: FOLDER ${all_files}"
#gs://dev-cvs-scan-reports/iac_scan_tf_plan/20231011-41-284/14/CV25BIGFILE/GITTF01:
            folder_name=(`echo "${all_files}" | cut -d "/" -f 5- | sed 's/\/:$//'`)
            #echo "INFO: FOLDER_LEAF ${folder_name}"
            folder_name_key=$(echo "K${folder_name}" | sed 's/\//_/g')
            #echo "${all_files}" >> ${all_tf_plan_folder_list}
            #echo "INFO: folder_name_key ${folder_name_key}"
            all_tf_plan_folder_list_hash[${folder_name_key}]="${folder_name_key}"
            tfplan_dir_local=(`echo "${all_files}" | cut -d "/" -f 5`)
            tfplan_dir_hh=(`echo "${all_files}" | cut -d "/" -f 6`)
            #echo "INFO: Directory ${tfplan_dir_local}/${tfplan_dir_hh} Creation"
            #mkdir -p ${tfplan_dir_local}/${tfplan_dir_hh}
            #full_dir=(`echo "${dw_dir}/${tfplan_dir_local}"`)
            #echo "INFO: full_dir_name ${full_dir}"
            #csv_unzip_appnm_dir_hash[${csv_dir_local}]=${full_dir}
       else
           #echo "INFO: tfplan_files ${all_files}"
#gs://dev-cvs-scan-reports/iac_scan_tf_plan/20231011-41-284/14/CV25BIGFILE/GITTF01/S18015_2023.tfplan
           folder_name=(`echo "${all_files}" | cut -d "/" -f 5-`)
           folder_name_only=(`echo "${folder_name}" | cut -d "/" -f 1-4`)
           folder_file_name=(`echo "${folder_name}" | cut -d "/" -f 5 | cut -d "." -f 1`)
           #echo "INFO: folder_name  ${folder_name}"
           #echo "INFO: folder_name_only ${folder_name_only}"
           #echo "INFO: folder_file_name ${folder_file_name}"
           folder_name_key=$(echo "K${folder_name_only}" | sed 's/\//_/g')
           #echo "INFO: folder_name_key ${folder_name_key}"
           #echo "${all_files}" >> ${all_tf_plan_folder_file_list}
           all_tf_plan_folder_file_list_hash[${folder_file_name}]="${folder_file_name}"

           get_file=(`echo "${all_tf_plan_folder_file_list_fhash[${folder_name_key}]}"`)
           get_file=${get_file:-NONE}
           if [ "${get_file}" != "NONE" ]; then
               new_val=$(echo "${get_file}|${folder_file_name}")
               all_tf_plan_folder_file_list_fhash[${folder_name_key}]="${new_val}"
           else
               all_tf_plan_folder_file_list_fhash[${folder_name_key}]="${folder_file_name}"
           fi

           get_val=(`echo "${all_tf_plan_folder_file_list_chash[${folder_name_key}]}"`)
           get_val=${get_val:-0}
           let ct=${get_val}+1
           all_tf_plan_folder_file_list_chash[${folder_name_key}]=${ct}
       fi
    done
    echo  "INFO: RPT_RUN_CT_END_`date '+%H_%M_%S-%s-%W_%j'`"

    rm -rf ${all_tf_plan_folder_file_list_process}
#TAG=RPT
    echo  "INFO: CONSOLIDATED_FOLDING_RPT_RUN_CT_START_`date '+%H_%M_%S-%s-%W_%j'`"
    for all_items in `echo "${!all_tf_plan_folder_list_hash[@]}"`
    do
          #echo "INFO: KEY - ${all_items}"
          ct=(`echo "${all_tf_plan_folder_file_list_chash[${all_items}]}"`)
          #echo "INFO: # of Times run - ${ct}"
          files=(`echo "${all_tf_plan_folder_file_list_fhash[${all_items}]}"`)
          #echo "INFO: files ${files}"
          #echo "ALL: ${all_items},${files},${ct}"
#INFO: KEY - K20231020-42-293_17_createSUB-HCB-AIPPS-aipps-prod-centralus_ECS var = ${all_items}
          single_row=(`echo "${all_items}" | sed 's/^K//' | tr '_' '\n'`)
          #echo "INFO: single_row ${single_row[@]}"
          date_combo1=(`echo "${single_row[0]}" | tr '-' '\n'`) 
          yd=(`echo "YD${date_combo1[2]}"`)
          yw=(`echo "YW${date_combo1[1]}"`)
          
          cal_day_of_year_lk_key_hash[${yd}]="${yd}"
          cal_day_of_year_lk_hash[${yd}]="${date_combo1[0]}"

#cal_processing_for_week_days
          get_cur_week_in_cal=(`echo "${cal_week_of_year_lk_key_hash[${yw}]}"`)
          get_cur_week_in_cal={get_cur_week_in_cal:-NONE}
          if [ "${get_cur_week_in_cal}" == "NONE" ]; then
              cal_week_of_year_lk_hash[${yw}]="${date_combo1[0]}"
              cal_week_of_year_lk_key_hash[${yw}]="${yw}"
          else
              get_cur_week_in_cal_val=(`echo "${cal_week_of_year_lk_hash[${yw}]}"`)
              new_val=(`echo "${get_cur_week_in_cal_val}|${date_combo1[0]}"`)
              cal_week_of_year_lk_hash[${yw}]="${new_val}"
          fi

          date_key=(`echo "${date_combo1[2]}_${single_row[1]}00_${single_row[3]}_${single_row[2]}"`)
          date_key_app=(`echo "${date_combo1[2]}_${single_row[1]}00_${single_row[3]}"`)

#date_day_app_key switch 
          date_day_app_key=(`echo "${date_combo1[0]}_${date_combo1[2]}_${single_row[3]}"`)
          #date_day_app_key=(`echo "${date_combo1[2]}_${single_row[3]}"`)
#date_day_app_key switch 

          date_year_month_app_key=(`echo "${date_combo1[0]}" | sed 's/\(.\)\{2\}$//'`)
          date_month_app_key=(`echo "${date_year_month_app_key}_${single_row[3]}"`)
          date_year_key=(`echo "${date_combo1[0]}" | sed 's/\(.\)\{4\}$//'`)
          date_year_app_key=(`echo "${date_year_key}_${single_row[3]}"`)
          
          date_week_app_key=(`echo "${date_year_key}_${date_combo1[1]}_${single_row[3]}"`)

          #echo "INFO: DATE_KEY ${date_key}  FILEDS ${date_combo1[0]} ${single_row[1]}00 ${single_row[3]} ${single_row[2]} ${ct}"
          #echo "INFO: ${date_combo1[0]},${single_row[1]}00,${single_row[3]},${single_row[2]},${ct}"
          echo "${date_combo1[0]},${single_row[1]}00,${single_row[3]},${single_row[2]},${ct}" >>${all_tf_plan_folder_file_list_process}
#hour based ct
          get_cur_hr_based_ct_key=(`echo "${hr_based_key_hash[${date_key}]}"`)
          get_cur_hr_based_ct_key=${get_cur_hr_based_ct_key:-NONE}
          if [ "${get_cur_hr_based_ct_key}" == "NONE"  ]; then
              hr_based_ct[${date_key}]="${ct}"
              hr_based_key_hash[${date_key}]="${date_key}"
          else
              get_cur_hr_based_ct_val=(`echo "${hr_based_ct[${date_key}]}"`)
              let new_ct=${get_cur_hr_based_ct_val}+${ct}
              hr_based_ct[${date_key}]="${new_ct}"
          fi
#hour based app  ct
          get_cur_hr_based_app_key=(`echo "${hr_app_based_key_hash[${date_key_app}]}"`)
          get_cur_hr_based_app_key=${get_cur_hr_based_app_key:-NONE}
          #echo "INFO: KEY - get_cur_hr_based_app_key ${get_cur_hr_based_app_key} date_key_app  ${date_key_app}"
          if [ "${get_cur_hr_based_app_key}" == "NONE"  ]; then
              #echo "INFO: first_new_key"
              hr_app_based_ct[${date_key_app}]="${ct}"
              hr_app_based_key_hash[${date_key_app}]="${date_key_app}"
          else
              #echo "INFO: mul_old key"
              get_cur_hr_based_app_val=(`echo "${hr_app_based_ct[${date_key_app}]}"`)
              let new_ct=${get_cur_hr_based_app_val}+${ct}
              hr_app_based_ct[${date_key_app}]="${new_ct}"
          fi

#day based app  ct
          day_app_based_key=(`echo "${day_app_based_key_hash[${date_day_app_key}]}"`)
          day_app_based_key=${day_app_based_key:-NONE}
          #echo "INFO: day_app_based_key ${day_app_based_key} date_day_app_key ${date_day_app_key}"
          if [ "${day_app_based_key}" == "NONE"  ]; then
              #echo "INFO: first_new_key"
              day_app_based_ct[${date_day_app_key}]="${ct}"
              day_app_based_key_hash[${date_day_app_key}]="${date_day_app_key}"
          else
              #echo "INFO: mul_old key"
              get_cur_day_based_app_val=(`echo "${day_app_based_ct[${date_day_app_key}]}"`)
              let new_ct=${get_cur_day_based_app_val}+${ct}
              day_app_based_ct[${date_day_app_key}]="${new_ct}"
          fi
          #read SSSSSS
#week based app  ct
          week_app_based_key=(`echo "${week_app_based_key_hash[${date_week_app_key}]}"`)
          week_app_based_key=${week_app_based_key:-NONE}
          if [ "${week_app_based_key}" == "NONE"  ]; then
              week_app_based_ct[${date_week_app_key}]="${ct}"
              week_app_based_key_hash[${date_week_app_key}]="${date_week_app_key}"
          else
              get_cur_week_based_app_val=(`echo "${week_app_based_ct[${date_week_app_key}]}"`)
              let new_ct=${get_cur_week_based_app_val}+${ct}
              week_app_based_ct[${date_week_app_key}]="${new_ct}"
          fi
#month based app  ct
          month_app_based_key=(`echo "${month_app_based_key_hash[${date_month_app_key}]}"`)
          month_app_based_key=${month_app_based_key:-NONE}
          if [ "${month_app_based_key}" == "NONE"  ]; then
              month_app_based_ct[${date_month_app_key}]="${ct}"
              month_app_based_key_hash[${date_month_app_key}]="${date_month_app_key}"
          else
              get_cur_month_based_app_val=(`echo "${month_app_based_ct[${date_month_app_key}]}"`)
              let new_ct=${get_cur_month_based_app_val}+${ct}
              month_app_based_ct[${date_month_app_key}]="${new_ct}"
          fi
          #hr_based_ct[${date_key}]="${hr_val}"
#year based app  ct
          year_app_based_key=(`echo "${year_app_based_key_hash[${date_year_app_key}]}"`)
          year_app_based_key=${year_app_based_key:-NONE}
          if [ "${year_app_based_key}" == "NONE"  ]; then
              year_app_based_ct[${date_year_app_key}]="${ct}"
              year_app_based_key_hash[${date_year_app_key}]="${date_year_app_key}"
          else
              get_cur_year_based_app_val=(`echo "${year_app_based_ct[${date_year_app_key}]}"`)
              let new_ct=${get_cur_year_based_app_val}+${ct}
              year_app_based_ct[${date_year_app_key}]="${new_ct}"
          fi
    done
    echo  "INFO: CONSOLIDATED_FOLDING_RPT_RUN_CT_END_`date '+%H_%M_%S-%s-%W_%j'`"

    echo  "INFO: FOLDING_RPT_RUN_CT_START_`date '+%H_%M_%S-%s-%W_%j'`"
#Consolidated rpt
#by hour all apps
#rpt: 20231013,1600_ECS_batrck23-patch-dms-usc-uat-nsg,1
    echo "DATE,HOUR,APP_TAG,BUILD_TAG,# of Scans" > ${dw_dir}/${processed_dir}/${hourly_all_app_based_file}
    for all_items in `echo "${!hr_based_ct[@]}"`
    do
          #echo "INFO: KEY - ${all_items}"
          ct=(`echo "${hr_based_ct[${all_items}]}"`)
          YD=(`echo "${all_items}" | cut -d "_" -f 1`)
          cal_key=(`echo "YD${YD}"`)
          cal_tr=(`echo "${cal_day_of_year_lk_hash[${cal_key}]}"`)
          new_val=(`echo "${all_items}" | cut -d "_" -f 2-`)
          #echo "ALL: HR-ALL ${cal_tr},${all_items},${ct}"
          #echo "ALL: HR-ALL ${cal_tr},${comma_sep},${ct}"
          comma_sep=(`echo "${new_val}" | tr '_' ','`)
          echo "${cal_tr},${comma_sep},${ct}"
    done | sort >> ${dw_dir}/${processed_dir}/${hourly_all_app_based_file}
#by hr and app
#rpt: 20231022,1400_ECS,1
    echo "DATE,HOUR,APP_TAG,# of Scans" > ${dw_dir}/${processed_dir}/${hourly_app_based_file}
    for all_items in `echo "${!hr_app_based_ct[@]}"`
    do
          #echo "INFO: KEY - ${all_items}"
          ct=(`echo "${hr_app_based_ct[${all_items}]}"`)
          YD=(`echo "${all_items}" | cut -d "_" -f 1`)
          cal_key=(`echo "YD${YD}"`)
          cal_tr=(`echo "${cal_day_of_year_lk_hash[${cal_key}]}"`)
          new_val=(`echo "${all_items}" | cut -d "_" -f 2-`)
          #echo "ALL: HR-APP  ${all_items},${ct}"
          #echo "ALL: HR-APP ${cal_tr},${new_val},${ct}"
          comma_sep=(`echo "${new_val}" | tr '_' ','`)
          echo "${cal_tr},${comma_sep},${ct}"
    done | sort >>${dw_dir}/${processed_dir}/${hourly_app_based_file}
#by day and app
#rpt: 20231014_287_ECS,2
    echo "DATE,DAY_OF_YEAR,APP_TAG,# of Scans" > ${dw_dir}/${processed_dir}/${day_app_based_file}
    for all_items in `echo "${!day_app_based_ct[@]}"`
    do
          #echo "INFO: KEY - ${all_items}"
          ct=(`echo "${day_app_based_ct[${all_items}]}"`)
          #echo "ALL: DAY-APP ${all_items},${ct}"
          comma_sep=(`echo "${all_items}" | tr '_' ','`)
          echo "${comma_sep},${ct}"
    done |  sort >>${dw_dir}/${processed_dir}/${day_app_based_file}
#by week and app
#rpt: 2023_43_PROD,4
    echo "YEAR,WEEK,APP_TAG,# of Scans" > ${dw_dir}/${processed_dir}/${week_app_based_file}
    for all_items in `echo "${!week_app_based_ct[@]}"`
    do
          #echo "INFO: KEY - ${all_items}"
          ct=(`echo "${week_app_based_ct[${all_items}]}"`)
          #echo "ALL: WEEK-APP  ${all_items},${ct}"
          comma_sep=(`echo "${all_items}" | tr '_' ','`)
          echo "${comma_sep},${ct}"
    done  |  sort >>${dw_dir}/${processed_dir}/${week_app_based_file}
#by month and app
#rpt: 202310_eastus2,3
    echo "YEAR_AND_MONTH,APP_TAG,# of Scans" > ${dw_dir}/${processed_dir}/${month_app_based_file}
    for all_items in `echo "${!month_app_based_ct[@]}"`
    do
          #echo "INFO: KEY - ${all_items}"
          ct=(`echo "${month_app_based_ct[${all_items}]}"`)
          #echo "ALL: MONTH-APP  ${all_items},${ct}"
          comma_sep=(`echo "${all_items}" | tr '_' ','`)
          echo "${comma_sep},${ct}"
    done  |  sort >>${dw_dir}/${processed_dir}/${month_app_based_file}
#by year and app
#rpt: 2023_ctc,1
    echo "YEAR,APP_TAG,# of Scans" > ${dw_dir}/${processed_dir}/${year_app_based_file}
    for all_items in `echo "${!year_app_based_ct[@]}"`
    do
          #echo "INFO: KEY - ${all_items}"
          ct=(`echo "${year_app_based_ct[${all_items}]}"`)
          #echo "ALL: YEAR-APP  ${all_items},${ct}"
          comma_sep=(`echo "${all_items}" | tr '_' ','`)
          echo "${comma_sep},${ct}"
    done  |  sort >>${dw_dir}/${processed_dir}/${year_app_based_file}
    echo  "INFO: FOLDING_RPT_RUN_CT_START_`date '+%H_%M_%S-%s-%W_%j'`"

    cd -
    cd ${dw_dir}/${processed_dir}
    echo "INFO: executing_python3 -python3 /apps/bin/create_scan_rpt_xls.py ./${xls_file}  ./${hourly_all_app_based_file} ./${hourly_app_based_file} ./${day_app_based_file} ./${week_app_based_file} ./${month_app_based_file} ./${year_app_based_file}"
    python3 /apps/bin/create_scan_rpt_xls.py ./${xls_file}  ./${hourly_all_app_based_file} ./${hourly_app_based_file} ./${day_app_based_file} ./${week_app_based_file} ./${month_app_based_file} ./${year_app_based_file}
    cd -
        final_file=(`ls -C1 ${dw_dir}/${processed_dir}/${xls_file}`)
        echo "INFO: url http://127.0.0.1${final_file}"

#sample_output_start
# echo "20231020" | sed 's/\(.\)\{2\}$//'
#202310
# echo "20231020" | sed 's/\(.\)\{4\}$//'
#2023
# echo "20231020" | sed 's/\(.\)\{6\}$//'
#20
# echo "20231020" | sed 's/^\(.\)\{6\}$//'
#20231020
# echo "20231020" | sed 's/^\(.\)\{6\}//'
#20
# echo "20231020" | sed 's/^\(.\)\{4\}//'
#1020
# echo "20231020" | sed 's/^\(.\)\{4\}//' | sed 's/^\(.\)\{2\}//'
#20
# echo "20231020" | sed 's/^\(.\)\{4\}//' | sed 's/\(.\)\{2\}$//'
#10
#INFO: KEY - K20231020-42-293_17_createSUB-HCB-AIPPS-aipps-prod-centralus_ECS
#INFO: # of Times run - 1
#INFO: files S58191_614
#ALL: K20231020-42-293_17_createSUB-HCB-AIPPS-aipps-prod-centralus_ECS,S58191_614,1

#INFO: KEY - K20231016-42-289_15_featureiorptcrbac_ECS
#INFO: # of Times run - 1
#INFO: files S62770_1989
#ALL: K20231016-42-289_15_featureiorptcrbac_ECS,S62770_1989,1

#INFO: KEY - K20231021-42-294_02_createSUB-PBM-MYPBM-RSEL-nsg_ECS
#INFO: # of Times run - 1
#INFO: files S57748_2132
#ALL: K20231021-42-294_02_createSUB-PBM-MYPBM-RSEL-nsg_ECS,S57748_2132,1

#INFO: KEY - K20231020-42-293_16_featurepgrnonprod-nsg_ECS
#INFO: # of Times run - 1
#INFO: files S08130_1299
#ALL: K20231020-42-293_16_featurepgrnonprod-nsg_ECS,S08130_1299,1

#INFO: KEY - K20231017-42-290_17_batrck23-patch-gdm-prod-use2-nsg-1_ECS
#INFO: # of Times run - 1
#INFO: files S41790_2654
#ALL: K20231017-42-290_17_batrck23-patch-gdm-prod-use2-nsg-1_ECS,S41790_2654,1

#sample_output_end
}


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
#gs://dev-cvs-scan-reports/iac_scan_rpt_csv/CSETEST/container/20230920-38-263/04/csv_1695184899-20230920-38-263_04.CSETEST.container.gz
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
            #gs://dev-cvs-scan-reports/iac_scan_rpt_bucket/CSES3/gcbuild/1695067883-20230918-38-261/20/bucket_1695067883-20230918-38-261_20.gz
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
        echo "INFO: CMD gcloud ${gcloud_context} ls gs://dev-cvs-scan-reports/iac_scan_tf_rpt"
        #files_to_download_list=(`gcloud ${gcloud_context} ls gs://dev-cvs-scan-reports/iac_scan_rpt_bucket`)
        #files_to_download_bucket_list=(`gcloud ${gcloud_context} ls gs://dev-cvs-scan-reports/iac_scan_rpt_bucket/*/*/*/*`)
        #files_to_download_csv_list=(`gcloud ${gcloud_context} ls gs://dev-cvs-scan-reports/iac_scan_rpt_csv/*/*/*/*`)
        files_to_download_tf_list=(`gcloud ${gcloud_context} ls gs://dev-cvs-scan-reports/iac_scan_tf_plan/*/*/*/*`)
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
    get_status_of_processed_rpt
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
declare -A  run_modules

    run_modules["echo_vars"]="echo_vars"
    run_modules["check_cloud_obj_srv"]="check_cloud_obj_srv"
    run_modules["get_status_of_processed_rpt"]="get_status_of_processed_rpt"
    run_modules["prepare_file_list"]="prepare_file_list"
    run_modules["get_run_ct"]="get_run_ct"
    run_modules["get_csv_files"]="get_csv_files"
    rt_execute=${1:-NONE}
    ev=$(echo "${run_modules[echo_vars]}")

    if [ "${rt_execute}" != "NONE" ]; then
          echo "INFO: Available functions in-order get_status_of_processed_rpt prepare_file_list get_run_ct  get_csv_files"
          for all_modules_to_execute in `echo "$@" | tr ',' '\n'`
          do
            echo "INFO: modules ${all_modules_to_execute}"
            fnp=()
            fnp=(`echo "${all_modules_to_execute}" | tr ':' ' '`)
            echo "INFO: fn and p =  ${fnp[0]} and ${fnp[1]}" 
            key=(`echo "${fnp[0]}"`)
            key=${key:-NONE}
            echo "INFO: key ${key}"
            p=(`echo "${fnp[1]}"`)
            p=${p:-NONE}
            mdf=(`echo "${run_modules[${key}]}"`)
            echo "INFO: Validated  fn - ${mdf} parater ${p}"
            case  "${mdf}" in
   
            "NONE")
                   ${ev}      
                   echo "INFO: Executing Module ${mdf}"
                    NONE
                    ;;
            *)
                 ${ev}      
                 echo "INFO: Executing Module ${mdf}"
                 if [ "${mdf}" == "${p}" ]; then
                     echo "INFO: NO_PARATER left to function"
                     ${mdf} "NONE"
                  else
                     echo "INFO: WITH_PARATER ${p}"
                     ${mdf} "${p}"

                  fi
                 ;;
            esac
         done
    else
         echo "INFO: Starting entry_point all_run"
         all_run
    fi
#DPC-Function push_report_to_s3  -Definition End
