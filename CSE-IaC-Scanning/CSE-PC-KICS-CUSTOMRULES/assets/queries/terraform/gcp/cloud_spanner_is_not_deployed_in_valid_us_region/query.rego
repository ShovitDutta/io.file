package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    spannerinstance := input.document[i].resource.google_spanner_instance[name]
    contains(spannerinstance.config, "regional")
    configobject := split(spannerinstance.config, "regional-")
    expectedFromLocationlist := ["us", "us-east4", "us-west2", "us-central1"]
    not common_lib.inArray(expectedFromLocationlist, configobject[1])

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_spanner_instance[%s].config", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Cloud Spanner should have a valid region",
        "keyActualValue": "Google Cloud Spanner region is not valid",
        "searchLine": common_lib.build_search_line(["resource", "google_spanner_instance", name, "config"], []),
        "remediation": "set the config to any of the valid region us, us-east4, us-west2, us-central1",
        "remediationType": "update"
    }
}

CxPolicy[result] {
    spannerinstance := input.document[i].resource.google_spanner_instance[name]
    not contains(spannerinstance.config, "regional")
    not contains(spannerinstance.config, "nam3")

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_spanner_instance[%s].config", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Cloud Spanner should have a valid region nam3 for multi region",
        "keyActualValue": "Google Cloud Spanner region is not valid",
        "searchLine": common_lib.build_search_line(["resource", "google_spanner_instance", name, "config"], []),
        "remediation": "set config as nam3 Spanner multi-region actually uses us-east4, us-east1 and us-central1 ",
        "remediationType": "update"
    }
}