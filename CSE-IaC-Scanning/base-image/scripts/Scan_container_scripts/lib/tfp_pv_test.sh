#!/usr/bin/env sh



declare -A tfp_pv_info_hash

    tfp_pv=$(echo "tfp_pv")
    tfp_pvc=$(echo "tfp_pvc")
    tfp_pvr=$(echo "tfp_pvr")
    tfp_get_key=$(echo "${tfp_pv}")
    tfp_file=${1:-NONE}
    if [ "${tfp_file}" == "NONE" ]; then
         echo "Usage $0 File_name_with_full_path required. File Missing. Exit 100"
         exit 100
    fi
#/tmp/iac_scan_status/tfp/2024/20241011-41-285/daily_tfp/S00431_844_azure.json
    leaf_nm=$(basename ${tfp_file})
    dir_nm=$(dirname ${tfp_file})
    tfp_cld=$(echo "${leaf_nm}" | cut -d "_" -f 3 | cut -d "." -f 1)
    tfp_sig=$(echo "${leaf_nm}" | cut -d "_" -f 1-2)
    #echo "INFO: File ${tfp_file} cloud ${tfp_cld}"
    dir_nm=$(echo "${dir_nm}" | sed 's/daily_//')
    dir_nm=$(echo "${dir_nm}/split_process")
    #echo "INFO: File ${tfp_file} cloud ${tfp_cld} ${tfp_sig} ${dir_nm}"
    #read SSSSS
    mkdir -p ${dir_nm}


cloud_gcp  ()
{

                      #echo "${tfp_pv}" | jq '.' > ${dir_nm}/${tfp_sig}_${tfp_cld}_tfp_pv_rec_k${1}_s${2}_t${3}_rm.json
                      echo "${1}" | jq '.' > ${2}_rm.json
                      tfp_pv_srp=$(echo "${1}"|  jq '.[]|[ { "service_reource":.type,"service_name":.name, "resources_from": .resources_from, "properties_already_set":.values, "tags_already_set":.values.labels}]' | jq -s '.')
                      echo "${tfp_pv_srp}" > ${2}_srv.json
                      get_tag_for_this_tfp_from_pv=$(echo "${tfp_pv_srp}" | jq '.[]|.[]|.tags_already_set|select(.!=null)|values|select(.applicationid)' | jq -s '.' | jq '.|sort|unique' | grep -v createdondate | jq '.|sort|unique|values|select(.[].applicationid)|.[]' | jq -s '.' | jq -n 'input|sort|unique|.[0]' |  jq ' def n: if . == "" then {} else . end; def nk: if . == null then {} else . end; (.|nk|n)')
                      get_tag_for_this_tfp_from_pv=${get_tag_for_this_tfp_from_pv:-tfp_pv_tag}
                      cat ${2}_srv.json 2>/dev/null | jq '.[]|.[]|{"srv":.service_reource,"srv_name":.service_name, "resources_from": .resources_from,"properties":.properties_already_set|keys|join("|"),"values":.properties_already_set}'  | jq -n -s  '.|{tf:[input]}|.tf[]|[{"total_resources":length,"tf":values}]' > ${2}_srp.json

                      echo "INFO: FILE: 1.tfp_pv_rm ${2}_rm.json"
                      echo "INFO: FILE: 2.tfp_pv_srv ${2}_srv.json"
                      echo "INFO: FILE: 2.tfp_pv_srp ${2}_srp.json"
                      resource_len=$(cat ${2}_srp.json 2>/dev/null | jq '.[].total_resources')
                      resource_len=${resource_len:-0}
                      if [ ${resource_len} -eq ${5} ]; then
                         echo "INFO: RESOURCE_FILE_WRITTEN"
                      else
                         echo "INFO_ERR: RESOURCE_FILE_MIS_MATCH"
                      fi

                      tfp_pv_info_hash["${3}_${4}_tfp_pv_srp"]=$(cat ${2}_srp.json)

                      ll_tfp=$(echo "${ll_tfp}|tfp_pv_srp")
}

cloud_azure ()
{

                      #echo "${tfp_pv}" | jq '.' > ${dir_nm}/${tfp_sig}_${tfp_cld}_tfp_pv_rm.json
                      echo "${1}" | jq '.' > ${2}_rm.json
                      tfp_pv_srp=$(echo "${1}" | jq '.[]|[ { "service_reource":.type,"service_name":.name, "resources_from": .resources_from, "properties_already_set":.values, "tags_already_set":.values.tags}]' | jq -s '.')
                      echo "${tfp_pv_srp}" > ${2}_srv.json
                      get_tag_for_this_tfp_from_pv=$(echo "${tfp_pv_srp}" | jq '.[]|.[]|.tags_already_set|select(.!=null)|values|select(.applicationname)' | jq -s '.' | jq '.|sort|unique' | grep -v createdondate | jq '.|sort|unique|values|select(.[].applicationname)|.[]' | jq -s '.' | jq -n 'input|sort|unique|.[0]' |  jq ' def n: if . == "" then {} else . end; def nk: if . == null then {} else . end; (.|nk|n)')
                      get_tag_for_this_tfp_from_pv=${get_tag_for_this_tfp_from_pv:-tfp_pv_tag}
                      cat ${2}_srv.json 2>/dev/null | jq '.[]|.[]|{"srv":.service_reource,"srv_name":.service_name, "resources_from": .resources_from, "properties":.properties_already_set|keys|join("|"),"values":.properties_already_set}' | jq -n -s  '.|{tf:[input]}|.tf[]|[{"total_resources":length,"tf":values}]' > ${2}_srp.json
                      echo "INFO: FILE: 1.tfp_pv_rm ${2}_rm.json"
                      echo "INFO: FILE: 2.tfp_pv_srv ${2}_srv.json"
                      echo "INFO: FILE: 2.tfp_pv_srp ${2}_srp.json"
                      resource_len=$(cat ${2}_srp.json 2>/dev/null | jq '.[].total_resources')
                      resource_len=${resource_len:-0}
                      if [ ${resource_len} -eq ${5} ]; then
                         echo "INFO: RESOURCE_FILE_WRITTEN"
                      else
                         echo "INFO_ERR: RESOURCE_FILE_MIS_MATCH"
                      fi

                      tfp_pv_info_hash["${3}_${4}_tfp_pv_srp"]=$(cat ${2}_srp.json)

                      ll_tfp=$(echo "${ll_tfp}|tfp_pv_srp")
}

    if [ "${tfp_get_key}" == "tfp_pv" ]; then
                  tfp_pvrc_all=$(cat ${tfp_file} | jq '.planned_values' | jq --slurp 'reduce .[] as $item ({}; . * $item)')
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
                  echo "INFO_DEBUG: FILE ${tfp_file} START"
                  #echo "INFO_DEBUG_TFP_PV: resources_from=${resources_from} tfp_pvrc_length=${tfp_pvrc_length}  total_tfp_pv_length=${total_tfp_pv_length}, total_cr=${total_cr}, total_cr_chk=${total_cr_chk}, tfp_pvrc_c_length=${tfp_pvrc_c_length}, tfp_pvrc_r_length=${tfp_pvrc_r_length}" 
                  file_storage_prefix=$(echo "${dir_nm}/${tfp_sig}_${tfp_cld}_tfp_pv_rec_k${tfp_pvrc_length}_s${total_tfp_pv_length}_t${resources_from}")
                  cloud_${tfp_cld} "${tfp_pv}" "${file_storage_prefix}" "${tfp_sig}" "${tfp_cld}" "${total_tfp_pv_length}" # "${tfp_pvrc_length}" "${total_tfp_pv_length}" "${resources_from}"
                  echo "INFO_DEBUG: FILE ${tfp_file} END"
       fi
