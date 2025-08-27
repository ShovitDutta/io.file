#p1_hash[ST_3]="tfp"
#p2_hash[ST_3]="NONE"
#p3_hash[ST_3]="TEST"
#p4_hash[ST_3]="TEST"


PROCESS_ST_3 ()
{

  echo "INFO: FN-NAME PROCESS_ST_3"

  case "${1}" in
  "csv")
             if [ "${#reports_to_pull_csv_gz[@]}" -gt 0 ]; then
                  echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT already_present ${#collect_zip_files_already_present[@]} count_from_file ${#zip_ar_files_list_ar[@]}"
                  zip_ar_files_list_ar=(`echo "${reports_to_pull_csv_gz[@]}" | tr ' ' '\n' | sort |  grep "\.gz$"`)
                  if [ ${#collect_zip_files_already_present[@]} -lt 1 ]; then
                      mkdir -p ${date_based_root_dir}/daily_zip
                      for all_zips in `echo "${zip_ar_files_list_ar[@]}"`
                      do
#gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231208-49-342/15/createscainsgprod/ECS/csv_1702047748-20231208-49-342_15.createscainsgprod.ECS.gz
#gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231208-49-342/15/createscainsgprod/ECS/csv_1702050583-20231208-49-342_15.createscainsgprod.ECS.gz
#gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231208-49-342/16/createSUB-RTL-PCC-coe-pt-centralus/ECS/csv_1702053537-20231208-49-342_16.createSUB-RTL-PCC-coe-pt-centralus.ECS.gz
#gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231208-49-342/16/createSUB-RTL-PCC-coe-pt-eastus2/ECS/csv_1702054087-20231208-49-342_16.createSUB-RTL-PCC-coe-pt-eastus2.ECS.gz
#gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231208-49-342/16/featureuatjumpboxdb/ECS/csv_1702052033-20231208-49-342_16.featureuatjumpboxdb.ECS.gz

                          echo "INFO: zip files ${all_zips}"
                          zip_file=(`echo "${all_zips}" | cut -d "/" -f 9`)
                          echo "INFO: BUCKET_PULL_CMD- gcloud storage cp ${all_zips} ${date_based_root_dir}/daily_zip/${zip_file}"
                          gcloud storage cp ${all_zips} ${date_based_root_dir}/daily_zip/${zip_file}
                          untar_csv_files ${date_based_root_dir}/daily_zip/${zip_file}  ${date_based_root_dir}/daily_csv
                      done
                  fi
             fi
                ;;
   "buk")
             if [ "${#reports_to_pull_buk_gz[@]}" -gt 0 ]; then
                  echo "INFO: BUCKET_ZIP_FILE_PULL_DECISION_VALIDATION_CT already_present ${#collect_zip_files_already_present[@]} count_from_file ${#zip_ar_files_list_ar[@]}"
                  zip_ar_files_list_ar=(`echo "${reports_to_pull_buk_gz[@]}" | tr ' ' '\n' | sort |  grep "\.gz$"`)
                  if [ ${#collect_zip_files_already_present[@]} -lt 1 ]; then
                      mkdir -p ${date_based_root_dir}/daily_zip
                      for all_zips in `echo "${zip_ar_files_list_ar[@]}"`
                      do
#gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231208-49-342/15/createscainsgprod/ECS/csv_1702047748-20231208-49-342_15.createscainsgprod.ECS.gz
#gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231208-49-342/15/createscainsgprod/ECS/csv_1702050583-20231208-49-342_15.createscainsgprod.ECS.gz
#gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231208-49-342/16/createSUB-RTL-PCC-coe-pt-centralus/ECS/csv_1702053537-20231208-49-342_16.createSUB-RTL-PCC-coe-pt-centralus.ECS.gz
#gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231208-49-342/16/createSUB-RTL-PCC-coe-pt-eastus2/ECS/csv_1702054087-20231208-49-342_16.createSUB-RTL-PCC-coe-pt-eastus2.ECS.gz
#gs://dev-cvs-scan-reports/iac_scan_rpt_csv/20231208-49-342/16/featureuatjumpboxdb/ECS/csv_1702052033-20231208-49-342_16.featureuatjumpboxdb.ECS.gz

                          echo "INFO: zip files ${all_zips}"
                          zip_file=(`echo "${all_zips}" | cut -d "/" -f 9`)
                          echo "INFO: BUCKET_PULL_CMD- gcloud storage cp ${all_zips} ${date_based_root_dir}/daily_zip/${zip_file}"
                          gcloud storage cp ${all_zips} ${date_based_root_dir}/daily_zip/${zip_file}
                          untar_buk_files ${date_based_root_dir}/daily_zip/${zip_file}  ${date_based_root_dir}/daily_buk
                      done
                  else
                      echo "INFO: buk zip files are present"
                      if [ ${#daily_buk_ar[@]} -lt 1 ]; then
                         for all_zips in `echo "${zip_ar_files_list_ar[@]}"`
                         do
                           echo "INFO: zip files ${all_zips}"
                           zip_file=(`echo "${all_zips}" | cut -d "/" -f 9`)
                           echo "INFO: UNTAR_CMD: untar_buk_files ${date_based_root_dir}/daily_zip/${zip_file}  ${date_based_root_dir}/daily_buk"
                           untar_buk_files ${date_based_root_dir}/daily_zip/${zip_file}  ${date_based_root_dir}/daily_buk
                         done
                      else
                          echo "INFO: untar completed."
                      fi
                  fi
             else
                      echo "INFO: reports_to_pull_buk_gz ${#reports_to_pull_buk_gz[@]}"
             fi
                ;;

   "tfp")
             if [ "${#reports_to_pull_tfp[@]}" -gt 0 ]; then
                  echo "INFO: BUCKET_TFP_FILE_PULL_DECISION_VALIDATION_CT already_present"
                  reports_to_pull_tfp=(`cat ${dir_nm}/${out_put_file}`)
                  #echo "INFO: Records from file ${#reports_to_pull_tfp[@]}"
                  #tfp_files_list_ar=(`echo "${reports_to_pull_tfp[@]}" | tr ' ' '\n'| sort |  grep "\.tfplan$"`)
                  tfp_files_list_ar=(`echo "${reports_to_pull_tfp[@]}" | tr ' ' '\n'| sort |  grep "\.tfplan$" | grep -v "err_"`)
                  tfp_ct=$(echo "${#tfp_files_list_ar[@]}")
                  if [ ${#collect_tfp_files_already_present[@]} -lt ${tfp_ct} ]; then
                      mkdir -p ${date_based_root_dir}/daily_tfp
                      for all_tfps in `echo "${tfp_files_list_ar[@]}"`
                      do
                          echo "INFO: tfp files ${all_tfps}"
                          tfp_file=(`echo "${all_tfps}" | cut -d "/" -f 9`)
                          echo "INFO: BUCKET_PULL_CMD- gcloud storage cp ${all_tfps} ${date_based_root_dir}/daily_tfp/${tfp_file}"
                          gcloud storage cp ${all_tfps} ${date_based_root_dir}/daily_tfp/${tfp_file}
                      done
                  else
                      echo "INFO: tfp files are present"
                  fi
             fi
                 ;;
   esac
}

