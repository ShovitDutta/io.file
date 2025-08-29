package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azresource := input.document[i].resource.azurerm_redis_cache[name]
	azresource.sku_name == "Basic"
	azresource.tags.environmenttype == "Prod"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(azresource, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].sku_name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_redis_cache[%s].sku_name should be defined and set to premium", [name]),
		"keyActualValue": sprintf("azurerm_redis_cache[%s].sku_name is not set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_redis_cache", name, "sku_name"], []),
		"remediation": "sku_name set to Premium",
		"remediationType": "update",
	}	
}

CxPolicy[result] {
	azresource := input.document[i].resource.azurerm_redis_cache[name]
	azresource.sku_name == "Standard"
	azresource.tags.environmenttype == "Prod"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(azresource, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].sku_name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_redis_cache[%s].sku_name should be defined and set to premium", [name]),
		"keyActualValue": sprintf("azurerm_redis_cache[%s].sku_name is not set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_redis_cache", name, "sku_name"], []),
		"remediation": "sku_name set to Premium",
		"remediationType": "update",
	}	
}