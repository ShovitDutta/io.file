
prepare_exception_process_filter_files ()
{
   ECHO "INFO: TYPE INDIRECT FN-NAME prepare_exception_process_filter_files"
   files_ar=()
   files_ar=$(echo "${2}" | tr '/' ' ')
   key_combo=$(echo "")
   for all_structure in `echo "${files_ar[@]}" | tr ' ' '\n'`
   do
      key_combo=$(echo "${key_combo}/${all_structure}" | sed 's/^\///')
      exception_process_levels_based_files_hash["${key_combo}"]="${3}/${1}/${key_combo}/${all_structure}.csv" 
   done
   for all_dir in `echo "${!exception_process_levels_based_files_hash[@]}"`
   do
        ECHO "INFO: key - ${all_dir}"
        get_val=$(echo "${exception_process_levels_based_files_hash[${all_dir}]}")     
        ECHO "INFO: value - ${get_val}"
   done
}

get_exception_process_list ()
{
   ECHO "INFO: TYPE INDIRECT FN-NAME get_exception_process_list"
   let obj_files_count=0
   if [ "${exception_process_enabled}" == "YES" ]; then
       #ECHO "INFO: CMD- gcloud storage ls -R  gs://dev-cvs-scan-reports/${1}"
       ECHO "INFO: CMD- gcloud storage ls -R  gs://${my_current_buk_exp}/${1}"
       #exception_directory_root_obj_folder_ar=$(gcloud storage ls -R  gs://${my_current_buk_exp}/${1} 2>/dev/null | tr '\n' ' ')
       exception_directory_root_obj_folder_ar=$(gcloud storage ls -R  gs://${my_current_buk_exp}/${1} 2>/dev/null)
       if [ ${#exception_directory_root_obj_folder_ar[@]} -gt 0 ]; then
          ECHO "INFO: Exception_list_found. ${#exception_directory_root_obj_folder_ar[@]}"
          for all_files in `echo "${exception_directory_root_obj_folder_ar[@]}" | tr ' ' '\n' |  grep  "\.csv$"`
          do
                let obj_files_count=${obj_files_count}+1
                bsn=$(dirname ${all_files})
                key=$(echo "${bsn}" | cut -d "/" -f 5-)
                ECHO "INFO: all_files ${all_files} key ${key}"
                exception_process_all_levels_based_files_hash[${key}]="${all_files}"
          done
          let index=0
          if [ ${obj_files_count} -gt 0 ]; then
             mkdir -p /tmp/${1}
             for all_csvs_to_current_ldap in `echo "${!exception_process_levels_based_files_hash[@]}"`
             do
                ECHO "INFO: Files to pull from s3 ${all_csvs_to_current_ldap}"
                get_file_loc=$(echo "${exception_process_all_levels_based_files_hash[${all_csvs_to_current_ldap}]}")
                get_file_loc1=$(basename "${get_file_loc}" | grep "\.csv$")
                get_file_loc1=${get_file_loc:-NONE}
                if [ "${get_file_loc1}" != "NONE" ]; then
                 ECHO "INFO: Files to pull from obj  key  ${all_csvs_to_current_ldap} File ${get_file_loc}"
                 gcloud storage cp ${get_file_loc} /tmp/${1} 2>/dev/null 1>/dev/null
                else
                 ECHO "INFO: NO_FILES_IN_OBJ_STORE_KEY ${all_csvs_to_current_ldap}"
                fi
             done
             exception_process_levels_csv_files_of_cvsids_ar=$(ls -C1 /tmp/${1}/*.csv 2>/dev/null)
              all_tmp_files=$(echo "/tmp/${1}")
              ECHO "INFO: Processing_file ${all_tmp_files}"
              cd ${all_tmp_files} 2>/dev/null 1>/dev/null
              exception_process_cvsid_list=$(cat * 2>/dev/null | sort -u |  cut -d "," -f 1 | grep -v "0.0.0.0" |  tr '\n' ',' | sed 's/\,$//')
              cd - 2>/dev/null 1>/dev/null
             ECHO "INFO: EXCEPTION_CVSID_LIST_OBJ ${exception_process_cvsid_list}"
           fi
       fi
   fi
   exception_process_cvsid_list=${exception_process_cvsid_list:-0.0.0.0}
}
get_glb_exception_process_list ()
{    
   ECHO "INFO: TYPE INDIRECT FN-NAME get_glb_exception_process_list"
   global_exception_file=$(echo "gs://${my_current_buk_exp}/iac_all_exception_list/all.csv")
   ECHO "INFO: global_exception_file ${global_exception_file} process -Start"
   gcloud storage cp ${global_exception_file} /tmp/all.csv 2>/dev/null 1>/dev/null
   exception_process_all_glb_ids=$(cat /tmp/all.csv 2>/dev/null | sort -u |  cut -d "," -f 1 |  tr '\n' ',' | sed 's/\,$//')
   exception_process_all_glb_ids=${exception_process_all_glb_ids:-NONE}
   echo "INFO: global_exception_list ${exception_process_all_glb_ids}"
   ECHO "INFO: global_exception_file ${global_exception_file} process -End"
}

test_remote_object_list ()
{
    ECHO "INFO: TYPE INDIRECT FN-NAME test_remote_object_list"
    gcp_ct=$(ls -C1 /apps/gcp 2>/dev/null | wc -l)
    if [ ${gcp_ct} -gt 0 ]; then
       GCLOUD_STORAGE_PUSH=(`echo "Y"`)
    else
        ECHO "WARN: gcloud VERIFICATION_ISSUES"
        ECHO "WARN: gcloud acct not set for PIPELINE ${pipeline_nm}. ignoring. NOT_ABLE_TO_PUSH_RPT_FILES"
        GCLOUD_STORAGE_PUSH=(`echo "N"`)
    fi
}


    declare -A cld_map

    cld_map['azure']="AZURE"
    cld_map['gcp']="GCP"
    cld_map['aws']="AWS"

chk_cloud ()
{
    ECHO "INFO: FUNCTION_NAME chk_cloud"

    ##echo "INFO: TFP_FILE=${1} Start"
    cloud_gcp=$(cat ${1} | jq -Mr '.configuration.provider_config|keys|sort| .[0] | select( . == "google" )')
    cloud_gcp=${cloud_gcp:-NONE}
    cloud_azure=$(cat ${1} | jq -Mr '.configuration.provider_config|keys|sort| .[0] | select( . == "azurerm" )')
    cloud_azure=${cloud_azure:-NONE}
    cloud_aws=$(cat ${1} | jq -Mr '.configuration.provider_config|keys|sort| .[0] | select( . == "aws" )')
    cloud_aws=${cloud_aws:-NONE}
    ##echo "INFO: ${cloud_gcp},${cloud_azure},${cloud_aws}"
    if [ ${cloud_azure} != "NONE" ]; then
       tfp_terraform_cloud_hash[${2}]="azure"
    else
       cloud_azure_ct=$(cat ${1} | jq -r '.' |  grep "provider_name" | cut -d ":" -f 2 | sed 's/\"//g' | sed 's/\,$//' | cut -d "/" -f 3 | sort -u |  grep -i azure | wc -l)
       cloud_azure_ct=${cloud_azure_ct:-0}
       if [ ${cloud_azure_ct} -gt 0 ]; then
          tfp_terraform_cloud_hash[${2}]="azure"
       fi
    fi

    if [ ${cloud_gcp} != "NONE" ]; then
       tfp_terraform_cloud_hash[${2}]="gcp"
    else
       cloud_gcp_ct=$(cat ${1} | jq -r '.' |  grep "provider_name" | cut -d ":" -f 2 | sed 's/\"//g' | sed 's/\,$//' | cut -d "/" -f 3 | sort -u |  grep -i google | wc -l)
       cloud_gcp_ct=${cloud_gcp_ct:-0}
       if [ ${cloud_gcp_ct} -gt 0 ]; then
             tfp_terraform_cloud_hash[${2}]="gcp"
       fi
    fi

    if [ ${cloud_aws} != "NONE" ]; then
       tfp_terraform_cloud_hash[${2}]="aws"
    else
       cloud_aws_ct=$(cat ${1} | jq -r '.' | grep "provider_name" | cut -d ":" -f 2 | sed 's/\"//g' | sed 's/\,$//' | cut -d "/" -f 3 | sort -u |  grep -i "aws" | wc -l)
       cloud_aws_ct=${cloud_aws_ct:-0}
       if [ ${cloud_aws_ct} -gt  0 ]; then
          tfp_terraform_cloud_hash[${2}]="aws"
       fi
    fi

    #cloud_gcp_ct=$(cat ${1} | jq -r '.' |  grep "provider_name" | cut -d ":" -f 2 | sed 's/\"//g' | sed 's/\,$//' | cut -d "/" -f 3 | sort -u |  grep -i google | wc -l)
    #cloud_gcp_ct=${cloud_gcp_ct:-0}
    #cloud_azure_ct=$(cat ${1} | jq -r '.' |  grep "provider_name" | cut -d ":" -f 2 | sed 's/\"//g' | sed 's/\,$//' | cut -d "/" -f 3 | sort -u |  grep -i azure | wc -l)
    #cloud_azure_ct=${cloud_azure_ct:-0}
    #cloud_aws_ct=$(cat ${1} | jq -r '.' | grep "provider_name" | cut -d ":" -f 2 | sed 's/\"//g' | sed 's/\,$//' | cut -d "/" -f 3 | sort -u |  grep -i "aws" | wc -l)
    #cloud_aws_ct=${cloud_aws:-0}

    ##echo "INFO: ${cloud_gcp},${cloud_azure},${cloud_aws}"
    #if [ ${cloud_azure} -gt 0 ]; then
    #   tfp_terraform_cloud_hash[${2}]="azure"
    #fi
    #if [ ${cloud_gcp} -gt 0 ]; then
    #   tfp_terraform_cloud_hash[${2}]="gcp"
    #fi
    #if [ ${cloud_aws} -gt  0 ]; then
    #   tfp_terraform_cloud_hash[${2}]="aws"
    #fi
    CLOUD=$(echo "${tfp_terraform_cloud_hash[${2}]}")
    CLOUD=${CLOUD:-NONE}
    if [ "${CLOUD}" == "NONE" ]; then
       tfp_terraform_cloud_hash[${2}]="NONE"
    fi
    echo "INFO: TFP_FILE=${1},CLOUD=${tfp_terraform_cloud_hash[${2}]},SIGNAURE=${2}"
    get_ucld=$(echo "${cld_map[${CLOUD}]}")
    #echo "INFO: TFP_FILE=${1} End"
}

