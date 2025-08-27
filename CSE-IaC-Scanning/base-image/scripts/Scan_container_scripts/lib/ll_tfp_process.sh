# ll_tfp=$(echo "${ll_tfp}|tfp_pv_srp")
# ll_tfp=$(echo "${2}_${4}|tfp_pv_tag")
# ll_tfp=$(echo "${ll_tfp}|tfp_ps_tag")
# ll_tfp=$(echo "${ll_tfp}|tfp_pc_ars")
# ll_tfp=$(echo "${ll_tfp}|tfp_pc_rcm")
# ll_tfp=$(echo "${ll_tfp}|tfp_pc_rcp")
# ll_tfp=$(echo "${ll_tfp}|tfp_rc_alsp_tag")
# ll_tfp=$(echo "${ll_tfp}|tfp_rc_tbsp_tag")

#tfp_key_items_collection_hash -Variables_Start

    declare -A tfp_pv_info_hash
    declare -A tfp_info_hash
    declare -A tfp_data_info_hash
    declare -A tfp_pv_tag_info_hash
    declare -A tfp_ps_tag_info_hash
    declare -A tfp_rc_tag_info_hash
    declare -A tfp_pc_ars_info_hash
    declare -A tfp_pc_rcp_info_hash
    declare -A tfp_pc_rcm_info_hash

    tfp_pv_info_hash["tfp_pv_obj"]="tfp_pv_obj"
    tfp_pv_info_hash["tfp_pv"]="tfp_pv"
    tfp_pv_info_hash["tfp_tag"]="tfp_tag"
    tfp_pv_info_hash["tfp_pv_srp"]="tfp_pv_srp"
    #tfp_data_info_hash["tfp_acctid_value"]="tfp_acctid_value"
    ll_tfp=$(echo "ll_tfp")


#tfp_key_items_collection_hash -Variables_End

fn_tfp_acctid_value ()
{
    ECHO "INFO: FUNCTION_NAME fn_tfp_acctid_value"
    ECHO "INFO_DEBUG: p1=${1} p2=${2} tfp_file, p3=${3} tfp_signature, p4=${4} directory, p5=${5} cloud - Start"
    get_tfp_acctid_value=$(echo "${tfp_data_info_hash[${1}_tfp_acctid_value]}")
    #echo "INFO: get_tfp_acctid_value ${get_tfp_acctid_value}"
} 

fn_tfp_pv_srp ()
{
    ECHO "INFO: FUNCTION_NAME fn_tfp_pv_srp"
    ECHO "INFO_DEBUG: p1=${1} p2=${2} tfp_file, p3=${3} tfp_signature, p4=${4} directory, p5=${5} cloud - Start"
    get_tfp_pv_srp_buffer=$(echo "${tfp_pv_info_hash[${1}_tfp_pv_srp]}")
    tfp_pv_srp_info=$(echo "${get_tfp_pv_srp_buffer}" | jq -Mr '.[]|[.tf[]|[.srv,.properties]|join("|")]|sort|unique' | jq '.[]|.'  | sed 's/|/\":\"/' | tr '\n' ',' | sed 's/^/{/' |sed 's/\"\,$/\"}/' | jq '.|values|{ "total_resources" : keys|length,"resources" : keys|join("|"), "properties" :values }')
    tfp_data_info_hash[${1}_tfp_pv_srp]="${tfp_pv_srp_info}"
    #echo "INFO: get_tfp_pv_srp_buffer ${get_tfp_pv_srp_buffer}"
} 

fn_tfp_pv_tag ()
{
    ECHO "INFO: FUNCTION_NAME fn_tfp_pv_tag"
    ECHO "INFO_DEBUG: p1=${1} p2=${2} tfp_file, p3=${3} tfp_signature, p4=${4} directory, p5=${5} cloud - Start"
    get_tfp_pv_tag_buffer=$(echo "${tfp_pv_tag_info_hash[${1}_tfp_pv_tag_json]}")
    appid=$(echo "${get_tfp_pv_tag_buffer}" | jq -Mr '.appid')
    tfp_data_info_hash[${1}_tfp_appid]="${appid}"
    #echo "INFO: get_tfp_pv_tag_buffer ${get_tfp_pv_tag_buffer}"
} 

fn_tfp_ps_tag ()
{
    ECHO "INFO: FUNCTION_NAME fn_tfp_ps_tag"
    ECHO "INFO_DEBUG: p1=${1} p2=${2} tfp_file, p3=${3} tfp_signature, p4=${4} directory, p5=${5} cloud - Start"
    get_tfp_ps_tag_buffer=$(echo "${tfp_ps_tag_info_hash[${1}_tfp_ps_tag_json]}")
    appid=$(echo "${get_tfp_ps_tag_buffer}" | jq -Mr '.appid')
    tfp_data_info_hash[${1}_tfp_appid]="${appid}"
    #echo "INFO: get_tfp_ps_tag_buffer ${get_tfp_ps_tag_buffer}"
} 

fn_tfp_pc_ars_ct ()
{
    ECHO "INFO: FUNCTION_NAME fn_tfp_pc_ars_ct"
    ECHO "INFO_DEBUG: p1=${1} p2=${2} tfp_file, p3=${3} tfp_signature, p4=${4} directory, p5=${5} cloud - Start"
    get_tfp_pc_ars_ct_buffer=$(echo "${tfp_pc_ars_info_hash[${1}_tfp_pc_ars_ct]}")
    #echo "INFO: get_tfp_pc_ars_ct_buffer ${get_tfp_pc_ars_ct_buffer}"
} 

fn_tfp_pc_rcp_ct ()
{
    ECHO "INFO: FUNCTION_NAME fn_tfp_pc_rcp_ct"
    ECHO "INFO_DEBUG: p1=${1} p2=${2} tfp_file, p3=${3} tfp_signature, p4=${4} directory, p5=${5} cloud - Start"
    get_tfp_pc_rcp_ct_buffer=$(echo "${tfp_pc_rcp_info_hash[${1}_tfp_pc_rcp_ct]}")
    #echo "INFO: get_tfp_pc_rcp_ct_buffer ${get_tfp_pc_rcp_ct_buffer}"
} 

fn_tfp_pc_rcm_ct ()
{
    ECHO "INFO: FUNCTION_NAME fn_tfp_pc_rcm_ct"
    ECHO "INFO_DEBUG: p1=${1} p2=${2} tfp_file, p3=${3} tfp_signature, p4=${4} directory, p5=${5} cloud - Start"
    get_tfp_pc_rcm_ct_buffer=$(echo "${tfp_pc_rcm_info_hash[${1}_tfp_pc_rcm_ct]}")
    #echo "INFO: get_tfp_pc_rcm_ct_buffer ${get_tfp_pc_rcm_ct_buffer}"
} 

fn_tfp_pc_ars ()
{
    ECHO "INFO: FUNCTION_NAME fn_tfp_pc_ars"
    ECHO "INFO_DEBUG: p1=${1} p2=${2} tfp_file, p3=${3} tfp_signature, p4=${4} directory, p5=${5} cloud - Start"
    get_tfp_pc_ars_buffer=$(echo "${tfp_pc_ars_info_hash[${1}_tfp_pc_ars]}")
    #echo "INFO: get_tfp_pc_ars_buffer ${get_tfp_pc_ars_buffer}"
} 

fn_tfp_pc_rcp ()
{
    ECHO "INFO: FUNCTION_NAME fn_tfp_pc_rcp"
    ECHO "INFO_DEBUG: p1=${1} p2=${2} tfp_file, p3=${3} tfp_signature, p4=${4} directory, p5=${5} cloud - Start"
    get_tfp_pc_rcp_buffer=$(echo "${tfp_pc_rcp_info_hash[${1}_tfp_pc_rcp]}")
    #echo "INFO: get_tfp_pc_rcp_buffer ${get_tfp_pc_rcp_buffer}"
} 

fn_tfp_pc_rcm ()
{
    ECHO "INFO: FUNCTION_NAME fn_tfp_pc_rcm"
    ECHO "INFO_DEBUG: p1=${1} p2=${2} tfp_file, p3=${3} tfp_signature, p4=${4} directory, p5=${5} cloud - Start"
    get_tfp_pc_rcm_buffer=$(echo "${tfp_pc_rcm_info_hash[${1}_tfp_pc_rcm]}")
    #echo "INFO: get_tfp_pc_rcm_buffer ${get_tfp_pc_rcm_buffer}"
} 

fn_tfp_rc_alsp_tag ()
{
    ECHO "INFO: FUNCTION_NAME fn_tfp_rc_alsp_tag"
    ECHO "INFO_DEBUG: p1=${1} p2=${2} tfp_file, p3=${3} tfp_signature, p4=${4} directory, p5=${5} cloud - Start"
    get_tfp_rc_alsp_tag_buffer=$(echo "${tfp_rc_tag_info_hash[${1}_tfp_rc_alsp_tag_json]}")
    appid=$(echo "${get_tfp_rc_alsp_tag_buffer}" | jq -Mr '.appid')
    tfp_data_info_hash[${1}_tfp_appid]="${appid}"
    #echo "INFO: get_tfp_rc_alsp_tag_buffer ${get_tfp_rc_alsp_tag_buffer}"
} 

fn_tfp_rc_tbsp_tag ()
{
    ECHO "INFO: FUNCTION_NAME fn_tfp_rc_tbsp_tag"
    ECHO "INFO_DEBUG: p1=${1} p2=${2} tfp_file, p3=${3} tfp_signature, p4=${4} directory, p5=${5} cloud - Start"
    get_tfp_rc_tbsp_tag_buffer=$(echo "${tfp_rc_tag_info_hash[${1}_tfp_rc_tbsp_tag_json]}")
    appid=$(echo "${get_tfp_rc_tbsp_tag_buffer}" | jq -Mr '.appid')
    tfp_data_info_hash[${1}_tfp_appid]="${appid}"
    #echo "INFO: get_tfp_rc_tbsp_tag_buffer ${get_tfp_rc_tbsp_tag_buffer}"
} 
