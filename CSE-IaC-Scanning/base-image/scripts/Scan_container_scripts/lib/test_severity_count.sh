#!/usr/bin/env sh


     summary_file_nm=${1:-NONE}

     if [ "${summary_file_nm}" == "NONE" ]; then
         echo "INFO: Usage $0 file_name. NO_FILE_NM. ERROR. Exit 100"
         exit 100
     fi
     declare -A RULE_CT_BY_SEVERITY_HASH

     RULES_SEVERITY_COUNT ()
{        
    echo "INFO: TYPE OPT-INDIRECT FN-NAME RULES_SEVERITY_COUNT"
       let ct=1
       let total_rules=0
       FN=${2:-6}
       #for all in `cat ${summary_file_nm} | awk -F "|" '{ OFS="|"; print $5;}' | sort | tr '\n' '|' | sed 's/CRITICAL|HIGH/CRITICAL\nHIGH/' | sed 's/HIGH|LOW/HIGH\nLOW/' | sed 's/LOW|MEDIUM/LOW\nMEDIUM/'| sed 's/MEDIUM|$/MEDIUM\n/'`
       #do
       #    SE=$(echo "${SEV}" | cut -d "," -f $ct)
       #    CCC=$(echo "${all}" | tr '|' '\n' | grep -e "$SE" | wc -l) 
       #    #echo "CT ${SE}:${CCC}"
       #    RULE_CT_BY_SEVERITY_HASH["${SE}"]="${CCC}"
       #    let ct=ct+1
       #    let total_rules=${total_rules}+${CCC}
       #done
       for all in `cat ${summary_file_nm} | awk -F "|" -v field=${FN} '{ OFS="|"; print $field;}' | sed 's/\"//g' |  sort | tr '\n' '|' |  sed 's/CRITICAL|HIGH/CRITICAL\nHIGH/' | sed 's/HIGH|LOW/HIGH\nLOW/' | sed 's/LOW|MEDIUM/LOW\nMEDIUM/'| sed 's/MEDIUM|$/MEDIUM\n/'`
       do
           echo "INFO: ${all}"
           REC=$(echo "${all}" | awk -F "|" '{ OFS="|"; print $1,NF;}')
           F1=$(echo "${REC}" | cut -d "|" -f 1)
           F2=$(echo "${REC}" | cut -d "|" -f 2)
           echo "INFO: ${REC} ${F1} ${F2}"
           RULE_CT_BY_SEVERITY_HASH["${F1}"]="${F2}"
           let total_rules=${total_rules}+${F2}
       done

          for all_sev in `echo "${!RULE_CT_BY_SEVERITY_HASH[@]}"`
          do
             get_ct=$(echo "${RULE_CT_BY_SEVERITY_HASH[${all_sev}]}")
             echo "INFO: TOTAL-SEVERITY ${all_sev} COUNT=${get_ct}"
          done
          echo "INFO: TOTAL-SEVERITY ALL COUNT=${total_rules}"
}

    RULES_SEVERITY_COUNT "${summary_file_nm}"
