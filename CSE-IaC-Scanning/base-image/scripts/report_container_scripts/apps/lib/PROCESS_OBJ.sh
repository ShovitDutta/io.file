             
   obj_ct=$(echo "0")
   obj_gz_file_list_ct=$(echo "0")
   obj_files_ar=()
   obj_json_ct=$(echo "0")
   obj_tar_file_to_json_file_ct=$(echo "0")
   obj_untar_status=$(echo "0")
             
pull_obj_gz_from_cloud ()
{
      echo "INFO: FN-NAME pull_obj_gz_from_cloud" 
      mkdir -p ${1}/daily_obj
      cd ${1}/daily_obj
      echo "INFO: gcloud storage cp gs://${my_current_buk_data}/iac_scan_rpt_bucket/${2}/*/*/*/bucket_*.gz ."
      gcloud storage cp gs://${my_current_buk_data}/iac_scan_rpt_bucket/${2}/*/*/*/bucket_*.gz .
      obj_files_ar=(`ls -C1 ${1}/daily_obj/bucket_*.gz 2>/dev/null`)
      echo "INFO: OBJ_GZ_FILES ${obj_files_ar[@]}"
      echo "${obj_files_ar[@]}" > ${1}/obj_${2}_process.info #obj_files_to_process.info
      echo "INFO: process_file_created ${1}/obj_${2}_process.info"
      cd -   
}            
      
obj_tar_file_to_json_file_count ()
{
      echo "INFO: FN-NAME obj_tar_file_to_json_file_count "
      for all_gz_files in `ls -C1 ${1}/daily_obj/bucket_*.gz 2>/dev/null`
      do
        bsn=$(basename ${all_gz_files})
        tar -tvf ${1}/daily_obj/${bsn} | cut -d "." -f2- | cut -d "/" -f2
      done | sort -u  > ${1}/obj_${2}_json.info
      obj_tar_file_to_json_file_ct=$(cat ${1}/obj_${2}_json.info | tr ' ' '\n' |  wc -l)
      obj_json_ct=$(ls -C1 ${1}/all_obj/*.json 2>/dev/null | wc -l)
      echo "INFO: files_from_dir ${obj_json_ct} and list_from_tar_file ${obj_tar_file_to_json_file_ct}"
      if [ ${obj_json_ct} -eq ${obj_tar_file_to_json_file_ct} ]; then
          if [ ${obj_json_ct} -gt 0 ]; then
              obj_untar_status=$(echo "1")
          fi
      fi 
      echo "INFO: UNTAR_STATUS-${obj_untar_status}"
}

untar_obj_gz_and_create_json_file ()
{   
      echo "INFO: FN-NAME untar_obj_gz_and_create_json_file"
      obj_tar_file_to_json_file_count  ${1} ${2}
      if [ ${obj_untar_status} -lt 1 ]; then
          mkdir -p ${1}/all_obj
          cd ${1}/all_obj
          for all_files_gz in `ls -C1 ${1}/daily_obj/bucket_*.gz 2>/dev/null`
          do
              echo "INFO: executing tar -xvf ${all_files_gz}"
              tar -xvf ${all_files_gz}
          done
          ls -C1 *.json 2>/dev/null > ${1}/obj_${2}_json.info
          cd -
      fi
      obj_tar_file_to_json_file_count  ${1} ${2}
      if [ "${obj_untar_status}" -eq 1  ]; then
          echo "INFO: UNTAR_AND_OBJ_FILE_CREATION_COMPLETE"
      fi
}

obj_chk_file_versus_inventory_gz ()
{
      echo "INFO: FN-NAME obj_chk_file_versus_inventory_gz"
      obj_ct=$(ls -C1 ${1}/daily_obj/bucket_*.gz 2>/dev/null | wc -l)
      obj_gz_file_list_ct=$(cat ${1}/obj_${2}_process.info 2>/dev/null | tr ' ' '\n' |  wc -l)
      echo "INFO: obj_ct ${obj_ct} obj_gz_file_list_ct ${obj_gz_file_list_ct}"
      echo "INFO: CALLING pull_obj_gz_from_cloud"
      if [ ${obj_ct} -lt 1 ]; then
         pull_obj_gz_from_cloud ${1} ${2}
      fi
      obj_ct=$(ls -C1 ${1}/daily_obj/bucket_*.gz 2>/dev/null | wc -l)
      obj_gz_file_list_ct=$(cat ${1}/obj_${2}_process.info 2>/dev/null | tr ' ' '\n' |  wc -l)
      if [ "${obj_ct}" == "${obj_gz_file_list_ct}" ]; then
          echo "INFO: GZ_FILE_PULL_COMPLETE"
      fi
}
process_all ()
{
      echo "INFO: FN-NAME process_all"
}

obj_chk_all_done ()
{
      echo "INFO: FN-NAME obj_chk_all_done"
      obj_tar_file_to_json_file_count  ${1} ${2}
      if [ "${obj_untar_status}" -eq 1  ]; then
          echo "INFO: UNTAR_AND_OBJ_FILE_CREATION_COMPLETE"
      else
          echo "INFO: UNTAR_AND_OBJ_FILE_CREATION_NOT_COMPLETE"
      fi
}

process_obj ()
{
  echo "INFO: FN-NAME process_obj"
  echo "INFO: TYPE ${1} dir ${2} ${3}."
      p1=${1:-NONE}
      p2=${2:-NONE}
      p3=${3:-NONE}
      obj_date=$(echo "${STORAGE_FOLDER_KEY1}")
      obj_date_as_num=$(echo "${obj_date}" | sed 's/-//g')
      date_as_num=$(echo "${2}" | sed 's/-//g')
      #if [ "${date_as_num}" -gt "${obj_date_as_num}" ]; then
      #      echo "INFO: Future_date. ${date_as_num}, ${obj_date_as_num}"
      #      return 0
      #fi
      obj_ct=$(echo "0")
  case  "${3}" in
  "obj")
           echo "INFO: DATE: ${2} and pulling or checking files"
           echo "INFO: collecting_gz files ${1}/daily_obj"
           mkdir -p ${1}/all_obj
           mkdir -p ${1}/daily_obj
           obj_ct=$(ls -C1 ${1}/daily_obj/bucket_*.gz 2>/dev/null | wc -l)
           obj_json_ct=$(ls -C1 ${1}/all_obj/*.json 2>/dev/null | wc -l)
           info_process_file=$(ls -C1 ${1}/obj_${2}_process.info 2>/dev/null)
           info_process_file=${info_process_file:-NONE}
           info_json_file=$(ls -C1 ${1}/obj_${2}_json.info 2>/dev/null)
           info_json_file=${info_json_file:-NONE}
           echo "INFO: info_process_file ${info_process_file} and info_json_file ${info_json_file}"
           echo "INFO: BEFORE IF STATEMENT info_process_file ${1}/all_obj/*.json  and obj_ct ${obj_ct}"
           if [  "${info_json_file}" == "NONE"  ]; then
               obj_chk_file_versus_inventory_gz ${1} ${2}
               untar_obj_gz_and_create_json_file ${1} ${2}
           else
               obj_chk_all_done ${1} ${2}
           fi
           ;;
   *)
        :
        ;;
   esac
}
