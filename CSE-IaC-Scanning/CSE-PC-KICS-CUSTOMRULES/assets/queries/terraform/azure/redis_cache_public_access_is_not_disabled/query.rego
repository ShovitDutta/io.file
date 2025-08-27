package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azresource := input.document[i].resource.azurerm_redis_cache[name]
	azresource.public_network_access_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(azresource, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_redis_cache[%s].public_network_access_enabled should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_redis_cache[%s].public_network_access_enabled is not set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_redis_cache", name, "public_network_access_enabled"], []),
		"remediation": "public_network_access_enabled set to false",
		"remediationType": "update",
	}	
}