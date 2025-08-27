package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
  dnszone := input.document[i].resource.google_dns_managed_zone[name]
  dnszone.visibility == "public"

  result := {
        "documentId": input.document[i].id,
        "resourceType": "google_dns_managed_zone",
        "searchKey": sprintf("google_dns_managed_zone[%s].visibility", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Cloud DNS Zone type is set to public",
        "keyActualValue": "Cloud DNS Zone type should be set to private",
        "searchLine": common_lib.build_search_line(["resource", "google_dns_managed_zone", name, "visibility"], []),
        "remediation": "set visibility to private",
        "remediationType": "update"
    }
}