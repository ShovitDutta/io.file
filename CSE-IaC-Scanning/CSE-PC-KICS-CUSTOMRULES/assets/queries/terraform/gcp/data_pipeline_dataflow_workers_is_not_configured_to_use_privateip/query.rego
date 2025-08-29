package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    googledatapipeline := input.document[i].resource.google_data_pipeline_pipeline[name].workload[k]
    launchtemplate := googledatapipeline.dataflow_launch_template_request[m]
    launchparam := launchtemplate.launch_parameters[l]
    envobject := launchparam.environment[n]
    envobject.ip_configuration != "WORKER_IP_PRIVATE"


    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_pipeline_pipeline[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Google Data Pipeline data flow worker should use PrivateIP",
        "keyActualValue": "Google Data Pipeline data flow worker is not using PrivateIP",
        "searchLine": common_lib.build_search_line(["resource", "google_data_pipeline_pipeline", name, "workload"], []),
        "remediation": "set ip configuration to use WORKER_IP_PRIVATE",
        "remediationType": "update"
    }
}