package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azuremysqlflexibleserver := input.document[i].resource.azurerm_mysql_flexible_server[name]
	not common_lib.valid_key(azuremysqlflexibleserver.tags,"itpmid")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mysql_flexible_server",
		"resourceName": tf_lib.get_resource_name(azuremysqlflexibleserver, name),
		"searchKey": sprintf("azurerm_mysql_flexible_server[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_mysql_flexible_server[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_mysql_flexible_server[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mysql_flexible_server", name, "tags"], []),
		"remediation": "update the itpmid under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azuremysqlflexibleserver := input.document[i].resource.azurerm_mysql_flexible_server[name]
	not common_lib.valid_key(azuremysqlflexibleserver.tags,"costcenter")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mysql_flexible_server",
		"resourceName": tf_lib.get_resource_name(azuremysqlflexibleserver, name),
		"searchKey": sprintf("azurerm_mysql_flexible_server[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_mysql_flexible_server[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_mysql_flexible_server[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mysql_flexible_server", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azuremysqlflexibleserver := input.document[i].resource.azurerm_mysql_flexible_server[name]
	not common_lib.valid_key(azuremysqlflexibleserver.tags,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mysql_flexible_server",
		"resourceName": tf_lib.get_resource_name(azuremysqlflexibleserver, name),
		"searchKey": sprintf("azurerm_mysql_flexible_server[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_mysql_flexible_server[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_mysql_flexible_server[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mysql_flexible_server", name, "tags"], []),
		"remediation": "update the dataclassification under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azuremysqlflexibleserver := input.document[i].resource.azurerm_mysql_flexible_server[name]
	not common_lib.valid_key(azuremysqlflexibleserver.tags,"environmenttype")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mysql_flexible_server",
		"resourceName": tf_lib.get_resource_name(azuremysqlflexibleserver, name),
		"searchKey": sprintf("azurerm_mysql_flexible_server[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_mysql_flexible_server[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_mysql_flexible_server[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mysql_flexible_server", name, "tags"], []),
		"remediation": "update the environmenttype under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azuremysqlflexibleserver := input.document[i].resource.azurerm_mysql_flexible_server[name]
	not common_lib.valid_key(azuremysqlflexibleserver.tags,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mysql_flexible_server",
		"resourceName": tf_lib.get_resource_name(azuremysqlflexibleserver, name),
		"searchKey": sprintf("azurerm_mysql_flexible_server[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_mysql_flexible_server[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_mysql_flexible_server[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mysql_flexible_server", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}