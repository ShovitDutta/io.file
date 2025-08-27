             
declare -A final_file_name_hash
             
   sts_ct=$(echo "0")
   gz_file_list_ct=$(echo "0")
   sts_files_ar=()
   sts_json_ct=$(echo "0")
   ststar_file_to_json_file_ct=$(echo "0")
             
get_sts_files_from_storage ()
{
  echo "INFO: FN-NAME get_sts_files_from_storage"
             if [ "${#reports_to_pull_sts[@]}" -gt 0 ]; then
                  echo "INFO: BUCKET_STS_FILE_PULL_DECISION_VALIDATION_CT already_present"
                  sts_files_list_ar=(`echo "${reports_to_pull_sts[@]}" | tr ' ' '\n'| sort |  grep "\.json$"`)
                  sts_ct=$(echo "${#sts_files_list_ar[@]}")
                  if [ ${sts_ct} -gt 0 ]; then
                      mkdir -p ${date_based_sts_dir}/daily_sts
                      for all_sts in `echo "${sts_files_list_ar[@]}"`
                      do
                          echo "INFO: sts files ${all_sts}"
                          sts_file=(`echo "${all_sts}" | cut -d "/" -f 9`)
                          echo "INFO: BUCKET_PULL_STS_CMD- gcloud storage cp ${all_sts} ${date_based_sts_dir}/daily_sts/${sts_file}"
                          gcloud storage cp ${all_sts} ${date_based_sts_dir}/daily_sts/${sts_file}
                      done
                  fi
             fi
}

get_date_based_sts_files ()
{
  echo "INFO: FN-NAME get_date_based_sts_files"
  echo "INFO: sts_check_file ${sts_check_file} search_pattern ${sts_search_pattern}"
             if [ "${sts_check_file}" == "NONE" ]; then
                  echo "INFO: executing cmd - gcloud storage ls ${sts_search_pattern}"
                  reports_to_pull_sts=$(gcloud storage ls ${sts_search_pattern} |  tr ' ' '\n')
                  if [ "${#reports_to_pull_sts[@]}" -gt 0 ]; then
                     mkdir -p ${date_based_sts_dir}/daily_sts
                     mkdir -p ${date_based_sts_dir}/all_sts
                     echo "${reports_to_pull_sts[@]}" | tr ' ' '\n' | sort  > ${date_based_sts_dir}/sts_all_files.info
                     echo "${reports_to_pull_sts[@]}" | tr ' ' '\n' | sort |  grep "CISS_SCAN_RESULT_WITH_ACCTID_DATA_" > ${date_based_sts_dir}/${sts_files_only}
                     echo "INFO: STS_PULL ${reports_to_pull_sts[@]}"
                     get_sts_files_from_storage
                  else
                     echo "INFO: NO_FILES_FOUND_IN_BUCKET_STS"
                  fi
             else
                  echo "INFO: FILE_LIST_CREATED ${date_based_sts_dir}/sts_all_files.info"
                  reports_to_pull_sts=(`cat ${date_based_sts_dir}/sts_all_files.info`)
                  echo "INFO: Records from file ${#reports_to_pull_sts[@]}"
             fi
}

process_sts ()
{
  echo "INFO: FN-NAME process_sts"
  echo "INFO: TYPE ${1} dir ${2} ${3}."
      p1=${1:-NONE}
      p2=${2:-NONE}
      p3=${3:-NONE}
      sts_date=$(echo "${STORAGE_FOLDER_KEY1}")
      sts_date_as_num=$(echo "${sts_date}" | sed 's/-//g')
      date_as_num=$(echo "${2}" | sed 's/-//g')
      #if [ "${date_as_num}" -gt "${rpt_date_as_num}" ]; then
      #      echo "INFO: Future_date. ${date_as_num}, ${rpt_date_as_num}"
      #      return 0
      #fi
      sts_ct=$(echo "0")
      get_date_based_sts_files
}
