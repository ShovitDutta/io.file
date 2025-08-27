#!/usr/bin/env sh

#2023_10_13-15_46_50-1697212010-41_2023-286
  build_id_run_str=$(date '+%Y_%m_%d-%H_%M_%S-%s-%W_%Y-%j')
#20231013-15_46_50-1697212010-41_2023-286
  Ymd=$(echo "${build_id_run_str}" | cut -d "-" -f 1)
  YEAR=$(echo "${Ymd}" | cut -d "_" -f 1)
  MONTH=$(echo "${Ymd}" | cut -d "_" -f 2)
  DAY_OF_MONTH=$(echo "${Ymd}" | cut -d "_" -f 3)
#20231013
  RUN_DATE=$(echo "${YEAR}${MONTH}${DAY_OF_MONTH}")
  HMS_KEY=$(echo "${build_id_run_str}" | cut -d "-" -f 2)
  HOUR_KEY=$(echo "${HMS_KEY}" | cut -d"_" -f 1)
  MINUTE_KEY=$(echo "${HMS_KEY}" | cut -d"_" -f 2)
  SECOND_KEY=$(echo "${HMS_KEY}" | cut -d"_" -f 3)
#1697212010
  ID=$(echo "${build_id_run_str}" | cut -d "-" -f 3)
#41_2023
  WEEK_YEAR_KEY=$(echo "${build_id_run_str}" | cut -d "-" -f 4)
#41_2023
  WEEK=$(echo "${WEEK_YEAR_KEY}" | cut -d "_" -f 1)
#286
  DAY_OF_YEAR=$(echo "${build_id_run_str}" | cut -d "-" -f 5)
#20231013-15_46_50-1697212010-412023-286
  build_id_run=$(echo "${RUN_DATE}-${HMS_KEY}-${ID}-${WEEK}${YEAR}-${DAY_OF_YEAR}")
#20231013-41-286
  STORAGE_FOLDER_KEY1=$(echo "${RUN_DATE}-${WEEK}-${DAY_OF_YEAR}")
#1697212010-20231013-41-286
  STORAGE_FOLDER_KEY2=$(echo "${ID}-${STORAGE_FOLDER_KEY1}")

  echo "INFO:build_id_run=${build_id_run}, STORAGE_FOLDER_KEY1=${STORAGE_FOLDER_KEY1},STORAGE_FOLDER_KEY2=${STORAGE_FOLDER_KEY2}"
  echo "INFO:RUN_DATE=${RUN_DATE}, YEAR=${YEAR},ID=${ID}"
  echo "INFO:WEEK=${WEEK}, DAY_OF_MONTH=${DAY_OF_MONTH},HOUR_KEY=${HOUR_KEY}"
  echo "INFO:MINUTE_KEY=${MINUTE_KEY}, SECOND_KEY=${SECOND_KEY},DAY_OF_YEAR=${DAY_OF_YEAR}"
  #ID=$(date '+%s')
  #WEEK=$(date '+%W')
  #RUN_DATE=$(date '+%Y%m%d')
  #RSTORAGE_FOLDER_KEY1=$(date '+%Y%m%d-%W-%j')
  #RSTORAGE_FOLDER_KEY2=$(date '+%s-%Y%m%d-%W-%j')
  #HOUR_KEY=$(date '+%H')
  #DAY_OF_MONTH=$(date '+%d')

  let get_tf_version=$( jq .terraform_version ${1} | sed 's/\.//g' | sed 's/\"//g')
  get_tf_version=${get_tf_version:-0}

  if [ ${get_tf_version} -eq 0 ]; then
         echo "WARN: file ${1} is not terraform_plan_output. Exiting"
         exit 100
  fi

  let get_tf_format=$( jq .format_version ${1} | sed 's/\.//g' | sed 's/\"//g')
  tf_plan_unique_hash=(`cat ${1} | jq . | sum | awk '{print $1,$2}' | tr ' ' '_'| awk '{ print "S"$1}'`)

  gl_rpt_dir=$(echo "/rpt/rpt_${STORAGE_FOLDER_KEY1}")

  mkdir -p ${gl_rpt_dir}
  cat ${1} | jq . > ${gl_rpt_dir}/${tf_plan_unique_hash}.json

  if [ ${get_tf_version} -gt 142 ]; then
#{
#  "format_version": "1.1",
#  "terraform_version": "1.4.3",
#  "planned_values": {
#    "root_module": {
#      "child_modules": [
#        {
#          "resources": [
#            {
#              "address": "module.spoke_clin_prod.azurerm_application_insights.app_insights[\"-clr-api-oci-prod2\"]",
#              "mode": "managed",
#              "type": "azurerm_application_insights",
#              "name": "app_insights",
#              "index": "-clr-api-oci-prod2",
#              "provider_name": "registry.terraform.io/hashicorp/azurerm",
#              "schema_version": 1,
#          "values": {
#            "enabled": true,
#            "timeouts": null
#           },
#          "sensitive_values": {}
#          }
#        ]
#       }
#      ]
#    }
#  }
#}
      echo "INFO: Newer version ${get_tf_version}"
      echo "{" >${gl_rpt_dir}/${tf_plan_unique_hash}_resource.json
      echo "\"format_version\":\"${get_tf_format}\"," >>${gl_rpt_dir}/${tf_plan_unique_hash}_resource.json
      echo "\"terraform_version\":\"${get_tf_version}\"," >>${gl_rpt_dir}/${tf_plan_unique_hash}_resource.json
      echo "\"resources\":" >>${gl_rpt_dir}/${tf_plan_unique_hash}_resource.json
      cat ${gl_rpt_dir}/${tf_plan_unique_hash}.json | jq -r '.planned_values.root_module.child_modules[].resources[0:]' >>${gl_rpt_dir}/${tf_plan_unique_hash}_resource.json
      echo "}" >>${gl_rpt_dir}/${tf_plan_unique_hash}_resource.json
  else
#{
#  "format_version": "1.1",
#  "terraform_version": "1.4.2",
#  "planned_values": {
#    "outputs": {
#      "resource_group_name": {
#        "sensitive": false
#      }
#    },
#    "root_module": {
#      "resources": [
#        {
#          "address": "azurerm_advanced_threat_protection.tp1",
#          "mode": "managed",
#          "type": "azurerm_advanced_threat_protection",
#          "name": "tp1",
#          "provider_name": "registry.terraform.io/hashicorp/azurerm",
#          "schema_version": 1,
#          "values": {
#            "enabled": true,
#            "timeouts": null 
#          },
#          "sensitive_values": {}
#        }
#      ]
#    }
#  }
#} 
      echo "INFO: Older version ${get_tf_version}"
      echo "{" >${gl_rpt_dir}/${tf_plan_unique_hash}_resource.json
      echo "\"format_version\":\"${get_tf_format}\"," >>${gl_rpt_dir}/${tf_plan_unique_hash}_resource.json
      echo "\"terraform_version\":\"${get_tf_version}\"," >>${gl_rpt_dir}/${tf_plan_unique_hash}_resource.json
      echo "\"resources\":" >>${gl_rpt_dir}/${tf_plan_unique_hash}_resource.json
      cat ${gl_rpt_dir}/${tf_plan_unique_hash}.json | jq -r '.planned_values.root_module.resources[0:]' >>${gl_rpt_dir}/${tf_plan_unique_hash}_resource.json
      echo "}" >>${gl_rpt_dir}/${tf_plan_unique_hash}_resource.json
  fi

  resource_keys_str=$(cat  ${gl_rpt_dir}/${tf_plan_unique_hash}_resource.json | jq -r '.resources[]| keys' | sort -u | grep -v "\[" | tr '\n' ' ')
  resource_keys_ar=$(echo "[${resource_keys_str}")
  echo "${resource_keys_ar}" | jq .
  
     #cat ${1}  | jq '.| keys,values' | jq '.[]' | jq '.root_module| { keys:values }' | jq '.keys | { keys:values }' | jq '.keys'| jq '.[]' | jq -r . | jq .[] | jq -r | jq .resources[0:] | grep -v "jq: error" >w1.json
#/workspace/sample_tf.json version 1.4.3
#/workspace/sample_tf.json version 1.4.1
     #cat ${1}  | jq '.| keys,values' | jq '.[]' | jq '.root_module | keys,values' | jq -r .resources[0:] | more
