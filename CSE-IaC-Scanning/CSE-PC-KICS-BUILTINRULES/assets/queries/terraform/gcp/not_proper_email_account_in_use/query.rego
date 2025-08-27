package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	members := input.document[i].resource.google_project_iam_binding[name].members
        mail := members[_]
        not checkMemberEmail(mail)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project_iam_binding",
		"resourceName": tf_lib.get_resource_name(members, name),
		"searchKey": sprintf("google_project_iam_binding[%s].members.%s", [name, mail]),
		"searchLine": common_lib.build_search_line(["resource", "google_project_iam_binding", name, "members"], []),
                "issueType": "IncorrectValue",
		"keyExpectedValue": "'members' should contain either corporate domain email or service account email that ends with gserviceaccount.com",
		"keyActualValue": sprintf("'members' has email address: %s", [mail]),
	}
}

checkMemberEmail(mail){
   contains(mail, "cvshealth.com")
}

checkMemberEmail(mail){
   contains(mail, "gserviceaccount.com")
}
