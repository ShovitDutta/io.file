package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name]
    skuname := ["Developer", "Premium"]
    not containsku(skuname, azureapimgmt)
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(azureapimgmt, name),
		"searchKey": sprintf("azurerm_api_management[%s].sku_name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_api_management[%s].sku_name should be either Developer or Platimum", [name]),
		"keyActualValue": sprintf("azurerm_api_management[%s].sku_name is not undefined or not developer or platinum", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "sku_name"], []),
		"remediation": "update the sku_name use Developer or Premium",
		"remediationType": "Update",
	}
}

containsku(skuname, azureapimgmt){
   some i
    contains(azureapimgmt.sku_name,skuname[i])
}
