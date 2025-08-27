package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    datafusioninstance := input.document[i].resource.google_data_fusion_instance[name]
    datafusioninstance.private_instance != true
    
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_fusion_instance[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "google_data_fusion_instance - private instance should set to true",
        "keyActualValue": "google_data_fusion_instance - private instance is set to false",
        "searchLine": common_lib.build_search_line(["resource", "google_data_fusion_instance", name, "private_instance"], []),
        "remediation": "set private_instance = true",
        "remediationType": "update",
    }
}