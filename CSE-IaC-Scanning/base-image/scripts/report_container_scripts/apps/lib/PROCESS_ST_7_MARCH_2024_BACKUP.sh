

PROCESS_ST_7 ()
{
  echo "INFO: FN-NAME PROCESS_ST_7"
  echo "INFO: ZIP_FILE ${1} dir ${2}."
  let my_process_num=8
      p1=${1:-NONE}
      p2=${2:-NONE}
      if [[ "${p1}" == "NONE" ]]  &&  [[ "${p2}" == "NONE" ]]; then
          echo "INFO: NO_PARAMETERS_PASSED"
      else

          if [ ${#rpt_daily_csv_ar[@]} -lt 3 ]; then
             echo "INFO: Combining All csv files source dir ${p1} and option  ${p2}. Making Dir ${date_based_root_dir}/all_csv, files_ct=${#rpt_daily_csv_ar[@]}"
             mkdir -p ${date_based_root_dir}/all_csv

             declare -A date_hash
             daily_csv_ar=(`ls -C1 ${date_based_root_dir}/daily_csv/SCAN*.csv 2>/dev/null | tr '\n' ' '`)
             get_run_date_from_file=$(echo "${daily_csv_ar[0]}" | cut -d "/" -f 5)
             get_only_yyyymmdd=$(echo "${get_run_date_from_file}" | cut -d "-" -f 1)
             WW=$(echo "${get_run_date_from_file}" | cut -d "-" -f 2)
             NNN=$(echo "${get_run_date_from_file}" | cut -d "-" -f 3)
             scan_result_file=$(echo "${date_based_root_dir}/all_csv/SCAN_RESULT_${get_only_yyyymmdd}.csv")
             echo "pipeline_name,app_id,date_time,epoh_time,terraform_id,rules,rules_type,rules_property_desc" > ${scan_result_file}

             #scan_date|report_run_date|pipeline_name|app_id|terraform_id
             for all_scan_files in `echo "${daily_csv_ar[@]}"`
             do
               #echo "INFO: SCAN_FILE ${all_scan_files} PROCESSING"
               #/data/iac_scan_status/2024/20240125-04-025/daily_csv/SCAN_R-20240125-21_29_42-1706218182-042024-025-1706218182-createSUB-CORP-EPACORE-hapdb-dev-centralus-ECS.csv 
               #cat ${all_scan_files} | cut -d "," -f 1,2,4,5,8,14,15,16,17
               date_key=(`echo "${all_scan_files}" | cut -d "/" -f 7 | cut -d "-" -f 2-6`)
               date_val=(`echo "${all_scan_files}" | cut -d "/" -f 7 | cut -d "-" -f 2-3 | sed 's/_/:/g'`)
               date_hash[${date_key}]="${date_val}"
               cat ${all_scan_files} | cut -d "," -f 1,2,5,8,14,15,16,17 | awk -F "," -v dy=${date_val} '{ OFS=","; print $1,$2,dy,$3,$4,$5,$6,$7,$8;}'
               
             done >> ${scan_result_file} #${date_based_root_dir}/all_csv/SCAN_RESULT_${DATE}.csv 

              terraformid_ruleid_rel=$(echo "${date_based_root_dir}/all_csv/terraformid_ruleid_rel_${get_only_yyyymmdd}.csv")
              terraformid_property_rel=$(echo "${date_based_root_dir}/all_csv/terraformid_property_rel_${get_only_yyyymmdd}.csv")
              echo "terraform_id,epoh_time,rule_id,scan_date,scan_week#,scan_day#" >${terraformid_ruleid_rel}
              echo "terraform_id,epoh_time,rules_property_desc,scan_date,scan_week#,scan_day#" >${terraformid_property_rel}

              for all_tfp_rules_combo in `cat ${scan_result_file} | grep -v "^pipeline_name" |  cut -d "," -f 4,5,6,8 | awk -F "," '{ print $2,$1,'\n',$3,$4;}' | sed 's/ /./' | sed 's/ /|/g' | sed 's/||/:/'`
              #for all_tfp_rules_combo in `cat ${date_based_root_dir}/all_csv/SCAN_RESULT_${DATE}.csv | cut -d "," -f 4,5,6,8 | awk -F "," '{ print $2,$1,'\n',$3,$4;}' | sed 's/ /./' | sed 's/ /|/g' | sed 's/||/:/'`
              do
                     tmp_ar=()
                     tmp_ar=(`echo "${all_tfp_rules_combo}" | tr ':' '\n'`)
                     echo "${tmp_ar[1]}" | cut -d "|" -f 1 | tr '.' '\n' > ${date_based_root_dir}/all_csv/${tmp_ar[0]}.ruleid_rel_${get_only_yyyymmdd}.csv
                     echo "${tmp_ar[1]}" | cut -d "|" -f 1 | tr '.' '\n' | awk -v tfp_id=${tmp_ar[0]} -v yyyymmdd=${get_only_yyyymmdd} -v ww=${WW} -v ddd=${NNN} '{ OFS=","; print tfp_id,$1,yyyymmdd,ww,ddd;}' | sed 's/\./\,/'  >> ${terraformid_ruleid_rel}

                     echo "${tmp_ar[1]}" | cut -d "|" -f 2 | sed 's/_-_\(.*\)\(\"\)/\2/g' | tr '.' '\n' > ${date_based_root_dir}/all_csv/${tmp_ar[0]}.property_rel_${get_only_yyyymmdd}.csv
                     echo "${tmp_ar[1]}" | cut -d "|" -f 2 | sed 's/_-_\(.*\)\(\"\)/\2/g' | tr '.' '\n' | awk -v tfp_id=${tmp_ar[0]} -v yyyymmdd=${get_only_yyyymmdd} -v ww=${WW} -v ddd=${NNN} '{ OFS=","; print tfp_id,$1,yyyymmdd,ww,ddd;}' | sed 's/\./\,/'  >>${terraformid_property_rel}
              done
          #createSUB-CORP-EPACORE-hapdb-dev-centralus,ECS,20240125-21_29_42-1706218182-042024-025,1706218182,S04763_736

             for all_date_formats in `echo "${!date_hash[@]}"`
             do
               echo "${all_date_formats}|${date_hash[${all_date_formats}]}"
             done > ${date_based_root_dir}/all_csv/SCAN_DATE_FORMAT.info
              
             #cat ${date_based_root_dir}/all_csv/SCAN_RESULT_${DATE}.csv | cut -d "," -f 1,2,3,4,5 | awk -F "," '{ print $5,$4,$3,$1,$2,$5,".",$4;}' | sed 's/ /./' | sed 's/ /|/g' | sed 's/|/:/' | sed 's/|.|/\./' > ${date_based_root_dir}/all_csv/SCAN_ADDITIONAL_FIELDS.csv
             cat ${scan_result_file} | grep -v "^pipeline_name" |  cut -d "," -f 1,2,3,4,5 | awk -F "," '{ print $5,$4,$3,$1,$2,$5,".",$4;}' | sed 's/ /./' | sed 's/ /|/g' | sed 's/|/:/' | sed 's/|.|/\./' > ${date_based_root_dir}/all_csv/SCAN_ADDITIONAL_FIELDS.csv

#S23595_670.1705976403:20240123-02_20_03-1705976403-042024-023|createSUB-CORP-APIM-NONPROD-apim-dev-centralus|ECS|S23595_670.1705976403

              for all_additional_fields in `cat ${date_based_root_dir}/all_csv/SCAN_ADDITIONAL_FIELDS.csv`
              do
               #echo "INFO: ${all_additional_fields}"
               #date_field=(`echo "${all_additional_fields}" | cut -d ":" -f 2 | cut -d "|" -f 1`)
               #echo "INFO: DATE_FIELD = ${date_field}"
               #date_format=(`echo "${date_hash[${date_field}]}"`)
               #echo "INFO: DATE_FIELD = ${date_format}"
               #echo "${all_additional_fields}" | sed 's/:/|/' | cut -d "|" -f 1,3- | awk -v date_f=${date_format} -F "|" '{  OFS="|"; print $1,date_f,$3,$4,$5;}'
               echo "${all_additional_fields}" | sed 's/:/|/' | cut -d "|" -f 1,2- | awk -F "|"  -v rd=${RUN_DATE} '{  OFS="|"; print $1,$2,rd,$3,$4,$5;}' | sed 's/|$//' | sed 's/|/^/' 
               #read SSSSS
              done > ${date_based_root_dir}/all_csv/SCAN_ADDITIONAL_DATE_FIELDS.csv
          else
          echo "INFO: PROCESS_ST_7_COMPLETED, all_csv_ct ${#rpt_daily_csv_ar[@]}, daily_csv=${#daily_csv_ar[@]}"
          let process_num=${process_num}+${my_process_num}
          process_ct=(`echo "ST_${process_num}"`)
          #PROCESS_${process_ct} ${p1_hash[${process_ct}]}  ${p2_hash[${process_ct}]}
          fi
      fi
}

