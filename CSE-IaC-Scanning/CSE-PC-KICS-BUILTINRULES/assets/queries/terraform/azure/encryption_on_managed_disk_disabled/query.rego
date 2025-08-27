package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	encryption := input.document[i].resource.azurerm_managed_disk[name].encryption_settings[k]
	not common_lib.valid_key(encryption, "disk_encryption_key")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_managed_disk",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_managed_disk[name], name),
		"searchKey": sprintf("azurerm_managed_disk[%s].encryption_settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_managed_disk[%s].encryption_settings.disk_encryption_key should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_managed_disk[%s].encryption_settings.disk_encryption_key is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_managed_disk",name,"encryption_settings"], []),
		"remediation": "define disk_encryption_key under encryption_settings",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	encryption := input.document[i].resource.azurerm_managed_disk[name].encryption_settings[k]
	encryption.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_managed_disk",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_managed_disk[name], name),
		"searchKey": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled should be true ", [name]),
		"keyActualValue": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled is false", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_managed_disk" ,name ,"encryption_settings"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

