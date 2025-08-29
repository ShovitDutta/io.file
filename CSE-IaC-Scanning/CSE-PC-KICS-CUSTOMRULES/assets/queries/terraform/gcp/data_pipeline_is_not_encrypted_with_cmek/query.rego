package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    googledatapipeline := input.document[i].resource.google_data_pipeline_pipeline[name].workload[k]
    launchtemplate := googledatapipeline.dataflow_launch_template_request[m]
    launchparam := launchtemplate.launch_parameters[l]
    envobject := launchparam.environment[n]
    not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",envobject.kms_key_name)
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_pipeline_pipeline[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Data Pipeline should define valid CMEK",
        "keyActualValue": "Google Data Pipeline is incorrect or missing CMEK",
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
    common_lib.emptyOrNull(envobject.kms_key_name) == true
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_pipeline_pipeline[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Data Pipeline - should use CMEK",
        "keyActualValue": "Google Data Pipeline - CMEK is null",
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
    not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",envobject.kms_key_name)
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_pipeline_pipeline[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Data Pipeline should define valid CMEK",
        "keyActualValue": "Google Data Pipeline is incorrect or missing CMEK",
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
    common_lib.emptyOrNull(envobject.kms_key_name) == true
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_pipeline_pipeline[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Data Pipeline - should use CMEK",
        "keyActualValue": "Google Data Pipeline - CMEK is null",
        "searchLine": common_lib.build_search_line(["resource", "google_data_pipeline_pipeline", name], []),
        "remediation": "set non default service account",
        "remediationType": "update"
    }
}
