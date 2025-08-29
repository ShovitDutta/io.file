package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azurelb := input.document[i].resource.azurerm_lb[name].tags
	not common_lib.valid_key(azurelb,"itpmid")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_lb",
		"resourceName": tf_lib.get_resource_name(azurelb, name),
		"searchKey": sprintf("azurerm_lb[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_lb[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_lb[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_lb", name, "tags"], []),
		"remediation": "update the itpmid under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azurelb := input.document[i].resource.azurerm_lb[name].tags
	azurelb.itpmid == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_lb",
		"resourceName": tf_lib.get_resource_name(azurelb, name),
		"searchKey": sprintf("azurerm_lb[%s].tags.itpmid", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_lb[%s].tags.itpmid should not be empty", [name]),
		"keyActualValue": sprintf("azurerm_lb[%s].tags.itpmid is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_lb", name, "tags", "itpmid"], []),
		"remediation": "update itpmid",
		"remediationType": "update",
	}
}

CxPolicy[result] {
	azurelb := input.document[i].resource.azurerm_lb[name].tags
	not common_lib.valid_key(azurelb,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_lb",
		"resourceName": tf_lib.get_resource_name(azurelb, name),
		"searchKey": sprintf("azurerm_lb[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_lb[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_lb[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_lb", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azurelb := input.document[i].resource.azurerm_lb[name].tags
	azurelb.costcenter == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_lb",
		"resourceName": tf_lib.get_resource_name(azurelb, name),
		"searchKey": sprintf("azurerm_lb[%s].tags.costcenter", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_lb[%s].tags.costcenter should not be empty", [name]),
		"keyActualValue": sprintf("azurerm_lb[%s].tags.costcenter is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_lb", name, "tags", "costcenter"], []),
		"remediation": "update costcenter with proper costcenternumber",
		"remediationType": "update",
	}
}

CxPolicy[result] {
	azurelb := input.document[i].resource.azurerm_lb[name].tags
	not common_lib.valid_key(azurelb,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_lb",
		"resourceName": tf_lib.get_resource_name(azurelb, name),
		"searchKey": sprintf("azurerm_lb[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_lb[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_lb[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_lb", name, "tags"], []),
		"remediation": "update the dataclassification under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azurelb := input.document[i].resource.azurerm_lb[name].tags
	azurelb.dataclassification == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_lb",
		"resourceName": tf_lib.get_resource_name(azurelb, name),
		"searchKey": sprintf("azurerm_lb[%s].tags.dataclassification", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_lb[%s].tags.dataclassification should not be empty", [name]),
		"keyActualValue": sprintf("azurerm_lb[%s].tags.dataclassification is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_lb", name, "tags", "dataclassification"], []),
		"remediation": "update dataclassification e.g confidential, internet etc",
		"remediationType": "update",
	}
}

CxPolicy[result] {
	azurelb := input.document[i].resource.azurerm_lb[name].tags
	not common_lib.valid_key(azurelb,"environmenttype")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_lb",
		"resourceName": tf_lib.get_resource_name(azurelb, name),
		"searchKey": sprintf("azurerm_lb[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_lb[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_lb[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_lb", name, "tags"], []),
		"remediation": "update the environmenttype under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azurelb := input.document[i].resource.azurerm_lb[name].tags
	azurelb.environmenttype == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_lb",
		"resourceName": tf_lib.get_resource_name(azurelb, name),
		"searchKey": sprintf("azurerm_lb[%s].tags.environmenttype", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_lb[%s].tags.environmenttype should not be empty", [name]),
		"keyActualValue": sprintf("azurerm_lb[%s].tags.environmenttype is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_lb", name, "tags", "environmenttype"], []),
		"remediation": "update environmenttype e.g dev, nonprod, prod etc",
		"remediationType": "update",
	}
}

CxPolicy[result] {
	azurelb := input.document[i].resource.azurerm_lb[name].tags
	not common_lib.valid_key(azurelb,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_lb",
		"resourceName": tf_lib.get_resource_name(azurelb, name),
		"searchKey": sprintf("azurerm_lb[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_lb[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_lb[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_lb", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azurelb := input.document[i].resource.azurerm_lb[name].tags
	azurelb.sharedemailaddress == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_lb",
		"resourceName": tf_lib.get_resource_name(azurelb, name),
		"searchKey": sprintf("azurerm_lb[%s].tags.sharedemailaddress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_lb[%s].tags.sharedemailaddress should not be empty", [name]),
		"keyActualValue": sprintf("azurerm_lb[%s].tags.sharedemailaddress is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_lb", name, "tags", "sharedemailaddress"], []),
		"remediation": "update sharedemailaddress",
		"remediationType": "update",
	}
}