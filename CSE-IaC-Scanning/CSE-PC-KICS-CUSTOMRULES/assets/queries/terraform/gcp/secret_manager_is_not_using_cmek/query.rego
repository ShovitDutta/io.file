package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib
 
CxPolicy[result] {
        regionalsecret := input.document[i].resource.google_secret_manager_regional_secret[name]
        count(regionalsecret.customer_managed_encryption[k]) == 0

        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_secret_manager_regional_secret",
                "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_secret_manager_regional_secret[name], name),
                "searchKey": sprintf("google_secret_manager_regional_secret[%s]", [name]),
                "issueType": "MissingAttribute",
                "keyExpectedValue": sprintf("google_secret_manager_regional_secret[%s].customer_managed_encryption.kms_key_name should be there", [name]),
                "keyActualValue": sprintf("google_secret_manager_regional_secret[%s].customer_managed_encryption.kms_key_name is missing", [name]),
                "searchLine": common_lib.build_search_line(["resource", "google_secret_manager_regional_secret", name], []),
                "remediation": "add CMEK under kms_key_name",
                "remediationType": "addition",
        }
}

CxPolicy[result] {
        regionalsecret := input.document[i].resource.google_secret_manager_regional_secret[name]
        cmekobject := regionalsecret.customer_managed_encryption[k]
        not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",cmekobject.kms_key_name)
   
        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_secret_manager_regional_secret",
                "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_secret_manager_regional_secret[name], name),
                "searchKey": sprintf("google_secret_manager_regional_secret[%s].customer_managed_encryption.kms_key_name", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": sprintf("google_secret_manager_regional_secret[%s].customer_managed_encryption.kms_key_name should be attached valid CMEK", [name]),
                "keyActualValue": sprintf("google_secret_manager_regional_secret[%s].customer_managed_encryption.kms_key_name is not attached CMEK", [name]),
                "searchLine": common_lib.build_search_line(["resource", "google_secret_manager_regional_secret", name, "customer_managed_encryption"], []),
                "remediation": "Update a valid CMEK",
                "remediationType": "update",
        }
}