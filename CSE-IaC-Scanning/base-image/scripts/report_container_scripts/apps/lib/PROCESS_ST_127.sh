#p1_hash[ST_127]="${DATE}"
#p2_hash[ST_127]="${LOAD_OPT1}"
#p3_hash[ST_127]="${LOAD_OPT2}"
#p4_hash[ST_127]="${FORCE_REPROCESS}"
 
PROCESS_ST_127 ()
{            
  echo "INFO: FN-NAME PROCESS_ST_127"
  echo "INFO: ${1},${2},${3}"
  let my_process_num=128
      p1=${1:-NONE}
      p2=${2:-N}
      p3=${3:-N}
      p4=${4:-Y}
      p5=${5:-Y}
      if [[ "${p1}" == "NONE" ]]  &&  [[ "${p2}" == "NONE" ]] && [[ "${p3}" == "NONE" ]] ; then
          echo "INFO: NO_PARAMETERS_PASSED"
          exit 100
      else   
         :   
      fi
      #process_sts_files_metadata.sh
      echo "INFO: CALLING-/apps/bin/process_sts_files_metadata.sh ${p1} ${p2} ${p3} ${p4}"
      /apps/bin/process_sts_files_metadata.sh ${p1} ${p2} ${p3} N
}            
