package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	OrgPolicy := input.document[i].resource.google_org_policy_policy[name]
    contains(OrgPolicy.name,"gcp.restrictNonCmekServices")
	OrgPolicy.spec[j].rules[k].enforce == "FALSE"
    OrgPolicy.spec[j].rules[k].values[m].denied_values[_] == "bigquery.googleapis.com"
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_org_policy_policy",
		"resourceName": tf_lib.get_resource_name(OrgPolicy, name),
		"searchKey": sprintf("google_org_policy_policy[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_org_policy_policy[%s].spec.rules.enforce should be set to TRUE", [name]),
		"keyActualValue": sprintf("google_org_policy_policy[%s].spec.rules.enforce is set to FALSE", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_org_policy_policy", name,"spec","rules","enforce"], []),
		"remediation": "policy enforced should be set to TRUE",
		"remediationType": "update"
	}
}
