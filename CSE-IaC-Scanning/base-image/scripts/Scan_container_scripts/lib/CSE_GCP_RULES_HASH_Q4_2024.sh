#!/usr/bin/env sh




             declare -A CSE_GCP_RULES_HASH

               

#CSE_GCP_RULES_HASH -Start  ---- Generated Code Don't Modify

             CSE_GCP_RULES_HASH["CSE-PC-GCP-COMPUTEENGINE-2627"]="2.6.2.7|2.6.2|compute_vlan_attachment_is_not_encrypted_with_ipsec|critical|Data Protection|custom|gcp|Ensure that only IPSEC VLAN attachment encryption setting is allowed|COMPUTE|CSE-PC-GCP-COMPUTEENGINE-2627|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_interconnect_attachment#encryption"
             CSE_GCP_RULES_HASH["CSE-PC-GCP-COMPUTEENGINE-2651"]="2.6.5.1|2.6.5|compute_engine_is_missing_labels|low|Governance|custom|gcp|IT Hygiene Compute Instances must be labelled per standards|COMPUTE|CSE-PC-GCP-COMPUTEENGINE-2651|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#labels"
             CSE_GCP_RULES_HASH["CSE-PC-GCP-REDISINSTANCE-23251"]="2.32.5.1|2.32.5|redis_instance_is_deployed_in_unapproved_locations|medium|Governance|custom|gcp|Ensure that redis instance are created in approved CVSH resource locations|REDIS|CSE-PC-GCP-REDISINSTANCE-23251|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance#location_id"

#CSE_GCP_RULES_HASH -End  ---- Generated Code Don't Modify




              declare -A CSE_GCP_CVSID_UUID_HASH




#CSE_GCP_CVSID_UUID_HASH -End  ---- Generated Code Don't Modify

              CSE_GCP_CVSID_UUID_HASH["2.6.2.7"]="CSE-PC-GCP-COMPUTEENGINE-2627|compute_vlan_attachment_is_not_encrypted_with_ipsec|COMPUTE|Ensure that only IPSEC VLAN attachment encryption setting is allowed"
              CSE_GCP_CVSID_UUID_HASH["2.6.5.1"]="CSE-PC-GCP-COMPUTEENGINE-2651|compute_engine_is_missing_labels|COMPUTE|IT Hygiene Compute Instances must be labelled per standards"
              CSE_GCP_CVSID_UUID_HASH["2.32.5.1"]="CSE-PC-GCP-REDISINSTANCE-23251|redis_instance_is_deployed_in_unapproved_locations|REDIS|Ensure that redis instance are created in approved CVSH resource locations"

#CSE_GCP_CVSID_UUID_HASH -End  ---- Generated Code Don't Modify
