package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


# This rule checks if the Azure Databricks workspace is using customer-managed keys (CMK) for encryption.

# check customer_managed_key_enabled is set to true for premium sku
CxPolicy[result] {
	az_data_bricks = input.document[i].resource.azurerm_databricks_workspace[name]

	# check if customer_managed_key_enabled for premium sku for databricks workspace
	lower(az_data_bricks.sku) == "premium"  # check if sku is standard
	az_data_bricks.customer_managed_key_enabled == false  # check if customer_managed_key_enabled is false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_databricks_workspace",
		"resourceName": tf_lib.get_resource_name(az_data_bricks, name),
		"searchKey": sprintf("azurerm_databricks_workspace[%s].customer_managed_key_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_databricks_workspace[%s].customer_managed_key_enabled should be defined true for premium sku", [name]),
		"keyActualValue": sprintf("azurerm_databricks_workspace[%s].customer_managed_key_enabled defined false for premium sku", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name, "customer_managed_key_enabled"], []),
		"remediation": "databricks workspace should be configured with customer managed key for encryption for premium sku",
		"remediationType": "addition",
	}
}

# check managed_disk_cmk_key_vault_key_id for databricks workspace
CxPolicy[result] {
	az_data_bricks = input.document[i].resource.azurerm_databricks_workspace[name]

	# check if customer_managed_key_enabled for premium sku for databricks workspace
	lower(az_data_bricks.sku) == "premium"  # check if sku is standard
	common_lib.emptyOrNull(az_data_bricks.managed_disk_cmk_key_vault_key_id)  # check if managed_disk_cmk_key_vault_key_id is empty or null

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_databricks_workspace",
		"resourceName": tf_lib.get_resource_name(az_data_bricks, name),
		"searchKey": sprintf("azurerm_databricks_workspace[%s].managed_disk_cmk_key_vault_key_id", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_databricks_workspace[%s].managed_disk_cmk_key_vault_key_id should be defined true for premium sku", [name]),
		"keyActualValue": sprintf("azurerm_databricks_workspace[%s].managed_disk_cmk_key_vault_key_id defined false for premium sku", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name, "managed_disk_cmk_key_vault_key_id"], []),
		"remediation": "databricks workspace managed disk should be configured with customer managed key for encryption for premium sku",
		"remediationType": "addition",
	}	
}

# check managed_services_cmk_key_vault_key_id for databricks workspace
CxPolicy[result] {
	az_data_bricks = input.document[i].resource.azurerm_databricks_workspace[name]

	# check if customer_managed_key_enabled for premium sku for databricks workspace
	lower(az_data_bricks.sku) == "premium"  # check if sku is standard
	common_lib.emptyOrNull(az_data_bricks.managed_services_cmk_key_vault_key_id)  # check if managed_services_cmk_key_vault_key_id is empty or null
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_databricks_workspace",
		"resourceName": tf_lib.get_resource_name(az_data_bricks, name),
		"searchKey": sprintf("azurerm_databricks_workspace[%s].managed_services_cmk_key_vault_key_id", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_databricks_workspace[%s].managed_services_cmk_key_vault_key_id should be defined true for premium sku", [name]),
		"keyActualValue": sprintf("azurerm_databricks_workspace[%s].managed_services_cmk_key_vault_key_id defined false for premium sku", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name, "managed_services_cmk_key_vault_key_id"], []),
		"remediation": "databricks workspace managed services should be configured with customer managed key for encryption for premium sku",
		"remediationType": "addition",
	}	
}


# check infrastructure_encryption_enabled(DBFS) for databricks workspace
CxPolicy[result] {
	az_data_bricks = input.document[i].resource.azurerm_databricks_workspace[name]

	# check if customer_managed_key_enabled for premium sku for databricks workspace
	lower(az_data_bricks.sku) == "premium"  # check if sku is standard
	az_data_bricks.infrastructure_encryption_enabled == false  # check if infrastructure_encryption_enabled is false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_databricks_workspace",
		"resourceName": tf_lib.get_resource_name(az_data_bricks, name),
		"searchKey": sprintf("azurerm_databricks_workspace[%s].infrastructure_encryption_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_databricks_workspace[%s].infrastructure_encryption_enabled should be defined true for premium sku", [name]),
		"keyActualValue": sprintf("azurerm_databricks_workspace[%s].infrastructure_encryption_enabled defined false for premium sku", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name, "infrastructure_encryption_enabled"], []),
		"remediation": "databricks workspace should be configured with infrastructure encryption for premium sku",
		"remediationType": "addition",
	}	
}