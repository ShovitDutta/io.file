package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    datafusioninstance := input.document[i].resource.google_data_fusion_instance[name].crypto_key_config[k]
    not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",datafusioninstance.key_reference)
    
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_data_fusion_instance[%s].crypto_key_config.key_reference", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "google_data_fusion_instance - crypto_key_config.key_refernece should use CMEK",
        "keyActualValue": "google_data_fusion_instance - crypto_key_config.key_refernece is incorrect or undefined",
        "searchLine": common_lib.build_search_line(["resource", "google_data_fusion_instance", name, "crypto_key_config"], []),
        "remediation": "set key_reference as Customer Managed Encryption Key",
        "remediationType": "update",
    }
}