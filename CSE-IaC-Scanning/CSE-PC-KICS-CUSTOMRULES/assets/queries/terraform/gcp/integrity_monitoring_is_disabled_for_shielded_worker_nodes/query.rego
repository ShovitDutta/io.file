package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name].node_config[k]
	object.get(resource, "shielded_instance_config", "undefined") == "undefined"

    result := {
        "documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_container_cluster[name], name),
        "searchKey": sprintf("google_container_cluster[%s].node_config.hielded_instance_config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "shielded_instance_config should be defined",
        "keyActualValue": "shielded_instance_config is undefined",
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], []),
        "remediation": "Define shielded_instance_config and under node_config",
        "remediationType": "addition"
    }
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name].node_config[k]
	shieldedconfig := resource.shielded_instance_config[m]
    shieldedconfig.enable_integrity_monitoring == false
    result := {
        "documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_container_cluster[name], name),
        "searchKey": sprintf("google_container_cluster[%s].node_config.shielded_instance_config.enable_integrity_monitoring", [name]),
        "issueType": "InCorrectValue",
        "keyExpectedValue": "Integrity monitoring should be set to true",
        "keyActualValue": "Integrity monitoring is set to false",
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "node_config", "shielded_instance_config"], []),
        "remediation": "Set enable_integrity_monitory to true",
        "remediationType": "addition"
    }
}
