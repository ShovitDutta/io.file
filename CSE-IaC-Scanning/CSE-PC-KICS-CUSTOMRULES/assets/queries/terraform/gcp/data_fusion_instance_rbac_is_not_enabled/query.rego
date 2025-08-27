package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    datafusioninstance := input.document[i].resource.google_data_fusion_instance[name]
    datafusioninstance.enable_rbac != true
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_fusion_instance[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "google_data_fusion_instance - enable_rbac should set to true",
        "keyActualValue": "google_data_fusion_instance - enable_rbac is not set to true",
        "searchLine": common_lib.build_search_line(["resource", "google_data_fusion_instance", name, "enable_rbac"], []),
        "remediation": "set enable_rbac = true",
        "remediationType": "update",
    }
}