package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib
 
CxPolicy[result] {
        artifactRegistry := input.document[i].resource.google_artifact_registry_repository[name]
        actualLocation := artifactRegistry.location
        expectedFromLocationlist := ["us", "us-east1", "us-east2", "us-central1"]
        not common_lib.inArray(expectedFromLocationlist, actualLocation)
 
        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_artifact_registry_repository",
                "resourceName": tf_lib.get_resource_name(artifactRegistry, name),
                "searchKey": sprintf("google_artifact_registry_repository[%s]", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": sprintf("google_artifact_registry_repository[%s].location should be there", [name]),
                "keyActualValue": sprintf("google_artifact_registry_repository[%s].location is missing", [name]),
                "searchLine": common_lib.build_search_line(["resource", "google_artifact_registry_repository", name, "location"], []),
                "remediation": "use only allowed locations for location",
                "remediationType": "addition"
        }
}
