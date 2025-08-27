package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_mssql_database[name]
	not common_lib.valid_key(resource, "transparent_data_encryption_key_vault_key_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mssql_database",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mssql_database[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mssql_database[%s].transparent_data_encryption_key_vault_key_id' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_database[%s].transparent_data_encryption_key_vault_key_id' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_database", name], []),
		"remediation": "Set transparent_data_encryption_key_vault_key_id to a valid Key Vault key for Customer-managed Transparent Data Encryption",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_mssql_database[name]
	common_lib.emptyOrNull(resource.transparent_data_encryption_key_vault_key_id) = true
	

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mssql_database",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mssql_database[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mssql_database[%s].transparent_data_encryption_key_vault_key_id' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_database[%s].transparent_data_encryption_key_vault_key_id' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_database", name, "transparent_data_encryption_key_vault_key_id"], []),
		"remediation": "Set transparent_data_encryption_key_vault_key_id to a valid Key Vault key for Customer-managed Transparent Data Encryption",
		"remediationType": "addition",
	}
}