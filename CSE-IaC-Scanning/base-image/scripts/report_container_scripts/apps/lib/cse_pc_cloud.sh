


      declare -A cse_pc_cloud_hash
      declare -A cse_pc_cloud_index_hash

      declare -A cse_pc_azure_resource_hash
      declare -A cse_pc_gcp_resource_hash
      declare -A cse_pc_aws_resource_hash
      declare -A cse_pc_resource_index_hash

      declare -A cse_pc_domain_hash
      declare -A cse_pc_domain_index_hash

      declare -A cse_pc_cloud_resource_category_rule_info

      declare -A cse_pc_cloud_reverse_hash
      declare -A cse_pc_reverse_resource
      declare -A cse_pc_reverse_domain


      cse_pc_cloud_hash["AZURE"]="AZURE"
      cse_pc_cloud_hash["GCP"]="GCP"
      cse_pc_cloud_hash["AWS"]="AWS"

      cse_pc_cloud_index_hash["AZURE"]=1
      cse_pc_cloud_index_hash["GCP"]=2
      cse_pc_cloud_index_hash["AWS"]=3

      cse_pc_azure_resource_hash
