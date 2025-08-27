package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

# This rule checks if the azurerm_redis_cache resource has the non_ssl_port_enabled attribute set to true.
CxPolicy[result] {
	cache := input.document[i].resource.azurerm_redis_cache[name]
	cache.non_ssl_port_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(cache, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].non_ssl_port_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_redis_cache[%s].non_ssl_port_enabled' should be set to false or undefined (false as default)", [name]),
		"keyActualValue": sprintf("'azurerm_redis_cache[%s].non_ssl_port_enabled' is true", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_redis_cache" ,name, "non_ssl_port_enabled"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}
