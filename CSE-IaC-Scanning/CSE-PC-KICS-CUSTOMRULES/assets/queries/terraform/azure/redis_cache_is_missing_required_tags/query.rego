package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azresource := input.document[i].resource.azurerm_redis_cache[name]
	not common_lib.valid_key(azresource.tags,"itpmid")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(azresource, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_redis_cache[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_redis_cache[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_redis_cache", name, "tags"], []),
		"remediation": "update the itpmid under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azresource := input.document[i].resource.azurerm_redis_cache[name]
	not common_lib.valid_key(azresource.tags,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(azresource, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_redis_cache[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_redis_cache[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_redis_cache", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azresource := input.document[i].resource.azurerm_redis_cache[name]
	not common_lib.valid_key(azresource.tags,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(azresource, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_redis_cache[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_redis_cache[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_redis_cache", name, "tags"], []),
		"remediation": "update the dataclassification under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azresource := input.document[i].resource.azurerm_redis_cache[name]
	not common_lib.valid_key(azresource.tags,"environmenttype")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(azresource, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_redis_cache[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_redis_cache[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_redis_cache", name, "tags"], []),
		"remediation": "update the environmenttype under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azresource := input.document[i].resource.azurerm_redis_cache[name]
	not common_lib.valid_key(azresource.tags,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(azresource, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_redis_cache[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_redis_cache[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_redis_cache", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}