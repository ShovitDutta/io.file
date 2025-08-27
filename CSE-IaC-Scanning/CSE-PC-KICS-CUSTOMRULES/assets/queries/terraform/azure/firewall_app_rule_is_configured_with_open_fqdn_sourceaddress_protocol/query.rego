package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
        azureFirewallAppRule := input.document[i].resource.azurerm_firewall_application_rule_collection[name].rule[j]
        azureFirewallAppRule.source_addresses[index] == "*"

        result := {
                "documentId": input.document[i].id,
                "resourceType": "azurerm_firewall_application_rule_collection",
                "resourceName": tf_lib.get_resource_name(azureFirewallAppRule, name),
                "searchKey": sprintf("azurerm_firewall_application_rule_collection[%s].rule.source_addresses", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": sprintf("azurerm_firewall_application_rule_collection[%s].rule.source_addresses should be defined and not contain *", [name]),
                "keyActualValue": sprintf("azurerm_firewall_application_rule_collection[%s].rule.source_addresses is invalid source addresses", [name]),
                "searchLine": common_lib.build_search_line(["resource", "azurerm_firewall_application_rule_collection", name, "rule"], []),
                "remediation": "update source_addresses should have valid source_addresses",
                "remediationType": "update",
       }
}

CxPolicy[result] {
        azureFirewallAppRule := input.document[i].resource.azurerm_firewall_application_rule_collection[name].rule[j]
        azureFirewallAppRule.target_fqdns[index] == "*"

        result := {
                "documentId": input.document[i].id,
                "resourceType": "azurerm_firewall_application_rule_collection",
                "resourceName": tf_lib.get_resource_name(azureFirewallAppRule, name),
                "searchKey": sprintf("azurerm_firewall_application_rule_collection[%s].rule.target_fqdns", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": sprintf("azurerm_firewall_application_rule_collection[%s].rule.target_fqdns should be defined and not contain *", [name]),
                "keyActualValue": sprintf("azurerm_firewall_application_rule_collection[%s].rule.target_fqdns is invalid source addresses", [name]),
                "searchLine": common_lib.build_search_line(["resource", "azurerm_firewall_application_rule_collection", name, "rule"], []),
                "remediation": "update target_fqdn should have valid fqdns",
                "remediationType": "update",
       }
}

CxPolicy[result] {
        azureFirewallAppRule := input.document[i].resource.azurerm_firewall_application_rule_collection[name].rule[j]
        azureprotocol := azureFirewallAppRule.protocol[k]
        azureprotocol.type == "Any"

        result := {
                "documentId": input.document[i].id,
                "resourceType": "azurerm_firewall_application_rule_collection",
                "resourceName": tf_lib.get_resource_name(azureFirewallAppRule, name),
                "searchKey": sprintf("azurerm_firewall_application_rule_collection[%s].rule.protocol.type", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": sprintf("azurerm_firewall_application_rule_collection[%s].rule.protocol.type should be defined and not contain Any", [name]),
                "keyActualValue": sprintf("azurerm_firewall_application_rule_collection[%s].rule.protocol.type is invalid type", [name]),
                "searchLine": common_lib.build_search_line(["resource", "azurerm_firewall_application_rule_collection", name, "rule"], []),
                "remediation": "update protocol type should have valid type http, https, mysql",
                "remediationType": "update",
       }
}
