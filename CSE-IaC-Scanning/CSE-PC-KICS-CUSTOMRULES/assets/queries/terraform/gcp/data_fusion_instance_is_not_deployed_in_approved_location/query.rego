package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    datafusioninstance := input.document[i].resource.google_data_fusion_instance[name]
    datafunctioninstancelocation := datafusioninstance.region
    approved_location_list := ["us-east4", "us-west2", "us-central1"]
    not common_lib.inArray(approved_location_list, datafunctioninstancelocation)
    
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_fusion_instance[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "google_data_fusion_instance - region should be set to approved location",
        "keyActualValue": "google_data_fusion_instance - region is not set to approved location",
        "searchLine": common_lib.build_search_line(["resource", "google_data_fusion_instance", name, "region"], []),
        "remediation": "set region either us-east4, us-west2, us-central1",
        "remediationType": "update",
    }
}