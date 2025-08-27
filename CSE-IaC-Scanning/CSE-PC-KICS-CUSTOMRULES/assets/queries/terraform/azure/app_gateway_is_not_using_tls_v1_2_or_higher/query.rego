package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azgateway := input.document[i].resource.azurerm_application_gateway[name]
	not common_lib.valid_key(azgateway, "ssl_profile")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(azgateway, name),
		"searchKey": sprintf("azurerm_application_gateway[%s].ssl_profile.ssl_policy.disabled_protocols", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].ssl_profile.ssl_policy.disabled_protocols should be defined and set it to TLSv1_0 or TLSv1_1", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].ssl_profile.ssl_policy.disabled_protocols is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name], []),
		"remediation": "define ssl_profile.ssl_policy.disabled_protocols and set the protcol version to TLSV1_0 and or TLSV1_1",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azgateway := input.document[i].resource.azurerm_application_gateway[name].ssl_profile[j]
	azgwssl := azgateway.ssl_policy[k]
    azgwdisabledprotocol := azgwssl.disabled_protocols[m]
	tls_version_to_disable := ["TLSv1_0", "TLSv1_1"]
    not common_lib.inArray(tls_version_to_disable, azgwdisabledprotocol)
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_application_gateway[name], name),
		"searchKey": sprintf("azurerm_application_gateway[%s].ssl_profile.ssl_policy.disabled_protocols", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].ssl_profile.ssl_policy.disabled_protocols should be defined and set it to TLSV1_0 or TLSV1_1", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].ssl_profile.ssl_policy.disabled_protocols is not set it to TLSV1_0 or TLSV1_1", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "ssl_profile"], []),
		"remediation": "ssl_profile.ssl_policy.disabled_protocols should be set it to TLSV1_0 or TLSV1_1",
		"remediationType": "update",
	}	
}