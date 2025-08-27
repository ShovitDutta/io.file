package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


# Function to validate the key_vault_key_id
is_valid_key(key_id) {
    key_id != null
    key_id != ""
	regex.match(".+\\.vault\\.azure\\.net/keys/.+/[0-9a-fA-F-]+$", key_id) # Regex to check if the key_id is a valid URL and contains the version
}

# Policy to check if customer_managed_key is missing
CxPolicy[result] {
	az_service_bus_cmk := input.document[i].resource.azurerm_servicebus_namespace[name].customer_managed_key
	count(az_service_bus_cmk) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_servicebus_namespace",
		"resourceName": tf_lib.get_resource_name(az_service_bus_cmk, name),
		"searchKey": sprintf("azurerm_servicebus_namespace[%s].customer_managed_key", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_servicebus_namespace[%s].customer_managed_key should be defined", [name]),
		"keyActualValue": sprintf("azurerm_servicebus_namespace[%s].customer_managed_key is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_servicebus_namespace", name, "customer_managed_key"], []),
		"remediation": "define customer_managed_key for encryption",
		"remediationType": "addition",
	}	
}

# Policy to validate the key_vault_key_id
CxPolicy[result] {
    az_service_bus_cmk := input.document[i].resource.azurerm_servicebus_namespace[name].customer_managed_key[j]

    not is_valid_key(az_service_bus_cmk.key_vault_key_id)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_servicebus_namespace",
        "resourceName": tf_lib.get_resource_name(az_service_bus_cmk, name),
        "searchKey": sprintf("azurerm_servicebus_namespace[%s].customer_managed_key.key_vault_key_id", [name]),
        "issueType": "InvalidAttribute",
        "keyExpectedValue": sprintf("azurerm_servicebus_namespace[%s].customer_managed_key.key_vault_key_id should be a valid URL with key version", [name]),
        "keyActualValue": sprintf("azurerm_servicebus_namespace[%s].customer_managed_key.key_vault_key_id is invalid", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_servicebus_namespace", name, "customer_managed_key", "key_vault_key_id"], []),
        "remediation": "provide a valid key_vault_key_id",
        "remediationType": "correction",
    }
}

