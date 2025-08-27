#p1_hash[ST_15]="${date_sts_based_root_dir}"
#p2_hash[ST_15]="${DATE}"
#p3_hash[ST_15]="sts"
#p4_hash[ST_15]="sts"
             
declare -A final_file_name_hash
             
   rpt_ct=$(echo "0")
   gz_file_list_ct=$(echo "0")
   rpt_files_ar=()
   rpt_pipe_ct=$(echo "0")
   tar_file_to_pipe_file_ct=$(echo "0")
   untar_status=$(echo "0")
             
pull_gz_from_cloud ()
{
      echo "INFO: FN-NAME pull_gz_from_cloud" 
      mkdir -p ${1}/daily_rpt
      cd ${1}/daily_rpt
      echo "INFO: gcloud storage cp gs://${my_current_buk_data}/iac_scan_status/${2}/rpt_*.gz ."
      gcloud storage cp gs://${my_current_buk_data}/iac_scan_status/${2}/rpt_*.gz .
      rpt_files_ar=(`ls -C1 ${1}/daily_rpt/rpt_*.gz 2>/dev/null`)
      echo "INFO: RPT_GZ_FILES ${rpt_files_ar[@]}"
      echo "${rpt_files_ar[@]}" > ${1}/rpt_${2}_process.info
      echo "INFO: process_file_created ${1}/rpt_${2}_process.info"
      cd -   
}            
      
tar_file_to_pipe_file_count ()
{
      echo "INFO: FN-NAME tar_file_to_pipe_file_count "
      for all_gz_files in `ls -C1 ${1}/daily_rpt/rpt_*.gz 2>/dev/null`
      do
        bsn=$(basename ${all_gz_files})
        tar -tvf ${1}/daily_rpt/${bsn} | cut -d "." -f2- | cut -d "/" -f2
      done | sort -u  > ${1}/rpt_${2}_pipe.info
      tar_file_to_pipe_file_ct=$(cat ${1}/rpt_${2}_pipe.info | tr ' ' '\n' |  wc -l)
      rpt_pipe_ct=$(ls -C1 ${1}/all_rpt/*.pipe 2>/dev/null | wc -l)
      echo "INFO: files_from_dir ${rpt_pipe_ct} and list_from_tar_file ${tar_file_to_pipe_file_ct}"
      if [ ${rpt_pipe_ct} -eq ${tar_file_to_pipe_file_ct} ]; then
          if [ ${rpt_pipe_ct} -gt 0 ]; then
              untar_status=$(echo "1")
          fi
      fi 
      echo "INFO: UNTAR_STATUS-${untar_status}"
}

untar_gz_and_create_pipe_file ()
{   
      echo "INFO: FN-NAME untar_gz_and_create_pipe_file"
      tar_file_to_pipe_file_count  ${1} ${2}
      if [ ${untar_status} -lt 1 ]; then
          mkdir -p ${1}/all_rpt
          cd ${1}/all_rpt
          for all_files_gz in `ls -C1 ${1}/daily_rpt/rpt_*.gz 2>/dev/null`
          do
              echo "INFO: executing tar -xvf ${all_files_gz}"
              tar -xvf ${all_files_gz}
          done
          ls -C1 *.pipe 2>/dev/null > ${1}/rpt_${2}_pipe.info
          cd -
      fi
      tar_file_to_pipe_file_count  ${1} ${2}
      if [ "${untar_status}" -eq 1  ]; then
          echo "INFO: UNTAR_AND_PIPE_FILE_CREATION_COMPLETE"
      fi
}

chk_file_versus_inventory_gz ()
{
      echo "INFO: FN-NAME chk_file_versus_inventory_gz"
      rpt_ct=$(ls -C1 ${1}/daily_rpt/rpt_*.gz 2>/dev/null | wc -l)
      gz_file_list_ct=$(cat ${1}/rpt_${2}_process.info 2>/dev/null | tr ' ' '\n' |  wc -l)
      echo "INFO: rpt_ct ${rpt_ct} gz_file_list_ct ${gz_file_list_ct}"
      echo "INFO: CALLING pull_gz_from_cloud"
      if [ ${rpt_ct} -lt 1 ]; then
         pull_gz_from_cloud ${1} ${2}
      fi
      rpt_ct=$(ls -C1 ${1}/daily_rpt/rpt_*.gz 2>/dev/null | wc -l)
      gz_file_list_ct=$(cat ${1}/rpt_${2}_process.info 2>/dev/null | tr ' ' '\n' |  wc -l)
      if [ "${rpt_ct}" == "${gz_file_list_ct}" ]; then
          echo "INFO: GZ_FILE_PULL_COMPLETE"
      fi
}
process_all ()
{
      echo "INFO: FN-NAME process_all"
}

chk_all_done ()
{
      echo "INFO: FN-NAME chk_all_done"
      tar_file_to_pipe_file_count  ${1} ${2}
      if [ "${untar_status}" -eq 1  ]; then
          echo "INFO: UNTAR_AND_PIPE_FILE_CREATION_COMPLETE"
          #exit 0
      else
          echo "INFO: UNTAR_AND_PIPE_FILE_CREATION_NOT_COMPLETE"
      fi
}

get_tfp_files_from_storage ()
{
  echo "INFO: FN-NAME get_tfp_files_from_storage"
             if [ "${#reports_to_pull_tfp[@]}" -gt 0 ]; then
                  echo "INFO: BUCKET_TFP_FILE_PULL_DECISION_VALIDATION_CT already_present"
                  reports_to_pull_tfp=(`cat ${date_based_tfp_dir}/${tfp_files_only}`)
                  tfp_files_list_ar=(`echo "${reports_to_pull_tfp[@]}" | tr ' ' '\n'| sort |  grep "\.tfplan$" | grep -v "err_"`)
                  tfp_ct=$(echo "${#tfp_files_list_ar[@]}")
                  if [ ${collect_tfp_files_already_present_ct}  -lt ${tfp_ct} ]; then
                      mkdir -p ${date_based_tfp_dir}/daily_tfp
                      for all_tfps in `echo "${tfp_files_list_ar[@]}"`
                      do
                          echo "INFO: tfp files ${all_tfps}"
                          tfp_file=(`echo "${all_tfps}" | cut -d "/" -f 9`)
                          echo "INFO: BUCKET_PULL_CMD- gcloud storage cp ${all_tfps} ${date_based_tfp_dir}/daily_tfp/${tfp_file}"
                          gcloud storage cp ${all_tfps} ${date_based_tfp_dir}/daily_tfp/${tfp_file}
                      done
                  else
                      echo "INFO: tfp files are present"
                  fi
             fi


}

get_date_based_tfp_files ()
{
  echo "INFO: FN-NAME get_date_based_tfp_files"
  echo "INFO: tfp_check_file ${tfp_check_file} search_pattern ${tfp_search_pattern}"
             if [ "${tfp_check_file}" == "NONE" ]; then
                  echo "INFO: executing cmd - gcloud storage ls ${tfp_search_pattern}"
                  reports_to_pull_tfp=$(gcloud storage ls ${tfp_search_pattern} |  tr ' ' '\n')
                  if [ "${#reports_to_pull_tfp[@]}" -gt 0 ]; then
                     mkdir -p ${date_based_tfp_dir}/daily_tfp
                     mkdir -p ${date_based_tfp_dir}/all_tfp
                     echo "${reports_to_pull_tfp[@]}" | tr ' ' '\n' | sort  > ${date_based_tfp_dir}/tfp_all_files.info
                     echo "${reports_to_pull_tfp[@]}" | tr ' ' '\n' | sort |  grep "\.tfplan$" > ${date_based_tfp_dir}/${tfp_files_only}
                     echo "INFO: TFP_PULL ${reports_to_pull_tfp[@]}"
                  else
                     echo "INFO: NO_FILES_FOUND_IN_BUCKET_TFP EXITING_WITH_ZERO"
                     exit 0
                  fi
             else
                  echo "INFO: FILE_LIST_CREATED"
                  #reports_to_pull_tfp=(`cat ${date_based_tfp_dir}/${out_put_file}`)
                  reports_to_pull_tfp=(`cat ${date_based_tfp_dir}/${tfp_files_only}`)
                  echo "INFO: Records from file ${#reports_to_pull_tfp[@]}"
             fi
             get_tfp_files_from_storage
}

PROCESS_ST_255 ()
{
  echo "INFO: FN-NAME PROCESS_ST_255"
  echo "INFO: TYPE ${1} dir ${2} ${3}."
  let my_process_num=255
      p1=${1:-NONE}
      p2=${2:-NONE}
      p3=${3:-NONE}
      rpt_date=$(echo "${STORAGE_FOLDER_KEY1}")
      rpt_date_as_num=$(echo "${rpt_date}" | sed 's/-//g')
      date_as_num=$(echo "${2}" | sed 's/-//g')
      #if [ "${date_as_num}" -gt "${rpt_date_as_num}" ]; then
      #      echo "INFO: Future_date. ${date_as_num}, ${rpt_date_as_num}"
      #      return 0
      #fi
      rpt_ct=$(echo "0")
      get_date_based_tfp_files
  case  "${3}" in
  "rpt")
           echo "INFO: DATE: ${2} and pulling or checking files"
           #echo "INFO: SAME_DAY. check the current inventory"
           echo "INFO: collecting_gz files ${1}/daily_rpt"
           mkdir -p ${1}/all_rpt
           mkdir -p ${1}/daily_rpt
           rpt_ct=$(ls -C1 ${1}/daily_rpt/rpt_*.gz 2>/dev/null | wc -l)
           rpt_pipe_ct=$(ls -C1 ${1}/all_rpt/*.pipe 2>/dev/null | wc -l)
           info_process_file=$(ls -C1 ${1}/rpt_${2}_process.info 2>/dev/null)
           info_process_file=${info_process_file:-NONE}
           info_pipe_file=$(ls -C1 ${1}/rpt_${2}_pipe.info 2>/dev/null)
           info_pipe_file=${info_pipe_file:-NONE}
           echo "INFO: info_process_file ${info_process_file} and info_pipe_file ${info_pipe_file}"
           echo "INFO: BEFORE IF STATEMENT info_process_file ${1}/all_rpt/*.pipe  and rpt_ct ${rpt_ct}"
           if [  "${info_pipe_file}" == "NONE"  ]; then
               chk_file_versus_inventory_gz ${1} ${2}
               untar_gz_and_create_pipe_file ${1} ${2}
           else
               chk_all_done ${1} ${2}
           fi
           ;;
   *)
        :
        ;;
   esac
}




