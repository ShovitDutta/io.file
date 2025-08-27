#!/usr/bin/env sh


      sarif_file_processed=$(echo "${1}")
      sarif_file_processed=${sarif_file_processed:-/workspace/scan/R-20241007-16_10_51-1728317451-412024-281-1728317451-CSE-Q3-CONTAINER/flatten_scan_result_file-azure_R-S50655_817_azure-20241007-16_10_51-1728317451-412024-281-1728317451-CSE-Q3-CONTAINER.pipe}
      sarif_rows_ar=()
      sarif_rows_ar=$(cat ${sarif_file_processed} | jq '.[]|values|join("|")' | sed 's/\t//g' | sed 's/\n//g')

      sarif_buffer=$(cat ${sarif_file_processed} | jq '.' | sed 's/\t//g' | sed 's/\n//g')

      total_records=$(echo "${sarif_buffer}" | jq 'length')
      echo "INFO: Total_recs: ${total_records}"
      declare -A sarif_columns_hash
      declare -A sarif_columns_from_scan_hash
      sarif_keys=$(cat ${sarif_file_processed} | jq '.[0]|keys_unsorted|sort|unique|join(",")'| sed 's/^\"//' | sed 's/\"$//')
      echo "INFO: keys sarif_keys ${sarif_keys}"
      for all_keys in `echo "${sarif_keys}" | tr ',' ' '`
      do
         sarif_columns_hash[${all_keys}]="${all_keys}"
      done
      read SSSSS
      let current_rec=0

      sarif_temp_ar=()
      while ( [ ${current_rec} -lt ${total_records} ] )
      do
         sarif_temp_ar[${current_rec}]=$(cat ${sarif_file_processed} | jq --arg rc "${current_rec}" '.[$rc|tonumber]|values'| sed 's/\t//g' | sed 's/\n//g') 
         echo "INFO: rc=${current_rec} and value ${sarif_temp_ar[${current_rec}]}"
         for all_keys_processed in `echo "${sarif_columns_hash[@]}"`
         do
             sarif_columns_from_scan_hash[${all_keys_processed}]=$(echo "${sarif_temp_ar[${current_rec}]}" | jq --arg KY "${all_keys_processed}" '.|.[$KY]')
             echo "INFO: PROCESSED Keys and Values ${all_keys_processed} ${sarif_columns_from_scan_hash[${all_keys_processed}]}"
         done
         #col3_values=()
         #col3_values[0]=$(echo "${sarif_temp_ar[${current_rec}]}" | jq '.query_id')
         #col3_values[1]=$(echo "${sarif_temp_ar[${current_rec}]}" | jq '.query_name')
         #col3_values[2]=$(echo "${sarif_temp_ar[${current_rec}]}" | jq '.severity')
         #echo "INFO: col3 ${col3_values[0]}"
         #echo "INFO: col3 ${col3_values[1]}"
         #echo "INFO: col3 ${col3_values[2]}"
         read SSSSS
         let current_rec=${current_rec}+1
      done
