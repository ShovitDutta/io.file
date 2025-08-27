post_process_obj_key_process ()
{
    ECHO "INFO: FUNCTION_NAME azure_tfp_obj_key_process"
                 
                           #echo "INFO: SARIF_FILE=${1}"
                           collect_rules_rec_ar=()
                           collect_rules_rec_ar=(`cat ${1}/${2}.json | jq '.queries[]| [.query_id?,.query_name?,.severity?,.cloud_provider?,.category?,.description?,.files[0].resource_type?,.files[0].resource_name?,.files[0].issue_type?,.files[0].search_key?,.files[0].expected_value?,.files[0].actual_value?,.files[0].remediation?,.files[0].remediation_type?]|join("|")' | awk -F "|" '{ OFS="|"; print NF,$0;}'| tr ' ' '_'`)
                           total_recs=$(echo "${#collect_rules_rec_ar[@]}")
              
                           if [ "${total_recs}" -gt  0 ]; then
                               echo "${collect_rules_rec_ar[@]}" | tr ' ' '\n' > ${4}/${3}_${2}_rules_inventory.pipe
                           fi
}
