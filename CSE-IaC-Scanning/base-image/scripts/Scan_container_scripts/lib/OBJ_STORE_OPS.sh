


#DPC-Function push_report_to_bucket  -Definition Start
## this function will push all the reports to bucket with key $build_id


push_pipe_status_files ()
{
    ECHO "INFO: FN-NAME push_pipe_status_files"

    #tfp_pipe_file_hash
    ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_status Start #######################
    cd ${global_info_dir} 2>/dev/null 1>/dev/null
    CUR_DIR=$(pwd)
    RPT_PIPE_ID=$(date '+%s')
    ECHO "INFO: CUR_DIR ${CUR_DIR} rpt_time ${RPT_PIPE_ID}"
    ECHO "INFO: CMD: tar -zcvf rpt_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${RPT_PIPE_ID}.${1} ./*_${build_id}.pipe"
    total_pipe_files=$(ls -C1 ./*_${build_id}.pipe | wc -l)
    rpt_rc=$(tar -zcvf rpt_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${RPT_PIPE_ID}.${1} ./*_${build_id}.pipe)
    rpt_list_tar_file=$(ls -C1 rpt_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${RPT_PIPE_ID}.${1})
    rpt_list_tar_file=${rpt_list_tar_file:-NONE}
    if [ "${rpt_list_tar_file}" == "NONE" ]; then
       ECHO "INFO: Tar of pipe files failed. Scan did not prodce any Files or No rules found. Not an Error"
       ECHO "NO_SCAN_ERROR" > error_rpt_list_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${RPT_PIPE_ID}.${1}
       #dev-cvs-scan-reports/iac_scan_status
       ECHO "INFO: pushing gcloud storage cp error_rpt_list_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${RPT_PIPE_ID}.${1} gs://${my_current_buk_scan}/iac_scan_status/${STOTAGE_FOLDER_KEY}/error_rpt_list_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${RPT_PIPE_ID}.${1}"
       gcloud storage cp error_rpt_list_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${1} gs://${my_current_buk_scan}/iac_scan_status/${STOTAGE_FOLDER_KEY}/error_rpt_list_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${RPT_PIPE_ID}.${1}  1>/dev/null 2>/dev/null
    else
       ECHO "INFO: Tar of pipe files  found. Scan prodced Files"
       ECHO "INFO: pushing gcloud storage cp rpt_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${RPT_PIPE_ID}.${1} gs://${my_current_buk_scan}/iac_scan_status/${STOTAGE_FOLDER_KEY}/rpt_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${RPT_PIPE_ID}.${1}"
       gcloud storage cp rpt_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${RPT_PIPE_ID}.${1} gs://${my_current_buk_scan}/iac_scan_status/${STOTAGE_FOLDER_KEY}/rpt_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${RPT_PIPE_ID}.${1} 1>/dev/null 2>/dev/null
       pipe_count=$(tar -ztvf rpt_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${RPT_PIPE_ID}.${1} | wc -l)
       if [ "${pipe_count}" == "${total_pipe_files}" ]; then
          ECHO "INFO: FILES_PUSHED_TAG_PIPE ${pipe_count} and TAR_BALL_MATCH"
       else
          ECHO "INFO: FILES_PUSHED_TAG_PIPE ${pipe_count} and ${total_pipe_files} TAR_BALL_MISMATCH"
       fi
    fi
    #for all_ppt_zips in `echo "${tfp_post_processed_zip_files_hash[@]}"`
    #do
    #   ECHO "INFO: Pushing files to cloud storage ${all_ppt_zips}"
    #   ECHO "INFO: CMD gcloud storage cp ${all_ppt_zips} gs://${my_current_buk_scan}/iac_scan_status/${STOTAGE_FOLDER_KEY}/ppf_tfp/${all_ppt_zips}"
    #   gcloud storage cp ${all_ppt_zips} gs://${my_current_buk_scan}/iac_scan_status/${STOTAGE_FOLDER_KEY}/ppf_tfp/${all_ppt_zips} 1>/dev/null 2>/dev/null
    #done
    #cd - 2>/dev/null 1>/dev/null
    ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_status End #######################
    #read SSSSS
}

push_report_to_bucket()
{
    ECHO "INFO: FN-NAME push_report_to_bucket"

    unique_key=(`echo "${app_nm}.${pipeline_nm}.gz"`)
    push_pipe_status_files "${unique_key}"

    ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_tf_plan Start #######################
    #Any errored tfplan file found, push to bucket to debug with vendor -Start
       for all_tfplan_key in `echo "${!processed_tf_plan_files[@]}"`
       do
           file_nm_to_push_all=$(echo "${processed_tf_plan_files[${all_tfplan_key}]}")
           file_nm_to_push=$(echo "${file_nm_to_push_all}" | cut -d "|" -f 3)
           ECHO "INFO: pushing tfplan file to gcloud storage ${file_nm_to_push}"
           ECHO "INFO: CMD - gcloud storage  cp ${file_nm_to_push} gs://${my_current_buk_scan}/iac_scan_tf_plan/${STOTAGE_FOLDER_KEY}/${HOUR_KEY}/${app_nm}/${pipeline_nm}/${all_tfplan_key}.${ID}.tfplan"
           gcloud storage  cp ${file_nm_to_push} gs://${my_current_buk_scan}/iac_scan_tf_plan/${STOTAGE_FOLDER_KEY}/${HOUR_KEY}/${app_nm}/${pipeline_nm}/${all_tfplan_key}.${ID}.tfplan 1>/dev/null 2>/dev/null
       done
    #Any errored tfplan file found, push to bucket to debug with vendor -end
    ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_tf_plan End #######################

    cd ${global_info_dir} 2>/dev/null 1>/dev/null
    ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_rpt_bucket Start #######################
    cp ${tfp_root}/*.json .
    #ECHO "INFO: creating_tar tar -zcvf bucket_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key} ./*.bucket"
    #bucket_rc=(`tar -zcvf bucket_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key} ./*.bucket`)
    ECHO "INFO: creating_tar tar -zcvf bucket_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key} ./*.json"
    bucket_rc=(`tar -zcvf bucket_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key} ./*.json`)

    get_bucket_tar=(`ls -C1 bucket_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key}`)
    get_bucket_tar=${get_bucket_tar:-NONE}


    ECHO "INFO: bucket files - Status ${get_bucket_tar} and ${bucket_rc}"

    if [ "${get_bucket_tar}" == "NONE" ]; then
           ECHO "INFO: Tar of bucket file failed. Scan did not prodce any Files or No rules found. Not an Error"
           echo "NO_SCAN_ERROR" > bucket_no_error_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key}
           ECHO "INFO: pushing gcloud storage cp bucket_no_error_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key} gs://${my_current_buk_scan}/iac_scan_rpt_bucket/${STOTAGE_FOLDER_KEY}/${HOUR_KEY}/${app_nm}/${pipeline_nm}/bucket_no_error_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key}"
           gcloud storage  cp bucket_no_error_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key} gs://${my_current_buk_scan}/iac_scan_rpt_bucket/${STOTAGE_FOLDER_KEY}/${HOUR_KEY}/${app_nm}/${pipeline_nm}/bucket_no_error_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key} 1>/dev/null 2>/dev/null
    else
           ECHO "INFO: pushing gcloud storage  cp bucket_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key} gs://${my_current_buk_scan}/iac_scan_rpt_bucket/${STOTAGE_FOLDER_KEY}/${HOUR_KEY}/${app_nm}/${pipeline_nm}/bucket_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key}"
           gcloud storage  cp bucket_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key} gs://${my_current_buk_scan}/iac_scan_rpt_bucket/${STOTAGE_FOLDER_KEY}/${HOUR_KEY}/${app_nm}/${pipeline_nm}/bucket_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key} 1>/dev/null 2>/dev/null
           #tar -ztvf bucket_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key}
    fi

    ECHO "INFO: Copleted bucket Processing" 
    ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_rpt_bucket End #######################

    cd - 1>/dev/null
    
    ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_rpt_kics Start #######################
    
    for all_kics_rpt_all in `echo "${kics_report_dir_hash[@]}"`
    do
        ECHO "INFO: kics rpts found ${all_kics_rpt_all}"
        all_kics_rpt=$(echo "${all_kics_rpt_all}" | cut -d "|" -f 1)
        unique_bld=$(echo "${all_kics_rpt_all}" | cut -d "|" -f 2)
        get_leaf=(`basename ${all_kics_rpt}`)
        cd ${all_kics_rpt} 1>/dev/null
        ECHO "INFO -CURDIR `pwd`"
        #ECHO "INFO: Creating tar for kics rpts found. tar -zcvf kics_scan_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_key} ./*${build_id}.*"
        ECHO "INFO: Creating tar for kics rpts found. tar -zcvf kics_scan_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_key} ./*${unique_bld}.*"
        #kics_scan_rc=(`tar -zcvf kics_scan_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_key} ./*${build_id}.*`)
        kics_scan_rc=(`tar -zcvf kics_scan_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_key} ./*${unique_bld}.*`)
        #get_all_kics_rpt_tar=(`ls -C1 kics_scan_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_bld}`)
        get_all_kics_rpt_tar=(`ls -C1 kics_scan_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_key}`)
        get_all_kics_rpt_tar=${get_all_kics_rpt_tar:-NONE}
           
        ECHO "INFO: kics_rpt_scan_result_files_tar - Status ${get_all_kics_rpt_tar} and ${kics_scan_rc}"
        if [ "${get_all_kics_rpt_tar}" == "NONE" ]; then
           ECHO "INFO: Tar of kics_rpt_file failed. Scan did not produce any Files or No rules found. Not an Error"
           echo "NO_SCAN_ERROR" > kics_no_error_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_key}
           ECHO "INFO: pushing gcloud storage  cp kics_no_error_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_key} gs://${my_current_buk_scan}/iac_scan_rpt_kics/${STOTAGE_FOLDER_KEY}/${HOUR_KEY}/${app_nm}/${pipeline_nm}/kics_no_error_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key}"
           gcloud storage  cp kics_no_error_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_key} gs://${my_current_buk_scan}/iac_scan_rpt_kics/${STOTAGE_FOLDER_KEY}/${HOUR_KEY}/${app_nm}/${pipeline_nm}/kics_no_error_${STORAGE_FOLDER_KEY}_${HOUR_KEY}.${unique_key} 1>/dev/null  2>/dev/null
        else
           ECHO "INFO: pushing gcloud storage  cp kics_scan_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_key} gs://${my_current_buk_scan}/iac_scan_rpt_kics/${STOTAGE_FOLDER_KEY}/${HOUR_KEY}/${app_nm}/${pipeline_nm}/kics_scan_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_key}"
           gcloud storage  cp kics_scan_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_key} gs://${my_current_buk_scan}/iac_scan_rpt_kics/${STOTAGE_FOLDER_KEY}/${HOUR_KEY}/${app_nm}/${pipeline_nm}/kics_scan_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_key} 1>/dev/null 2>/dev/null
           #tar -ztvf kics_scan_${app_nm}_${STORAGE_FOLDER_KEY}_${HOUR_KEY}_${get_leaf}.${unique_key}
        fi
        cd - 1>/dev/null
    done
    ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_rpt_kics End #######################
}

summary_keys ()
{       
    ECHO "INFO: Copleted kics_report_upload_files Processing"
        
               ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_rpt_keys Start #######################
               for all_unique_keys_found in `echo "${!tf_plan_file_rpt_hash[@]}"`
               do
                      ECHO "INFO: KEY_CHECK_SUM - ${all_unique_keys_found}"
                      get_contents=(`echo "${tf_plan_file_report_hash[${all_unique_keys_found}]}"`)
                      get_file_nm=(`echo "${tf_plan_file_rpt_hash[${all_unique_keys_found}]}"`)
                      echo "${get_contents}|S:run_end" >> ${global_info_dir}/${get_file_nm}.${all_unique_keys_found}
                      ECHO "INFO: Creating keys gcloud storage  cp ${global_info_dir}/${get_file_nm}.${all_unique_keys_found} gs://${my_current_buk_scan}/iac_scan_rpt_keys/${get_file_nm}.${all_unique_keys_found}"
                      gcloud storage  cp ${global_info_dir}/${get_file_nm}.${all_unique_keys_found} gs://${my_current_buk_scan}/iac_scan_rpt_keys/${get_file_nm}.${all_unique_keys_found} 1>/dev/null 2>/dev/null
                      #ECHO "INFO: FILE_PUSHED ${get_file_nm_rc}"
                      file_with_ext=(`echo "${get_file_nm}.${all_unique_keys_found}"`)
                      end_of_process_bucket_keys_hash[${all_unique_keys_found}]=${file_with_ext}
               done

    ECHO "INFO: Copleted iac_scan_rpt_keys created and push Processing"
               ####### gcloud_push_folder  gs://${my_current_buk_scan}/iac_scan_rpt_keys End #######################
}

#DPC-Function push_report_to_bucket  -Definition End


