
cloud=$(echo "google")
pj=$(echo "project")
gcp_projectid=$(echo "0000-0000-0000-0000-0000")
gcp_projectid_from_cf=${gcp_projectid_from_cf:-NONE}
gcp_projectid_from_rc=${gcp_projectid_from_rc:-NONE}
gcp_projectid_from_pv=${gcp_projectid_from_pv:-NONE}
gcp_projectid_from_gv==${gcp_projectid_from_gv:-NONE}

declare -A gcp_projectid_process_hash

process_gcp_cloud_tfp_file ()
{
    ECHO "INFO: FUNCTION_NAME process_gcp_cloud_tfp_file"
    #echo "INFO_DEBUG: p1=${1}, p2=${2}, p3=${3}, p4=${4} - Start"
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

    #get_global_variables_list variables. (gv=global_variables)
    tfp_gv=$(echo "tfp_gv")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_gv}]}")
    if [ "${tfp_get_key}" == "tfp_gv" ]; then
         gcp_projectid_from_gv=$(cat ${1} | jq '.variables|select( . != null)|.project_id|select( . != null)|.value|select( . != null)')
         gcp_projectid_from_gv=${gcp_projectid_from_gv:-NONE}
         gcp_projectid_process_hash["gcp_projectid_from_gv"]="${gcp_projectid_from_gv}"
    fi
    

    #get_resources_properties_list. planned_values (pv=plan_file_Planned_Values)
    tfp_pv=$(echo "tfp_pv")
    tfp_pvc=$(echo "tfp_pvc")
    tfp_pvr=$(echo "tfp_pvr")
    total_tfp_pv_length=$(echo "0")
    file_storage_prefix=$(echo "rec")
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_pv}]}")
    if [ "${tfp_get_key}" == "tfp_pv" ]; then
                  #gcp_projectid_from_pv=$(cat ${1} | jq '.planned_values' | grep "project\":" | sort -u | sed 's/^/{/' | sed 's/\,$//'| sed 's/$/}/' | sed 's/ //g' | jq '.[keys[0]]' | sed 's/\"//g')
                  #gcp_projectid_from_pv=$(cat ${1} | jq '.planned_values' | grep "project\":" | sort -u | sed 's/^/{/' | sed 's/\,$//'| sed 's/$/}/' | sed 's/ //g' | jq '.project' | jq -n 'input' 2>/dev/null | sed 's/\"//g')
                  #gcp_projectid_from_pv=$(cat ${1} | grep "project\":" | sort -u | sed 's/^/{/' | sed 's/\,$//'| sed 's/$/}/' | sed 's/ //g' | jq '.project' | jq -n 'input' 2>/dev/null | sed 's/\"//g' | sed 's/null/0000-0000-0000-0000/g')
                  gcp_projectid_from_pv=$(cat ${1} |  grep "\"project\": \"" | sort -u | sed 's/^/{/' | sed 's/\,$//'| sed 's/$/}/' | sed 's/ //g' | jq '.project' | jq -n 'input' 2>/dev/null | sed 's/\"//g')
                  gcp_projectid_from_pv=${gcp_projectid_from_pv:-NONE}
                  gcp_projectid_process_hash["gcp_projectid_from_pv"]="${gcp_projectid_from_pv}"
                  ECHO "INFO: Module PV, FILE ${1}  gcp_projectid_from_pv=${gcp_projectid_from_pv}"
                  tfp_pvrc_all=$(cat ${1} | jq '.planned_values' | jq --slurp 'reduce .[] as $item ({}; . * $item)')
                  keys=()
                  keys=$(echo "${tfp_pvrc_all}" | jq 'keys')
                  tfp_pvrc=$(echo "${tfp_pvrc_all}" | jq '.root_module')
                  tfp_pvrc_length=$(echo "${tfp_pvrc}" | jq 'length')
                  keys_rm=()
                  keys_rm=$(echo "${tfp_pvrc}" | jq 'keys')
                  keys_rm_length=${keys_rm_length:-0}
                  keys_rm_length=$(echo "${tfp_pvrc}" | jq 'keys|length')
                  keys_rm_length=${keys_rm_length:-0}
                       
                  tfp_pvrc_c_length=$(echo "${tfp_pvrc}" | jq ' def n: if . == "" then [] else . end; def nk: if . == null then [] else . end; (.child_modules|nk|n)|(.[].resources|nk|n)|length')
                  tfp_pvrc_c_length=${tfp_pvrc_c_length:-0}
                  resources_from=$(echo "a")
                  if [ ${tfp_pvrc_c_length} -gt 0 ]; then 
                      #tfp_pvc=$(echo "${tfp_pvrc}" | jq '.root_module|.child_modules[].resources')
                      tfp_pvc=$(echo "${tfp_pvrc}" | jq '.child_modules[].resources| .[] += { "resources_from" : "c" }')
                  else 
                      tfp_pvc=$(echo "[]")
                      resources_from=$(echo "r")
                  fi
                  tfp_pvrc_r_length=$(echo "${tfp_pvrc}" | jq ' def n: if . == "" then [] else . end; def nk: if . == null then [] else . end; (.resources|nk|n)|length')
                  tfp_pvrc_r_length=${tfp_pvrc_r_length:-0}
                  if [ ${tfp_pvrc_r_length} -gt 0 ]; then
                      tfp_pvr=$(echo "${tfp_pvrc}" | jq '.resources | .[] += { "resources_from" : "r" }')
                  else
                      tfp_pvr=$(echo "[]")
                      resources_from=$(echo "c")
                  fi
           
                  total_cr=`expr ${tfp_pvrc_r_length} + ${tfp_pvrc_c_length}`
                  total_cr_chk=${total_cr_chk:-0}
    
                  if [ ${keys_rm_length} -gt 1 ]; then
                       total_cr_chk0=$(echo "${tfp_pvc}" "${tfp_pvr}" | jq --slurp '.|sort|.[0]|length')
                       total_cr_chk1=$(echo "${tfp_pvc}" "${tfp_pvr}" | jq --slurp '.|sort|.[1]|length')
                       total_cr_chk=`expr ${total_cr_chk0} + ${total_cr_chk1}`
                       resources_from=$(echo "a")
                  else
                       total_cr_chk=$(echo "${tfp_pvc}" "${tfp_pvr}" | jq --slurp '.|sort|.[1]|length')
                  fi
                  total_cr_chk=${total_cr_chk:-0}
                  total_tfp_pv_length=${total_tfp_pv_length:-0}
                  if [ ${total_cr_chk} -eq ${total_cr} ]; then
                       if [ ${keys_rm_length} -gt 1 ]; then
                           tfp_pv=$(echo "${tfp_pvc}","${tfp_pvr}" | sed 's/^]\,\[/\,/' | jq '.')
                       else
                           tfp_pv=$(echo "${tfp_pvc}" "${tfp_pvr}" | jq --slurp '.|sort|.[1]')
                       fi
                       total_tfp_pv_length=$(echo "${tfp_pv}" | jq 'length')
                  else
                      tfp_pv=${tfp_pv:-NONE}
                  fi
                  ECHO "INFO_PV_DEBUG: tfp_pv ${1} ${tfp_pv}"
                  ECHO "INFO_DEBUG: FILE ${1} START"
                  #echo "INFO_DEBUG_TFP_PV: resources_from=${resources_from} tfp_pvrc_length=${tfp_pvrc_length}  total_tfp_pv_length=${total_tfp_pv_length}, total_cr=${total_cr}, total_cr_chk=${total_cr_chk}, tfp_pvrc_c_length=${tfp_pvrc_c_length}, tfp_pvrc_r_length=${tfp_pvrc_r_length}"
                  file_storage_prefix=$(echo "rec_k${tfp_pvrc_length}_s${total_tfp_pv_length}_t${resources_from}")
                  #cloud_${tfp_cld} "${tfp_pv}" "${file_storage_prefix}" "${tfp_sig}" "${tfp_cld}" "${total_tfp_pv_length}" # "${tfp_pvrc_length}" "${total_tfp_pv_length}" "${resources_from}"
                  ECHO "INFO_DEBUG: FILE ${1} END"
       fi
    ECHO "INFO: JQ-2 .planned_values.root_module"

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
         gcp_projectid_from_rc=$(cat ${1} | jq -Mr --arg cld "$cloud" --arg acctid "$pj" '.resource_changes|.[0]| select( . != null)|.change|.before?|.project|select( . != null)')
         gcp_projectid_from_rc=$(cat ${1} | jq -Mr --arg cld "$cloud" --arg acctid "$pj" '.resource_changes|.[0]|.change|.before?|select( . != null)| .project|select( . !=null)')
         gcp_projectid_from_rc=${gcp_projectid_from_rc:-NONE}
         gcp_projectid_process_hash["gcp_projectid_from_rc"]="${gcp_projectid_from_rc}"
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
    tfp_pc_ars=$(echo "tfp_pc_ars")
    let tfp_pc_rcp_ct=0
    let tfp_pc_rcm_ct=0
    let tfp_pc_ars_ct=0
    tfp_get_key=$(echo "${tfp_keys_type_sym_rel_hash[${tfp_pc}]}")
    if [ "${tfp_get_key}" == "tfp_pc" ]; then

                ECHO "INFO: tfp_pc_process_start cat${1} |  jq 'configuration.provider_config|[keys,values]|[.[0][]]|length'"
                tfp_pc_ars_ct=$(cat ${1} | jq '.configuration.provider_config|[keys,values]|[.[0][]]|length')

                tfp_pc_rcp_ct=$(cat ${1} | jq '.configuration.provider_config|[keys,values]|[.[0][]|contains("module")|select(. == false)]|length')

                tfp_pc_rcm_ct=$(cat ${1} |  jq '.configuration.provider_config|[keys,values]|[.[0][]|contains("module")|select(. == true)]|length')

                tfp_pc_ars=$(cat ${1} |  jq '.configuration.provider_config|[keys,values]|{"resource_keys":.[0]|sort,"resource_info":[.[1]]|sort}')
                tfp_pc_ars=${tfp_pc_ars:-tfp_pc_ars}

                tfp_pc_rcp=$(cat ${1} | jq '.configuration.provider_config|[keys,values]|{"resource_keys":[.[0][]|select(contains("module") == false )],"resource_info":.[1]}|[{ "service_resources": .resource_info[.resource_keys[]]}]')
                tfp_pc_rcp=${tfp_pc_rcp:-tfp_pc_rcp}

                tfp_pc_rcm=$(cat ${1} | jq '.configuration.provider_config|[keys,values]|{"module_keys":[.[0][]|select(contains("module") == true )],"resource_info":.[1]}|[{ "service_modules": .resource_info[.module_keys[]]}]')
                tfp_pc_rcm=${tfp_pc_rcm:-tfp_pc_rcm}
                gcp_projectid_from_cf=$(cat ${1} | jq -Mr --arg cld "$cloud" --arg acctid "$pj" '.configuration|select( . != null)| .provider_config[$cld].expressions[$acctid].constant_value|select( . != null)')
                gcp_projectid_from_cf=${gcp_projectid_from_cf:-NONE}
                gcp_projectid_process_hash["gcp_projectid_from_cf"]="${gcp_projectid_from_cf}"
                ECHO "INFO: tfp_pc_process_end"
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
    let tag_len=0
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
#----------------
                      echo "${tfp_pv}" | jq '.' > ${3}/${2}_${4}_tfp_pv_${file_storage_prefix}_rm.json
                      tfp_pv_srp=$(echo "${tfp_pv}"|  jq '.[]|[ { "service_reource":.type,"service_name":.name, "resources_from": .resources_from, "properties_already_set":.values, "tags_already_set":.values.labels}]' | jq -s '.')
                      echo "${tfp_pv_srp}" > ${3}/${2}_${4}_tfp_pv_${file_storage_prefix}_srv.json
                      get_tag_for_this_tfp_from_pv=$(echo "${tfp_pv_srp}" | jq '.[]|.[]|.tags_already_set|select(.!=null)|values|select(.applicationid)' | jq -s '.' | jq '.|sort|unique' | grep -v createdondate | jq '.|sort|unique|values|select(.[].applicationid)|.[]' | jq -s '.' | jq -n 'input|sort|unique|.[0]' |  jq ' def n: if . == "" then {} else . end; def nk: if . == null then {} else . end; (.|nk|n)')
                      get_tag_for_this_tfp_from_pv=${get_tag_for_this_tfp_from_pv:-tfp_pv_tag}
                      cat ${3}/${2}_${4}_tfp_pv_${file_storage_prefix}_srv.json 2>/dev/null | jq '.[]|.[]|{"srv":.service_reource,"srv_name":.service_name, "resources_from": .resources_from,"properties":.properties_already_set|keys|join("|"),"values":.properties_already_set}'  | jq -n -s  '.|{tf:[input]}|.tf[]|[{"total_resources":length,"tf":values}]' > ${3}/${2}_${4}_tfp_pv_${file_storage_prefix}_srp.json

                      ECHO "INFO: FILE: 1.tfp_pv_rm ${3}/${2}_${4}_tfp_pv_${file_storage_prefix}_rm.json"
                      ECHO "INFO: FILE: 2.tfp_pv_srv ${3}/${2}_${4}_tfp_pv_${file_storage_prefix}_srv.json"
                      ECHO "INFO: FILE: 2.tfp_pv_srp ${3}/${2}_${4}_tfp_pv_${file_storage_prefix}_srp.json"
                      resource_len=$(cat ${3}/${2}_${4}_tfp_pv_${file_storage_prefix}_srp.json 2>/dev/null | jq '.[].total_resources')
                      resource_len=${resource_len:-0}
                      if [ ${resource_len} -eq ${total_tfp_pv_length} ]; then
                         ECHO "INFO: RESOURCE_FILE_WRITTEN ${3}/${2}_${4}_tfp_pv_${file_storage_prefix}_rm.json"
                      else
                         echo "INFO_ERR: RESOURCE_FILE_MIS_MATCH"
                      fi

                      tfp_pv_info_hash["${2}_${4}_tfp_pv_srp"]=$(cat ${3}/${2}_${4}_tfp_pv_${file_storage_prefix}_srp.json)

                      ll_tfp=$(echo "${ll_tfp}|tfp_pv_srp")

#----------------
         #echo "${tfp_pv}" | jq '.' > ${3}/${2}_${4}_tfp_pv_rm.json
         #echo "${tfp_pv}" | jq '.|.[]|[ { "service_reource":.type,"service_name":.name, "properties_already_set":.values, "tags_already_set":.values.labels}]' > ${3}/${2}_${4}_tfp_pv.json

         #get_tag_for_this_tfp_from_pv=$(cat ${3}/${2}_${4}_tfp_pv.json 2>/dev/null | jq '.[]|.tags_already_set|select(.!=null)|values|select(.applicationid)' |grep -v "^\{\}$" | tr '\n' ' ' | sed 's/ //g' | sed "s/}{/},{/g" | sed 's/$/\n/' | sed 's/^/[/' | sed 's/$/]/' | sed "s/},{/},\n{/g"  | jq '.|sort'| grep -v createdondate | jq '.|sort|unique|values|select(.[].applicationid)|.[]' 2>/dev/null | jq -n 'input' 2>/dev/null)

         #get_tag_for_this_tfp_from_pv=${get_tag_for_this_tfp_from_pv:-tfp_pv_tag}
         #cat ${3}/${2}_${4}_tfp_pv.json | jq '.|.[]|{"srv":.service_reource,"srv_name":.service_name,"properties":.properties_already_set|keys|join("|"),"values":.properties_already_set}' | jq -n -s '.|{tf:[input]}|.tf[]|[{"total_resources":length,"tf":values}]' > ${3}/${2}_${4}_tfp_pv_srp.json
         #tfp_pv_info_hash["${2}_${4}_tfp_pv_srp"]=$(cat ${3}/${2}_${4}_tfp_pv_srp.json)

         #ll_tfp=$(echo "${ll_tfp}|tfp_pv_srp")
    fi
         
    if [ "${get_tag_for_this_tfp_from_pv}" != "tfp_pv_tag" ]; then
          echo "${get_tag_for_this_tfp_from_pv}" | sed 's/applicationid/appid/' > ${3}/${2}_${4}_tfp_pv_tag.json
          tfp_pv_tag_info_hash[${2}_${4}_tfp_pv_tag_key]=$(echo "${get_tag_for_this_tfp_from_pv}" | jq '.|keys|join("|")' | sed 's/applicationid/appid/')
          tag_pv_len=$(echo "${get_tag_for_this_tfp_from_pv}" | jq '.|keys|length')
          tag_len=${tag_pv_len}
          tfp_data_info_hash[${2}_${4}_tfp_tag_keys]=$(echo "${get_tag_for_this_tfp_from_pv}" | jq '.|keys|join("|")' |  sed 's/\"//g')
          tfp_data_info_hash[${2}_${4}_tfp_tag_values]=$(echo "${get_tag_for_this_tfp_from_pv}" | jq -Mr '.|[.[]]|join("|")')
          tfp_pv_tag_info_hash[${2}_${4}_tfp_pv_tag_value]=$(echo "${get_tag_for_this_tfp_from_pv}" | jq -Mr '.|[.[]]|join("|")')
          tfp_pv_tag_info_hash[${2}_${4}_tfp_pv_tag_json]=$(cat ${3}/${2}_${4}_tfp_pv_tag.json | sed 's/applicationid/appid/')
          ll_tfp=$(echo "${ll_tfp}|tfp_pv_tag")
    else 
          ECHO "INFO: get_tag_for_this_tfp_from_pv ${get_tag_for_this_tfp_from_pv}"
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
          echo "${get_tag_for_this_tfp_from_rc_tbsp}" | sed 's/applicationid/appid/' > ${3}/${2}_${4}_tfp_rc_tbsp_tag.json
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_tbsp_tag_key]=$(echo "${get_tag_for_this_tfp_from_rc_tbsp}" | jq '.|keys|join("|")' | sed 's/applicationid/appid/')
          tag_rc_tbsp_len=$(echo "${get_tag_for_this_tfp_from_rc_tbsp}" | jq '.|keys|length')
          if [ ${tag_rc_tbsp_len} -gt ${tag_len} ]; then
              tfp_data_info_hash[${2}_${4}_tfp_tag_keys]=$(echo "${get_tag_for_this_tfp_from_rc_tbsp}" | jq '.|keys|join("|")' | sed 's/\"//g')
              tfp_data_info_hash[${2}_${4}_tfp_tag_values]=$(echo "${get_tag_for_this_tfp_from_rc_tbsp}" | jq -Mr '.|[.[]]|join("|")')
              tag_len=${tag_rc_tbsp_len}
          fi
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_tbsp_tag_value]=$(echo "${get_tag_for_this_tfp_from_rc_tbsp}" | jq -Mr '.|[.[]]|join("|")')
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_tbsp_tag_json]=$(cat ${3}/${2}_${4}_tfp_rc_tbsp_tag.json | sed 's/applicationid/appid/')
          ll_tfp=$(echo "${ll_tfp}|tfp_rc_tbsp_tag")

     else
          ECHO "INFO: get_tag_for_this_tfp_from_rc_tbsp ${get_tag_for_this_tfp_from_rc_tbsp}"
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
          echo "${get_tag_for_this_tfp_from_rc_alsp}" | sed 's/applicationid/appid/' > ${3}/${2}_${4}_tfp_rc_alsp_tag.json
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_alsp_tag_key]=$(echo "${get_tag_for_this_tfp_from_rc_alsp}" | jq '.|keys|join("|")' | sed 's/applicationid/appid/')
          tag_rc_alsp_len=$(echo "${get_tag_for_this_tfp_from_rc_alsp}" | jq '.|keys|length')
          if [ ${tag_rc_alsp_len} -gt ${tag_len} ]; then
              tfp_data_info_hash[${2}_${4}_tfp_tag_keys]=$(echo "${get_tag_for_this_tfp_from_rc_alsp}" | jq '.|keys|join("|")' | sed 's/\"//g')
              tfp_data_info_hash[${2}_${4}_tfp_tag_values]=$(echo "${get_tag_for_this_tfp_from_rc_alsp}" | jq -Mr '.|[.[]]|join("|")')
              tag_len=${tag_rc_alsp_len}
          fi 
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_alsp_tag_value]=$(echo "${get_tag_for_this_tfp_from_rc_alsp}" | jq -Mr '.|[.[]]|join("|")')
          tfp_rc_tag_info_hash[${2}_${4}_tfp_rc_alsp_tag_json]=$(cat ${3}/${2}_${4}_tfp_rc_alsp_tag.json | sed 's/applicationid/appid/')
          ll_tfp=$(echo "${ll_tfp}|tfp_rc_alsp_tag")

    else
          ECHO "INFO: get_tag_for_this_tfp_from_rc_alsp ${get_tag_for_this_tfp_from_rc_alsp}"
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
          echo "${get_tag_for_this_tfp_from_ps}" | sed 's/applicationid/appid/' > ${3}/${2}_${4}_tfp_ps_tag.json
          tfp_ps_tag_info_hash[${2}_${4}_tfp_ps_tag_key]=$(echo "${get_tag_for_this_tfp_from_ps}" | jq '.|keys|join("|")' | sed 's/applicationid/appid/')
          tag_ps_len=$(echo "${get_tag_for_this_tfp_from_ps}" | jq '.|keys|length')
          if [ ${tag_ps_len} -gt ${tag_len} ]; then
              tfp_data_info_hash[${2}_${4}_tfp_tag_keys]=$(echo "${get_tag_for_this_tfp_from_ps}" | jq '.|keys|join("|")' | sed 's/\"//g')
              tfp_data_info_hash[${2}_${4}_tfp_tag_values]=$(echo "${get_tag_for_this_tfp_from_ps}" | jq -Mr '.|[.[]]|join("|")')
              tag_len=${tag_ps_len}
          fi
          tfp_ps_tag_info_hash[${2}_${4}_tfp_ps_tag_value]=$(echo "${get_tag_for_this_tfp_from_ps}" | jq -Mr '.|[.[]]|join("|")')
          tfp_ps_tag_info_hash[${2}_${4}_tfp_ps_tag_json]=$(cat ${3}/${2}_${4}_tfp_ps_tag.json | sed 's/applicationid/appid/')
          ll_tfp=$(echo "${ll_tfp}|tfp_ps_tag")
    else
          ECHO "INFO: get_tag_for_this_tfp_from_ps ${get_tag_for_this_tfp_from_ps}"
    fi

    if [ "${tfp_pc_ars}" == "tfp_pc_ars" ]; then
        ECHO "INFO: File ${1} has no Configuration_Data (all_resources). No Cloud_Resources_Used. Soft Deployment or Virtual_Devices: Ramdom_Number_generator,Time .. etc."
    else
        ECHO "INFO: File ${1} has Configuration_Data. Cloud Resources/Properties set. Any Rules Violated or NON-COMPLIANCE_ACTION: SCAN"
        echo "${tfp_pc_ars}" > ${3}/${2}_${4}_tfp_pc_ars.json
        tfp_pc_ars_info_hash[${2}_${4}_tfp_pc_ars]=$(cat ${3}/${2}_${4}_tfp_pc_ars.json)
        tfp_pc_ars_info_hash[${2}_${4}_tfp_pc_ars_ct]="${tfp_pc_ars_ct}"
        ll_tfp=$(echo "${ll_tfp}|tfp_pc_ars_ct")
        ll_tfp=$(echo "${ll_tfp}|tfp_pc_ars")
    fi

    if [ "${tfp_pc_rcp}" == "tfp_pc_rcp" ]; then
        ECHO "INFO: File ${1} has no Configuration_Data (resources). No Cloud_Resources_Used. Soft Deployment or Virtual_Devices: Ramdom_Number_generator,Time .. etc."
    else
        ECHO "INFO: File ${1} has Configuration_Data. Cloud Resources/Properties set. Any Rules Violated or NON-COMPLIANCE_ACTION: SCAN"
        echo "${tfp_pc_rcp}" > ${3}/${2}_${4}_tfp_pc_rcp.json
        tfp_pc_rcp_info_hash[${2}_${4}_tfp_pc_rcp]=$(cat ${3}/${2}_${4}_tfp_pc_rcp.json)
        tfp_pc_rcp_info_hash[${2}_${4}_tfp_pc_rcp_ct]="${tfp_pc_rcp_ct}"
        ll_tfp=$(echo "${ll_tfp}|tfp_pc_rcp_ct")
        ll_tfp=$(echo "${ll_tfp}|tfp_pc_rcp")
    fi

    if [ "${tfp_pc_rcm}" == "tfp_pc_rcm" ]; then
        ECHO "INFO: File ${1} has no Configuration_Data. Custom Module"
    else
        ECHO "INFO: File ${1} has Configuration_Data (modules). Custom Module Resources/Properties set. Any Rules Violated or NON-COMPLIANCE_ACTION: SCAN"
        echo "${tfp_pc_rcm}" > ${3}/${2}_${4}_tfp_pc_rcm.json
        tfp_pc_rcm_info_hash[${2}_${4}_tfp_pc_rcm]=$(cat ${3}/${2}_${4}_tfp_pc_rcm.json)
        tfp_pc_rcm_info_hash[${2}_${4}_tfp_pc_rcm_ct]="${tfp_pc_rcm_ct}"
        ll_tfp=$(echo "${ll_tfp}|tfp_pc_rcm_ct")
        ll_tfp=$(echo "${ll_tfp}|tfp_pc_rcm")
    fi


    if [ "${tfp_rk}" == "tfp_rk" ]; then
       ECHO "INFO: File ${1} has no Checks_performed_On_resources_And_Instances."
    else
       ECHO "INFO: File ${1} has Checks_performed_On_resources_And_Instances. NO_RULES_INVOLVED_INFORMATION_PURPOSE_ONLY"
        echo "${tfp_rk}" | jq '.' > ${3}/${2}_${4}_tfp_rk.json
    fi

#Project Id Processing Start
          #echo "INFO: gcp_projectid_process_hash info"
          declare -A gcp_projectid_process_tmp_hash
          for all_ids in `echo "${gcp_projectid_process_hash[@]}" | tr ' ' '\n' | sort -u | grep -v "NONE" | grep -v "null"`
          do
              gcp_projectid_process_tmp_hash["${all_ids}"]="${all_ids}"
          done
          id_ct=$(echo "${#gcp_projectid_process_tmp_hash[@]}")
          id_ct=${id_ct:-NONE}
          if [ "${id_ct}" != "NONE" ]; then
               gcp_projectid=$(echo "${gcp_projectid_process_tmp_hash[@]}" | cut -d " " -f 1)
          else
               gcp_projectid=$(echo "0000-0000-0000-0000-0000")
          fi
#Project Id Processing End
    
    STS_ACCT_ID=$(echo "${gcp_projectid}" | sed 's/\"//g' | sed 's/=//')
    ECHO "INFO: gcp_projectid ${gcp_projectid}"
    tfp_data_info_hash[${2}_${4}_tfp_acctid_value]="${STS_ACCT_ID}"
    ll_tfp=$(echo "${ll_tfp}|tfp_acctid_value")
    ECHO "INFO: GCP STS_ACCT_ID ${STS_ACCT_ID}"
    tfp_data_info_hash[${2}_${4}_tfp_tag_len]=$(echo "${tag_len}")
    tfp_info_hash[${tfp_root_key}]="${ll_tfp}"
}
