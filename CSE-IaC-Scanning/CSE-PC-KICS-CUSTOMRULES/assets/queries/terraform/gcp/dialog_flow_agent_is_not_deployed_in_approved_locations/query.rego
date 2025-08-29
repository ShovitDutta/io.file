package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib
 
CxPolicy[result] {
        dialogflowcxagent := input.document[i].resource.google_dialogflow_cx_agent[name]
        actualLocation := dialogflowcxagent.location
        expectedFromLocationlist := ["us*", "us-east1", "us-west2", "us-central1", "us-east4"]
        not common_lib.inArray(expectedFromLocationlist, actualLocation)
 
        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_dialogflow_cx_agent",
                "resourceName": tf_lib.get_resource_name(dialogflowcxagent, name),
                "searchKey": sprintf("google_dialogflow_cx_agent[%s]", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": sprintf("google_dialogflow_cx_agent[%s].location should be defined in approved location", [name]),
                "keyActualValue": sprintf("google_dialogflow_cx_agent[%s].location is not defined in approved location", [name]),
                "searchLine": common_lib.build_search_line(["resource", "google_dialogflow_cx_agent", name, "location"], []),
                "remediation": "Defined approved locations us*,us-east1, us-west2, us-central1, us-east4 under location",
                "remediationType": "update"
        }
}
