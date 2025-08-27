package Cx

import data.generic.terraform as tf_lib 

CxPolicy[result] {
	resource := input.document[i].data.azurerm_storage_account_sas[name]
	# Extracts start and expiration times from the SAS resource
    start_time := time.parse_rfc3339_ns(resource.start)
    expiry_time := time.parse_rfc3339_ns(resource.expiry)

	# Calculates the difference between the start and expiration times in nanoseconds
	diff := expiry_time-start_time

	# Calculates the nanoseconds in 7 days and assigns it to a variable
	min := 604800*1000*1000*1000

    # Check that the start and expiry times are greater than 7 days (in nanoseconds)
    not diff > min

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault_key",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_storage_account_sas[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'expiry' should exist and be a minimum of 7 days after 'start'",
		"keyActualValue": "'expiry' is missing or too short a delta",
	}
}