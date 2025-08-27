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
     echo "HELP: Usage $0 week_of_year"
     #echo "HELP: Usage Example  $0 20231031-42-304 (YYYYMMDD-WEEK-DAY_OF_YEAR)"
     #echo "HELP: Usage Example  $0 (default will be current week until last hour)"
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
  let LASTMONTH=${MONTH}-1
  let LASTYEAR=${YEAR}-1

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

    get_date_folder_from_obj_ar=()
    get_date_folder_from_obj_root_dir_ar=()
    get_date_hh_folder_from_obj_ar=()
    declare -A get_date_folder_from_obj_hash
    declare -A get_date_hh_folder_from_obj_hash
    get_date_folder_from_obj_csv_root=(`echo "gs://dev-cvs-scan-reports/iac_scan_rpt_csv/"`)
    declare -A week_day_hash
    declare -A hrs_of_day_hash
    declare -A year_hash
    declare -A all_finalized_dir_list
    #load all_gz_files_downloaded
    csv_gz_files_found=(`ls -CR1 ${dw_dir}/${processed_dir}/${YEAR} 2>/dev/null | grep "\.gz$"`)
    let num_of_csv_gz_files_found=(`echo "${#csv_gz_files_found[@]}"`)
    num_of_csv_gz_files_found=${num_of_csv_gz_files_found:-0}
    let week_to_process=(`echo "${WEEK}"`)
    init_files_found=(`ls -CR1 ${dw_dir}/${processed_dir}/init.* 2>/dev/null`)
    let num_of_init_files_found=(`echo "${#init_files_found[@]}"`)
    num_of_init_files_found=${num_of_init_files_found:-0}

    declare -A process_state_engine_for_week_hash
    process_state_engine_for_week_ar=()
    processed_week_ar=()
    declare -A processed_week_hash

    declare -A weeks_to_process_state_p1_hash
    declare -A weeks_to_process_state_p2_hash
    declare -A weeks_to_process_state_week_hash
    declare -A weeks_to_process_state_xls_hash

    . /apps/lib/snyk_kics_inventory_info.sh

    static_cr_csv=(`echo "/apps/custom/report/cr.csv"`)
    static_kics_rules_tf_csv=(`echo "/apps/custom/report/kics_terraform_rules.csv"`)
csv_to_xls_final_stage ()
{

  echo "INFO: FN-NAME csv_to_xls_final_stage"
  week_key=(`echo "${1}_week_done"`)
  week_val=(`echo "${1}.week.done"`)
  week_xls_key=(`echo "${1}_xls_done"`)
  week_xls_val=(`echo "${1}.xls.done"`)
#41.kics.sm.csv 41.rr.csv 41.rr.ct.csv 41.rr.detail.unique.rules.csv 41.rr.tfr.ct.csv 41.snyk.sm.csv
   echo "INFO: dir-${dw_dir}/${processed_dir}/${YEAR}/${1}/csv_all"
   cd ${dw_dir}/${processed_dir}/${YEAR}/${1}/csv_all
   get_final_rpt_files=(`ls -C1 ${1}.*.csv 2>/dev/null | tr ' ' '\n'`)
   echo "INFO: final_files_to_process ${#get_final_rpt_files[@]}"
   if [ "${#get_final_rpt_files[@]}" -eq 4 ]; then
       echo "INFO: all_files_are_generated_ready_to_produce iac_scan.${1}.${YEAR}.xlsx"
# "Coverage_Report","Scan_metrics(kics)","Scan_metrics(snyk)","Weekly metrics by rules","Rules and Resources","list of kics rules"
       echo "INFO: executing_python3 -python3 /apps/bin/convert_files_to_cr_sm_rr_formatted_xls.py iac_scan.${1}.${YEAR}.xlsx ${static_cr_csv} ${1}.kics.sm.csv ${1}.snyk.sm.csv ${1}.rr.csv ${1}.rr.detail.unique.rules.csv ${static_kics_rules_tf_csv}"
        #python3 /apps/bin/convert_files_to_xls.py iac_scan.${1}.${YEAR}.xlsx ${static_cr_csv} ${1}.kics.sm.csv ${1}.snyk.sm.csv ${1}.rr.csv ${1}.rr.detail.unique.rules.csv ${1}.rr.ct.csv ${1}.rr.tfr.ct.csv
        rpt_dir=(`echo "${dw_dir}/${processed_dir}/${YEAR}/${1}/csv_all"`)
        /apps/bin/create_xls.sh ${rpt_dir}/iac_scan.${1}.${YEAR}.xlsx ${static_cr_csv} ${rpt_dir}/${1}.kics.sm.csv ${rpt_dir}/${1}.snyk.sm.csv ${rpt_dir}/${1}.rr.csv ${rpt_dir}/${1}.rr.detail.unique.rules.csv ${static_kics_rules_tf_csv}
        #python3 /apps/bin/convert_files_to_xls.py iac_scan.${1}.${YEAR}.xlsx ${static_cr_csv} ${1}.kics.sm.csv ${1}.snyk.sm.csv ${1}.rr.csv ${1}.rr.detail.unique.rules.csv ${static_kics_rules_tf_csv}
        final_file=(`ls -C1 iac_scan.${1}.${YEAR}.xlsx 2>/dev/null`)
        final_file=${final_file:-NONE}
        if [ "${final_file}" == "NONE" ]; then
             echo "INFO: REPORT_FILE-iac_scan.${1}.${YEAR}.xlsx FAILED"
        else
            echo "INFO: url http://127.0.0.1/${final_file}"
            touch ${rpt_dir}/${week_val}
            touch ${rpt_dir}/${week_xls_val}
        fi
   fi
   
   weeks_to_process_state_week_hash[${week_xls_key}]="done"
   weeks_to_process_state_week_hash[${week_key}]="done"
}

start_process_for_week_p2 ()
{
  echo "INFO: FN-NAME start_process_for_week_p2"
  echo "INFO: start_process_for_week_p2_for_week=${2}_start with ${1}"
  echo "INFO: checking_process process_state_p2"
  p1=(`echo "${2}_p1_done"`)
  p2=(`echo "${2}_p2_done"`)
  status_p1=(`echo "${2}.p1.done"`)
  status_p2=(`echo "${2}.p2.done"`)
  from_d1_p1=(`echo "${1}" | sed 's/week/p1/'`)
  from_d1_p2=(`echo "${1}" | sed 's/week/p2/'`)
  my_key=(`echo "${2}_p2_done"`)
  my_val=(`echo "${2}.p2.done"`)
  my_week_key=(`echo "${2}_week_done"`)
  weeks_to_process_state_p2_hash[${my_key}]="done"
  #weeks_to_process_state_p2_hash[${my_week_key}]="done"
  touch ${dw_dir}/${processed_dir}/${YEAR}/${my_val}
  #echo "INFO: YET_TO_IMPLEMENT"

}

process_state_p2 ()
{
   echo "INFO: FN-NAME process_state_p2"
   echo "INFO: start_process_p2_for_week=${2}_start with ${1} ${2}"
   p2=(`echo "${2}_p2_done"`)
   p1=(`echo "${2}_p1_done"`)
   week=(`echo "${2}_week_done"`)
   status_p2=(`echo "${2}.p2.done"`)
       get_result=(`echo "${process_state_engine_for_week_hash[${p2}]}"`)
       get_result=${get_result:-NONE}
       echo "INFO: val = ${get_result}"
       if [ "${get_result}" == "NONE" ]; then
           weeks_to_process_state_p2_hash[${2}]="NONE"
           echo "INFO: process_p2 for week ${2} is not done. calling start_process_for_week_p2 with ${1} ${2}"
           start_process_for_week_p2 ${1} ${2}
       else
           echo "INFO: status_p2_for_week_${1}_result_${get_result}"
           file_present=(`echo "${1}" | tr '_' '.'`)
           if [ "${file_present}" == "${get_result}" ]; then
               echo "INFO:  file_present ${file_present}"
               weeks_to_process_state_p2_hash[${p2}]="done"
           else
               "INFO: status_p1 for ${1} MIS_MATCH"
           fi
       fi
}


   all_rules_id=()
   declare -A all_rules_id_hash
   declare -A all_rules_id_as_key_value_hash
   declare -A all_tfr_id_hash
   declare -A all_tfr_id_as_key_value_hash

process_p1_rr_rpt ()
{

   echo "INFO: FN-NAME process_p1_rr_rpt"
          #read read_s
          echo "INFO: dir-${dw_dir}/${processed_dir}/${YEAR}/${1}/csv_all"
          cd ${dw_dir}/${processed_dir}/${YEAR}/${1}/csv_all 
          #echo "RuleId,Rule Desc,Rule Type,Category,Severity,Count" > ${1}.rr.csv
          echo "RuleId,Count" > ${1}.rr.csv
          echo "RuleId,Rule_desc,Terraform_Resource" >${1}.rr.detail.unique.rules.csv
#./43/csv_all/43.kics.sm.csv ./43/csv_all/43.snyk.sm.csv ./43/csv_all/43.rr.csv ./43/csv_all/43.rr.detail.unique.rules.csv 
#old_process_before_Nov_23_Start 
          #cat rr_* | grep -vi  "^RuleId" | cut -d "," -f 1-5 | sed 's/HIGH/high/g' | sed 's/LOW/low/g' | sed 's/MEDIUM/medium/g' | sed 's/CRITICAL/critical/g' | sed 's/"//g' |  sort -k 1,4 > ${1}.rr
#cat rr_* | grep -v  "^RuleId" | cut -d "," -f 1-5 | sed 's/HIGH/high/g' | sed 's/LOW/low/g' | sed 's/MEDIUM/medium/g' | sed 's/CRITICAL/critical/g' | sed 's/"//g' |  sort -k 1 |  cut -d "," -f 1,4
          #cat ${1}.rr  | sort -u -k 1,4 | tr ',' '|' | cut -d "|" -f 1,4 | sort   >> ${1}.rr.with_two_col
          #cat ${1}.rr.with_two_col | sort -u -k 1 > ${1}.rr.unique.rules
          #cat ${1}.rr | cut -d "," -f 1 | sort   > ${1}.rr.rules
          #cat ${1}.rr | cut -d "," -f 1,2,4 | sort   > ${1}.rr.detail.rules
          #cat ${1}.rr | cut -d "," -f 1,2,4 | sort -u >> ${1}.rr.detail.unique.rules.csv
          #cat ${1}.rr | cut -d "," -f 4 | sort   > ${1}.rr.tfr.rules
          #cat ${1}.rr | cut -d "," -f 4 | sort -u   > ${1}.rr.tfr.unique.rules
#old_process_before_Nov_23_End 
#New_process_start
          cat rr_* | grep -vi  "^RuleId" | cut -d "," -f 1,3 | sed 's/HIGH/high/g' | sed 's/LOW/low/g' | sed 's/MEDIUM/medium/g' | sed 's/CRITICAL/critical/g' | sed 's/"//g' |  sort -k 1,3 > ${1}.rr.pre
          cat ${1}.rr.pre | grep -i "standard" > ${1}.rr.standard.pre
          cat ${1}.rr | grep -i "custom" > ${1}.rr.custom.pre

          cat ${1}.rr.standard.pre | cut -d "," -f 1 | sort   > ${1}.rr.standard.all.pre
          cat ${1}.rr.standard.pre | cut -d "," -f 1 | sort -u   > ${1}.rr.standard.all_unique_sorted.pre
          cat ${1}.rr.custom.pre | cut -d "," -f 1 | sort   > ${1}.rr.custom.all.pre
          cat ${1}.rr.custom.pre | cut -d "," -f 1 | sort -u   > ${1}.rr.custom.all_unique_sorted.pre

          echo "INFO: Standard_rules"
          for all_rules_found in `cat ${1}.rr.standard.all_unique_sorted.pre`
          do
             standard_ct=(`cat ${1}.rr.standard.all.pre | grep -e "${all_rules_found}" | wc -l`)
             #echo "INFO: ${all_rules_found}, ${1}.${standard_ct}"
             echo "${all_rules_found}, ${1}.${standard_ct}"
             val_from_hash=(`echo "${snyk_kics_rules_list_hash[${all_rules_found}]}"`)
             #echo "INFO: ${val_from_hash} and key ${all_rules_found}...."
             if [ "${val_from_hash}" != "${all_rules_found}" ]; then
                echo "INFO: From Hash ${all_rules_found}, ${val_from_hash}" >>${1}.rr.missing
             else
                echo "INFO: ${val_from_hash} all_good" >>${1}.rr.all_good
             fi
          done >> ${1}.rr.csv

          echo "INFO: custom_rules"
          for all_rules_found in `cat ${1}.rr.custom.all_unique_sorted.pre`
          do
             standard_ct=(`cat ${1}.rr.custom.all.pre | grep -e "${all_rules_found}" | wc -l`)
             #echo "INFO: ${all_rules_found},${1}.${standard_ct}"
             echo "${all_rules_found},${1}.${standard_ct}"
          done >> ${1}.rr.csv
          #read read_ss
          my_key=(`echo "${1}_p1rr_done"`)
          weeks_to_process_state_p1_hash[${my_key}]="done"
#New_process_End
}


rr_dummy  ()
{
          for all_rules in `cat ${1}.rr.unique.rules`
          do
            search_str1=(`echo "${all_rules}" | cut -d "|" -f 1`)
            #search_str2=(`echo "${all_rules}" | cut -d "|" -f 2`)
            #get_ct=(`cat ${1}.rr | egrep "${search_str1}" | egrep "${search_str2}" | wc -l`)
            get_ct=(`cat ${1}.rr | egrep "${search_str1}" | wc -l`)
            all_rules_id_hash[${all_rules}]=${get_ct}
            all_rules_id_as_key_value_hash[${all_rules}]=${all_rules}
            #get_val=(`echo "${all_rules_id_hash[${all_rules}]}"`)
            #echo "INFO: print CT ${get_val}  and KEY ${all_rules}"
          done
          for all_rules_from_rr in `cat ${1}.rr`
          do
             ruleid_col=(`echo "${all_rules_from_rr}" | cut -d "," -f 1`)
             get_count_from_rule_hash=(`echo "${all_rules_id_hash[${ruleid_col}]}"`)
             echo "${all_rules_from_rr},${get_count_from_rule_hash}"
          done 
          #done | sort -u  >> ${1}.rr.csv
          # these files are not_needed
          #echo "RuleId,Count" > ${1}.rr.ct.csv
          #for all_keys in `echo "${!all_rules_id_hash[@]}"`
          #do
          #   get_val=(`echo "${all_rules_id_hash[${all_keys}]}"`)
          #   #echo "INFO:RuleId=${all_keys}, count ${get_val}"
          #   echo "${all_keys},${get_val}" | sed 's/"//g'
          #done >> ${1}.rr.ct_csv # not needed.

          #for all_tfr_rules in `cat ${1}.rr.tfr.unique.rules`
          #do
          #  get_ct=(`cat ${1}.rr.tfr.rules | egrep "${all_tfr_rules}" | wc -l`)
          #  all_tfr_id_hash[${all_tfr_rules}]=${get_ct}
          #  all_tfr_id_as_key_value_hash[${all_tfr_rules}]=${all_tfr_rules}
          #done
          #echo "Terraform_Resource_Category,Count" > ${1}.rr.tfr.ct.csv
          #for all_keys in `echo "${!all_tfr_id_hash[@]}"`
          #do
          #   get_val=(`echo "${all_tfr_id_hash[${all_keys}]}"`)
          #   #echo "INFO:RuleId=${all_keys}, count ${get_val}"
          #   echo "${all_keys},${get_val}"  | sed 's/"//g'
          #done >> ${1}.rr.tfr.ct_csv #not needed
          cd -
          my_key=(`echo "${1}_p1rr_done"`)
          weeks_to_process_state_p1_hash[${my_key}]="done"

}

process_p1_sm_rpt ()
{

   echo "INFO: FN-NAME process_p1_sm_rpt"
#create_sm_kics_file
          echo "INFO: dir-${dw_dir}/${processed_dir}/${YEAR}/${1}/csv_all"
          cd ${dw_dir}/${processed_dir}/${YEAR}/${1}/csv_all 
          cat sm_* | grep "#kics" |  grep -v "#kics_rules" > ${1}.kics
          cat sm_* | grep "#snyk" |  grep -v "#snyk_rules" > ${1}.snyk
          declare -A kics_hash
          kics_hash["kics_severity_low"]=0
          kics_hash["kics_severity_medium"]=0
          kics_hash["kics_severity_high"]=0
          for all_kics_items in  `cat ${1}.kics`
          do
             f1=(`echo "${all_kics_items}" | cut -d "," -f 1 | cut -d "#" -f 2`)
             f2=(`echo "${all_kics_items}" | cut -d "," -f 2`)
             #echo "INFO: all ${all_kics_items} f1=${f1} and f2=${f2}"
             get_key=(`echo "${kics_hash[${f1}]}"`)
             get_key=${get_key:-0}
             let val=${f2}+${get_key}
             kics_hash[${f1}]=${val}

             #echo "INFO: get_key = ${get_key} and f1=${f1}"
             #echo " ${f1} ${kics_hash[${f1}]}"
             #read SSSSSSS
          done
          declare -A snyk_hash
          snyk_hash["snyk_severity_low"]=0
          snyk_hash["snyk_severity_medium"]=0
          snyk_hash["snyk_severity_high"]=0
          for all_snyk_items in `cat ${1}.snyk`
          do
             f1=(`echo "${all_snyk_items}" | cut -d "," -f 1 | cut -d "#" -f 2`)
             f2=(`echo "${all_snyk_items}" | cut -d "," -f 2`)
             #echo "INFO: all ${all_snyk_items} f1=${f1} and f2=${f2}"
             get_key=(`echo "${snyk_hash[${f1}]}"`)
             get_key=${get_key:-0}
             let val=${f2}+${get_key}
             snyk_hash[${f1}]=${val}
             #echo " ${f1} ${snyk_hash[${f1}]}"
             #read SSSSSSS
          done
          echo "Scan Results/Week,Week of Year (${1})" > ${1}.kics.sm.csv
          get_s_h=(`echo "${kics_hash[kics_severity_high]}"`)
          get_s_m=(`echo "${kics_hash[kics_severity_medium]}"`)
          get_s_l=(`echo "${kics_hash[kics_severity_low]}"`)
          let kt=${get_s_h}+${get_s_m}+${get_s_l}
          echo "#kics_rules,${kt}" >> ${1}.kics.sm.csv
          for all_sms in `echo "${!kics_hash[@]}"`
          do
            val=(`echo "${kics_hash[${all_sms}]}"`)
            echo "INFO: key=${all_sms} value=${val}"
            echo "#${all_sms},${val}" >>${1}.kics.sm.csv
          done
          echo "Scan Results/Week,Week of Year (${1})" > ${1}.snyk.sm.csv
          get_s_h=(`echo "${snyk_hash[snyk_severity_high]}"`)
          get_s_m=(`echo "${snyk_hash[snyk_severity_medium]}"`)
          get_s_l=(`echo "${snyk_hash[snyk_severity_low]}"`)
          let kt=${get_s_h}+${get_s_m}+${get_s_l}
          echo "#snyk_rules,${kt}" >> ${1}.snyk.sm.csv
          for all_sms in `echo "${!snyk_hash[@]}"`
          do
            val=(`echo "${snyk_hash[${all_sms}]}"`)
            echo "INFO: key=${all_sms} value=${val}"
            echo "#${all_sms},${val}" >>${1}.snyk.sm.csv
          done
        cd -
          my_key=(`echo "${1}_p1sm_done"`)
          weeks_to_process_state_p1_hash[${my_key}]="done"
}

start_process_for_week_p1 ()
{
  echo "INFO: FN-NAME start_process_for_week_p1"
  echo "INFO: start_process_for_week_p1_for_week=${2}_start with ${1}"
  echo "INFO: checking_process process_state_p1"
  #read SSSSSS
  p1=(`echo "${2}_p1_done"`)
  p2=(`echo "${2}_p2_done"`)
  status_p1=(`echo "${2}.p1.done"`)
  status_p2=(`echo "${2}.p2.done"`)
  from_d1_p1=(`echo "${1}" | sed 's/week/p1/'`)
  from_d1_p2=(`echo "${1}" | sed 's/week/p2/'`)
# ar=$(tar -tvf ./14/csv_1697035812-20231011-41-284_14.CV25BIGFILE.GITTF.gz | grep -v KICS | grep -v SNYK | grep -v scan | cut -d "/" -f 2- | tr '\n' ' ')
#tar -zxvf ../14/csv_1697035812-20231011-41-284_14.CV25BIGFILE.GITTF.gz `echo ${ar}`
#/data/iac_scan_status/2023/41/20231011-41-284/all_csv
  #${dw_dir}/${processed_dir}/${YEAR}
  #gz_file csv_1697246362-20231014-41-287_01.sub-rtl-esri-prod-eastus-DBSubnettosubnet.ECS.gz
  case "${3}" in
  "untar")
          untar_key=(`echo "${2}_p1gz_done"`)
          my_val=(`echo "${2}.p1gz.done"`)
          get_untar_status=(`echo "${weeks_to_process_state_p1_hash[${untar_key}]}"`)
          get_untar_status=${get_untar_status:-NONE}
          if [ "${get_untar_status}" == "NONE" ]; then
              for all_week_based_gz_file_list in ` ls -CR1 ${dw_dir}/${processed_dir}/${YEAR} | grep "\.gz$" | egrep "\-${2}\-"`
              do
                 echo "INFO: gz_file ${all_week_based_gz_file_list}"
                 get_dir_from_file=(`echo "${all_week_based_gz_file_list}" | cut -d "." -f 1 | cut -d "-" -f 2-4 | sed 's/_/\//'`)
                 echo "INFO get_dir_from_file ${get_dir_from_file}"
                 full_file_name=(`echo "${dw_dir}/${processed_dir}/${YEAR}/${2}/${get_dir_from_file}/${all_week_based_gz_file_list}"`)
                 untar_dir=(`echo "${dw_dir}/${processed_dir}/${YEAR}/${2}/csv_all"`)
                 mkdir -p ${untar_dir}
                 echo "INFO: full_file_path ${full_file_name}"
                 chk_file=(`ls -C1 ${full_file_name} 2>/dev/null`)
                 if [ "${full_file_name}" == "${chk_file}" ]; then
                     echo "INFO: file ${chk_file} verified."
                     ar=$(tar -tvf ${chk_file} | sed 's/ //g' | cut -d "/" -f 3 | grep -v KICS | grep -v SNYK | grep -v scan |  tr '\n' ' ' | sed 's/ / \.\//g' | sed 's/\.\/$//')
                     echo "INFO: Files to untar ${ar}"
                     cd ${untar_dir}
                     echo "INFO: executing cmd tar -zxvf ${full_file_name} ./${ar}"
                     tar -zxvf ${full_file_name} `echo "./${ar}"`
                     echo "INFO: csv files `ls -C1 *.csv`"
                     cd -
                 fi
              done
          fi
          touch ${dw_dir}/${processed_dir}/${YEAR}/${my_val}
          weeks_to_process_state_p1_hash[${untar_key}]="done"
                ;;
    "sm")
          sm_key=(`echo "${2}_p1sm_done"`)
          my_val=(`echo "${2}.p1sm.done"`)
          get_sm_status=(`echo "${weeks_to_process_state_p1_hash[${sm_key}]}"`)
          get_sm_status=${get_sm_status:-NONE}
          if [ "${get_sm_status}" == "NONE" ]; then
           process_p1_sm_rpt ${2}
           touch ${dw_dir}/${processed_dir}/${YEAR}/${my_val}
           weeks_to_process_state_p1_hash[${sm_key}]="done"
          fi
           ;;
    "rr")
          rr_key=(`echo "${2}_p1rr_done"`)
          my_val=(`echo "${2}_p1rr_done"`)
          get_rr_status=(`echo "${weeks_to_process_state_p1_hash[${rr_key}]}"`)
          get_rr_status=${get_rr_status:-NONE}
          if [ "${get_rr_status}" == "NONE" ]; then
           process_p1_rr_rpt ${2}
           touch ${dw_dir}/${processed_dir}/${YEAR}/${my_val}
           weeks_to_process_state_p1_hash[${rr_key}]="done"
          fi
           ;;
    *)
          untar_key=(`echo "${2}_p1gz_done"`)
          my_val=(`echo "${2}.p1gz.done"`)
          get_untar_status=(`echo "${weeks_to_process_state_p1_hash[${untar_key}]}"`)
          get_untar_status=${get_untar_status:-NONE}
          if [ "${get_untar_status}" == "NONE" ]; then
               for all_week_based_gz_file_list in ` ls -CR1 ${dw_dir}/${processed_dir}/${YEAR} | grep "\.gz$" | egrep "\-${2}\-"`
               do
                  echo "INFO: gz_file ${all_week_based_gz_file_list}"
                  get_dir_from_file=(`echo "${all_week_based_gz_file_list}" | cut -d "." -f 1 | cut -d "-" -f 2-4 | sed 's/_/\//'`)
                  echo "INFO get_dir_from_file ${get_dir_from_file}"
                  full_file_name=(`echo "${dw_dir}/${processed_dir}/${YEAR}/${2}/${get_dir_from_file}/${all_week_based_gz_file_list}"`)
                  untar_dir=(`echo "${dw_dir}/${processed_dir}/${YEAR}/${2}/csv_all"`)
                  mkdir -p ${untar_dir}
                  echo "INFO: full_file_path ${full_file_name}"
                  chk_file=(`ls -C1 ${full_file_name} 2>/dev/null`)
                  if [ "${full_file_name}" == "${chk_file}" ]; then
                      echo "INFO: file ${chk_file} verified."
                      ar=$(tar -tvf ${chk_file} | sed 's/ //g' | cut -d "/" -f 3 | grep -v KICS | grep -v SNYK | grep -v scan |  tr '\n' ' ' | sed 's/ / \.\//g' | sed 's/\.\/$//')
                      echo "INFO: Files to untar ${ar}"
                      cd ${untar_dir}
                      echo "INFO: executing cmd tar -zxvf ${full_file_name} ./${ar}"
                      tar -zxvf ${full_file_name} `echo "./${ar}"`
                      echo "INFO: csv files `ls -C1 *.csv`"
                      cd -
                  fi
               done
               touch ${dw_dir}/${processed_dir}/${YEAR}/${my_val}
               weeks_to_process_state_p1_hash[${untar_key}]="done"
          fi

          sm_key=(`echo "${2}_p1sm_done"`)
          my_val=(`echo "${2}.p1sm.done"`)
          get_sm_status=(`echo "${weeks_to_process_state_p1_hash[${sm_key}]}"`)
          get_sm_status=${get_sm_status:-NONE}

          if [ "${get_sm_status}" == "NONE" ]; then
              process_p1_sm_rpt ${2}
              touch ${dw_dir}/${processed_dir}/${YEAR}/${my_val}
              weeks_to_process_state_p1_hash[${sm_key}]="done"
          fi

          rr_key=(`echo "${2}_p1rr_done"`)
          my_val=(`echo "${2}.p1rr.done"`)
          get_rr_status=(`echo "${weeks_to_process_state_p1_hash[${rr_key}]}"`)
          get_rr_status=${get_rr_status:-NONE}

          if [ "${get_rr_status}" == "NONE" ]; then
             process_p1_rr_rpt ${2}
             touch ${dw_dir}/${processed_dir}/${YEAR}/${my_val}
             weeks_to_process_state_p1_hash[${rr_key}]="done"
          fi

          my_key=(`echo "${2}_p1_done"`)
          my_val=(`echo "${2}.p1.done"`)
          touch ${dw_dir}/${processed_dir}/${YEAR}/${my_val}
          weeks_to_process_state_p1_hash[${my_key}]="done"
           ;;
    esac
}

process_state_p1 ()
{
   echo "INFO: FN-NAME process_state_p1"
   echo "INFO: start_process_p1_for_week=${2}_start with ${1}"
       p1=(`echo "${1}_p1_done"`)
       get_result=(`echo "${process_state_engine_for_week_hash[${p1}]}"`)
       get_result=${get_result:-NONE}
       echo "INFO: val = ${get_result}"
       if [ "${get_result}" == "NONE" ]; then
           weeks_to_process_state_p1_hash[${2}]="NONE"
           echo "INFO: process_p1 for week ${2} is not done. calling start_process_for_week_p1 with ${1} ${2}"
           
           start_process_for_week_p1 ${1} ${2} 
           process_state_p2 ${p2} ${2}

       else
           echo "INFO: status_p1_for_week_${1}_result_${get_result}"
           file_present=(`echo "${1}" | tr '_' '.'`)
           if [ "${file_present}" == "${get_result}" ]; then
               echo "INFO: file_present ${file_present}"
               weeks_to_process_state_p1_hash[${2}]="done"
               p2=(`echo "${1}" | sed 's/p1/p2/'`)
               echo "INFO: calling status_p2 ${p2}"
               process_state_p2 ${1}  ${2}
           else
               "INFO: status_p1 for ${1} MIS_MATCH"
           fi
       fi
}


start_process_for_week_final ()
{
  echo "INFO: FN-NAME start_process_for_week_final"
  echo "INFO: start_process_for_week_final_for_week=${2}_start with ${1}"
  echo "INFO: checking_process process_state_p1"

  p1=(`echo "${1}" | sed 's/week/p1/'`)
  p2=(`echo "${1}" | sed 's/week/p2/'`)
  xls=(`echo "${1}" | sed 's/week/xls/'`)
  week_done_file=(`echo "${2}.week.done"`)
  week_done_key=(`echo "${2}_week_done"`)

  get_process_status_p1_for_given_week=(`echo "${weeks_to_process_state_p1_hash[${p1}]}"`)
  get_process_status_p1_for_given_week=${get_process_status_p1_for_given_week:-NONE}
  if [ "${get_process_status_p1_for_given_week}" == "done" ]; then
       echo "INFO: process_state_p1 for_week ${2} is done"
       echo "INFO: check_for_process process_state_p2 for_week ${2}"
       get_process_status_p2_for_given_week=(`echo "${weeks_to_process_state_p2_hash[${p2}]}"`)
       get_process_status_p2_for_given_week=${get_process_status_p2_for_given_week:-NONE}
       if [ "${get_process_status_p2_for_given_week}" == "done" ]; then
          echo "INFO: process_state_p2 for_week ${2} is done" 
          echo "INFO: bucket_pull_csv_gz_untar_week_consolidation_done"
          echo "INFO: checking_process csv_to_xls_final_stage for_week ${2}"
          get_process_status_xls_for_given_week=(`echo "${weeks_to_process_state_xls_hash[${xls}]}"`)
          get_process_status_xls_for_given_week=${get_process_status_xls_for_given_week:-NONE}
          if [ "${get_process_status_xls_for_given_week}" == "NONE" ]; then
              echo "INFO: csv_to_xls_final_stage_not_done calling last step csv_to_xls_final_stage with ${2}"
              echo "INFO calling final step: csv_to_xls_final_stage"
              csv_to_xls_final_stage ${2}
          else
              echo "INFO: csv_to_xls_final_stage for_week ${2} is done"
              touch ${dw_dir}/${processed_dir}/${YEAR}/${week_done_file}
              process_state_engine_for_week_hash[${week_done_key}]=${week_done_file}
              weeks_to_process_state_week_hash[${week_done_key}]="done"
          fi
       else
          echo "INFO: checking_process process_state_p2 for_week ${2} incomplete"
          echo "INFO: calling process_state_p2 with week ${2}"
          process_state_p2 ${p2} ${2} 
       fi
  else
       echo "INFO: get_process_status_p1_for_given_week=${get_process_status_p1_for_given_week}"
       echo "INFO: checking_process process_state_p1 for_week ${2}"
       echo "INFO: only_bucket_pull_done"
       echo "INFO: calling process_state_p1 ${p1} ${2}"
       process_state_p1 ${p1} ${2}
  fi
  
}

process_state_week ()
{
   echo "INFO: FN-NAME process_state_week"
   echo "INFO: process_state_week_for_week=${2}_start with ${1}"
       get_result=(`echo "${process_state_engine_for_week_hash[${1}]}"`)
       get_result=${get_result:-NONE}
       echo "INFO: process_state_week_value=${get_result}"
       if [ "${get_result}" == "NONE" ]; then
           weeks_to_process_state_week_hash[${2}]="NONE"
           p1=(`echo "${1}" | sed 's/week/p1/'`)
           #process_state_p1 ${p1} ${2}
           get_week_status_from_children=(`echo "${weeks_to_process_state_week_hash[${2}]}"`)
           get_week_status_from_children=${get_week_status_from_children:-NONE}
           echo "INFO: calling start_process_for_week_final with ${1} ${2}"
           start_process_for_week_final ${1} ${2}
       else
           echo "INFO: status_week for week=${1} and result=${get_result}" 
           file_present=(`echo "${1}" | tr '_' '.'`)
           if [ "${file_present}" == "${get_result}" ]; then
               echo "INFO: FN=process_state_week file_present  ${file_present}"
               weeks_to_process_state_week_hash[${1}]="done"
           else
               "INFO: status_week for week=${1} and MIS_MATCH"
           fi 
       fi
}

collect_process_state_engine_for_week ()
{
   echo "INFO: FN-NAME collect_process_state_engine_for_week"
   cd ${dw_dir}/${processed_dir}/${YEAR}
   process_state_engine_for_week_ar=(`ls -C1  ??.*.done 2>/dev/null | tr ' ' '\n'`)
   for all_states in `echo "${process_state_engine_for_week_ar[@]}" | tr ' ' '\n'`
   do 
      #echo "INFO: state_engine_for_week ${all_states}"
      key=(`echo "${all_states}" | tr '.' '_'`)
      process_state_engine_for_week_hash[${key}]="${all_states}" 
      #echo "INFO: key ${key} and val ${all_states}"
   done
   for all_state in `echo "${!process_state_engine_for_week_hash[@]}"`
   do
      get_val=(`echo "${process_state_engine_for_week_hash[${all_state}]}"`)
      #echo "current_state_for_all_weeks_found ${all_state},${get_val}"
      get_state=(`echo "${get_val}" | cut -d "." -f 2`)
      get_state_status=(`echo "${get_val}" | cut -d "." -f 3`)
      
      case "${get_state}" in
      "p1")
             weeks_to_process_state_p1_hash[${all_state}]=${get_state_status}
             ;;
      "p1sm")
             weeks_to_process_state_p1_hash[${all_state}]=${get_state_status}
             ;;
      "p1rr")
             weeks_to_process_state_p1_hash[${all_state}]=${get_state_status}
             ;;
      "p1gz")
             weeks_to_process_state_p1_hash[${all_state}]=${get_state_status}
             ;;
      "p2")
             weeks_to_process_state_p2_hash[${all_state}]=${get_state_status}
             ;;
      "week")
             weeks_to_process_state_week_hash[${all_state}]=${get_state_status}
              ;;
      "xls")
             weeks_to_process_state_xls_hash[${all_state}]=${get_state_status}
              ;;
      esac
  
      
   done
}

   declare -A weeks_processed_until_this_run_hash
   declare -A weeks_to_process_from_input

collect_all_processing_info ()
{
      echo "INFO: FN-NAME collect_all_processing_info"
      processed_week_ar=(`echo "${csv_gz_files_found[@]}" | tr ' ' '\n' | cut -d "." -f 1 | cut -d "-" -f 3 | sort -u | tr ' ' '\n'`)
      for all_unique_weeks in `echo "${processed_week_ar[@]}" | tr ' ' '\n'`
      do
        weeks_processed_until_this_run_hash[${all_unique_weeks}]="${all_unique_weeks}"
        #echo "INFO: processed_week_from_gz_files ${all_unique_weeks}"
        key_state_p1=(`echo "${all_unique_weeks}_p1_done"`)
        key_state_p2=(`echo "${all_unique_weeks}_p2_done"`)
        key_state_week_status=(`echo "${all_unique_weeks}_week_done"`)
        processed_week_hash[${key_state_p1}]="NONE"
        processed_week_hash[${key_state_p2}]="NONE"
        processed_week_hash[${key_state_week_status}]="NONE"
      done
      #for all_status_of_week in `echo "${!processed_week_hash[@]}"`
      #do
      #    get_val=(`echo "${processed_week_hash[${all_status_of_week}]}"`)
      #    echo "INFO: hash_nm=processed_week_hash and key=${all_status_of_week}, val=${get_val}"
      #done
}

single_week_process ()
{
   echo "INFO: FN-NAME single_week_process"
   echo "INFO: week to Process is ${1}"
   done_file=(`echo "${1}_week_done"`)
   p1=(`echo "${1}_p1_done"`)
   p2=(`echo "${1}_p2_done"`)
   week=(`echo "${1}_week_done"`)
   process_state_week "${done_file}" "${1}"
   rc=(`echo "${weeks_to_process_state_week_hash[${week}]}"`)
   echo "INFO: key_used ${week} function_called-process_state_week , rc=${rc}"
   if [ "${rc}" == "done" ]; then
        echo "INFO: week# ${1} Completed. EXIT_WITH_SUCCESS"
        exit 0
   else
        echo "INFO: flag_file_missing. process for week ${2} p1,p2,week processes not done"
        echo "INFO: week# ${1} has issues. EXIT_WITH_ERROR"
        exit 101
   fi
}

  let max_week=0
  data_pull_pattern=(`echo "*"`)
calculate_which_week_of_year_to_process ()
{
   echo "INFO: FN-NAME calculate_which_week_of_year_to_process"
   collect_process_state_engine_for_week
   collect_all_processing_info
   week_1=$(date --date "yesterday" +"%V")
   week_2=$(date --date "today" +"%V")
   week_2=$(date --date "tomorrow" +"%V")
   day_1=$(date --date "yesterday" +"%a")
   day_2=$(date --date "today" +"%a")
   day_3=$(date --date "tomorrow" +"%a")
   marker_date_year_end=$(date --date "12/31/${LASTYEAR}" +"%V")
   marker_date_year_start=$(date --date "01/01/${YEAR}" +"%V")
   let  week_to_process=(`echo "${week_2}"`)
   if [ "${day_2}" == "Mon" ]; then
       let  week_to_process=${week_to_process}-1 
       if [ ${week_to_process} -eq 0 ]; then
          let week_to_process=52
       fi
       echo "INFO: Week data Processing, week is set ${week_to_process}"
       let max_week=${week_to_process}
   fi
   if [ "${1}" -gt 0 ]; then
      #echo "INFO: this script should be run only on Mon of every Week."  
      echo "INFO: week number is required. this is parameter 1."
      input_week_to_process=${1:-0}
      case "${input_week_to_process}" in
     
      "all")
              echo "INFO: process_all_weeks_based_on_status"
              get_the_last_entry=(`echo "${csv_gz_files_found[@]}" | tr ' ' '\n' | tail -n 1`)
              get_week_from_last_entry=(`echo "${get_the_last_entry}" | cut -d "." -f 1 | cut -d "-" -f 3`)
              let week_to_process=${get_week_from_last_entry}
              option_all_process
              ;;
      *)
          if [ ${input_week_to_process} -eq 0 ]; then
              echo "INPUT: week input is ZERO.exiting"
              exit 100
          else
              echo "INFO: input_week_to_process ${input_week_to_process} and week_to_process ${week_to_process}"
              if [ "${input_week_to_process}" -gt ${week_to_process} ]; then
                    echo "INPUT: input week# ${input_week_to_process} is out_of_range (max is ${week_to_process}). EXIT_WITH_ERROR_100"
                    exit 100
              fi
                  echo "INPUT: week input is ${input_week_to_process}"
              if [ ${input_week_to_process} -lt ${WEEK} ]; then
                    echo "INFO: DATA_SHOULD_BE_PULLED_FROM_OBJ"
                    echo "INFO: DATA_PULL ${YEAR}*-${input_week_to_process}-*"
                    data_pull_pattern=(`echo "${YEAR}*-${input_week_to_process}-*"`)
                    chk_week=(`ls -C1 ${dw_dir}/${processed_dir}/${YEAR}/${input_week_to_process} 2>/dev/null`)
                    chk_week=${chk_week:-0}
                    if [ "${chk_week}" -eq 0 ]; then
                        echo "INFO: Direcroty not Found. Start Pulling from Bucket"
                        single_week_process ${input_week_to_process}
                    fi
              fi
              #else 
                  week_to_process=(`echo "${weeks_processed_until_this_run_hash[${input_week_to_process}]}"`)
                  week_to_process=${week_to_process:-0}
                  if [ ${week_to_process} -eq 0 ]; then
                      
                      echo "INPUT: input week# is out_of_range or NO_DATA_AVAILABLE. EXIT_WITH_ERROR_100"
                      exit 100
                  else
                        single_week_process ${week_to_process}
                  fi
              #fi
          fi
           ;;
      esac
   fi

}  
option_all_process ()
{
   echo "INFO: FN-NAME option_all_process"
   case "${num_of_csv_gz_files_found}" in

   0)
      echo "INFO: NO_PROCESSING_IS_STATRED"
      echo "INFO: CHECHING_FOR_init_files"
      if [ ${num_of_init_files_found} -gt 0 ]; then
           echo "INFO: init files found. NO_GZ_DW process completed."
           echo "INITIATING GZ_DW_CSV"
      fi
      ;;
   *)
      get_the_last_entry=(`echo "${csv_gz_files_found[@]}" | tr ' ' '\n' | tail -n 1`)
      get_week_from_last_entry=(`echo "${get_the_last_entry}" | cut -d "." -f 1 | cut -d "-" -f 3`)

      echo "INFO: last entry ${get_week_from_last_entry}"
      if [ "${week_to_process}" -eq ${get_week_from_last_entry} ]; then
           echo "INFO: week_to_process and get_week_from_last_entry are equal, gz of csv pulling from bucket is done."
           echo "INFO: weekly report creation process checking"
           cd ${dw_dir}/${processed_dir}/${PROCESS_YEAR}
           chk_done_for_last_entry=(`ls -C1 ${week_to_process}.week.done 2>/dev/null | cut -d "." -f 1`)
           if [ "${week_to_process}" == "${chk_done_for_last_entry}" ]; then
               echo "INFO: ALL_PROCESS and STEPS are DONE. Nothing to Process. EXIT_WITH_ZERO"
               exit 0
           else
                 echo "INFO: collect_process_state_engine"
                 for all_states_key in `echo "${!process_state_engine_for_week_hash[@]}" | tr ' ' '\n'`
                 do
                     get_val=(`echo "${process_state_engine_for_week_hash[${all_states_key}]}"`)
                     get_week_from_processed_hash=(`echo "${processed_week_hash[${all_states_key}]}"`)
                     processed_week_hash[${all_states_key}]="${get_val}"
                     #echo "INFO: STATUS_${all_states_key} ${get_val} and get_week_from_processed_hash ${get_week_from_processed_hash}"
                 done
                 for all_unique_weeks in `echo "${processed_week_ar[@]}" | tr ' ' '\n' | sort -u`
                 do
                     echo "INFO: WEEK # ${all_unique_weeks} calling status process_state_week"
                     wwd=(`echo "${all_unique_weeks}_week_done"`)
                     process_state_week "${wwd}" "${all_unique_weeks}"
                 done
                 
           fi 
      else
            echo "INFO: ${week_to_process} is new. fetch from bucket and start ptocess"
            exit 0
      fi
                 ;;
   esac
   exit 0
}

process_gz_files_dw_decision ()
{
   echo "INFO: FN-NAME process_gz_files_dw_decision"
   if [ ${num_of_csv_gz_files_found} -gt 0 ]; then
       echo "INFO: num_of_csv_gz_files_found=${num_of_csv_gz_files_found}"
       water_mark=(`cat ${dw_dir}/${processed_dir}/${WEEK}.dir`)
   fi

}

get_date_folder_from_obj ()
{
    echo "INFO: FN-NAME get_date_folder_from_obj"
#gs://dev-cvs-scan-reports/iac_scan_tf_plan/20231028-43-301/09/
    cd ${dw_dir}/${processed_dir}
    echo "INFO: # of gz files found - ${num_of_csv_gz_files_found}"
    chk_file=(`ls -C1 ${dw_dir}/${processed_dir}/${WEEK}.list 2>/dev/null`)
    chk_file=${chk_file:-NONE}
    echo "INFO: chk_file=${chk_file}"
    echo "INFO: data_pull_pattern ${data_pull_pattern} MARKER=get_date_folder_from_obj"
    read SSSSSS
    if [ "${chk_file}" == "NONE" ]; then
        echo "INFO: executing gcloud storage ls gs://dev-cvs-scan-reports/iac_scan_tf_plan/${data_pull_pattern} |  tr ' ' '\n'"
        get_date_folder_from_obj_ar=(`gcloud storage ls gs://dev-cvs-scan-reports/iac_scan_tf_plan/${data_pull_pattern} |  tr ' ' '\n' | grep -v "iac_scan_tf_plan/$"`)
        echo "INFO: Writing file ${dw_dir}/${processed_dir}/${WEEK}.list"
        echo "${get_date_folder_from_obj_ar[@]}" | tr ' ' '\n'  >>${dw_dir}/${processed_dir}/${WEEK}.list
        echo "INFO: Writing file ${dw_dir}/${processed_dir}/${WEEK}.dir"
        echo "${get_date_folder_from_obj_ar[@]}" | tr ' ' '\n' | grep ":$" >> ${dw_dir}/${processed_dir}/${WEEK}.dir
        echo "INFO: Writing file ${dw_dir}/${processed_dir}/${WEEK}_HOUR.dir_hr"
        echo "${get_date_folder_from_obj_ar[@]}" | tr ' ' '\n' | grep -v ":$" >> ${dw_dir}/${processed_dir}/${WEEK}_HOUR.dir_hr
        get_date_folder_from_obj_root_dir_ar=(`echo "${get_date_folder_from_obj_ar[@]}" | tr ' ' '\n' | grep ":$"`)
        get_date_hh_folder_from_obj_ar=(`echo "${get_date_folder_from_obj_ar[@]}"  | tr ' ' '\n' | grep -v ":$"`)
        
    else
        get_date_folder_from_obj_ar=(`cat ${dw_dir}/${processed_dir}/${WEEK}.list | tr ' ' '\n'`)
        get_date_folder_from_obj_root_dir_ar=(`cat "${dw_dir}/${processed_dir}/${WEEK}.dir" | tr ' ' '\n'`)
        get_date_hh_folder_from_obj_ar=(`cat "${dw_dir}/${processed_dir}/${WEEK}_HOUR.dir_hr"  | tr ' ' '\n' | grep -v ":$"`)
    fi
    #20230928-39-271
    #take only directory top level
    for all_date_key_as_is in `echo "${get_date_folder_from_obj_root_dir_ar[@]}" | tr ' ' '\n'`
    do
      #gs://dev-cvs-scan-reports/iac_scan_tf_plan/20231011-41-284/14/
      #20230928-39-271 (20230928-39)
      #echo "INFO: VAL=${all_date_key_as_is}"
      all_date_key=(`echo "${all_date_key_as_is}" | cut -d "/" -f 5`)
      #echo "INFO: VAL=${all_date_key}"
      #mkdir -p ${dw_dir}/${processed_dir}/${all_date_key}
      new_key_fyyyymmddww=(`echo "${all_date_key}" | cut -d "-" -f 1-2`)
      #20230928-39-271 (39)
      new_key_fww=(`echo "${all_date_key}" | cut -d "-" -f 2`)
      mkdir -p ${dw_dir}/${processed_dir}/${YEAR}/${new_key_fww}
      #20230928-39-271/10 (271)
      new_key_fj=(`echo "${all_date_key}" | cut -d "-" -f 3`)
      #echo "INFO: new_key_fyyyymmddww=${new_key_fyyyymmddww}, new_key_fww=${new_key_fww},new_key_fj=${new_key_fj}"
      #echo "INFO: VAL=${all_date_key}"
      get_date_folder_from_obj_hash[${all_date_key}]="${all_date_key}"
      get_val_from_week_day_hash=(`echo "${week_day_hash[${new_key_fww}]}"`)
      get_val_from_week_day_hash=${get_val_from_week_day_hash:-NONE}
      if [ "${get_val_from_week_day_hash}" == "NONE" ]; then
           week_day_hash[${new_key_fww}]="${all_date_key}"
      else
          get_cur_val=(`echo "${week_day_hash[${new_key_fww}]}"`)
          new_val=(`echo "${get_cur_val},${all_date_key}"`)
          week_day_hash[${new_key_fww}]="${new_val}"
      fi
    done 

    for all_date_key_as_is in `echo "${get_date_hh_folder_from_obj_ar[@]}" | tr ' ' '\n'`
    do
      #gs://dev-cvs-scan-reports/iac_scan_tf_plan/20231011-41-284/14/
      #20230928-39-271 (20230928-39)
      #ww-yymmdd-ww-j done ( 39 20230928-39-271,20230928-39-278 ...)
      all_date_key=(`echo "${all_date_key_as_is}" | cut -d "/" -f 5`)
      new_key_fwwjhr=(`echo "${all_date_key_as_is}" | cut -d "/" -f 5-6`)
      #echo "INFO: new_key_fwwjhr=${new_key_fwwjhr}"
      new_key_fww=(`echo "${all_date_key}" | cut -d "-" -f 2`)

      get_val_from_hrs_of_day_hash=(`echo "${hrs_of_day_hash[${all_date_key}]}"`)
      get_val_from_hrs_of_day_hash=${get_val_from_hrs_of_day_hash:-NONE}
      if [ "${get_val_from_hrs_of_day_hash}" == "NONE" ]; then
              hrs_of_day_hash[${all_date_key}]="${new_key_fwwjhr}"
      else
           get_cur_val=(`echo "${hrs_of_day_hash[${all_date_key}]}"`)
           new_val=(`echo "${get_cur_val},${new_key_fwwjhr}"`)
           hrs_of_day_hash[${all_date_key}]="${new_val}"
      fi
      final_leaf=(`echo "${dw_dir}/${processed_dir}/${YEAR}/${new_key_fww}/${new_key_fwwjhr}"`)
      mkdir -p ${final_leaf}  #${dw_dir}/${processed_dir}/${YEAR}/${new_key_fww}/${new_key_fwwjhr}
      all_finalized_dir_list[${final_leaf}]="${final_leaf}"
      echo "INFO: final ${all_finalized_dir_list[${final_leaf}]}"
    done
    reports_to_pull_csv_gz=(`gcloud storage ls gs://dev-cvs-scan-reports/iac_scan_rpt_csv/*/*/*/*/ | grep "\.gz$" | tr ' ' '\n'`)
    for all_csv_gz in `echo "${reports_to_pull_csv_gz[@]}" | tr ' ' '\n'`
    do
      key_folder_to_dw=(`echo "${all_csv_gz}" | cut -d "/" -f 5-6`) 
      file_nm=(`echo "${all_csv_gz}" | cut -d "/" -f 9`)
      week=(`echo "${key_folder_to_dw}" | cut -d "-" -f 2`)
      full_dir_nm_to_dw=(`echo "${dw_dir}/${processed_dir}/${YEAR}/${week}/${key_folder_to_dw}"`)
      get_dir_from_tf_pan_hash=(`echo "${all_finalized_dir_list[${full_dir_nm_to_dw}]}"`)
      get_dir_from_tf_pan_hash=${get_dir_from_tf_pan_hash:-NONE}
      if [ "${get_dir_from_tf_pan_hash}" != "NONE" ]; then
           echo "INFO: Executing file download- gcloud storage cp ${all_csv_gz} ${get_dir_from_tf_pan_hash}/${file_nm}"
           gcloud storage cp ${all_csv_gz} ${get_dir_from_tf_pan_hash}/${file_nm}
      fi
    done
    #gcloud storage ls gs://dev-cvs-scan-reports/iac_scan_rpt_csv/*/*/*/*/ | grep "\.gz$"
    #gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231027-43-300/19/redi-splunk-dev/ECS/csv_1698434314-20231027-43-300_19.redi-splunk-dev.ECS.gz
    #gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231027-43-300/19/redi-splunk-prod/ECS/csv_1698434328-20231027-43-300_19.redi-splunk-prod.ECS.gz
    #gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231027-43-300/19/redi-splunk-qa/ECS/csv_1698434285-20231027-43-300_19.redi-splunk-qa.ECS.gz
    #gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231027-43-300/20/Alexei-Simons-patch-1/ECS/csv_1698438984-20231027-43-300_20.Alexei-Simons-patch-1.ECS.gz
    #gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231027-43-300/20/Alexei-Simons-patch-2/ECS/csv_1698438991-20231027-43-300_20.Alexei-Simons-patch-2.ECS.gz
    #gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231027-43-300/20/featureSUB-CORP-SECUREHUB002-hub-prod-westus3/ECS/csv_1698437780-20231027-43-300_20.featureSUB-CORP-SECUREHUB002-hub-prod-westus3.ECS.gz
    #gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231028-43-301/01/createSUB-RTL-MCLIN-mclin-dev-eastus2/ECS/csv_1698455845-20231028-43-301_01.createSUB-RTL-MCLIN-mclin-dev-eastus2.ECS.gz
    #gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231028-43-301/03/createSUB-PBM-DMS-QA-USC-nsg/ECS/csv_1698462427-20231028-43-301_03.createSUB-PBM-DMS-QA-USC-nsg.ECS.gz
    #gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231028-43-301/03/createSUB-PBM-DMS-UAT-USC-out-nsg/ECS/csv_1698462506-20231028-43-301_03.createSUB-PBM-DMS-UAT-USC-out-nsg.ECS.gz
    #gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231028-43-301/03/createSUB-PBM-MOR-QA-USE2-nsg/ECS/csv_1698463406-20231028-43-301_03.createSUB-PBM-MOR-QA-USE2-nsg.ECS.gz
    #gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231028-43-301/09/createSUB-CORP-EPACORE-PGR-nsg/ECS/csv_1698486035-20231028-43-301_09.createSUB-CORP-EPACORE-PGR-nsg.ECS.gz

    #
    #for all_date_hr_key in `echo "${!hrs_of_day_hash[@]}"`
    #do
    #  get_ours=(`echo "${hrs_of_day_hash[${all_date_hr_key}]}"`)
    #  echo "INFO: DAY=${all_date_hr_key} and HRS ${get_ours}" 
    #done
    #for all_week in `echo "${!week_day_hash[@]}"`
    #do
    #    get_day=(`echo "${week_day_hash[${all_week}]}"`)
    #    echo "INFO: week # ${all_week} and day ${get_day}"
    #    echo "INFO: WEEK_INFO_START"
    #    for all_hrs in `echo "${week_day_hash[${all_week}]}" | tr ',' '\n'`
    #    do
    #       get_hr=(`echo "${hrs_of_day_hash[${all_hrs}]}"`)
    #       echo "INFO: week # ${all_week}:DAY:${all_hrs}=${get_hr}"
    #    done
    #    echo "INFO: WEEK_INFO_END"
    #done
}

get_status_of_processed_rpt ()
{
    echo "INFO: FN-NAME get_status_of_processed_rpt"
    WEEK=${1:-NONE}
  

    if [ "${WEEK}" == "NONE" ]; then
         echo "ERROR: Usage $0 Missing Parameter (week of the year). EXIT_WITH_ERR_CODE=100"
         exit 100
    fi
    get_date_folder_from_obj
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

    case "${choice}" in

    "csv")
          echo "INFO: cloud obj pull csv_start_`date '+%H_%M_%S-%s-%W_%j'`"
          reports_to_pull_csv_gz=(`gcloud storage ls gs://dev-cvs-scan-reports/iac_scan_rpt_csv/${DATE}/${HOUR}/*/* |  tr ' ' '\n'`)
          echo "INFO: cloud obj pull csv_end_`date '+%H_%M_%S-%s-%W_%j'`"
          ll_filter_last_hr=()
          ll_filter_last_hr=(`echo "${reports_to_pull_tf_files[@]}" | tr ' ' '\n' | sort | cut -d "/" -f 5-6 | sort -u`)
          filter_limit=(`echo "${filter_last_hr}" | cut -d "-" -f 3 | sed 's/\///'`)
          echo "INFO: filter_last_hr ${ll_filter_last_hr}, filter_limit ${filter_limit}"

              #rm -rf ${all_csv_rpt_folder_file_list}
             
             echo "INFO: ${reports_to_pull_csv_gz[@]} | tr ' ' '\n'"
             read SSSSSS
             echo "${reports_to_pull_csv_gz[@]}" | tr ' ' '\n' | sort  >> ${all_csv_rpt_folder_file_list}
             cd -
          ;;
     "snyk")
             echo "INFO: cloud obj pull snyk_start_`date '+%H_%M_%S-%s-%W_%j'`"
             reports_to_pull_snyk_gz=(`gcloud storage ls gs://dev-cvs-scan-reports/iac_scan_rpt_snyk/${DATE}/${HOUR}/*/*`)
             echo "INFO: cloud obj pull snyk_end_`date '+%H_%M_%S-%s-%W_%j'`"
             echo "${reports_to_pull_snyk_gz[@]}" >> ${all_snyk_rpt_folder_file_list}
             prepare_file_list "snyk"
             ;;
     "kics")
             echo "INFO: cloud obj pull kics_start_`date '+%H_%M_%S-%s-%W_%j'`"
             reports_to_pull_kics_gz=(`gcloud storage ls gs://dev-cvs-scan-reports/iac_scan_rpt_kics/${DATE}/${HOUR}/*/*`)
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
    echo "INFO: Current Week ${WEEK}"
    calculate_which_week_of_year_to_process ${1}
    check_cloud_obj_srv
    get_date_folder_from_obj ${1}
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
        all_run ${1} ${2} ${3}

#DPC-Function push_report_to_s3  -Definition End
