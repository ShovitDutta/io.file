#!/usr/bin/env sh

     export PATH=${PATH}:/apps/bin:/apps/kics/bin:/apps/snyk/bin:/apps/opa/bin:/apps/gcp/google-cloud-sdk/bin:/apps/hc/tf:/apps/hc/vault:/apps/hc/consul:/apps/hc/bin
     echo "INFO: Running $0 script"


check_cloud_obj_srv ()
{
    /apps/bin/gcp_srv_acct_stp.sh 1>>/tmp/gcp_login.std01 2>>/tmp/gcp_login.std02

   cat /tmp/gcp_login.std01
   cat /tmp/gcp_login.std02

   rm -rf /tmp/gcp_login.std01 /tmp/gcp_login.std02
}


#for all in `cat ${tfplan_file} | jq  '[paths(type == "object")|join(".") ]' | sed -e 's/\.\([0-9]\+\)/\[\1\]/g' | sed 's/\"/\./' | sed 's/\"//g'`; do echo ${all} ; done

#kics_terraform_rules.info  snyk_rule_rulenm_service_severity_category_desc.info
     synk_file_info=$(ls -C1 /apps/lib/snyk_rule_rulenm_service_severity_category_desc.info)
     kics_file_info=$(ls -C1 /apps/lib/kics_terraform_rules.info)

     declare -A snyk_rules_list_hash
     declare -A kics_rules_list_hash

     snyk_inventory_sc=$(echo "/apps/lib/snyk_inventory_info.sh")
     kics_inventory_sc=$(echo "/apps/lib/kics_inventory_info.sh")
     snyk_kics_inventory_sc=$(echo "/apps/lib/snyk_kics_inventory_info.sh")

     echo "#!/usr/bin/env sh" > ${snyk_inventory_sc}
     echo -e  "\n" >> ${snyk_inventory_sc}
     echo "#snyk Rules hash Start" >> ${snyk_inventory_sc}       
     echo "      declare -A snyk_rules_list_hash" >> ${snyk_inventory_sc}
     echo -e  "\n" >> ${snyk_inventory_sc}

     for all_snyk_rules in `cat "${synk_file_info}" | grep -v "^#" |  cut -d "|" -f 1`
     do
            #echo "${all_snyk_rules}"
            snyk_rules_list_hash[${all_snyk_rules}]="${all_snyk_rules}"
            echo "         snyk_rules_list_hash[\"${all_snyk_rules}\"]=\"${all_snyk_rules}\""

     done >> ${snyk_inventory_sc}

     echo -e  "\n" >> ${snyk_inventory_sc}
     echo "#snyk Rules hash End" >> ${snyk_inventory_sc}       

 
     echo "#!/usr/bin/env sh" > ${kics_inventory_sc}
     echo -e  "\n" >> ${kics_inventory_sc}
     echo "#kics Rules hash Start" >> ${kics_inventory_sc}       
     echo "      declare -A kics_rules_list_hash" >> ${kics_inventory_sc}
     echo -e  "\n" >> ${kics_inventory_sc}

     for all_kics_rules in `cat "${kics_file_info}" | grep -v "^#" |  cut -d "|" -f 1`
     do
            #echo "${all_kics_rules}"
            #all_kics_rules=$(echo "${all_kics_rules}" | sed 's/\"//g')
            echo "         kics_rules_list_hash[${all_kics_rules}]=${all_kics_rules}"
     done >> ${kics_inventory_sc}

     echo -e  "\n" >> ${kics_inventory_sc}
     echo "#kics Rules hash End" >> ${kics_inventory_sc}       


     echo "#snyk Rules Inv hash Start" >> ${snyk_inventory_sc}       
     echo "      declare -A snyk_rules_inv_list_hash" >> ${snyk_inventory_sc}
     echo -e  "\n" >> ${snyk_inventory_sc}
     for all_snyk_rules in `cat "${synk_file_info}" | grep -v "^#" | sed 's/ /_/g'`
     do
            rul_as_key=(`echo "${all_snyk_rules}" | cut -d "|" -f 1`)
            #snyk_rules_list_hash[${all_snyk_rules}]="${all_snyk_rules}"
            echo "         snyk_rules_inv_list_hash[\"${rul_as_key}\"]='${all_snyk_rules}'"
     done >> ${snyk_inventory_sc}
     echo -e  "\n" >> ${snyk_inventory_sc}
     echo "#snyk Rules Inv hash End" >> ${snyk_inventory_sc}       

     echo "      declare -A kics_rules_inv_list_hash" >> ${kics_inventory_sc}
     echo -e  "\n" >> ${kics_inventory_sc}
     echo "#kics Rules Inv  hash Start" >> ${kics_inventory_sc}       
     for all_kics_rules in `cat "${kics_file_info}" | grep -v "^#" | sed 's/ /_/g'`
     do
            rule_as_key=(`echo "${all_kics_rules}" | cut -d "|" -f 1`)
            #all_kics_rules=$(echo "${all_kics_rules}" | sed 's/\"//g')
            #kics_rules_inv_list_hash[${all_kics_rules}]="${all_kics_rules}"
            echo "         kics_rules_inv_list_hash[${rule_as_key}]='${all_kics_rules}'"
     done >> ${kics_inventory_sc}
     echo -e  "\n" >> ${kics_inventory_sc}
     echo "#kics Rules Inv  hash End" >> ${kics_inventory_sc}       

#new_file    
     echo "#!/usr/bin/env sh" > ${snyk_kics_inventory_sc}
     echo -e  "\n" >> ${snyk_kics_inventory_sc}
     echo "#kics Rules hash Start" >> ${snyk_kics_inventory_sc}       

     echo "      declare -A snyk_kics_rules_list_hash" >> ${snyk_kics_inventory_sc}
     for all_snyk_rules in `cat "${synk_file_info}" | grep -v "^#" |  cut -d "|" -f 1`
     do
         echo "         snyk_kics_rules_list_hash[\"${all_snyk_rules}\"]=\"${all_snyk_rules}\""
     done >> ${snyk_kics_inventory_sc}

     for all_kics_rules in `cat "${kics_file_info}" | grep -v "^#" |  cut -d "|" -f 1`
     do
         echo "         snyk_kics_rules_list_hash[${all_kics_rules}]=${all_kics_rules}"
     done >> ${snyk_kics_inventory_sc}

     echo "      declare -A snyk_kics_rules_inv_list_hash" >> ${snyk_kics_inventory_sc}
     for all_snyk_rules in `cat "${synk_file_info}" | grep -v "^#" | sed 's/ /_/g'`
     do
            rul_as_key=(`echo "${all_snyk_rules}" | cut -d "|" -f 1`)
            #snyk_rules_list_hash[${all_snyk_rules}]="${all_snyk_rules}"
            echo "         snyk_kics_rules_inv_list_hash[\"${rul_as_key}\"]='${all_snyk_rules}'"
     done >> ${snyk_kics_inventory_sc}

     for all_kics_rules in `cat "${kics_file_info}" | grep -v "^#" | sed 's/ /_/g'`
     do
            rule_as_key=(`echo "${all_kics_rules}" | cut -d "|" -f 1`)
            #all_kics_rules=$(echo "${all_kics_rules}" | sed 's/\"//g')
            #kics_rules_inv_list_hash[${all_kics_rules}]="${all_kics_rules}"
            echo "         snyk_kics_rules_inv_list_hash[${rule_as_key}]='${all_kics_rules}'"
     done >> ${snyk_kics_inventory_sc}
