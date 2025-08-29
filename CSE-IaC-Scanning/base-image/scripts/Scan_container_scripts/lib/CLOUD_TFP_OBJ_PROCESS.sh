azure_tfp_obj_key_process ()
{
    ECHO "INFO: FUNCTION_NAME azure_tfp_obj_key_process"

          #echo "INFO: TFP_FILE=${1}"
          collect_resources=()
          collect_resources=(`cat ${1}| jq '.configuration.provider_config|keys' | jq '.| join("|")' | sed 's/\"//g' | tr '|' '\n'`)
          collect_only_azure_resources=()
          collect_only_azure_resources=(`echo "${collect_resources[@]}" | tr ' ' '\n'`) # | grep "^azurerm"`)
          collect_only_modules=()
          collect_only_modules=(`echo "${collect_resources[@]}" | tr ' ' '\n' | grep -v  "^azurerm"`)
          total_resources=$(echo "${#collect_only_azure_resources[@]}")

          if [ "${total_resources}" -gt  0 ]; then
                azure_subscription_id=$(cat ${1} | jq '.configuration.provider_config.azurerm.expressions.subscription_id.constant_value?' | sed 's/\"//g' |  sed 's/null//')
                azure_subscription_id=${azure_subscription_id:-NONE}
          else
                echo "INFO: NO_AZURE_CLOUD_RESOURCES_USED_FOR_THIS_DEPLOYMENT(ONLY_SOFT_RESOURCES)"
                azure_subscription_id=$(cat ${1} | jq '.prior_state.values.root_module.child_modules[].resources[0].values.subscription_id?' | sed 's/\"//g' |  sed 's/null//')
                azure_subscription_id=${azure_subscription_id:-NONE}
          fi

          if [ "${azure_subscription_id}" == "NONE" ]; then
              azure_subscription_id=$(echo "0000-0000-0000-0000-0000")
          fi
              STS_ACCT_ID=$(echo "${azure_subscription_id}")
              tfp_acctid_hash[${2}]="${STS_ACCT_ID}"
              #echo "INFO: AZURE STS_ACCT_ID ${STS_ACCT_ID}"

}

gcp_tfp_obj_key_process ()
{
    ECHO "INFO: FUNCTION_NAME gcp_tfp_obj_key_process"
          collect_resources=()
          collect_resources=(`cat ${1}| jq '.configuration.provider_config|keys' | jq '.| join("|")' | sed 's/\"//g' | tr '|' '\n'`)
          collect_only_google_resources=()
          collect_only_google_resources=(`echo "${collect_resources[@]}" | tr ' ' '\n'`) # | grep "^google"`)
          collect_only_modules=()
          collect_only_modules=(`echo "${collect_resources[@]}" | tr ' ' '\n' | grep -v  "^google"`)
          total_resources=$(echo "${#collect_only_google_resources[@]}")
                           
          cloud=$(echo "google")
          pj=$(echo "project")
          gcp_projectid_from_cf=${gcp_projectid_from_cf:-NONE}
          gcp_projectid_from_rc=${gcp_projectid_from_rc:-NONE}
          gcp_projectid=$(echo "0000-0000-0000-0000-0000")
          gcp_projectid_from_gv==${gcp_projectid_from_gv:-NONE}
          if [ "${total_resources}" -gt  0 ]; then
              gcp_projectid_from_cf=$(cat ${1} | jq -Mr --arg cld "$cloud" --arg acctid "$pj" '.configuration|select( . != null)| .provider_config[$cld].expressions[$acctid].constant_value|select( . != null)')
              gcp_projectid_from_cf=${gcp_projectid_from_cf:-NONE}
              gcp_projectid_from_gv=$(cat ${1} | jq '.variables|select( . != null)|.project_id|select( . != null)|.value|select( . != null)')
          else
              #get from resource_changes
              gcp_projectid_from_rc=$(cat ${1} | jq -Mr --arg cld "$cloud" --arg acctid "$pj" '.resource_changes|.[0]| select( . != null)|.change|.before?|.project|select( . != null)')
              gcp_projectid_from_rc=$(cat ${1} | jq -Mr --arg cld "$cloud" --arg acctid "$pj" '.resource_changes|.[0]|.change|.before?|select( . != null)| .project|select( . !=null)')
              gcp_projectid_from_rc=${gcp_projectid_from_rc:-NONE}
              gcp_projectid_from_gv=$(cat ${1} | jq '.variables|select( . != null)|.project_id|select( . != null)|.value|select( . != null)')
          fi
          if [ "${gcp_projectid_from_gv}" != "NONE" ]; then
                gcp_projectid=$(echo "${gcp_projectid_from_gv}")
          fi
          if [ "${gcp_projectid_from_rc}" != "NONE" ]; then
                gcp_projectid=$(echo "${gcp_projectid_from_rc}")
          fi

          if [ "${gcp_projectid_from_cf}" != "NONE" ]; then
                gcp_projectid=$(echo "${gcp_projectid_from_cf}")
          fi

          if [ "${gcp_projectid}" == "NONE" ]; then
                gcp_projectid=$(echo "0000-0000-0000-0000-0000")
          else
                ECHO "INFO_DEBUG: gcp_projectid ${gcp_projectid}"
          fi
             STS_ACCT_ID=$(echo "${gcp_projectid}")
             tfp_acctid_hash[${2}]="${STS_ACCT_ID}"
             #echo "INFO: GCP STS_ACCT_ID ${STS_ACCT_ID}"
}

aws_tfp_obj_key_process ()
{
    ECHO "INFO: FUNCTION_NAME aws_tfp_obj_key_process"
}

cloud_tfp_obj_key_process ()
{
    ECHO "INFO: FUNCTION_NAME cloud_tfp_obj_key_process"
    my_cloud=$(echo "${tfp_terraform_cloud_hash[${2}]}")
    #ECHO "INFO: cloud_tfp_obj_key_process cp ${1} ${tfp_daily_dir}/${2}_${my_cloud}.tfplan"
    #cp ${1} ${tfp_daily_dir}/${2}_${my_cloud}.tfplan
    ECHO "INFO: Calling FN- ${my_cloud}_tfp_obj_key_process ${1} ${2}"
    ${my_cloud}_tfp_obj_key_process ${1} ${2}
}
