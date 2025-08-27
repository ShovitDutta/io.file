package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	vertexaifeaturestore := input.document[i].resource.google_vertex_ai_featurestore[name]
	encryptionspec := vertexaifeaturestore.encryption_spec
        count(encryptionspec) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_vertex_ai_featurestore",
		"resourceName": tf_lib.get_resource_name(vertexaifeaturestore, name),
		"searchKey": sprintf("google_vertex_ai_featurestore[%s]", [name]),
		"issueType": "MissingValue",
		"keyExpectedValue": "google_vertex_ai_featurestore[%s].encryption_spec.kms_key_name should be defined",
		"keyActualValue": "google_vertex_ai_featurestore[%s].encryption_spec.kms_key_name is undefined",
		"searchLine": common_lib.build_search_line(["resource", "google_vertex_ai_featurestore", name, "encryption_spec"], []),
		"remediation": "set kms_key_name under encryption_spec.kms_key_name",
		"remediationType": "addition"
	}
}

CxPolicy[result] {
        vertexaifeaturestore := input.document[i].resource.google_vertex_ai_featurestore[name].encryption_spec[k]
        not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",vertexaifeaturestore.kms_key_name)
 
        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_vertex_ai_featurestore",
                "resourceName": tf_lib.get_resource_name(vertexaifeaturestore, name),
                "searchKey": sprintf("google_vertex_ai_featurestore[%s]", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": sprintf("google_vertex_ai_featurestore[%s].encryption_spec.kms_key_name should be attached valid CMEK", [name]),
                "keyActualValue": sprintf("google_vertex_ai_featurestore[%s].encryption_spec.kms_key_name is not attached CMEK", [name]),
                "searchLine": common_lib.build_search_line(["resource", "google_vertex_ai_featurestore", name, "encryption_spec"], []),
                "remediation": "Attach a valid CMEK under encryption_spec",
                "remediationType": "update"
        }
}