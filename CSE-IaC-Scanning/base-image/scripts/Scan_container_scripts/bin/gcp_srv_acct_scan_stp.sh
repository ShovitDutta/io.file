#!/usr/bin/env sh

     export PATH=${PATH}:/apps/bin:/apps/kics/bin:/apps/snyk/bin:/apps/opa/bin:/apps/gcp/google-cloud-sdk/bin:/apps/hc/tf:/apps/hc/vault:/apps/hc/consul:/apps/hc/bin
     echo "INFO: Running $0 script"
     . /apps/.ciss


#Cloud related OPS - Start

  WHO_AM_I=$(whoami)
  echo "INFO: RUN_TIME_INFO: ${WHO_AM_I}"

  GCLOUD_STORAGE_PUSH=(`echo "Y"`)


  my_current_buk_exp=$(echo "current_buk_exp")
  my_current_buk_scan=$(echo "current_buk_scan")
  my_proj_based_service_acct_fqdn=$(echo "current_buk_scan")
test_remote_object_list ()
{
    echo "INFO: TYPE INDIRECT FN-NAME test_remote_object_list"
    echo "INFO: using gcloud (${1}) to list few files..."
    echo "INFO: cmd-gcloud_list=${my_current_buk_exp}"
    gcloud_list=$(gcloud storage ls gs://${my_current_buk_exp} 2>/dev/null | wc -l)
    if [ "${gcloud_list}" -gt 0 ]; then
        echo "INFO: gcloud CT_${gcloud_list}_VERIFICATION_OK"
        GCLOUD_STORAGE_PUSH=(`echo "Y"`)
    else
        echo "WARN: ${gcloud_list}  gcloud VERIFICATION_ISSUES"
        echo "WARN: gcloud acct not set for PIPELINE ${pipeline_nm}. ignoring. NOT_ABLE_TO_PUSH_RPT_FILES"
        GCLOUD_STORAGE_PUSH=(`echo "N"`)
    fi
}
  my_proj_json_info=$(echo '{"my_status":"NONE"}')
  root_config_tar=$(echo "NONE")
  env_based_on_storage=$(echo "stage")
sync_config ()
{

          echo "INFO: TYPE DIRECT FN-NAME sync_config"
          echo "INFO: Sync - config"
          echo "INFO: proj_info_status ${proj_info_status}"
          if [ ${proj_info_status} == "NONE" ]; then
                gcloud_file_ct=$(tar -tvf /apps/config/root_config.tar | wc -l)
                echo "INFO: Signature ${gcloud_file_ct}"
                rm -rf /root/.config
                cd 1>/dev/null
                echo "INFO - dir `pwd`"
                untar_stat=(`tar -xvf /apps/config/root_config.tar | tr '\n' ' '`)
                untar_ct=(`echo "${#untar_stat[@]}"`)
                if [ "${gcloud_file_ct}" -eq "${untar_ct}" ]; then
                     proj_based_service_acct_tf=$(tar -tvf /apps/config/root_config.tar | grep "\.json" | cut -d "/" -f 3- | grep -v last_update_check.json)
                     proj_based_service_acct_tf=${proj_based_service_acct_tf:-NONE}
                     echo "INFO: proj_based_service_acct_tf ${proj_based_service_acct_tf}"
                     if [ "${proj_based_service_acct_tf}" != "NONE" ]; then
                         proj_based_service_acct_fqdn=$(echo "${proj_based_service_acct_tf}" | cut -d "/" -f 4)
                         proj_based_service_acct_fqdn=${proj_based_service_acct_fqdn:-NONE}
                         set_buk_based_on_proj "*.json"
                     else
                         proj_based_service_acct_fqdn=${proj_based_service_acct_fqdn:-NONE}
                     fi
                     echo "INFO: config directory CREATION_OK"
                fi
                cd - 1>/dev/null
                echo "INFO - dir `pwd`"
          else
               :
          fi
          my_proj_json_info=$(cat /apps/.config/proj_info.json)
}
probe_sync_config ()
{
   if [ "${proj_info_status}" == "NONE" ]; then
      frcf=$(find /apps/config -name "*.tar" 2>/dev/null)
      frcf=${frcf:-NONE}
      echo "INFO: frcf ${frcf}"
      if [ "${frcf}" != "NONE" ]; then
         frcf_bsn=$(basename "${frcf}")
         echo "INFO: frcf_bsn ${frcf_bsn}"
         env_based_on_storage=$(echo "${frcf_bsn}" | cut -d "_" -f 1)
         cd /apps/config 1>/dev/null
         echo "INFO - dir `pwd`"
         case "${env_based_on_storage}" in
         "stage")
               mv ${frcf_bsn} root_config.tar
               #root_config_tar=$(echo "/apps/config/root_config.tar")
               env_based_on_storage=$(echo "stage")

              ;;
         "prod")
               mv ${frcf_bsn} root_config.tar
               env_based_on_storage=$(echo "prod")
               ;;
         "sb")
               mv ${frcf_bsn} root_config.tar
               env_based_on_storage=$(echo "prod")
               ;;
         *)
          root_config_tar=$(echo "NONE")
          env_based_on_storage=$(echo "NONE")
          echo "INFO: NO_STORAGE_NO_EXCEPTION"
          ;;
         esac
         echo "INFO: STORAGE_STATUS ${env_based_on_storage} ${proj_info_status}"
         cd - 1>/dev/null
         echo "INFO - dir `pwd`"
         sync_config
         #process_proj_name
      fi
    else
          chk_config_file=$(ls -C1 /apps/config/root_config.tar)
          echo "INFO: FILE_FOUND ${chk_config_file}"
          echo "INFO: STORAGE_STATUS TYPE=${env_based_on_storage} PROCESS_STATUS=${proj_info_status}"
          my_proj_json_info=$(cat /apps/.config/proj_info.json)
    fi
      process_proj_name
}
process_proj_name ()
{
          echo "INFO: TYPE DIRECT FN-NAME process_proj_name"
          #echo "${my_proj_json_info}" | jq '.'
          my_current_buk_exp=$(echo "${my_proj_json_info}" | jq -Mr '.current_buk_exp') # | sed 's/\"//g')
          my_current_buk_scan=$(echo "${my_proj_json_info}" | jq -Mr '.current_buk_scan') # | sed 's/\"//g')
          my_proj_based_service_acct_fqdn=$(echo "${my_proj_json_info}" | jq -Mr '.current_srv_acct_fqdn') # | sed 's/\"//g')
          echo "INFO: BUCKET_INFO_SCAN ${my_current_buk_exp} ${my_current_buk_scan}"
}

#just create a .config directory for cloud -Start
#sync from backup, test for acct, list few files from cloud storage
  probe_sync_config
  #sync_config
  #process_proj_name
  gcloud_acct_if_any=$(gcloud info | grep "Account:" | cut -d ":" -f 2 | sed 's/\[//' | sed 's/\]//' | sed 's/^ //')
  gcloud_acct_if_any=${gcloud_acct_if_any:-NONE}


  srv_acct=$(echo "${my_proj_based_service_acct_fqdn}")
  srv_acct=${srv_acct:-NONE}

  echo "INFO: srv_acct ${srv_acct}"
  echo "INFO: gcloud_acct_if_any ${gcloud_acct_if_any}"

set_srv_acct ()
{
  echo "INFO: TYPE DIRECT FN-NAME set_srv_acct"

  case "${1}" in
  "NONE")
         echo "WARN: Condition - NONE. gcloud acct not set. ignoring. NOT_ABLE_TO_PUSH_RPT_FILES"
         GCLOUD_STORAGE_PUSH=(`echo "N"`)
         ;;
  "None")
          echo "INFO: Condition - None.  ${HOME}/.config file mismatch."
          GCLOUD_STORAGE_PUSH=(`echo "N"`)
          echo "WARN: ${config_present} acct not set. ignoring. NOT_ABLE_TO_PUSH_RPT_FILES"
                 ;;
   *)
          echo "INFO: Condition - Default.  ${HOME}/.config Test."
          config_present=$(ls -R -C1 ${HOME}/.config/*  | grep "^${2}")
          config_present=${config_present:-NONE}
          echo "INFO: Condition - Default  config_present ${config_present}"
          if [ "${config_present}" != "NONE" ]; then
             test_remote_object_list "${config_present}"
          else
             GCLOUD_STORAGE_PUSH=(`echo "N"`)
             echo "WARN: ${config_present} acct not set."
          fi
          ;;
   esac
}

  set_srv_acct "${gcloud_acct_if_any}" "${srv_acct}"

#just create a .config directory for cloud -End
#Cloud related OPS - End



