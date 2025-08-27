package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	object.get(resource, "release_channel", "undefined") == "undefined"

    result := {
        "documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_container_cluster[name], name),
        "searchKey": sprintf("google_container_cluster[%s].release_channel", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Release channel should be defined",
        "keyActualValue": "Release channel is undefined",
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], []),
        "remediation": "Define release_channel and under channel set either RAPID, REGULAR, STABLE",
        "remediationType": "addition"
    }
}


CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]  
	releasechannel := resource.release_channel[k].channel
	expectedReleaseChannelOption := ["RAPID", "REGULAR", "STABLE"]
	not common_lib.inArray(expectedReleaseChannelOption, releasechannel)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_container_cluster[name], name),
		"searchKey": sprintf("google_container_cluster[%s].release_channel.channel", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Release channel should set either RAPID, REGULAR, STABLE",
		"keyActualValue": "Release channel is not set either RAPID, REGULAR, STABLE",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "release_channel"],[]),
		"remediation": "Set release_channel either RAPID, REGULAR, STABLE",
        "remediationType": "update"
	}
}
