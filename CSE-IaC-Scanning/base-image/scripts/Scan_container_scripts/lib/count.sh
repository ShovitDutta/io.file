#!/usr/bin/env sh

    let total_rules=0
    declare -A RULE_CT_BY_SEVERITY_HASH 
    FN=$(echo "6")
       for states in `echo "LOW|MEDIUM|HIGH|CRITICAL" | tr '|' '\n'`
       do
           #echo "INFO: state ${states}"
           all=$(cat ${1} | sort -k 6 -t "|" | cut -d "|" -f 6 | sed 's/\"//g' | awk -F "|"  -v st="${states}" '{ OFS="|"; if ( $1 == st ) { print $1;}}' | tr '\n' '|' | sed 's/|$//')
           all=${all:-NONE}
           if [ "${all}" != "NONE" ]; then
              #echo "INFO: state ${states}  all ${all}"
              REC=$(echo "${all}" | awk -F "|" '{ OFS="|"; print $1,NF;}')
              F1=$(echo "${REC}" | cut -d "|" -f 1)
              F2=$(echo "${REC}" | cut -d "|" -f 2)
              #echo "INFO: ${REC} ${F1} ${F2}"
              RULE_CT_BY_SEVERITY_HASH["${F1}"]="${F2}"
              let total_rules=${total_rules}+${F2}
           else
              RULE_CT_BY_SEVERITY_HASH["${states}"]="0"
           fi
       done

       #for all_sev in `echo "${!RULE_CT_BY_SEVERITY_HASH[@]}"`
       #do
             #get_ct=$(echo "${RULE_CT_BY_SEVERITY_HASH[${all_sev}]}")
             #echo "INFO: TOTAL-SEVERITY ${all_sev} COUNT=${get_ct}"
       #done 
       echo "INFO: Total_rules_ct ${total_rules}"
       let total_severity_high_ct=$(echo "${RULE_CT_BY_SEVERITY_HASH['HIGH']}")
          total_severity_high_ct=${total_severity_high_ct:-0}
       let total_severity_medium_ct=$(echo "${RULE_CT_BY_SEVERITY_HASH['MEDIUM']}")
          total_severity_medium_ct=${total_severity_medium_ct:-0}
       let total_severity_critical_ct=$(echo "${RULE_CT_BY_SEVERITY_HASH['CRITICAL']}")
          total_severity_critical_ct=${total_severity_critical_ct:-0}
       let total_severity_low_ct=$(echo "${RULE_CT_BY_SEVERITY_HASH['LOW']}")
          total_severity_low_ct=${total_severity_low_ct:-0}
       let all_severity_ct=$(echo "${total_rules}")

     let rules_low_mi_hi_cri_ct=${total_severity_low_ct}+${total_severity_medium_ct}+${total_severity_high_ct}+${total_severity_critical_ct}

       echo "INFO: LOW-count ${total_severity_low_ct}"
       echo "INFO: MEDIUM-count ${total_severity_medium_ct}"
       echo "INFO: HIGH-count ${total_severity_hi_ct}"
       echo "INFO: CRITICAL-count ${total_severity_cri_ct}"
       echo "INFO: COMBO-LOW+MEDIUM+HIGH+CRITICAL ${rules_low_mi_hi_cri_ct}"


