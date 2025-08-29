#!/usr/bin/env sh

     export PATH=${PATH}:/apps/bin:/apps/kics/bin:/apps/snyk/bin:/apps/opa/bin:/apps/gcp/google-cloud-sdk/bin:/apps/hc/tf:/apps/hc/vault:/apps/hc/consul:/apps/hc/bin
     echo "INFO: Running $0 script"
     . /apps/.ciss


#Cloud related OPS - Start

  WHO_AM_I=$(whoami)
  echo "INFO: RUN_TIME_INFO: ${WHO_AM_I}"

  GCLOUD_STORAGE_PUSH=(`echo "Y"`)

  proj_based_service_acct_nm=$(echo "NONE")
  proj_based_service_acct_fqdn=$(echo "NONE")
  proj_based_service_acct_tf=$(echo "NONE")
  proj_nm=$(echo "NONE")

test_remote_object_list ()
{
    echo "INFO: TYPE INDIRECT FN-NAME test_remote_object_list"
    echo "INFO: using gcloud (${1}) to list few files..."
    gcloud_list=$(gcloud storage ls gs://dev-cvs-scan-reports 2>/dev/null | wc -l)
    if [ "${gcloud_list}" -gt 0 ]; then
        echo "INFO: gcloud CT_${gcloud_list}_VERIFICATION_OK"
        GCLOUD_STORAGE_PUSH=(`echo "Y"`)
    else
        echo "WARN: gcloud VERIFICATION_ISSUES"
        echo "WARN: gcloud acct not set for PIPELINE ${pipeline_nm}. ignoring. NOT_ABLE_TO_PUSH_RPT_FILES"
        GCLOUD_STORAGE_PUSH=(`echo "N"`)
    fi
}

sync_config ()
{

          echo "INFO: TYPE DIRECT FN-NAME sync_config"
          echo "INFO: Sync - config"
          gcloud_file_ct=$(tar -tvf /apps/config/root_config.tar | wc -l)
          echo "INFO: Signature ${gcloud_file_ct}"
          rm -rf /root/.config
          cd 1>/dev/null
          echo "INFO - dir `pwd`"
          untar_stat=(`tar -xvf /apps/config/root_config.tar | tr '\n' ' '`)
          untar_ct=(`echo "${#untar_stat[@]}"`)
          if [ "${gcloud_file_ct}" -eq "${untar_ct}" ]; then
               proj_based_service_acct_tf=$(tar -tvf /apps/config/root_config.tar | grep "\.json" | cut -d "/" -f 3- | grep -v last_update_check.json)
               proj_based_service_acct_tf=${proj_based_service_acct_tf:-NONE)
               if [ "${proj_based_service_acct_tf}" != "NONE" ]; then
                   proj_based_service_acct_fqdn=$(echo "${proj_based_service_acct_tf}" | cut -d "/" -f 4)
                   proj_based_service_acct_fqdn=${proj_based_service_acct_fqdn:-NONE}
               else
                   proj_based_service_acct_fqdn=${proj_based_service_acct_fqdn:-NONE}
               fi
               echo "INFO: config directory CREATION_OK"
          fi
          cd - 1>/dev/null
          echo "INFO - dir `pwd`"
}

process_proj_name ()
{
          echo "INFO: TYPE DIRECT FN-NAME process_proj_name"
          echo "INFO: STORAGE_LEVEL_INFO- proj_based_service_acct_fqdn ${proj_based_service_acct_fqdn}"
          proj_based_service_acct_nm=$(echo "${proj_based_service_acct_fqdn}" | cut -d "@" -f 1)
          proj_nm=$(echo "${proj_based_service_acct_fqdn}" | cut -d "@" -f 2 | cut -d "." -f 1)
          echo "INFO: STORAGE_LEVEL_INFO- proj_based_service_acct_nm ${proj_based_service_acct_nm}, proj_nm ${proj_nm}"
}

#just create a .config directory for cloud -Start
#sync from backup, test for acct, list few files from cloud storage

  sync_config
  process_proj_name
  read SSSSS
  gcloud_acct_if_any=$(gcloud info | grep "Account:" | cut -d ":" -f 2 | sed 's/\[//' | sed 's/\]//' | sed 's/^ //')
  gcloud_acct_if_any=${gcloud_acct_if_any:-NONE}


  srv_acct=$(echo "${proj_based_service_acct_tf}")
  srv_acct=${srv_acct:-NONE}

  echo "INFO: srv_acct ${srv_acct}"

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



