package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
        cloudrun_svc := input.document[i].resource.google_cloud_run_v2_service[name]
        cloudrun_svc_deployed_location := cloudrun_svc.location
        approved_location_list := ["us-east4", "us-west2", "us", "us-central1"]
        not common_lib.inArray(approved_location_list, cloudrun_svc_deployed_location)

        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_cloud_run_v2_service",
                "resourceName": tf_lib.get_resource_name(cloudrun_svc, name),
                "searchKey": sprintf("google_cloud_run_v2_service[%s]", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": sprintf("google_cloud_run_v2_service[%s].location should be one of the approved locations", [name]),
                "keyActualValue": sprintf("google_cloud_run_v2_service[%s].location is deployed in invalid region", [name]),
                "searchLine": common_lib.build_search_line(["resource", "google_cloud_run_v2_service", name, "location"], []),
                "remediation": "only approved locations are allowed",
                "remediationType": "update"
        }
}