package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    spannerdb := input.document[i].resource.google_spanner_database[name]
    object.get(spannerdb, "encryption_config", "undefined") == "undefined"

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_spanner_database[%s].encryption_config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Cloud Spanner encryption config should be defined",
        "keyActualValue": "Cloud Spanner encryption config is undefined",
        "searchLine": common_lib.build_search_line(["resource", "google_spanner_database", name], []),
        "remediation": "Define encryption_config under google spanner database",
        "remediationType": "addition"
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.google_spanner_database[name]
    encryptionconfig := resource.encryption_config[k]
    encryptionconfig.kms_key_name == null

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_spanner_database[%s].encryption_config.kms_key_name", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Cloud Spanner Customer managed KMS key name should be defined",
        "keyActualValue": "Cloud Spanner Customer managed KMS key name is null or empty",
        "searchLine": common_lib.build_search_line(["resource", "google_spanner_database", name, "encryption_config"], []),
        "remediation": "set a valid kms_key_name under google spanner database",
        "remediationType": "update"
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.google_spanner_database[name]
    encryptionconfig := resource.encryption_config[k]
    not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",encryptionconfig.kms_key_name)

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_spanner_database[%s].encryption_config.kms_key_name", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Cloud Spanner Customer managed KMS key name should be valid and appropriate format",
        "keyActualValue": "Cloud Spanner Customer managed KMS key name is not in appropriate format",
        "searchLine": common_lib.build_search_line(["resource", "google_spanner_database", name, "encryption_config"], []),
        "remediation": "set a valid kms_key_name under google spanner database",
        "remediationType": "update"
    }
}