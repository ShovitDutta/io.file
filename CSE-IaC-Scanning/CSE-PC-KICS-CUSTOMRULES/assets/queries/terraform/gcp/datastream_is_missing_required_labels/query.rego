package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
   datastreamsrv := input.document[i].resource.google_datastream_stream[name]
   not common_lib.valid_key(datastreamsrv.labels,"itpmid")

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_datastream_stream",
     "resourceName": tf_lib.get_resource_name(datastreamsrv, name),
     "searchKey": sprintf("google_datastream_stream[%s].labels", [name]),
     "issueType": "MissingValue",
     "keyExpectedValue": sprintf("google_datastream_stream[%s].labels.itpmid should be defined", [name]),
     "keyActualValue": sprintf("google_datastream_stream[%s].labels.itpmid is missing", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_datastream_stream", name], []),
     "remediation": "itpmid should be defined under labels",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   datastreamsrv := input.document[i].resource.google_datastream_stream[name]
   not common_lib.valid_key(datastreamsrv.labels,"costcenter")

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_datastream_stream",
     "resourceName": tf_lib.get_resource_name(datastreamsrv, name),
     "searchKey": sprintf("google_datastream_stream[%s].labels", [name]),
     "issueType": "MissingValue",
     "keyExpectedValue": sprintf("google_datastream_stream[%s].labels.costcenter should be defined", [name]),
     "keyActualValue": sprintf("google_datastream_stream[%s].labels.costcenter is missing", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_datastream_stream", name], []),
     "remediation": "costcetner should be defined under labels",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   datastreamsrv := input.document[i].resource.google_datastream_stream[name]
   not common_lib.valid_key(datastreamsrv.labels,"applicationid")

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_datastream_stream",
     "resourceName": tf_lib.get_resource_name(datastreamsrv, name),
     "searchKey": sprintf("google_datastream_stream[%s].labels", [name]),
     "issueType": "MissingValue",
     "keyExpectedValue": sprintf("google_datastream_stream[%s].labels.applicationid should be defined", [name]),
     "keyActualValue": sprintf("google_datastream_stream[%s].labels.applicationid is missing", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_datastream_stream", name], []),
     "remediation": "applicationid should be defined under labels",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   datastreamsrv := input.document[i].resource.google_datastream_stream[name]
   not common_lib.valid_key(datastreamsrv.labels,"sharedemailaddress")

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_datastream_stream",
     "resourceName": tf_lib.get_resource_name(datastreamsrv, name),
     "searchKey": sprintf("google_datastream_stream[%s].labels", [name]),
     "issueType": "MissingValue",
     "keyExpectedValue": sprintf("google_datastream_stream[%s].labels.sharedemailaddress should be defined", [name]),
     "keyActualValue": sprintf("google_datastream_stream[%s].labels.sharedemailaddress is missing", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_datastream_stream", name], []),
     "remediation": "sharedemailaddress should be defined under labels",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   datastreamsrv := input.document[i].resource.google_datastream_stream[name]
   not common_lib.valid_key(datastreamsrv.labels,"environmenttype")

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_datastream_stream",
     "resourceName": tf_lib.get_resource_name(datastreamsrv, name),
     "searchKey": sprintf("google_datastream_stream[%s].labels", [name]),
     "issueType": "MissingValue",
     "keyExpectedValue": sprintf("google_datastream_stream[%s].labels.environmenttype should be defined", [name]),
     "keyActualValue": sprintf("google_datastream_stream[%s].labels.environmenttype is missing", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_datastream_stream", name], []),
     "remediation": "environmenttype should be defined under labels",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   datastreamsrv := input.document[i].resource.google_datastream_stream[name]
   not common_lib.valid_key(datastreamsrv.labels,"dataclassification")

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_datastream_stream",
     "resourceName": tf_lib.get_resource_name(datastreamsrv, name),
     "searchKey": sprintf("google_datastream_stream[%s].labels", [name]),
     "issueType": "MissingValue",
     "keyExpectedValue": sprintf("google_datastream_stream[%s].labels.dataclassification should be defined", [name]),
     "keyActualValue": sprintf("google_datastream_stream[%s].labels.dataclassification is missing", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_datastream_stream", name], []),
     "remediation": "dataclassification should be defined under labels",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   datastreamsrv := input.document[i].resource.google_datastream_stream[name]
   not common_lib.valid_key(datastreamsrv.labels,"owner")

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_datastream_stream",
     "resourceName": tf_lib.get_resource_name(datastreamsrv, name),
     "searchKey": sprintf("google_datastream_stream[%s].labels", [name]),
     "issueType": "MissingValue",
     "keyExpectedValue": sprintf("google_datastream_stream[%s].labels.owner should be defined", [name]),
     "keyActualValue": sprintf("google_datastream_stream[%s].labels.owner is missing", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_datastream_stream", name], []),
     "remediation": "owner should be defined under labels",
     "remediationType": "addition",
  }
}