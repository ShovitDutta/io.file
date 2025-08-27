#!/usr/bin/env sh




             declare -A CSE_GCP_RULES_HASH

               

#CSE_GCP_RULES_HASH -Start  ---- Generated Code Don't Modify

             CSE_GCP_RULES_HASH["CSE-PC-GCP-GKE-21441"]="2.14.4.1|2.14.4|gke_cluster_is_missing_labels|low|Governance|custom|gcp|Clusters must be labelled per standards|GKE|CSE-PC-GCP-GKE-21441|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#resource_labels-2"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-GKE-21446"]="2.14.4.6|2.14.4|gke_cluster_release_channel_is_not_set|medium|Cluster and Node Governance|custom|gcp|Clusters must use Release Channel for version management|GKE|CSE-PC-GCP-GKE-21446|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#release_channel-1"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-GKE-21424"]="2.14.2.4|2.14.2|gke_worker_node_boot_disks_is_not_encrypted_using_cmek|high|Data Protection|custom|gcp|Worker node boot disks must be encrypted using CMEK|GKE|CSE-PC-GCP-GKE-21424|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#boot_disk_kms_key-1"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-GKE-21445"]="2.14.4.5|2.14.4|integrity_monitoring_is_disabled_for_shielded_worker_nodes|medium|Cluster and Node Governance|custom|gcp|Integrity Monitoring must be enabled for Shielded worker nodes for standard clusters|GKE|CSE-PC-GCP-GKE-21445|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#enable_integrity_monitoring-1"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-GKE-21447"]="2.14.4.7|2.14.4|node_auto_repair_disabled|medium|Cluster and Node Governance|custom|gcp|Worker nodes must have auto-repair feature turned on|GKE|CSE-PC-GCP-GKE-21447|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#auto_repair-1"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-GKE-21444"]="2.14.4.4|2.14.4|secure_boot_is_disabled_for_shielded_worker_nodes|medium|Cluster and Node Governance|custom|gcp|Secure boot must be enabled that only runs authentic software by verifying the digital signature of all boot components|GKE|CSE-PC-GCP-GKE-21444|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#enable_secure_boot-1"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-CLOUDCOMPOSER-22515"]="2.25.1.5|2.25.1|cloud_composer_is_attached_with_default_service_account|high|IAM|custom|gcp|Default service should not be used when deploying composer environments|Cloud_Composer|CSE-PC-GCP-CLOUDCOMPOSER-22515|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/composer_environment#service_account-1"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-CLOUDCOMPOSER-22551"]="2.25.5.1|2.25.5|cloud_composer_is_deployed_in_unapproved_region|high|Governance|custom|gcp|Composer environments should be deployed in approved regions useast4 uswest2 uscentral|Cloud_Composer|CSE-PC-GCP-CLOUDCOMPOSER-22551|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/composer_environment#region-2"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-CLOUDCOMPOSER-22521"]="2.25.2.1|2.25.2|cloud_composer_is_not_encrypted_with_CMEK_to_protect_data|high|Data Protection|custom|gcp|Cloud Composer Environments must be encrypted with CVSH standard CMEK|Cloud_Composer|CSE-PC-GCP-CLOUDCOMPOSER-22521|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/composer_environment#kms_key_name-1"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-CLOUDCOMPOSER-22532"]="2.25.3.2|2.25.3|cloud_composer_is_not_set_to_use_private_ip|critical|Network Security|custom|gcp|Use Private IP mode network configuration Environment clusters should not have external IP addresses|Cloud_Composer|CSE-PC-GCP-CLOUDCOMPOSER-22532|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/composer_environment#enable_private_environment-1"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-CLOUDSPANNER-24024"]="2.40.2.4|2.40.2|cloud_spanner_db_deletion_protection_is_disabled|high|Data Protection|custom|gcp|Ensure cloud spanner db have deletion protection enabled|Cloud_Spanner|CSE-PC-GCP-CLOUDSPANNER-24024|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/spanner_database#deletion_protection-1"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-CLOUDSPANNER-24021"]="2.40.2.1|2.40.2|cloud_spanner_db_is_not_using_cmek|high|Data Protection|custom|gcp|CMEK should be used in place of GMEK|Cloud_Spanner|CSE-PC-GCP-CLOUDSPANNER-24021|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/spanner_database#kms_key_name-2"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-CLOUDSPANNER-24025"]="2.40.2.5|2.40.2|cloud_spanner_is_not_deployed_in_valid_us_region|high|Data Protection|custom|gcp|Ensure cloud spanner is deployed in a valid US-region|Cloud_Spanner|CSE-PC-GCP-CLOUDSPANNER-24025|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/spanner_instance#config-2"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-DATAPIPELINE-217731"]="2.177.3.1|2.177.3|data_pipeline_dataflow_workers_is_not_configured_to_use_privateip|high|Network Security|custom|gcp|Use private IPs to restrict Dataflow workers from accessing resources outside of the VPC or peer networks enhancing security by limiting exposure|DATA_PIPELINE|CSE-PC-GCP-DATAPIPELINE-217731|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/data_pipeline_pipeline#ip_configuration-1"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-DATAPIPELINE-217714"]="2.177.1.4|2.177.1|data_pipeline_is_attached_with_default_service_account|high|IAM|custom|gcp|Ensure default service accounts are not being used by data pippelines|DATA_PIPELINE|CSE-PC-GCP-DATAPIPELINE-217714|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/data_pipeline_pipeline#scheduler_service_account_email-1"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-DATAPIPELINE-217751"]="2.177.5.1|2.177.5|data_pipeline_is_not_deployed_in_valid_us_region|high|Governance|custom|gcp|Datapipelines should be deployed in approved regions us-east4 us-west2 us-central1|DATA_PIPELINE|CSE-PC-GCP-DATAPIPELINE-217751|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/data_pipeline_pipeline#region-1"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-DATAPIPELINE-217721"]="2.177.2.1|2.177.2|data_pipeline_is_not_encrypted_with_cmek|high|Data Protection|custom|gcp|Ensure customer managed encryption keys is being used at the time of data pipeline creation|DATA_PIPELINE|CSE-PC-GCP-DATAPIPELINE-217721|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/data_pipeline_pipeline#kms_key_name-2"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-DIALOGFLOW-24121"]="2.41.2.1|2.41.2|dialog_flow_agent_is_not_deployed_in_approved_locations|critical|Data Protection|custom|gcp|Cloud DialogFlow Agents should be deployed in one of the approved locations|DIALOG_FLOW|CSE-PC-GCP-DIALOGFLOW-24121|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dialogflow_cx_agent#location-5"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-DOCUMENTAI-24621"]="2.46.2.1|2.46.2|document_ai_is_not_using_cmek_for_encryption|high|Data Protection|custom|gcp|CMEK required on all instances for data-at-rest|DOCUMENT_AI|CSE-PC-GCP-DOCUMENTAI-24621|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/document_ai_processor#kms_key_name-1"
            CSE_GCP_RULES_HASH["CSE-PC-GCP-CLOUDDNS-23933"]="2.39.3.3|2.39.3|cloud_dns_zone_type_is_set_to_public|critical|Network Security|custom|gcp|Ensure Cloud DNS Zone type is set to PRIVATE|CLOUD_DNS|CSE-PC-GCP-CLOUDDNS-23933|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone#visibility-1"

#CSE_GCP_RULES_HASH -End  ---- Generated Code Don't Modify




            declare -A CSE_GCP_CVSID_UUID_HASH




#CSE_GCP_CVSID_UUID_HASH -End  ---- Generated Code Don't Modify

              CSE_GCP_CVSID_UUID_HASH["2.14.4.1"]="CSE-PC-GCP-GKE-21441|gke_cluster_is_missing_labels|GKE|Clusters must be labelled per standards"
            CSE_GCP_CVSID_UUID_HASH["2.14.4.6"]="CSE-PC-GCP-GKE-21446|gke_cluster_release_channel_is_not_set|GKE|Clusters must use Release Channel for version management"
            CSE_GCP_CVSID_UUID_HASH["2.14.2.4"]="CSE-PC-GCP-GKE-21424|gke_worker_node_boot_disks_is_not_encrypted_using_cmek|GKE|Worker node boot disks must be encrypted using CMEK"
            CSE_GCP_CVSID_UUID_HASH["2.14.4.5"]="CSE-PC-GCP-GKE-21445|integrity_monitoring_is_disabled_for_shielded_worker_nodes|GKE|Integrity Monitoring must be enabled for Shielded worker nodes for standard clusters"
            CSE_GCP_CVSID_UUID_HASH["2.14.4.7"]="CSE-PC-GCP-GKE-21447|node_auto_repair_disabled|GKE|Worker nodes must have auto-repair feature turned on"
            CSE_GCP_CVSID_UUID_HASH["2.14.4.4"]="CSE-PC-GCP-GKE-21444|secure_boot_is_disabled_for_shielded_worker_nodes|GKE|Secure boot must be enabled that only runs authentic software by verifying the digital signature of all boot components"
            CSE_GCP_CVSID_UUID_HASH["2.25.1.5"]="CSE-PC-GCP-CLOUDCOMPOSER-22515|cloud_composer_is_attached_with_default_service_account|Cloud_Composer|Default service should not be used when deploying composer environments"
            CSE_GCP_CVSID_UUID_HASH["2.25.5.1"]="CSE-PC-GCP-CLOUDCOMPOSER-22551|cloud_composer_is_deployed_in_unapproved_region|Cloud_Composer|Composer environments should be deployed in approved regions useast4 uswest2 uscentral"
            CSE_GCP_CVSID_UUID_HASH["2.25.2.1"]="CSE-PC-GCP-CLOUDCOMPOSER-22521|cloud_composer_is_not_encrypted_with_CMEK_to_protect_data|Cloud_Composer|Cloud Composer Environments must be encrypted with CVSH standard CMEK"
            CSE_GCP_CVSID_UUID_HASH["2.25.3.2"]="CSE-PC-GCP-CLOUDCOMPOSER-22532|cloud_composer_is_not_set_to_use_private_ip|Cloud_Composer|Use Private IP mode network configuration Environment clusters should not have external IP addresses"
            CSE_GCP_CVSID_UUID_HASH["2.40.2.4"]="CSE-PC-GCP-CLOUDSPANNER-24024|cloud_spanner_db_deletion_protection_is_disabled|Cloud_Spanner|Ensure cloud spanner db have deletion protection enabled"
            CSE_GCP_CVSID_UUID_HASH["2.40.2.1"]="CSE-PC-GCP-CLOUDSPANNER-24021|cloud_spanner_db_is_not_using_cmek|Cloud_Spanner|CMEK should be used in place of GMEK"
            CSE_GCP_CVSID_UUID_HASH["2.40.2.5"]="CSE-PC-GCP-CLOUDSPANNER-24025|cloud_spanner_is_not_deployed_in_valid_us_region|Cloud_Spanner|Ensure cloud spanner is deployed in a valid US-region"
            CSE_GCP_CVSID_UUID_HASH["2.177.3.1"]="CSE-PC-GCP-DATAPIPELINE-217731|data_pipeline_dataflow_workers_is_not_configured_to_use_privateip|DATA_PIPELINE|Use private IPs to restrict Dataflow workers from accessing resources outside of the VPC or peer networks enhancing security by limiting exposure"
            CSE_GCP_CVSID_UUID_HASH["2.177.1.4"]="CSE-PC-GCP-DATAPIPELINE-217714|data_pipeline_is_attached_with_default_service_account|DATA_PIPELINE|Ensure default service accounts are not being used by data pippelines"
            CSE_GCP_CVSID_UUID_HASH["2.177.5.1"]="CSE-PC-GCP-DATAPIPELINE-217751|data_pipeline_is_not_deployed_in_valid_us_region|DATA_PIPELINE|Datapipelines should be deployed in approved regions us-east4 us-west2 us-central1"
            CSE_GCP_CVSID_UUID_HASH["2.177.2.1"]="CSE-PC-GCP-DATAPIPELINE-217721|data_pipeline_is_not_encrypted_with_cmek|DATA_PIPELINE|Ensure customer managed encryption keys is being used at the time of data pipeline creation"
            CSE_GCP_CVSID_UUID_HASH["2.41.2.1"]="CSE-PC-GCP-DIALOGFLOW-24121|dialog_flow_agent_is_not_deployed_in_approved_locations|DIALOG_FLOW|Cloud DialogFlow Agents should be deployed in one of the approved locations"
            CSE_GCP_CVSID_UUID_HASH["2.46.2.1"]="CSE-PC-GCP-DOCUMENTAI-24621|document_ai_is_not_using_cmek_for_encryption|DOCUMENT_AI|CMEK required on all instances for data-at-rest"
            CSE_GCP_CVSID_UUID_HASH["2.39.3.3"]="CSE-PC-GCP-CLOUDDNS-23933|cloud_dns_zone_type_is_set_to_public|CLOUD_DNS|Ensure Cloud DNS Zone type is set to PRIVATE"

#CSE_GCP_CVSID_UUID_HASH -End  ---- Generated Code Don't Modify
