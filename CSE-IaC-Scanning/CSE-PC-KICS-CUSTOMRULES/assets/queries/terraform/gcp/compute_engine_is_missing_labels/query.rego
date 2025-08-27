package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


CxPolicy[result] {
   computeinterconnectsrv := input.document[i].resource.google_compute_instance[name]
   not common_lib.valid_key(computeinterconnectsrv.labels,"itpmid")
   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_compute_instance",
     "resourceName": tf_lib.get_resource_name(computeinterconnectsrv, name),
     "searchKey": sprintf("google_compute_instance[%s].labels", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_compute_instance[%s].labels.itpmid should be defined", [name]),
     "keyActualValue": sprintf("google_compute_instance[%s].labels.itpmid is undefined", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name, "labels"], []),
     "remediation": "Define itpmid under labels",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   computeinterconnectsrv := input.document[i].resource.google_compute_instance[name]
   not common_lib.valid_key(computeinterconnectsrv.labels,"environmenttype")
   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_compute_instance",
     "resourceName": tf_lib.get_resource_name(computeinterconnectsrv, name),
     "searchKey": sprintf("google_compute_instance[%s].labels", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_compute_instance[%s].labels.environmenttype should be defined", [name]),
     "keyActualValue": sprintf("google_compute_instance[%s].labels.environmenttype is undefined", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name, "labels"], []),
     "remediation": "Define environmenttype under labels",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   computeinterconnectsrv := input.document[i].resource.google_compute_instance[name]
   not common_lib.valid_key(computeinterconnectsrv.labels,"costcenter")
   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_compute_instance",
     "resourceName": tf_lib.get_resource_name(computeinterconnectsrv, name),
     "searchKey": sprintf("google_compute_instance[%s].labels", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_compute_instance[%s].labels.costcenter should be defined", [name]),
     "keyActualValue": sprintf("google_compute_instance[%s].labels.costcenter is undefined", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name, "labels"], []),
     "remediation": "Define costcenter under labels",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   computeinterconnectsrv := input.document[i].resource.google_compute_instance[name]
   not common_lib.valid_key(computeinterconnectsrv.labels,"dataclassification")
   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_compute_instance",
     "resourceName": tf_lib.get_resource_name(computeinterconnectsrv, name),
     "searchKey": sprintf("google_compute_instance[%s].labels", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_compute_instance[%s].labels.dataclassification should be defined", [name]),
     "keyActualValue": sprintf("google_compute_instance[%s].labels.dataclassification is undefined", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name, "labels"], []),
     "remediation": "Define dataclassification under labels",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   computeinterconnectsrv := input.document[i].resource.google_compute_instance[name]
   not common_lib.valid_key(computeinterconnectsrv.labels,"sharedemailaddress")
   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_compute_instance",
     "resourceName": tf_lib.get_resource_name(computeinterconnectsrv, name),
     "searchKey": sprintf("google_compute_instance[%s].labels", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_compute_instance[%s].labels.sharedemailaddress should be defined", [name]),
     "keyActualValue": sprintf("google_compute_instance[%s].labels.sharedemailaddress is undefined", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name, "labels"], []),
     "remediation": "Define sharedemailaddress under labels",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   computeinterconnectsrv := input.document[i].resource.google_compute_instance[name]
   not common_lib.valid_key(computeinterconnectsrv.labels,"applicationid")
   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_compute_instance",
     "resourceName": tf_lib.get_resource_name(computeinterconnectsrv, name),
     "searchKey": sprintf("google_compute_instance[%s].labels", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_compute_instance[%s].labels.applicationid should be defined", [name]),
     "keyActualValue": sprintf("google_compute_instance[%s].labels.applicationid is undefined", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name, "labels"], []),
     "remediation": "Define applicationid under labels",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   computeinterconnectsrv := input.document[i].resource.google_compute_instance[name]
   not common_lib.valid_key(computeinterconnectsrv.labels,"owner")
   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_compute_instance",
     "resourceName": tf_lib.get_resource_name(computeinterconnectsrv, name),
     "searchKey": sprintf("google_compute_instance[%s].labels", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_compute_instance[%s].labels.owner should be defined", [name]),
     "keyActualValue": sprintf("google_compute_instance[%s].labels.owner is undefined", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name, "labels"], []),
     "remediation": "Define owner under labels",
     "remediationType": "addition",
  }
}