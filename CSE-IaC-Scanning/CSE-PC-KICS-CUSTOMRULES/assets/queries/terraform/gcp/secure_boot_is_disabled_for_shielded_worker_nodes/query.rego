package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name].node_config[k]
	shieldedconfig := resource.shielded_instance_config[m]
    shieldedconfig.enable_secure_boot == false
    result := {
        "documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_container_cluster[name], name),
        "searchKey": sprintf("google_container_cluster[%s].node_config.shielded_instance_config.enable_secure_boot", [name]),
        "issueType": "InCorrectValue",
        "keyExpectedValue": "Secure Boot should be set to true",
        "keyActualValue": "Secure Boot is set to false",
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "node_config", "shielded_instance_config"], []),
        "remediation": "Set enable_secure_boot to true",
        "remediationType": "addition"
    }
}
