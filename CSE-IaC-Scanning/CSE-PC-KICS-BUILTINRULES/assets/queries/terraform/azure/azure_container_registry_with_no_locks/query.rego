package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resourceRegistry := input.document[i].resource.azurerm_container_registry[name]
	resourceLock := input.document[i].resource.azurerm_management_lock[k]

	
	#	scopeSplitted := split(resourceLock.scope, ".")
	#	not re_match(scopeSplitted[1], name)

	# Convert both scope and name to lowercase for case-insensitive comparison
    scopeLower := lower(resourceLock.scope)
    nameLower := lower(resourceRegistry.name)

    not contains(scopeLower, nameLower)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_management_lock",
		"resourceName": tf_lib.get_resource_name(resourceLock, k),
		"searchKey": sprintf("azurerm_management_lock[%s].scope", [k]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_management_lock[%s] scope' should contain azurerm_container_registry[name]'", [k]),
		"keyActualValue": sprintf("'azurerm_management_lock[%s] scope' does not contain azurerm_container_registry[name]'", [k]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_management_lock", k, "scope"], []),
	}
}


