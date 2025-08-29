package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib
 
CxPolicy[result] {
        vertexaifeaturestore := input.document[i].resource.google_vertex_ai_featurestore[name]
        actualregion := vertexaifeaturestore.region
        expectedFromregionlist := ["us-east4", "us-west2", "us-central1"]
        not common_lib.inArray(expectedFromregionlist, actualregion)
 
        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_vertex_ai_featurestore",
                "resourceName": tf_lib.get_resource_name(vertexaifeaturestore, name),
                "searchKey": sprintf("google_vertex_ai_featurestore[%s]", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": sprintf("google_vertex_ai_featurestore[%s].region should be defined in approved region", [name]),
                "keyActualValue": sprintf("google_vertex_ai_featurestore[%s].region is not defined in approved region", [name]),
                "searchLine": common_lib.build_search_line(["resource", "google_vertex_ai_featurestore", name, "region"], []),
                "remediation": "Defined region set value either us-west2, us-central1, us-east4 under region",
                "remediationType": "update"
        }
}