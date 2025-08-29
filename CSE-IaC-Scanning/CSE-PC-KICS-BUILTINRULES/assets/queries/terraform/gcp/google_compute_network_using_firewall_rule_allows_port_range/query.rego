package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	
	firewall := input.document[i].resource.google_compute_firewall[primary]
	computeNetwork := input.document[i].resource.google_compute_network[name]
	is_port_range(firewall.allow)
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_network",
		"resourceName": tf_lib.get_resource_name(computeNetwork, name),
		"searchKey": sprintf("google_compute_network[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_network[%s]' should not be using a firewall rule that allows access to all ports", [name]),
		"keyActualValue": sprintf("'google_compute_network[%s]' is using a firewall rule that allows access to all ports", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_compute_network", name], []),
	}
}

is_port_range(allow) {
	is_array(allow)
	regex.match("[0-9]+-[0-9]+", allow[_].ports[_])
	allow[_].ports[_] != "0-65535"
} else {
	is_object(allow)
	regex.match("[0-9]+-[0-9]+", allow.ports[_])
	allow.ports[_] != "0-65535"
}
