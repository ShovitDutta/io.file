             
   scn_ct=$(echo "0")
   scn_gz_file_list_ct=$(echo "0")
   scn_files_ar=()
   scn_json_ct=$(echo "0")
   scn_tar_file_to_json_file_ct=$(echo "0")
   scn_untar_status=$(echo "0")
             
pull_scn_gz_from_cloud ()
{
      echo "INFO: FN-NAME pull_scn_gz_from_cloud" 
      mkdir -p ${1}/daily_scn
      cd ${1}/daily_scn
      echo "INFO: gcloud storage cp gs://${my_current_buk_data}/iac_scan_rpt_kics/${2}/*/*/*/kics_*.gz ."
      gcloud storage cp gs://${my_current_buk_data}/iac_scan_rpt_kics/${2}/*/*/*/kics*.gz .
      scn_files_ar=(`ls -C1 ${1}/daily_scn/kics_*.gz 2>/dev/null`)
      echo "INFO: OBJ_GZ_FILES ${scn_files_ar[@]}"
      echo "${scn_files_ar[@]}" > ${1}/scn_${2}_process.info
      echo "INFO: process_file_created ${1}/scn_${2}_process.info"
      cd -   
}            
      
scn_tar_file_to_json_file_count ()
{
      echo "INFO: FN-NAME scn_tar_file_to_json_file_count "
      for all_gz_files in `ls -C1 ${1}/daily_scn/kics_*.gz 2>/dev/null`
      do
        bsn=$(basename ${all_gz_files})
        tar -tvf ${1}/daily_scn/${bsn} | cut -d "." -f2- | cut -d "/" -f2
      done | sort -u  > ${1}/scn_${2}_json.info
      scn_tar_file_to_json_file_ct=$(cat ${1}/scn_${2}_json.info | tr ' ' '\n' | grep "\.json" |   wc -l)
      scn_json_ct=$(ls -C1 ${1}/all_scn/*.json 2>/dev/null | wc -l)
      echo "INFO: files_from_dir ${scn_json_ct} and list_from_tar_file ${scn_tar_file_to_json_file_ct}"
      if [ ${scn_json_ct} -eq ${scn_tar_file_to_json_file_ct} ]; then
          if [ ${scn_json_ct} -gt 0 ]; then
              scn_untar_status=$(echo "1")
          fi
      fi 
      echo "INFO: UNTAR_STATUS-${scn_untar_status}"
}

untar_scn_gz_and_create_json_file ()
{   
      echo "INFO: FN-NAME untar_scn_gz_and_create_json_file"
      scn_tar_file_to_json_file_count  ${1} ${2}
      if [ ${scn_untar_status} -lt 1 ]; then
          mkdir -p ${1}/all_scn
          cd ${1}/all_scn
          for all_files_gz in `ls -C1 ${1}/daily_scn/kics_*.gz 2>/dev/null`
          do
              echo "INFO: executing tar -xvf ${all_files_gz}"
              tar -xvf ${all_files_gz}
          done
          ls -C1 *.json 2>/dev/null > ${1}/scn_${2}_json.info
          cd -
      fi
      scn_tar_file_to_json_file_count  ${1} ${2}
      if [ "${scn_untar_status}" -eq 1  ]; then
          echo "INFO: UNTAR_AND_SCN_FILE_CREATION_COMPLETE"
      fi
}

scn_chk_file_versus_inventory_gz ()
{
      echo "INFO: FN-NAME scn_chk_file_versus_inventory_gz"
      scn_ct=$(ls -C1 ${1}/daily_scn/kics_*.gz 2>/dev/null | wc -l)
      scn_gz_file_list_ct=$(cat ${1}/scn_${2}_process.info 2>/dev/null | tr ' ' '\n' |  wc -l)
      echo "INFO: scn_ct ${scn_ct} scn_gz_file_list_ct ${scn_gz_file_list_ct}"
      echo "INFO: CALLING pull_scn_gz_from_cloud"
      if [ ${scn_ct} -lt 1 ]; then
         pull_scn_gz_from_cloud ${1} ${2}
      fi
      scn_ct=$(ls -C1 ${1}/daily_scn/kics_*.gz 2>/dev/null | wc -l)
      scn_gz_file_list_ct=$(cat ${1}/scn_${2}_process.info 2>/dev/null | tr ' ' '\n' |  wc -l)
      if [ "${scn_ct}" == "${scn_gz_file_list_ct}" ]; then
          echo "INFO: GZ_FILE_PULL_COMPLETE"
      fi
}
process_all ()
{
      echo "INFO: FN-NAME process_all"
}

scn_chk_all_done ()
{
      echo "INFO: FN-NAME scn_chk_all_done"
      scn_tar_file_to_json_file_count  ${1} ${2}
      if [ "${scn_untar_status}" -eq 1  ]; then
          echo "INFO: UNTAR_AND_SCN_FILE_CREATION_COMPLETE"
      else
          echo "INFO: UNTAR_AND_SCN_FILE_CREATION_NOT_COMPLETE"
      fi
}

process_scn ()
{
  echo "INFO: FN-NAME process_scn"
  echo "INFO: TYPE ${1} dir ${2} ${3}."
      p1=${1:-NONE}
      p2=${2:-NONE}
      p3=${3:-NONE}
      scn_date=$(echo "${STORAGE_FOLDER_KEY1}")
      scn_date_as_num=$(echo "${scn_date}" | sed 's/-//g')
      date_as_num=$(echo "${2}" | sed 's/-//g')
      #if [ "${date_as_num}" -gt "${scn_date_as_num}" ]; then
      #      echo "INFO: Future_date. ${date_as_num}, ${scn_date_as_num}"
      #      return 0
      #fi
      scn_ct=$(echo "0")
  case  "${3}" in
  "scn")
           echo "INFO: DATE: ${2} and pulling or checking files"
           echo "INFO: collecting_gz files ${1}/daily_scn"
           mkdir -p ${1}/all_scn
           mkdir -p ${1}/daily_scn
           scn_ct=$(ls -C1 ${1}/daily_scn/kics_*.gz 2>/dev/null | wc -l)
           scn_json_ct=$(ls -C1 ${1}/all_scn/*.json 2>/dev/null | wc -l)
           info_process_file=$(ls -C1 ${1}/scn_${2}_process.info 2>/dev/null)
           info_process_file=${info_process_file:-NONE}
           info_json_file=$(ls -C1 ${1}/scn_${2}_json.info 2>/dev/null)
           info_json_file=${info_json_file:-NONE}
           echo "INFO: info_process_file ${info_process_file} and info_json_file ${info_json_file}"
           echo "INFO: BEFORE IF STATEMENT info_process_file ${1}/all_scn/*.json  and scn_ct ${scn_ct}"
           if [  "${info_json_file}" == "NONE"  ]; then
               scn_chk_file_versus_inventory_gz ${1} ${2}
               untar_scn_gz_and_create_json_file ${1} ${2}
           else
               scn_chk_all_done ${1} ${2}
           fi
           ;;
   *)
        :
        ;;
   esac
}
