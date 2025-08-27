package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    datafusioninstance := input.document[i].resource.google_data_fusion_instance[name]
    datafusioninstance.enable_stackdriver_logging != true
    
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_fusion_instance[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "google_data_fusion_instance - enable_stackdriver_logging should set to true",
        "keyActualValue": "google_data_fusion_instance - enable_stackdriver_logging is set to false",
        "searchLine": common_lib.build_search_line(["resource", "google_data_fusion_instance", name, "enable_stackdriver_logging"], []),
        "remediation": "set enable_stackdriver_logging = true",
        "remediationType": "update",
    }
}

CxPolicy[result] {
    datafusioninstance := input.document[i].resource.google_data_fusion_instance[name]
    datafusioninstance.enable_stackdriver_monitoring != true
    
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_fusion_instance[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "google_data_fusion_instance - enable_stackdriver_monitoring should set to true",
        "keyActualValue": "google_data_fusion_instance - enable_stackdriver_monitoring is set to false",
        "searchLine": common_lib.build_search_line(["resource", "google_data_fusion_instance", name, "enable_stackdriver_monitoring"], []),
        "remediation": "set enable_stackdriver_monitoring = true",
        "remediationType": "update",
    }
}