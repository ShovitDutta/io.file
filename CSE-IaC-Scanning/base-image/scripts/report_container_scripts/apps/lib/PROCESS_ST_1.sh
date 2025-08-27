#p1_hash[ST_1]="tfp"
#p2_hash[ST_1]="NONE"
#p3_hash[ST_1]="NONE"
#p4_hash[ST_1]="NONE"


PROCESS_ST_1 ()
{

  echo "INFO: FN-NAME PROCESS_ST_1"
   
  case "${1}" in
  "csv")
             if [ "${check_file}" == "NONE" ]; then
                  echo "INFO: executing cmd - gcloud storage ls ${search_pattern}"
                  reports_to_pull_csv_gz=(`gcloud storage ls ${search_pattern} |  tr ' ' '\n'`)
                  if [ "${#reports_to_pull_csv_gz[@]}" -gt 0 ]; then
                     mkdir -p ${date_based_root_dir}/daily_csv
                     mkdir -p ${date_based_root_dir}/daily_zip
                     mkdir -p ${date_based_root_dir}/all_csv
                     echo "${reports_to_pull_csv_gz[@]}" | tr ' ' '\n' | sort  > ${dir_nm}/${out_put_file}
                     echo "${reports_to_pull_csv_gz[@]}" | tr ' ' '\n' | sort |  grep "\.gz$" > ${dir_nm}/${gz_files_only}
                  else
                     echo "INFO: NO_FILES_FOUND_IN_BUCKET EXITING_WITH_ZERO"
                     exit 0
                  fi
             else
                  echo "INFO: FILE_LIST_CREATED"
                  reports_to_pull_csv_gz=(`cat ${dir_nm}/${out_put_file}`)
                  echo "INFO: Records from file ${#reports_to_pull_csv_gz[@]}"
             fi
                 ;;
   "buk")
             if [ "${check_file}" == "NONE" ]; then
                  echo "INFO: executing cmd - gcloud storage ls ${search_pattern}"
                  reports_to_pull_buk_gz=(`gcloud storage ls ${search_pattern} |  tr ' ' '\n'`)
                  if [ "${#reports_to_pull_buk_gz[@]}" -gt 0 ]; then
                     mkdir -p ${date_based_root_dir}/daily_buk
                     mkdir -p ${date_based_root_dir}/daily_zip
                     mkdir -p ${date_based_root_dir}/all_buk
                     echo "${reports_to_pull_buk_gz[@]}" | tr ' ' '\n' | sort  > ${dir_nm}/${out_put_file}
                     echo "${reports_to_pull_buk_gz[@]}" | tr ' ' '\n' | sort |  grep "\.gz$" > ${dir_nm}/${gz_files_only}
                  else
                     echo "INFO: NO_FILES_FOUND_IN_BUCKET EXITING_WITH_ZERO"
                     exit 0
                  fi
             else
                  echo "INFO: FILE_LIST_CREATED"
                  reports_to_pull_buk_gz=(`cat ${dir_nm}/${out_put_file}`)
                  echo "INFO: Records from file ${#reports_to_pull_buk_gz[@]}"
             fi
                 ;;

   "tfp")
            if [ "${check_file}" == "NONE" ]; then
                  echo "INFO: executing cmd - gcloud storage ls ${search_pattern}"
                  reports_to_pull_tfp=(`gcloud storage ls ${search_pattern} |  tr ' ' '\n'`)
                  if [ "${#reports_to_pull_tfp[@]}" -gt 0 ]; then
                     mkdir -p ${date_based_root_dir}/daily_tfp
                     mkdir -p ${date_based_root_dir}/all_tfp
                     echo "${reports_to_pull_tfp[@]}" | tr ' ' '\n' | sort  > ${dir_nm}/${out_put_file}
                     echo "${reports_to_pull_tfp[@]}" | tr ' ' '\n' | sort |  grep "\.tfplan$" > ${dir_nm}/${tfp_files_only}
                  else
                     echo "INFO: NO_FILES_FOUND_IN_BUCKET EXITING_WITH_ZERO"
                     exit 0
                  fi
             else
                  echo "INFO: FILE_LIST_CREATED"
                  reports_to_pull_tfp=(`cat ${dir_nm}/${out_put_file}`)
                  echo "INFO: Records from file ${#reports_to_pull_tfp[@]}"
             fi
               ;;
    esac
}

