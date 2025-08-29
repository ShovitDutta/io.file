package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib



# Policy to check if dnssec_config.state is defined
CxPolicy[result] {
	resource := input.document[i].resource.google_dns_managed_zone[name]
	dns_config := resource.dnssec_config[k]

	common_lib.emptyOrNull(dns_config.state)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_dns_managed_zone",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_dns_managed_zone[%s].dnssec_config.state", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'dnssec_config.state' should equal to 'on'",
		"keyActualValue": "'dnssec_config.state' is null or undefined",
		"searchLine": common_lib.build_search_line(["resource","google_dns_managed_zone", name, "dnssec_config", "state"],[]),
		"remediation": "Set 'dnssec_config.state' to 'on' to enable DNSSEC for the managed zone.",
		"remediationType": "update",
	}
}


# Policy to check if dnssec_config.state is not equal to "on"
CxPolicy[result] {
	resource := input.document[i].resource.google_dns_managed_zone[name]
	dns_config := resource.dnssec_config[k]

	lower(dns_config.state) != "on"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_dns_managed_zone",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_dns_managed_zone[%s].dnssec_config.state", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'dnssec_config.state' should equal to 'on'",
		"keyActualValue": "'dnssec_config.state' is set to off or other value",
		"searchLine": common_lib.build_search_line(["resource","google_dns_managed_zone", name, "dnssec_config", "state"],[]),
		"remediation": "Set 'dnssec_config.state' to 'on' to enable DNSSEC for the managed zone.",
		"remediationType": "update",
	}
}