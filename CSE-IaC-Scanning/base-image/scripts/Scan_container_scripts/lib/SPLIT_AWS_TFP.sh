
process_aws_cloud_tfp_file ()
{
    ECHO "INFO: FUNCTION_NAME process_aws_cloud_tfp_file"
    #echo "INFO_DEBUG: p1=${1}, p2=${2}, p3=${3}, p4=${4} - Start"
    tfp_root_key=$(echo "${2}_${4}")
    ll_tfp=$(echo "${tfp_root_key}")
    #get_cloud_from_tfp. configuration.provider_config (pd=Plan_file_clouD)
    #tfp_pd=$(cat ${1} | jq -Mr '.configuration.provider_config|keys|sort| .[0] | select( . == "aws" )|select (. != null)')
    tfp_pd=$(echo "tfp_pd")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_pd}]}")
    if [ "${tfp_get_key}" == "tfp_pd" ]; then
                tfp_pd=$(cat ${1} | jq -Mr '.configuration.provider_config|keys|sort|unique|.[0]| select( .|contains("aws"))|select (. != null)')
                tfp_pd=${tfp_pd:-NONE}
                if [ "${tfp_pd}" == "NONE" ]; then
                     echo "INFO: PROVIDER_FROM_TFP_FILE_UNKNOWN"
                     tfp_pd=$(echo "$4")
                else
                     tfp_pd=$(echo "aws")
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
                tfp_pc_rcp_ct=$(cat ${1} | jq '.configuration.provider_config|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name == "aws" )'  | sed 's/^\}/\}\,/' | grep "^\}\,$" | wc -l)

                tfp_pc_rcp=$(cat ${1} | jq '.configuration.provider_config|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name == "aws" )'  | sed 's/^\}/\}\,/' | tr '\n' ' ' | sed 's/ //g' | sed 's/\}\,$/\}\n/' | sed 's/^/\[/' | sed 's/$/\]/'  | sed "s/{\"service_resources\"/\n{\"service_resources\"/g"   | jq '.')
                tfp_pc_rcp=${tfp_pc_rcp:-tfp_pc_rcp}

                tfp_pc_rcm_ct=$(cat ${1} | jq '.configuration.provider_config|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name != "aws" )'  | sed 's/^\}/\}\,/' | grep "^\}\,$" | wc -l)

                tfp_pc_rcm=$(cat ${1} | jq '.configuration.provider_config|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name != "aws" )'  | sed 's/^\}/\}\,/' | tr '\n' ' ' | sed 's/ //g' | sed 's/\}\,$/\}\n/' | sed 's/^/\[/' | sed 's/$/\]/'  | sed "s/{\"service_resources\"/\n{\"service_resources\"/g"   | jq '.')
                tfp_pc_rcm=${tfp_pc_rcm:-tfp_pc_rcm}
    fi

    #get_drift_data. resource_drift (rd=Plan_file_Resource_Drift)
    tfp_rd=$(echo "tfp_rd")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_rd}]}")
    if [ "${tfp_get_key}" == "tfp_rd" ]; then
                tfp_rd=$(cat ${1} | jq '.resource_drift|select( . != null)|{ "keys": keys|sort| select(.), "values": values }| {"service_resources": .values[.keys[]]}|select( .service_resources.name != "aws" )' | sed 's/^\}/\}\,/' | tr '\n' ' ' | sed 's/ //g' | sed 's/\}\,$/\}\n/' | sed 's/^/\[/' | sed 's/$/\]/'  | sed "s/{\"service_resources\"/\n{\"service_resources\"/g"   | jq '.|{ "total_resources_deployed":length,"resource_list":.}')
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

