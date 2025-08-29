
untar_csv_files ()
{

      echo "INFO: FN-NAME untar_csv_files"     
      echo "INFO: ZIP_FILE ${1} dir ${2}."
      p1=${1:-NONE}
      p2=${2:-NONE}
      if [[ "${p1}" == "NONE" ]]  &&  [[ "${p2}" == "NONE" ]]; then
          echo "INFO: NO_PARAMETERS_PASSED"
      else
          ar=$(tar -tvf ${p1} | sed 's/ //g' | cut -d "/" -f 3 | grep -v KICS | grep -v SNYK | grep -v scan |  tr '\n' ' ' | sed 's/ / \.\//g' | sed 's/\.\/$//')
          echo "INFO: Files to untar ${ar}"
          cd ${p2} # ${untar_dir}
          echo "INFO: executing cmd tar -zxvf ${p1} ./${ar}"
          tar -zxvf ${p1} `echo "./${ar}"`
          echo "INFO: csv files `ls -C1 *.csv`"
          cd -
      fi
}

#-rw-r--r-- root/root        53 2024-03-05 04:20 ./BUCKET_SCAN_CR_R-20240305-04_19_55-1709612395-102024-065-1709612395-featuressub-hcb-msde-2-ECS.bucket
#-rw-r--r-- root/root       581 2024-03-05 04:20 ./BUCKET_SCAN_R-20240305-04_19_55-1709612395-102024-065-1709612395-featuressub-hcb-msde-2-ECS.bucket
#-rw-r--r-- root/root       651 2024-03-05 04:20 ./BUCKET_SCAN_RR_ALL_R-20240305-04_19_55-1709612395-102024-065-1709612395-featuressub-hcb-msde-2-ECS.bucket
#-rw-r--r-- root/root       247 2024-03-05 04:20 ./BUCKET_SCAN_RR_DATE_R-20240305-04_19_55-1709612395-102024-065-1709612395-featuressub-hcb-msde-2-ECS.bucket
#-rw-r--r-- root/root       513 2024-03-05 04:20 ./BUCKET_SCAN_RR_R-20240305-04_19_55-1709612395-102024-065-1709612395-featuressub-hcb-msde-2-ECS.sh.bucket
#-rwxr-xr-x root/root      3872 2024-03-05 04:20 ./S10414_933_tfplan.kics_json.R-20240305-04_19_55-1709612395-102024-065-1709612395-featuressub-hcb-msde-2-ECS.bucket
#-rwxr-xr-x root/root      8052 2024-03-05 04:20 ./S10414_933_tfplan.kics_sarif.R-20240305-04_19_55-1709612395-102024-065-1709612395-featuressub-hcb-msde-2-ECS.bucket
#-rw-r--r-- root/root       162 2024-03-05 04:20 ./sh.BUCKET_SCAN_RR_R-20240305-04_19_55-1709612395-102024-065-1709612395-featuressub-hcb-msde-2-ECS.bucket


untar_buk_files ()
{

      echo "INFO: FN-NAME untar_buk_files"
      echo "INFO: ZIP_FILE ${1} dir ${2}."
      p1=${1:-NONE}
      p2=${2:-NONE}
      if [[ "${p1}" == "NONE" ]]  &&  [[ "${p2}" == "NONE" ]]; then
          echo "INFO: NO_PARAMETERS_PASSED"
      else
          echo "INFO: Executing CMD- tar -tvf ${p1}"
          tar -tvf ${p1}
          #ar=$(tar -tvf ${p1} | sed 's/ //g' | cut -d "/" -f 3 | grep -v KICS | grep -v SNYK | grep -v scan |  tr '\n' ' ' | sed 's/ / \.\//g' | sed 's/\.\/$//')
          ar=$(tar -tvf ${p1} | sed 's/ //g' | cut -d "/" -f 3  | tr '\n' ' ' | sed 's/ / \.\//g' | sed 's/\.\/$//')
          echo "INFO: Files to untar ${ar}"
          cd ${p2} # ${untar_dir}
          echo "INFO: executing cmd tar -zxvf ${p1} ./${ar}"
          tar -zxvf ${p1} `echo "./${ar}"`
          echo "INFO: csv files `ls -C1 *.bucket`"
          cd -
      fi
}

process_all_csv_rpt ()
{
      echo "INFO: FN-NAME process_all_csv_rpt"     
      echo "INFO: ZIP_FILE ${1} dir ${2}."
      p1=${1:-NONE}
      p2=${2:-NONE}
      if [[ "${p1}" == "NONE" ]]  &&  [[ "${p2}" == "NONE" ]]; then
          echo "INFO: NO_PARAMETERS_PASSED"
      else
           echo "INFO: Parameters passed ${p1} and ${p2}"
           files_found_rr=(`ls -C1 ${p1}/rr_*.csv 2>/dev/null`)
           files_found_cr=(`ls -C1 ${p1}/cr_*.csv 2>/dev/null`)
           files_found_sm=(`ls -C1 ${p1}/sm_*.csv 2>/dev/null`)
           echo "INFO: REPORT_FILE_TO_PROCESS_CT var_name=files_found_rr, value=${#files_found_rr[@]}"
           echo "INFO: REPORT_FILE_TO_PROCESS_CT var_name=files_found_cr, value=${#files_found_cr[@]}"
           echo "INFO: REPORT_FILE_TO_PROCESS_CT var_name=files_found_sm, value=${#files_found_sm[@]}"
      fi


}
