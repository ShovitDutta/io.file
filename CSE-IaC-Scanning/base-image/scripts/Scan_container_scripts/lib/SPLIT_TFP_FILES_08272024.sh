
#tfp_key_items_collection_hash -Variables_Start

    declare -A tfp_pv_info_hash
    declare -A tfp_info_hash
    tfp_pv_info_hash["tfp_pv_obj"]="tfp_pv_obj"
    tfp_pv_info_hash["tfp_pv"]="tfp_pv"
    tfp_pv_info_hash["tfp_tag"]="tfp_tag"
    tfp_pv_info_hash["tfp_pv_srp"]="tfp_pv_srp"
    declare -A tfp_pv_tag_info_hash
    declare -A tfp_ps_tag_info_hash
    declare -A tfp_rc_tag_info_hash
    declare -A tfp_pc_rcp_info_hash
    declare -A tfp_pc_rcm_info_hash
    ll_tfp=$(echo "ll_tfp")


#tfp_key_items_collection_hash -Variables_End

final_result_of_tfp_info ()
{
    echo "INFO: FUNCTION_NAME final_result_of_tfp_info"
    #echo "INFO_DEBUG: p1=${1}, p2=${2}, p3=${3}, p4=${4} - Start"
    #echo "INFO_DEBUG: p1=${1} tfp_file, p2=${2} tfp_signature, p3=${3} directory, p4=${4} cloud - Start"
    tfp_root_key=$(echo "${2}_${4}")

    processed_keys=$(echo "${tfp_info_hash[${tfp_root_key}]}")
    
             echo "INFO: processed_keys ${processed_keys}"
#processed_keys S11986_26_gcp|tfp_pv_srp|tfp_pc_rcp
             for all_keys in `echo "${processed_keys}" | cut -d "|" -f2- | tr '|' '\n'`
             do
               echo "INFO: Calling_function ${all_keys} ${tfp_root_key}"
             done 
    read SSSSS
}

process_azure_cloud_tfp_file ()
{
    ECHO "INFO: FUNCTION_NAME process_azure_cloud_tfp_file"
    #echo "INFO_DEBUG: p1=${1}, p2=${2}, p3=${3}, p4=${4} - Start"
    tfp_root_key=$(echo "${2}_${4}")
    ll_tfp=$(echo "${tfp_root_key}")
    #get_cloud_from_tfp. configuration.provider_config (pd=Plan_file_clouD)
    #tfp_pd=$(cat ${1} | jq -Mr '.configuration.provider_config|keys|sort| .[0] | select( . == "azure" )|select (. != null)')
    tfp_pd=$(echo "tfp_pd")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_pd}]}")
    if [ "${tfp_get_key}" == "tfp_pd" ]; then
                tfp_pd=$(cat ${1} | jq -Mr '.configuration.provider_config|keys|sort|unique|.[0]| select( .|contains("azure"))|select (. != null)')
                tfp_pd=${tfp_pd:-NONE}
                if [ "${tfp_pd}" == "NONE" ]; then
                     echo "INFO: PROVIDER_FROM_TFP_FILE_UNKNOWN"
                     tfp_pd=$(echo "$4")
                else
                     tfp_pd=$(echo "azure")
                fi
    fi

    #get_resources_properties_list. planned_values (pv=plan_file_Planned_Values)
    tfp_pv=$(echo "tfp_pv")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_pv}]}")
    if [ "${tfp_get_key}" == "tfp_pv" ]; then
                tfp_pvc=$(cat ${1} | jq '.planned_values.root_module|keys|.[]|.|contains("child_modules")')
                tfp_pvc=${tfp_pvc:-tfp_pvc}
                tfp_pvr=$(cat ${1} | jq '.planned_values.root_module|keys|.[]|.|contains("resources")')
                tfp_pvr=${tfp_pvr:-tfp_pvr}

                if [ "${tfp_pvc}" == "true" ]; then
                   tfp_pv=$(cat ${1} | jq  '.planned_values|.root_module.child_modules[]?.resources')
                fi

                if [ "${tfp_pvr}" == "true" ]; then
                   tfp_pv=$(cat ${1} | jq  '.planned_values|.root_module.resources')
                fi
                tfp_pv=${tfp_pv:-NONE}
    fi

    #get_resource_changes_data. resource_changes (rc=plan_file_Resource_Changes: alsp=already set properties, tbsp=to be set properties)
    tfp_rc=$(echo "tfp_rc")
    tfp_rc_tbsp=$(echo "tfp_rc_tbsp")
    tfp_rc_alsp=$(echo "tfp_rc_alsp")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_rc}]}")
    if [ "${tfp_get_key}" == "tfp_rc" ]; then
                tfp_rc_tbsp=$(cat ${1} | jq  '[.resource_changes?|.[]|{ "service_reource":.type,"service_name":.name, "ops_to_be_performed":.change.actions, "properties_to_be_set":.change.after, "tags_to_be_set": .change.after.tags}]')
                tfp_rc_tbsp=${tfp_rc_tbsp:-tfp_rc_tbsp}

                tfp_rc_alsp=$(cat ${1} | jq  '[.resource_changes?|.[]|{ "service_reource":.type,"service_name":.name, "ops_already_performed":.change.actions, "properties_already_set":.change.before, "tags_already_set": .change.before.tags}]')
                tfp_rc_alsp=${tfp_rc_alsp:-tfp_rc_alsp}
    fi

    #get_prior_state. prior_state (ps=plan_Prior_State)
    tfp_ps=$(echo "tfp_ps")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_ps}]}")
    if [ "${tfp_get_key}" == "tfp_ps" ]; then
                tfp_ps=$(cat ${1} | jq  '.prior_state?|.values?|select( . != null)|.root_module.child_modules[]?|[.resources[]]|[.[]|{ "service_reource":.type,"service_name":.name,  "properties_to_be_set":.values, "tags_to_be_set": .values.tags}]|sort|unique')
                tfp_ps=${tfp_ps:-tfp_ps}
    fi

    #get_configuration_data. configuration.provider_config (pc=Plan_file_Configuration:  rcp=Resources_from_Cloud_Provider, rcm=Resources_from_Custom_Modules)
    tfp_pc=$(echo "tfp_pc")
    tfp_pc_rcp=$(echo "tfp_pc_rcp")
    tfp_pc_rcm=$(echo "tfp_pc_rcm")
    let tfp_pc_rcp_ct=0
    let tfp_pc_rcm_ct=0
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_pc}]}")
    if [ "${tfp_get_key}" == "tfp_pc" ]; then
                tfp_pc_rcp_ct=$(cat ${1} | jq '.configuration.provider_config|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name == "azure" )'  | sed 's/^\}/\}\,/' | grep "^\}\,$" | wc -l)

                tfp_pc_rcp=$(cat ${1} | jq '.configuration.provider_config|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name == "azure" )'  | sed 's/^\}/\}\,/' | tr '\n' ' ' | sed 's/ //g' | sed 's/\}\,$/\}\n/' | sed 's/^/\[/' | sed 's/$/\]/'  | sed "s/{\"service_resources\"/\n{\"service_resources\"/g"   | jq '.')
                tfp_pc_rcp=${tfp_pc_rcp:-tfp_pc_rcp}

                tfp_pc_rcm_ct=$(cat ${1} | jq '.configuration.provider_config|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name != "azure" )'  | sed 's/^\}/\}\,/' | grep "^\}\,$" | wc -l)

                tfp_pc_rcm=$(cat ${1} | jq '.configuration.provider_config|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name != "azure" )'  | sed 's/^\}/\}\,/' | tr '\n' ' ' | sed 's/ //g' | sed 's/\}\,$/\}\n/' | sed 's/^/\[/' | sed 's/$/\]/'  | sed "s/{\"service_resources\"/\n{\"service_resources\"/g"   | jq '.')
                tfp_pc_rcm=${tfp_pc_rcm:-tfp_pc_rcm}
    fi

    #get_drift_data. resource_drift (rd=Plan_file_Resource_Drift)
    tfp_rd=$(echo "tfp_rd")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_rd}]}")
    if [ "${tfp_get_key}" == "tfp_rd" ]; then
                tfp_rd=$(cat ${1} | jq '.resource_drift|select( . != null)|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name != "azure" )' | sed 's/^\}/\}\,/' | tr '\n' ' ' | sed 's/ //g' | sed 's/\}\,$/\}\n/' | sed 's/^/\[/' | sed 's/$/\]/'  | sed "s/{\"service_resources\"/\n{\"service_resources\"/g"   | jq '.|{ "total_resources_deployed":length,"resource_list":.}')
                tfp_rd=${tfp_rd:-tfp_rd}
    fi

    #get_checks_made_on_resources_data_and_instances. checks (rk=plan_file_Resource_Checks)
    tfp_rk=$(echo "tfp_rk")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_rk}]}")
    if [ "${tfp_get_key}" == "tfp_rk" ]; then
                tfp_rk=$(cat ${1} | jq '.|.checks|select( . != null)| values| sort|[ .[]|{ "tf_deployment_type":.address.kind,"tf_deployment_keys":.address|keys, "tf_deployment_resource_type": .address|values,"tf_status":.status  ,"tf_instances_of_type_deployed":.instances}]')
                tfp_rk=${tfp_rk:-tfp_rk}
    fi


    #All_Processing_Done
    #push into hash = tfp_key_based_obj_hash
    #tfp_keys_type_sym_rel_hash
    get_tag_for_this_tfp_from_pv=$(echo "tfp_pv_tag")
    get_services_resources_properties_of_this_plan=$(echo "tfp_pv_srp")
    if [ "${tfp_pv}" == "tfp_pv" ]; then
         ECHO "INFO: File ${1} has no Planned_Values. Deployment could be to correct DRIFT(or Shecdular job, timer or Virtual Resource, Soft deployment"

         if [ "${tfp_rd}" != "tfp_rd" ]; then
            ECHO "INFO: File ${1} has no Planned_Values, but DRIFT found. Deployment O.K. Any Rules Violated or NON-COMPLIANCE subject_to_discussion. DRIFT_FOUND"
         else
            ECHO "INFO: File ${1} has no Planned_Values and no Drift. Deployment OK if Instance Counts Increase/Decrease. Any Rules Violated or NON-COMPLIANCE subject_to_discussion. SOFT_DEPLOYMENT "
         fi
    else
         ECHO "INFO: File ${1} has Planned_Values, Any Rules Violated or NON-COMPLIANCE_ACTION: SCAN"

         echo "${tfp_pv}" | jq '.|.[]|[ { "service_reource":.type,"service_name":.name, "properties_already_set":.values, "tags_already_set":.values.tags}]' > ${3}/${2}_${4}_tfp_pv.json

         get_tag_for_this_tfp_from_pv=$(cat ${3}/${2}_${4}_tfp_pv.json 2>/dev/null | jq '.[]|.tags_already_set|select(.!=null)|values|select(.applicationname)' |grep -v "^\{\}$" | tr '\n' ' ' | sed 's/ //g' | sed "s/}{/},{/g" | sed 's/$/\n/' | sed 's/^/[/' | sed 's/$/]/' | sed "s/},{/},\n{/g"  | jq '.|sort'| grep -v createdondate | jq '.|sort|unique|values|select(.[].applicationname)|.[]' 2>/dev/null | jq -n 'input' 2>/dev/null)

         get_tag_for_this_tfp_from_pv=${get_tag_for_this_tfp_from_pv:-tfp_pv_tag}

         cat ${3}/${2}_${4}_tfp_pv.json | jq '.|.[]|{"srv":.service_reource,"srv_name":.service_name,"properties":.properties_already_set|keys|join("|"),"values":.properties_already_set}' | jq -n -s '.|{tf:[input]}|.tf[]|[{"total_resources":length,"tf":values}]' > ${3}/${2}_${4}_tfp_pv_srp.json
         tfp_pv_info_hash["${2}_${4}_tfp_pv_srp"]=$(cat ${3}/${2}_${4}_tfp_pv_srp.json)

         ll_tfp=$(echo "${ll_tfp}|tfp_pv_srp")
    fi

    if [ "${get_tag_for_this_tfp_from_pv}" != "tfp_pv_tag" ]; then
          echo "${get_tag_for_this_tfp_from_pv}" >  ${3}/${2}_${4}_tfp_pv_tag.json
          tfp_pv_tag_info_hash[${2}_${4}_tfp_pv_tag_key]=$(echo "${get_tag_for_this_tfp_from_pv}" | jq '.|keys|join("|")')
          tfp_pv_tag_info_hash[${2}_${4}_tfp_pv_tag_value]=$(echo "${get_tag_for_this_tfp_from_pv}" | jq -Mr '.|[.[]]|join("|")')
          ll_tfp=$(echo "${2}_${4}|tfp_pv_tag")
    else
          echo "INFO: get_tag_for_this_tfp_from_pv ${get_tag_for_this_tfp_from_pv}"
    fi

    get_tag_for_this_tfp_from_rc_tbsp=$(echo "tfp_rc_tbsp_tag")
    if [ "${tfp_rc_tbsp}" == "tfp_rc_tbsp" ]; then
        ECHO "INFO: File ${1} has no Resource_Changes."
    else
        ECHO "INFO: File ${1} has Resource_Changes. Resources/Properties set/to_be_set_will_be_collected. Any Rules Violated or NON-COMPLIANCE_ACTION: ABEND/NOABEND_WITH_EXCEPTION"
        echo "${tfp_rc_tbsp}" | jq '.' > ${3}/${2}_${4}_tfp_rc_tbsp.json
        #get_tag_for_this_tfp_from_rc_tbsp=$(cat ${3}/${2}_${4}_tfp_rc_tbsp.json |  jq '.[]|.tags_to_be_set|select(.!=null)'| jq -n '[input]' 2>/dev/null | jq '.[0]' 2>/dev/null)
        get_tag_for_this_tfp_from_rc_tbsp=$(cat ${3}/${2}_${4}_tfp_rc_tbsp.json  2>/dev/null |  jq '.[]|.tags_to_be_set|select(.!=null)|values|select(.applicationname)'|  grep -v "^\{\}$" | tr '\n' ' ' | sed 's/ //g' | sed "s/}{/},{/g" | sed 's/$/\n/' | sed 's/^/[/' | sed 's/$/]/' | sed "s/},{/},\n{/g"  | jq '.|sort'| grep -v createdondate | jq '.|unique|sort|values|select(.[].applicationname)|.[]' 2>/dev/null | jq -n 'input' 2>/dev/null)

        get_tag_for_this_tfp_from_rc_tbsp=${get_tag_for_this_tfp_from_rc_tbsp:-tfp_rc_tbsp_tag}
    fi

    if [ "${get_tag_for_this_tfp_from_rc_tbsp}" != "tfp_rc_tbsp_tag" ]; then
          echo "{get_tag_for_this_tfp_from_rc_tbsp}" > ${3}/${2}_${4}_tfp_rc_tbsp_tag.json
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_tbsp_tag_key]=$(echo "${get_tag_for_this_tfp_from_rc_tbsp}" | jq '.|keys|join("|")')
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_tbsp_tag_value]=$(echo "${get_tag_for_this_tfp_from_rc_tbsp}" | jq -Mr '.|[.[]]|join("|")')
          ll_tfp=$(echo "${ll_tfp}|tfp_rc_tbsp_tag")
    else
          echo "INFO: get_tag_for_this_tfp_from_rc_tbsp ${get_tag_for_this_tfp_from_rc_tbsp}"

    fi

    get_tag_for_this_tfp_from_rc_alsp=$(echo "tfp_rc_alsp_tag")
    if [ "${tfp_rc_alsp}" == "tfp_rc_alsp" ]; then
        ECHO "INFO: File ${1} has no Resource_Changes."
    else
        ECHO "INFO: File ${1} has Resource_Changes. Resources/Properties set. Any Rules Violated or NON-COMPLIANCE_ACTION: PASS"
        echo "${tfp_rc_alsp}" | jq '.' > ${3}/${2}_${4}_tfp_rc_alsp.json
        #get_tag_for_this_tfp_from_rc_alsp=$(cat ${3}/${2}_${4}_tfp_rc_alsp.json |  jq '.[]|.tags_already_set|select(.!=null)'| jq -n '[input]' 2>/dev/null| jq '.[0]' 2>/dev/null)
        get_tag_for_this_tfp_from_rc_alsp=$(cat ${3}/${2}_${4}_tfp_rc_alsp.json 2>/dev/null | jq '.[]|.tags_already_set|select(.!=null)|values|select(.applicationname)'| grep -v "^\{\}$" | tr '\n' ' ' | sed 's/ //g' | sed "s/}{/},{/g" | sed 's/$/\n/' | sed 's/^/[/' | sed 's/$/]/' | sed "s/},{/},\n{/g"  | jq '.|sort'| grep -v createdondate | jq '.|unique|sort|values|select(.[].applicationname)|.[]' 2>/dev/null | jq -n 'input' 2>/dev/null)

        get_tag_for_this_tfp_from_rc_alsp=${get_tag_for_this_tfp_from_rc_alsp:-tfp_rc_alsp_tag}
    fi

    if [ "${get_tag_for_this_tfp_from_rc_alsp}" != "tfp_rc_alsp_tag" ]; then
          echo "${get_tag_for_this_tfp_from_rc_alsp}" >  ${3}/${2}_${4}_tfp_rc_alsp_tag.json
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_alsp_tag_key]=$(echo "${get_tag_for_this_tfp_from_rc_alsp}" | jq '.|keys|join("|")')
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_alsp_tag_value]=$(echo "${get_tag_for_this_tfp_from_rc_alsp}" | jq -Mr '.|[.[]]|join("|")')
          ll_tfp=$(echo "${ll_tfp}|tfp_rc_alsp_tag")
    else
          echo "INFO: get_tag_for_this_tfp_from_rc_alsp ${get_tag_for_this_tfp_from_rc_alsp}"
    fi

    get_tag_for_this_tfp_from_ps=$(echo "tfp_ps_tag")
    if [ "${tfp_ps}" == "tfp_ps" ]; then
        ECHO "INFO: File ${1} has no Prior_State. Resources/Properties set. Any Rules Violated or NON-COMPLIANCE_ACTION: SCAN, DEPLOYMENT_TYPE: NEW"
    else
        ECHO "INFO: File ${1} has Prior_State. Resources/Properties set. Any Rules Violated or NON-COMPLIANCE_ACTION: SCAN, DEPLOYMENT_TYPE: update,delete,no-ops"
        echo "${tfp_ps}" | jq '.' >  ${3}/${2}_${4}_tfp_ps.json
        #get_tag_for_this_tfp_from_ps=$(cat ${3}/${2}_${4}_tfp_ps.json 2>/dev/null  | jq '.[]|.tags_to_be_set|select(.!=null)' | jq -n '[input]' | jq '.|select(.!=null)' | jq '.[0]')
        get_tag_for_this_tfp_from_ps=$(cat ${3}/${2}_${4}_tfp_ps.json 2>/dev/null | jq '.[]|.tags_to_be_set|select(.!=null)|values|select(.applicationname)' | grep -v "^\{\}$" | tr '\n' ' ' | sed 's/ //g' | sed "s/}{/},{/g" | sed 's/$/\n/' | sed 's/^/[/' | sed 's/$/]/' | sed "s/},{/},\n{/g"  | jq '.|sort'| grep -v createdondate | jq '.|unique|sort|values|select(.[].applicationname)|.[]' 2>/dev/null | jq -n 'input' 2>/dev/null)

        get_tag_for_this_tfp_from_ps=${get_tag_for_this_tfp_from_ps:-tfp_ps_tag}
    fi

    if [ "${get_tag_for_this_tfp_from_ps}" != "tfp_ps_tag" ]; then
          echo "${get_tag_for_this_tfp_from_ps}" > ${3}/${2}_${4}_tfp_ps_tag.json
          tfp_ps_tag_info_hash[${2}_${4}_tfp_ps_tag_key]=$(echo "${get_tag_for_this_tfp_from_ps}" | jq '.|keys|join("|")')
          tfp_ps_tag_info_hash[${2}_${4}_tfp_ps_tag_value]=$(echo "${get_tag_for_this_tfp_from_ps}" | jq -Mr '.|[.[]]|join("|")')
          ll_tfp=$(echo "${ll_tfp}|tfp_ps_tag")
    else
          echo "INFO: get_tag_for_this_tfp_from_ps ${get_tag_for_this_tfp_from_ps}"
    fi

    if [ "${tfp_pc_rcp}" == "tfp_pc_rcp" ]; then
        ECHO "INFO: File ${1} has no Configuration_Data. No Cloud_Resources_Used. Soft Deployment or Virtual_Devices: Ramdom_Number_generator,Time .. etc."
    else
        ECHO "INFO: File ${1} has Configuration_Data. Cloud Resources/Properties set. Any Rules Violated or NON-COMPLIANCE_ACTION: SCAN"
        echo "${tfp_pc_rcp}" | jq '.' | sed "s/^\[/\[\n \{ \"total_services\": $tfp_pc_rcp_ct\}\,/" > ${3}/${2}_${4}_tfp_pc_rcp.json
        tfp_pc_rcp_info_hash[${2}_${4}_tfp_pc_rcp]=$(cat ${3}/${2}_${4}_tfp_pc_rcp.json)
        ll_tfp=$(echo "${ll_tfp}|tfp_pc_rcp")
    fi

    if [ "${tfp_pc_rcm}" == "tfp_pc_rcm" ]; then
        ECHO "INFO: File ${1} has no Configuration_Data. Custom Module"
    else
        ECHO "INFO: File ${1} has Configuration_Data. Custom Module Resources/Properties set. Any Rules Violated or NON-COMPLIANCE_ACTION: SCAN"
        echo "${tfp_pc_rcm}" | jq '.' | sed "s/^\[/\[\n \{ \"total_services\": $tfp_pc_rcm_ct\}\,/" > ${3}/${2}_${4}_tfp_pc_rcm.json
        tfp_pc_rcm_info_hash[${2}_${4}_tfp_pc_rcm]=$(cat ${3}/${2}_${4}_tfp_pc_rcm.json)
        ll_tfp=$(echo "${ll_tfp}|tfp_pc_rcm")
    fi

    if [ "${tfp_rk}" == "tfp_rk" ]; then
       ECHO "INFO: File ${1} has no Checks_performed_On_resources_And_Instances."
    else
       ECHO "INFO: File ${1} has Checks_performed_On_resources_And_Instances. NO_RULES_INVOLVED_INFORMATION_PURPOSE_ONLY"
        echo "${tfp_rk}" | jq '.' > ${3}/${2}_${4}_tfp_rk.json
    fi

    echo "INFO_DEBUG: p1=${1}, p2=${2}, p3=${3}, p4=${4} - Done"
    tfp_info_hash[${tfp_root_key}]="${ll_tfp}"
}

process_gcp_cloud_tfp_file ()
{
    ECHO "INFO: FUNCTION_NAME process_gcp_cloud_tfp_file"
    echo "INFO_DEBUG: p1=${1}, p2=${2}, p3=${3}, p4=${4} - Start"
    tfp_root_key=$(echo "${2}_${4}")
    ll_tfp=$(echo "${tfp_root_key}")

    #get_cloud_from_tfp. configuration.provider_config (pd=Plan_file_clouD)
    tfp_pd=$(echo "tfp_pd")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_pd}]}")
    if [ "${tfp_get_key}" == "tfp_pd" ]; then
           tfp_pd=$(cat ${1} | jq -Mr '.configuration.provider_config|keys|sort|unique|.[0]| select( .|contains("google"))|select (. != null)')
           tfp_pd=${tfp_pd:-NONE}
           if [ "${tfp_pd}" == "NONE" ]; then
                echo "INFO: PROVIDER_FROM_TFP_FILE_UNKNOWN"
                tfp_pd=$(echo "${2}")
           else
                tfp_pd=$(echo "gcp")
           fi
    fi

    #get_resources_properties_list. planned_values (pv=plan_file_Planned_Values)
    tfp_pv=$(echo "tfp_pv")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_pv}]}")
    if [ "${tfp_get_key}" == "tfp_pv" ]; then
          tfp_pvc=$(cat ${1} | jq '.planned_values.root_module|keys|.[]|.|contains("child_modules")')
          tfp_pvc=${tfp_pvc:-tfp_pvc}
          tfp_pvr=$(cat ${1} | jq '.planned_values.root_module|keys|.[]|.|contains("resources")')
          tfp_pvr=${tfp_pvr:-tfp_pvr}

          if [ "${tfp_pvc}" == "true" ]; then
             tfp_pv=$(cat ${1} | jq  '.planned_values|.root_module.child_modules[]?.resources')
          fi

          if [ "${tfp_pvr}" == "true" ]; then
             tfp_pv=$(cat ${1} | jq  '.planned_values|.root_module.resources')
          fi
    fi

    #get_resource_changes_data. resource_changes (rc=plan_file_Resource_Changes: alsp=already set properties, tbsp=to be set properties)
    tfp_rc=$(echo "tfp_rc")
    tfp_rc_tbsp=$(echo "tfp_rc_tbsp")
    tfp_rc_alsp=$(echo "tfp_rc_alsp")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_rc}]}")
    if [ "${tfp_get_key}" == "tfp_rc" ]; then
         tfp_rc_tbsp=$(cat ${1} | jq  '[.resource_changes?|.[]|{ "service_reource":.type,"service_name":.name, "ops_to_be_performed":.change.actions, "properties_to_be_set":.change.after, "tags_to_be_set": .change.after.labels}]')
         tfp_rc_tbsp=${tfp_rc_tbsp:-tfp_rc_tbsp}

         tfp_rc_alsp=$(cat ${1} | jq  '[.resource_changes?|.[]|{ "service_reource":.type,"service_name":.name, "ops_already_performed":.change.actions, "properties_already_set":.change.before, "tags_already_set": .change.before.labels}]')
         tfp_rc_alsp=${tfp_rc_alsp:-tfp_rc_alsp}
    fi

    #get_prior_state. prior_state (ps=plan_Prior_State)
    tfp_ps=$(echo "tfp_ps")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_ps}]}")
    if [ "${tfp_get_key}" == "tfp_ps" ]; then
         tfp_ps=$(cat ${1} | jq  '.prior_state?|.values?|select( . != null)|.root_module.child_modules[]?|[.resources[]]|[.[]|{ "service_reource":.type,"service_name":.name,  "properties_to_be_set":.values, "tags_to_be_set": .values.labels}]|sort|unique')
         tfp_ps=${tfp_ps:-tfp_ps}
    fi

    #get_configuration_data. configuration.provider_config (pc=Plan_file_Configuration:  rcp=Resources_from_Cloud_Provider, rcm=Resources_from_Custom_Modules) 
    tfp_pc=$(echo "tfp_pc")
    tfp_pc_rcp=$(echo "tfp_pc_rcp")
    tfp_pc_rcm=$(echo "tfp_pc_rcm")
    let tfp_pc_rcp_ct=0
    let tfp_pc_rcm_ct=0
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_pc}]}")
    if [ "${tfp_get_key}" == "tfp_pc" ]; then
         tfp_pc_rcp_ct=$(cat ${1} | jq '.configuration.provider_config|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name == "google" )'  | sed 's/^\}/\}\,/' | grep "^\}\,$" | wc -l)

         tfp_pc_rcp=$(cat ${1} | jq '.configuration.provider_config|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name == "google" )'  | sed 's/^\}/\}\,/' | tr '\n' ' ' | sed 's/ //g' | sed 's/\}\,$/\}\n/' | sed 's/^/\[/' | sed 's/$/\]/'  | sed "s/{\"service_resources\"/\n{\"service_resources\"/g"   | jq '.')
         tfp_pc_rcp=${tfp_pc_rcp:-tfp_pc_rcp}

         tfp_pc_rcm_ct=$(cat ${1} | jq '.configuration.provider_config|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name != "google" )'  | sed 's/^\}/\}\,/' | grep "^\}\,$" | wc -l)

         tfp_pc_rcm=$(cat ${1} | jq '.configuration.provider_config|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name != "google" )'  | sed 's/^\}/\}\,/' | tr '\n' ' ' | sed 's/ //g' | sed 's/\}\,$/\}\n/' | sed 's/^/\[/' | sed 's/$/\]/'  | sed "s/{\"service_resources\"/\n{\"service_resources\"/g"   | jq '.')
         tfp_pc_rcm=${tfp_pc_rcm:-tfp_pc_rcm}
    fi

    #get_drift_data. resource_drift (rd=Plan_file_Resource_Drift)
    tfp_rd=$(echo "tfp_rd")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_rd}]}")
    if [ "${tfp_get_key}" == "tfp_rd" ]; then
         tfp_rd=$(cat ${1} | jq '.resource_drift|select( . != null)|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name != "google" )' | sed 's/^\}/\}\,/' | tr '\n' ' ' | sed 's/ //g' | sed 's/\}\,$/\}\n/' | sed 's/^/\[/' | sed 's/$/\]/'  | sed "s/{\"service_resources\"/\n{\"service_resources\"/g"   | jq '.|{ "total_resources_deployed":length,"resource_list":.}')
         tfp_rd=${tfp_rd:-tfp_rd}
    fi

    #get_checks_made_on_resources_data_and_instances. checks (rk=plan_file_Resource_Checks)
    tfp_rk=$(echo "tfp_rk")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_rk}]}")
    if [ "${tfp_get_key}" == "tfp_rk" ]; then
         tfp_rk=$(cat ${1} | jq '.|.checks|select( . != null)| values| sort|[ .[]|{ "tf_deployment_type":.address.kind,"tf_deployment_keys":.address|keys, "tf_deployment_resource_type": .address|values,"tf_status":.status  ,"tf_instances_of_type_deployed":.instances}]')
         tfp_rk=${tfp_rk:-tfp_rk}
    fi


    #All_Processing_Done

    get_tag_for_this_tfp_from_pv=$(echo "tfp_pv_tag")
    get_services_resources_properties_of_this_plan=$(echo "tfp_pv_srp")
    if [ "${tfp_pv}" == "tfp_pv" ]; then
         ECHO "INFO: File ${1} has no Planned_Values. Deployment could be to correct DRIFT"
         if [ "${tfp_rd}" != "tfp_rd" ]; then
            ECHO "INFO: File ${1} has no Planned_Values, but DRIFT found. Deployment O.K. Any Rules Violated or NON-COMPLIANCE subject_to_discussion. DRIFT_FOUND"
         else
            ECHO "INFO: File ${1} has no Planned_Values and no Drift. Deployment OK if Instance Counts Increase/Decrease. Any Rules Violated or NON-COMPLIANCE subject_to_discussion. SOFT_DEPLOYMENT "
         fi
    else
         ECHO "INFO: File ${1} has Planned_Values, Any Rules Violated or NON-COMPLIANCE_ACTION: SCAN"
         echo "${tfp_pv}" | jq '.|.[]|[ { "service_reource":.type,"service_name":.name, "properties_already_set":.values, "tags_already_set":.values.labels}]' > ${3}/${2}_${4}_tfp_pv.json

         get_tag_for_this_tfp_from_pv=$(cat ${3}/${2}_${4}_tfp_pv.json 2>/dev/null | jq '.[]|.tags_already_set|select(.!=null)|values|select(.applicationid)' |grep -v "^\{\}$" | tr '\n' ' ' | sed 's/ //g' | sed "s/}{/},{/g" | sed 's/$/\n/' | sed 's/^/[/' | sed 's/$/]/' | sed "s/},{/},\n{/g"  | jq '.|sort'| grep -v createdondate | jq '.|sort|unique|values|select(.[].applicationid)|.[]' 2>/dev/null | jq -n 'input' 2>/dev/null)

         get_tag_for_this_tfp_from_pv=${get_tag_for_this_tfp_from_pv:-tfp_pv_tag}
         cat ${3}/${2}_${4}_tfp_pv.json | jq '.|.[]|{"srv":.service_reource,"srv_name":.service_name,"properties":.properties_already_set|keys|join("|"),"values":.properties_already_set}' | jq -n -s '.|{tf:[input]}|.tf[]|[{"total_resources":length,"tf":values}]' > ${3}/${2}_${4}_tfp_pv_srp.json
         tfp_pv_info_hash["${2}_${4}_tfp_pv_srp"]=$(cat ${3}/${2}_${4}_tfp_pv_srp.json)

         ll_tfp=$(echo "${ll_tfp}|tfp_pv_srp")
    fi
         
    if [ "${get_tag_for_this_tfp_from_pv}" != "tfp_pv_tag" ]; then
          echo "${get_tag_for_this_tfp_from_pv}" > ${3}/${2}_${4}_tfp_pv_tag.json
          tfp_pv_tag_info_hash[${2}_${4}_tfp_pv_tag_key]=$(echo "${get_tag_for_this_tfp_from_pv}" | jq '.|keys|join("|")')
          tfp_pv_tag_info_hash[${2}_${4}_tfp_pv_tag_value]=$(echo "${get_tag_for_this_tfp_from_pv}" | jq -Mr '.|[.[]]|join("|")')
          ll_tfp=$(echo "${ll_tfp}|tfp_pv_tag")
    else 
          echo "INFO: get_tag_for_this_tfp_from_pv ${get_tag_for_this_tfp_from_pv}"
    fi

    get_tag_for_this_tfp_from_rc_tbsp=$(echo "tfp_rc_tbsp_tag")
    if [ "${tfp_rc_tbsp}" == "tfp_rc_tbsp" ]; then
        ECHO "INFO: File ${1} has no Resource_Changes." 
    else
        ECHO "INFO: File ${1} has Resource_Changes. Resources/Properties set/to_be_set_will_be_collected. Any Rules Violated or NON-COMPLIANCE_ACTION: ABEND/NOABEND_WITH_EXCEPTION" 
        ECHO "${tfp_rc_tbsp}" | jq '.' > ${3}/${2}_${4}_tfp_rc_tbsp.json
        #get_tag_for_this_tfp_from_rc_tbsp=$(cat ${3}/${2}_${4}_tfp_rc_tbsp.json |  jq '.[]|.tags_to_be_set|select(.!=null)'| jq -n '[input]' 2>/dev/null | jq '.[0]' 2>/dev/null)
        get_tag_for_this_tfp_from_rc_tbsp=$(cat ${3}/${2}_${4}_tfp_rc_tbsp.json 2>/dev/null | jq '.[]|.tags_to_be_set|select(.!=null)|values|select(.applicationid)'|  grep -v "^\{\}$" | tr '\n' ' ' | sed 's/ //g' | sed "s/}{/},{/g" | sed 's/$/\n/' | sed 's/^/[/' | sed 's/$/]/' | sed "s/},{/},\n{/g"  | jq '.|sort'| grep -v createdondate | jq '.|unique|sort|values|select(.[].applicationid)|.[]' 2>/dev/null | jq -n 'input' 2>/dev/null)

        get_tag_for_this_tfp_from_rc_tbsp=${get_tag_for_this_tfp_from_rc_tbsp:-tfp_rc_tbsp_tag}
    fi

    if [ "${get_tag_for_this_tfp_from_rc_tbsp}" != "tfp_rc_tbsp_tag" ]; then
          echo "${get_tag_for_this_tfp_from_rc_tbsp}" > ${3}/${2}_${4}_tfp_rc_tbsp_tag.json
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_tbsp_tag_key]=$(echo "${get_tag_for_this_tfp_from_rc_tbsp}" | jq '.|keys|join("|")')
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_tbsp_tag_value]=$(echo "${get_tag_for_this_tfp_from_rc_tbsp}" | jq -Mr '.|[.[]]|join("|")')
          ll_tfp=$(echo "${ll_tfp}|tfp_rc_tbsp_tag")

     else
          echo "INFO: get_tag_for_this_tfp_from_rc_tbsp ${get_tag_for_this_tfp_from_rc_tbsp}"
    fi

    get_tag_for_this_tfp_from_rc_alsp=$(echo "tfp_rc_alsp_tag")
    if [ "${tfp_rc_alsp}" == "tfp_rc_alsp" ]; then
        ECHO "INFO: File ${1} has no Resource_Changes." 
    else
        ECHO "INFO: File ${1} has Resource_Changes. Resources/Properties set. Any Rules Violated or NON-COMPLIANCE_ACTION: PASS" 
        echo "${tfp_rc_alsp}" | jq '.' > ${3}/${2}_${4}_tfp_rc_alsp.json
        #get_tag_for_this_tfp_from_rc_alsp=$(cat ${3}/${2}_${4}_tfp_rc_alsp.json |  jq '.[]|.tags_already_set|select(.!=null)'| jq -n '[input]' 2>/dev/null| jq '.[0]' 2>/dev/null)
        get_tag_for_this_tfp_from_rc_alsp=$(cat ${3}/${2}_${4}_tfp_rc_alsp.json 2>/dev/null | jq '.[]|.tags_already_set|select(.!=null)|values|select(.applicationid)'| grep -v "^\{\}$" | tr '\n' ' ' | sed 's/ //g' | sed "s/}{/},{/g" | sed 's/$/\n/' | sed 's/^/[/' | sed 's/$/]/' | sed "s/},{/},\n{/g"  | jq '.|sort'| grep -v createdondate | jq '.|unique|sort|values|select(.[].applicationid)|.[]' 2>/dev/null | jq -n 'input' 2>/dev/null)

        get_tag_for_this_tfp_from_rc_alsp=${get_tag_for_this_tfp_from_rc_alsp:-tfp_rc_alsp_tag}

    fi

    if [ "${get_tag_for_this_tfp_from_rc_alsp}" != "tfp_rc_alsp_tag" ]; then
          echo "${get_tag_for_this_tfp_from_rc_alsp}" > ${3}/${2}_${4}_tfp_rc_alsp_tag.json
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_alsp_tag_key]=$(echo "${get_tag_for_this_tfp_from_rc_alsp}" | jq '.|keys|join("|")')
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_alsp_tag_value]=$(echo "${get_tag_for_this_tfp_from_rc_alsp}" | jq -Mr '.|[.[]]|join("|")')
          ll_tfp=$(echo "${ll_tfp}|tfp_rc_alsp_tag")

    else
          echo "INFO: get_tag_for_this_tfp_from_rc_alsp ${get_tag_for_this_tfp_from_rc_alsp}"
    fi

    get_tag_for_this_tfp_from_ps=$(echo "tfp_ps_tag")
    if [ "${tfp_ps}" == "tfp_ps" ]; then
        ECHO "INFO: File ${1} has no Prior_State. Resources/Properties set. Any Rules Violated or NON-COMPLIANCE_ACTION: SCAN, DEPLOYMENT_TYPE: NEW" 
    else
        ECHO "INFO: File ${1} has Prior_State. Resources/Properties set. Any Rules Violated or NON-COMPLIANCE_ACTION: SCAN, DEPLOYMENT_TYPE: update,delete,no-ops" 
        echo "${tfp_ps}" | jq '.' >  ${3}/${2}_${4}_tfp_ps.json
        get_tag_for_this_tfp_from_ps=$(cat ${3}/${2}_${4}_tfp_ps.json 2>/dev/null | jq '.[]|.tags_to_be_set|select(.!=null)|values|select(.applicationid)' | grep -v "^\{\}$" | tr '\n' ' ' | sed 's/ //g' | sed "s/}{/},{/g" | sed 's/$/\n/' | sed 's/^/[/' | sed 's/$/]/' | sed "s/},{/},\n{/g"  | jq '.|sort'| grep -v createdondate | jq '.|unique|sort|values|select(.[].applicationid)|.[]' 2>/dev/null | jq -n 'input' 2>/dev/null)
        get_tag_for_this_tfp_from_ps=${get_tag_for_this_tfp_from_ps:-tfp_ps_tag}
    fi

    if [ "${get_tag_for_this_tfp_from_ps}" != "tfp_ps_tag" ]; then
          echo "${get_tag_for_this_tfp_from_ps}" > ${3}/${2}_${4}_tfp_ps_tag.json
          tfp_ps_tag_info_hash[${2}_${4}_tfp_ps_tag_key]=$(echo "${get_tag_for_this_tfp_from_ps}" | jq '.|keys|join("|")')
          tfp_ps_tag_info_hash[${2}_${4}_tfp_ps_tag_value]=$(echo "${get_tag_for_this_tfp_from_ps}" | jq -Mr '.|[.[]]|join("|")')
          ll_tfp=$(echo "${ll_tfp}|tfp_ps_tag")
    else
          echo "INFO: get_tag_for_this_tfp_from_ps ${get_tag_for_this_tfp_from_ps}"
    fi

    if [ "${tfp_pc_rcp}" == "tfp_pc_rcp" ]; then
        ECHO "INFO: File ${1} has no Configuration_Data. No Cloud_Resources_Used. Soft Deployment or Virtual_Devices: Ramdom_Number_generator,Time .. etc." 
    else
        ECHO "INFO: File ${1} has Configuration_Data. Cloud Resources/Properties set. Any Rules Violated or NON-COMPLIANCE_ACTION: SCAN" 
        echo "${tfp_pc_rcp}" | jq '.' | sed "s/^\[/\[\n \{ \"total_services\": $tfp_pc_rcp_ct\}\,/" > ${3}/${2}_${4}_tfp_pc_rcp.json
        tfp_pc_rcp_info_hash[${2}_${4}_tfp_pc_rcp]=$(cat ${3}/${2}_${4}_tfp_pc_rcp.json)
          ll_tfp=$(echo "${ll_tfp}|tfp_pc_rcp")
    fi
    
    if [ "${tfp_pc_rcm}" == "tfp_pc_rcm" ]; then
        ECHO "INFO: File ${1} has no Configuration_Data. Custom Module" 
    else
        ECHO "INFO: File ${1} has Configuration_Data. Custom Module Resources/Properties set. Any Rules Violated or NON-COMPLIANCE_ACTION: SCAN" 
        echo "${tfp_pc_rcm}" | jq '.' | sed "s/^\[/\[\n \{ \"total_services\": $tfp_pc_rcm_ct\}\,/" > ${3}/${2}_${4}_tfp_pc_rcm.json
        tfp_pc_rcm_info_hash[${2}_${4}_tfp_pc_rcm]=$(cat ${3}/${2}_${4}_tfp_pc_rcm.json)
          ll_tfp=$(echo "${ll_tfp}|tfp_pc_rcm")
    fi

    if [ "${tfp_rk}" == "tfp_rk" ]; then
       ECHO "INFO: File ${1} has no Checks_performed_On_resources_And_Instances."
    else
       ECHO "INFO: File ${1} has Checks_performed_On_resources_And_Instances. NO_RULES_INVOLVED_INFORMATION_PURPOSE_ONLY"
        echo "${tfp_rk}" | jq '.' > ${3}/${2}_${4}_tfp_rk.json
    fi
    tfp_info_hash[${tfp_root_key}]="${ll_tfp}"

}


configuration_init ()
{
    ECHO "INFO: FUNCTION_NAME configuration"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    pc_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    #tfp_configuration_hash[${pop_base}]="${pop_base}"
    #get_config_keys=$(cat ${1} | | jq '.configuration' | jq 'keys|join("|")' | sed 's/\"//g')
    #appnm=$(echo "${1}" | awk -F "/" '{ APPNM=NF-1; print $APPNM;}')
    ##echo "INFO: pop_base=${pop_base},APPNM=${appnm}"
    config_filenm=$(echo "${root_dir}/configuration_${pop_base}_${pc_cloud}.json")
    chk_file=$(ls -C1 ${config_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.configuration' > ${config_filenm}
    else
         ECHO "INFO: key-configuration-already-done,${chk_file}"
    fi
    tfp_configuration_hash[${pop_base}]="${config_filenm}"
    echo "INFO: configuration=${tfp_configuration_hash[${pop_base}]}"
}

planned_values_init ()
{
    ECHO "INFO: FUNCTION_NAME  planned_values"
    ##echo "INFO: trp is ${1}, version ${ver}"
    #pop_base=$(echo "${tfp_hash[${base_name}]}")
    pop_base=$(echo "${2}")
    pv_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    #ECHO "INFO: parameters Passed ${1}, ${2}, pop_base ${pop_base} my_cld ${get_my_cld}"
    #tfp_hash[${pop_base}_${get_my_cld}]="${pop_base}_${get_my_cld}"
    planned_values_filenm=$(echo "${root_dir}/planned_values_${pop_base}_${pv_cloud}.json")
    chk_file=$(ls -C1 ${planned_values_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.planned_values' > ${planned_values_filenm}
    else
         ECHO "INFO: key-planned_values-already-done,${chk_file}"
    fi
    tfp_planned_values_hash[${pop_base}]="${planned_values_filenm}"
    ECHO "INFO: planned_values=${tfp_planned_values_hash[${pop_base}_${get_my_cld}]}"

}

prior_state_init ()
{
    ECHO "INFO: FUNCTION_NAME prior_state"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    ps_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    prior_state_filenm=$(echo "${root_dir}/prior_state_${pop_base}_${ps_cloud}.json")
    chk_file=$(ls -C1 ${prior_state_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.prior_state' > ${prior_state_filenm}
    else
         ECHO "INFO: key-prior_state-already-done,${chk_file}"
    fi
    tfp_prior_state_hash[${pop_base}]="${prior_state_filenm}"
    ECHO "INFO: prior_state=${tfp_prior_state_hash[${pop_base}]}"

}


relevant_attributes_init ()
{
    ECHO "INFO: FUNCTION_NAME relevant_attributes"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    ra_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    relevant_attributes_filenm=$(echo "${root_dir}/relevant_attributes_${pop_base}_${ra_cloud}.json")
    chk_file=$(ls -C1 ${relevant_attributes_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.relevant_attributes' > ${relevant_attributes_filenm}
    else
         ECHO "INFO: key-relevant_attributes-already-done,${chk_file}"
    fi
    tfp_relevant_attributes_hash[${pop_base}]="${relevant_attributes_filenm}"
    ECHO "INFO: relevant_attributes=${tfp_relevant_attributes_hash[${pop_base}]}"

}

resource_changes_init ()
{
    ECHO "INFO: FUNCTION_NAME resource_changes"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    rc_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    resource_changes_filenm=$(echo "${root_dir}/resource_changes_${pop_base}_${rc_cloud}.json")
    chk_file=$(ls -C1 ${resource_changes_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.resource_changes' > ${resource_changes_filenm}
    else
         ECHO "INFO: key-resource_changes-already-done,${chk_file}"
    fi
    tfp_resource_changes_hash[${pop_base}]="${resource_changes_filenm}"
    ECHO "INFO: resource_changes=${tfp_resource_changes_hash[${pop_base}]}"

}


resource_drift_init ()
{
    ECHO "INFO: FUNCTION_NAME resource_drift"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    rd_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    resource_drift_filenm=$(echo "${root_dir}/resource_drift_${pop_base}_${rd_cloud}.json")
    chk_file=$(ls -C1 ${resource_drift_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.resource_drift' > ${resource_drift_filenm}
    else
         ECHO "INFO: key-resource_drift-already-done,${chk_file}"
    fi
    tfp_resource_drift_hash[${pop_base}]="${resource_drift_filenm}"
    ECHO "INFO: resource_drift=${tfp_resource_drift_hash[${pop_base}]}"

}

applyable_init ()
{
    ECHO "INFO: FUNCTION_NAME applayable"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    tv_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    get_applyable=(`cat ${1} | jq '.applyable'`)
    tfp_applyable_hash[${pop_base}]="${get_applyable}"
    echo "INFO: SIGNATURE=${pop_base} applayable=${tfp_applyable_hash[${pop_base}]}"
}
terraform_version_init ()
{
    ECHO "INFO: FUNCTION_NAME terraform_version"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    tv_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    get_terraform_version=(`cat ${1} | jq '.terraform_version'`)
    tfp_terraform_version_hash[${pop_base}]="${get_terraform_version}"
    echo "INFO: SIGNATURE=${pop_base} terraform_version=${tfp_terraform_version_hash[${pop_base}]}"
}

checks_init ()
{
    ECHO "INFO: FUNCTION_NAME checks"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    ck_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    checks_filenm=$(echo "${root_dir}/checks_${pop_base}_${ck_cloud}.json")
    chk_file=$(ls -C1 ${checks_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.checks' > ${checks_filenm}
    else
         ECHO "INFO: key-checks-already-done,${chk_file}"
    fi
    tfp_checks_hash[${pop_base}]="${checks_filenm}"
    ECHO "INFO: checks=${tfp_checks_hash[${pop_base}]}"
    break_step
}


format_version_init ()
{
    ECHO "INFO: FUNCTION_NAME format_version"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    fv_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    fv=$(cat ${1} | jq '.format_version')
    tfp_format_version_hash[${pop_base}]="${fv}"
    echo "INFO: SIGNATURE=${pop_base} tfp_format_version=${tfp_format_version_hash[${pop_base}]}"

}

errored_init ()
{
    ECHO "INFO: FUNCTION_NAME errored"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    er_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    fv=$(cat ${1} | jq '.errored')
    tfp_errored_hash[${pop_base}]="${fv}"
    ECHO "INFO: errored=${tfp_errored_hash[${pop_base}]}"

}

timestamp_init ()
{
    ECHO "INFO: FUNCTION_NAME timestamp"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    ts_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    fv=$(cat ${1} | jq '.timestamp')
    tfp_timestamp_hash[${pop_base}]="${fv}"
    ECHO "INFO: timestamp=${tfp_timestamp_hash[${pop_base}]}"

}


variables_init ()
{
    ECHO "INFO: FUNCTION_NAME  variables"
    ##echo "INFO: trp is ${1}, version ${ver}"
    pop_base=$(echo "${2}")
    vs_cloud=$(echo "${4}")
    root_dir=$(echo "${3}")
    variables_filenm=$(echo "${root_dir}/variables_${pop_base}_${vs_cloud}.json")
    chk_file=$(ls -C1 ${variables_filenm} 2>/dev/null)
    chk_file=${chk_file:-NONE}
    if [ "${chk_file}" == "NONE" ]; then
         cat ${1} | jq '.variables|{ "all_variables":.}'  > ${variables_filenm}
    else
         ECHO "INFO: key-variables-already-done,${chk_file}"
    fi
    tfp_variables_hash[${pop_base}]="${variables_filenm}"
    ECHO "INFO: variables=${tfp_variables_hash[${pop_base}]}"

}



split_tfp_files_into_keys ()
{
      ECHO "INFO: TYPE INDIRECT FN-NAME split_tfp_files_into_keys"
      for all in `echo "${tf_plan_file_unique_hash[@]}"`
      do
         ECHO "INFO: key-${all}"
         get_file=(`echo "${tf_plan_file_key_name_hash[${all}]}"`)
         get_dir=(`echo "${SCAN_DIR}/${tf_plan_file_key_dir_hash[${all}]}"`)
         ECHO "INFO: base-${tf_plan_file_key_just_file_hash[${all}]}"
         ECHO "INFO: uniquekey-${tf_plan_file_report_hash[${all}]}"
         ECHO "INFO: report_key-${tf_plan_file_rpt_hash[${all}]}"
         base_id_clip=(`echo "${tf_plan_file_key_just_file_hash[${all}]}" | sed 's/tfut//'`)
         base_id=(`echo "${all}_${base_id_clip}"`)
         kics_tfplan_signature_hash[${base_id}]=${base_id_clip}
         chk_cloud ${get_file} ${all}
         get_my_cld=$(echo "${tfp_terraform_cloud_hash[${all}]}")
         cat ${get_file} | jq '.' > ${tfp_daily_dir}/${all}_${get_my_cld}.json
         tfp_file_to_process=$(echo "${tfp_daily_dir}/${all}_${get_my_cld}.json")
         tf_plan_check_sum_files_list_hash[${all}]="${tfp_file_to_process}"
      done
      get_my_cld=$(echo "NONE")
      for all_files_from_tf_plan_check_sum_files_list_hash in `echo "${!tf_plan_check_sum_files_list_hash[@]}"`
      do
          get_file=$(echo "${tf_plan_check_sum_files_list_hash[$all_files_from_tf_plan_check_sum_files_list_hash]}")
          get_my_cld=$(echo "${tfp_terraform_cloud_hash[${all_files_from_tf_plan_check_sum_files_list_hash}]}")
          ECHO "INFO_DEBUG: KEYS-${all_files_from_tf_plan_check_sum_files_list_hash} FILE- ${get_file} CLOUD=${get_my_cld}"
          #------- keys_loop ---------
          #  tfp_root_keys_ar=$(cat ${get_file} | jq 'keys|join("|")'  2>/dev/null | sed 's/\"//g' | tr '|' ' ')
          #  any_keys=$(echo "${#tfp_root_keys_ar[@]}")
          #  if [ ${any_keys} -gt 0 ]; then
          #        #echo "INFO: CALLING_FN- find_tag ${all}"
          #        for all_root_key in `echo "${tfp_root_keys_ar[@]}"`
          #        do   
          #           ${all_root_key}_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld}
          #        done
          #        get_current_configuration_file=$(echo "${tfp_configuration_hash[${all_files_from_tf_plan_check_sum_files_list_hash}]}")
          #        echo "INFO: CALLING_FN-  ${all_files_from_tf_plan_check_sum_files_list_hash} ${get_current_configuration_file}"
          #        echo "INFO: CALLING- tfp_tag_process_for_${get_my_cld}_clouds ${all} ${get_current_configuration_file}"
          #        tfp_tag_process_for_${get_my_cld}_clouds ${all_files_from_tf_plan_check_sum_files_list_hash} ${get_current_configuration_file}
          #        #tfp_tag_process_for_${clip_cloud}_clouds
          #  else
          #        echo "INFO: NOT_A_TERRAFORM_FILE(NOT_A_JSON)"
          #  fi
          #------- keys_loop ---------
          #ECHO "INFO_DEBUG: KEYS-${all_files_from_tf_plan_check_sum_files_list_hash} FILE- ${get_file} CLOUD=${get_my_cld}"
          terraform_version_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld}
          format_version_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld}
          applyable_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld}
          planned_values_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          configuration_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          prior_state_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          relevant_attributes_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          resource_drift_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          resource_changes_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          checks_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          errored_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          timestamp_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          variables_init ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld} 
          process_${get_my_cld}_cloud_tfp_file ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld}
          #get_current_configuration_file=$(echo "${tfp_configuration_hash[${all_files_from_tf_plan_check_sum_files_list_hash}]}")
          #tfp_tag_process_for_${get_my_cld}_clouds ${all_files_from_tf_plan_check_sum_files_list_hash} ${get_file} ${get_current_configuration_file}
          final_result_of_tfp_info ${get_file} ${all_files_from_tf_plan_check_sum_files_list_hash} ${tfp_root} ${get_my_cld}
      done
      echo "INFO_DEBUG: -DONE"
      exit 0
      #read SSSSS
}
