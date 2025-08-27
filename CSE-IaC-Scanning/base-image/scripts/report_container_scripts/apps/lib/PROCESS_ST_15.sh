#p1_hash[ST_15]="${date_sts_based_root_dir}"
#p2_hash[ST_15]="${DATE}"
#p3_hash[ST_15]="sts"
#p4_hash[ST_15]="sts"

declare -A final_file_name_hash

   sts_ct=$(echo "0")
   gz_file_list_ct=$(echo "0")
   sts_files_ar=()
   sts_pipe_ct=$(echo "0")
   tar_file_to_pipe_file_ct=$(echo "0")
   untar_status=$(echo "0")

pull_gz_from_cloud ()
{
      echo "INFO: FN-NAME pull_gz_from_cloud"
      mkdir -p ${1}/daily_sts
      cd ${1}/daily_sts
      gcloud storage cp gs://${my_current_buk_data}/iac_scan_status/${2}/rpt_*.gz .
      sts_files_ar=(`ls -C1 ${1}/daily_sts/rpt_*.gz 2>/dev/null`)
      echo "INFO: STS_GZ_FILES ${sts_files_ar[@]}"
      echo "${sts_files_ar[@]}" > ${1}/sts_${2}_process.info
      echo "INFO: process_file_created ${1}/sts_${2}_process.info"
      cd -
}

tar_file_to_pipe_file_count ()
{
      echo "INFO: FN-NAME tar_file_to_pipe_file_count "
      for all_gz_files in `ls -C1 ${1}/daily_sts/rpt_*.gz 2>/dev/null`
      do
        bsn=$(basename ${all_gz_files})
        tar -tvf ${1}/daily_sts/${bsn} | cut -d "." -f2- | cut -d "/" -f2
      done | sort -u  > ${1}/sts_${2}_pipe.info
      tar_file_to_pipe_file_ct=$(cat ${1}/sts_${2}_pipe.info | tr ' ' '\n' |  wc -l)
      sts_pipe_ct=$(ls -C1 ${1}/all_sts/*.pipe 2>/dev/null | wc -l)
      echo "INFO: files_from_dir ${sts_pipe_ct} and list_from_tar_file ${tar_file_to_pipe_file_ct}"
      if [ ${sts_pipe_ct} -eq ${tar_file_to_pipe_file_ct} ]; then
          if [ ${sts_pipe_ct} -gt 0 ]; then
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
          mkdir -p ${1}/all_sts
          cd ${1}/all_sts
          for all_files_gz in `ls -C1 ${1}/daily_sts/rpt_*.gz 2>/dev/null`
          do
              echo "INFO: executing tar -xvf ${all_files_gz}"
              tar -xvf ${all_files_gz}
          done
          ls -C1 *.pipe 2>/dev/null > ${1}/sts_${2}_pipe.info
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
      sts_ct=$(ls -C1 ${1}/daily_sts/rpt_*.gz 2>/dev/null | wc -l)
      gz_file_list_ct=$(cat ${1}/sts_${2}_process.info 2>/dev/null | tr ' ' '\n' |  wc -l)
      echo "INFO: sts_ct ${sts_ct} gz_file_list_ct ${gz_file_list_ct}"
      echo "INFO: CALLING pull_gz_from_cloud"
      if [ ${sts_ct} -lt 1 ]; then
         pull_gz_from_cloud ${1} ${2}
      fi
      sts_ct=$(ls -C1 ${1}/daily_sts/rpt_*.gz 2>/dev/null | wc -l)
      gz_file_list_ct=$(cat ${1}/sts_${2}_process.info 2>/dev/null | tr ' ' '\n' |  wc -l)
      if [ "${sts_ct}" == "${gz_file_list_ct}" ]; then
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

PROCESS_ST_15 ()
{
  echo "INFO: FN-NAME PROCESS_ST_15"
  echo "INFO: TYPE ${1} dir ${2} ${3}."
  let my_process_num=16
      p1=${1:-NONE}
      p2=${2:-NONE}
      p3=${3:-NONE}
      sts_date=$(echo "${STORAGE_FOLDER_KEY1}")
      sts_date_as_num=$(echo "${sts_date}" | sed 's/-//g')
      date_as_num=$(echo "${2}" | sed 's/-//g')
      ###if [ "${date_as_num}" -gt "${sts_date_as_num}" ]; then
      ###      echo "INFO: Future_date. ${date_as_num}, ${sts_date_as_num}"
      ###      return 0
      ###fi
      sts_ct=$(echo "0")
  case  "${3}" in
  "sts")
           echo "INFO: DATE: ${2} and pulling or checking files"
           echo "INFO: SAME_DAY. check the current inventory"
           echo "INFO: collecting_gz files ${1}/daily_sts"
           mkdir -p ${1}/all_sts
           mkdir -p ${1}/daily_sts
           sts_ct=$(ls -C1 ${1}/daily_sts/rpt_*.gz 2>/dev/null | wc -l)
           sts_pipe_ct=$(ls -C1 ${1}/all_sts/*.pipe 2>/dev/null | wc -l)
           reportso_to_pull_sts=()
           info_process_file=$(ls -C1 ${1}/sts_${2}_process.info 2>/dev/null)
           info_process_file=${info_process_file:-NONE}
           info_pipe_file=$(ls -C1 ${1}/sts_${2}_pipe.info 2>/dev/null)
           info_pipe_file=${info_pipe_file:-NONE}
           echo "INFO: info_process_file ${info_process_file} and info_pipe_file ${info_pipe_file}"
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

