package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	storageBucket := input.document[i].resource.azurerm_storage_account[name]
	not common_lib.valid_key(storageBucket.tags,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(storageBucket, name),
		"searchKey": sprintf("azurerm_storage_account[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_storage_account[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_storage_account[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "tags"], []),
		"remediation": "sharedemailaddress = some_address",
		"remediationType": "addition",
	}
}