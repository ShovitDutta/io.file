package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# This rule checks if the azurerm_redis_cache resource has the patch_schedule attribute defined and not null.
CxPolicy[result] {
	redis_cache := input.document[i].resource.azurerm_redis_cache[name]

	count(redis_cache.patch_schedule) == 0	

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(redis_cache, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].patch_schedule", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_redis_cache[%s].patch_schedule' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_redis_cache[%s].patch_schedule' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_redis_cache" ,name, "patch_schedule"], []),
		"remediation": "Define patch_schedule for azurerm_redis_cache",
		"remediationType": "addition",
	}
}
