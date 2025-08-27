package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    resourceobj := input.document[i].resource.google_data_pipeline_pipeline[name]
    expectedRegionlist := ["us", "us-east4", "us-west2", "us-central1"]
    not common_lib.inArray(expectedRegionlist, resourceobj.region)
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_pipeline_pipeline[%s].region", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Data Pipeline should be deployed in valid region",
        "keyActualValue": "Google Data Pipeline - region is not valid",
        "searchLine": common_lib.build_search_line(["resource", "google_data_pipeline_pipeline", name, "region"], []),
        "remediation": "set the region to any of the valid region us, us-east4, us-west2, us-central1",
        "remediationType": "update",
    }
}
