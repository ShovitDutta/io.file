#p1_hash[ST_63]="tfp" 
#p2_hash[ST_63]="${DATE}"
#p3_hash[ST_63]="tfp"
#p4_hash[ST_63]="${FORCE_REPROCESS}"



PROCESS_ST_63 ()
{
  echo "INFO: FN-NAME PROCESS_ST_63"
  echo "INFO: ${1},${2},${3}"
  let my_process_num=64
      p1=${1:-NONE}
      p2=${2:-NONE}
      p3=${3:-NONE}
      p4=${4:-Y}
      p5=${5:-Y}
      if [[ "${p1}" == "NONE" ]]  &&  [[ "${p2}" == "NONE" ]] && [[ "${p3}" == "NONE" ]] ; then
          echo "INFO: NO_PARAMETERS_PASSED"
          exit 100
      else
         :
      fi
      echo "INFO: CALLING /apps/bin/process_tfp_acctid_appid.sh ${p2} ${p4}"
      /apps/bin/process_tfp_acctid_appid.sh ${p2}
      #/apps/bin/process_sts_files_metadata.sh ${p2} ${p4} ${p5}
}
