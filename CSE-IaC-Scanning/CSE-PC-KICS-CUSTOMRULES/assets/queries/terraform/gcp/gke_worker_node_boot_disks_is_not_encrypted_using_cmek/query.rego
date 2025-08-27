package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Policy to check if boot_disk_kms_key is defined
CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	nodeconfig := resource.node_config[k]
	common_lib.emptyOrNull(nodeconfig.boot_disk_kms_key)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].node_config", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'boot_disk_kms_key' should not null",
		"keyActualValue": "'boot_disk_kms_key' is null",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], ["node_config"]),
		"remediation": "add boot_disk_kms_key to use CMEK",
     	"remediationType": "addition",
	}
}

# Policy to check if boot_disk_kms_key has CMEK or not
CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	node_config := resource.node_config[k]
	not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",node_config.boot_disk_kms_key)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].node_config.boot_disk_kms_key", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'boot_disk_kms_key' should be encrypted with CMEK",
		"keyActualValue": "'boot_disk_kms_key' is not encrypted with CMEK",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], ["node_config", "boot_disk_kms_key"]),
		"remediation": "update boot_disk_kms_key to use CMEK",
     	"remediationType": "update",
	}
}

