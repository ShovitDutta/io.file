package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    googledatapipeline := input.document[i].resource.google_data_pipeline_pipeline[name].workload[k]
    launchtemplate := googledatapipeline.dataflow_launch_template_request[m]
    launchparam := launchtemplate.launch_parameters[l]
    envobject := launchparam.environment[n]
    contains(envobject.service_account_email,"compute@developer.gserviceaccount.com")
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_pipeline_pipeline[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Data Pipeline should not use default service account",
        "keyActualValue": "Google Data Pipeline is using default service account",
        "searchLine": common_lib.build_search_line(["resource", "google_data_pipeline_pipeline", name], []),
        "remediation": "set non default service account",
        "remediationType": "update",
    }
}

CxPolicy[result] {
    googledatapipeline := input.document[i].resource.google_data_pipeline_pipeline[name].workload[k]
    launchtemplate := googledatapipeline.dataflow_launch_template_request[m]
    launchparam := launchtemplate.launch_parameters[l]
    envobject := launchparam.environment[n]
    contains(envobject.service_account_email, "@appspot.gserviceaccount.com")
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_pipeline_pipeline[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Data Pipeline should not use default service account",
        "keyActualValue": "Google Data Pipeline is using default service account",
        "searchLine": common_lib.build_search_line(["resource", "google_data_pipeline_pipeline", name], []),
        "remediation": "set non default service account",
        "remediationType": "update"
    }
}

CxPolicy[result] {
    googledatapipeline := input.document[i].resource.google_data_pipeline_pipeline[name].workload[k]
    launchtemplate := googledatapipeline.dataflow_launch_template_request[m]
    launchparam := launchtemplate.launch_parameters[l]
    envobject := launchparam.environment[n]
    common_lib.emptyOrNull(envobject.service_account_email) == true
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_pipeline_pipeline[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Data Pipeline - should use user defined service account",
        "keyActualValue": "Google Data Pipeline - service account is undefined or null",
        "searchLine": common_lib.build_search_line(["resource", "google_data_pipeline_pipeline", name], []),
        "remediation": "set non default service account",
        "remediationType": "update"
    }
}

CxPolicy[result] {
    googledatapipeline := input.document[i].resource.google_data_pipeline_pipeline[name].workload[k]
    launchtemplate := googledatapipeline.dataflow_flex_template_request[m]
    launchparam := launchtemplate.launch_parameter[l]
    envobject := launchparam.environment[n]
    contains(envobject.service_account_email, "-compute@developer.gserviceaccount.com")
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_pipeline_pipeline[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Data Pipeline should not use default service account",
        "keyActualValue": "Google Data Pipeline is using default service account",
        "searchLine": common_lib.build_search_line(["resource", "google_data_pipeline_pipeline", name], []),
        "remediation": "set non default service account",
        "remediationType": "update"
    }
}

CxPolicy[result] {
    googledatapipeline := input.document[i].resource.google_data_pipeline_pipeline[name].workload[k]
    launchtemplate := googledatapipeline.dataflow_flex_template_request[m]
    launchparam := launchtemplate.launch_parameter[l]
    envobject := launchparam.environment[n]
    contains(envobject.service_account_email, "@appspot.gserviceaccount.com")
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_pipeline_pipeline[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Data Pipeline should not use default service account",
        "keyActualValue": "Google Data Pipeline is using default service account",
        "searchLine": common_lib.build_search_line(["resource", "google_data_pipeline_pipeline", name], []),
        "remediation": "set non default service account",
        "remediationType": "update"
    }
}

CxPolicy[result] {
    googledatapipeline := input.document[i].resource.google_data_pipeline_pipeline[name]
    googleworkload := googledatapipeline.workload[k]
    launchtemplate := googleworkload.dataflow_flex_template_request[m]
    launchparam := launchtemplate.launch_parameter[l]
    envobject := launchparam.environment[n]
    common_lib.emptyOrNull(envobject.service_account_email) == true
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_pipeline_pipeline[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Data Pipeline - should use user defined service account",
        "keyActualValue": "Google Data Pipeline - service account is undefined or null",
        "searchLine": common_lib.build_search_line(["resource", "google_data_pipeline_pipeline", name], []),
        "remediation": "set non default service account",
        "remediationType": "update"
    }
}
