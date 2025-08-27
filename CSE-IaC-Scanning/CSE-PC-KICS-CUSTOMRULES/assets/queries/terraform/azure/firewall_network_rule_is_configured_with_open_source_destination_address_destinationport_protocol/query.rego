package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
        azureFirewallNetworkRule := input.document[i].resource.azurerm_firewall_network_rule_collection[name].rule[j]
        azureFirewallNetworkRule.destination_ports[index] == "*"

        result := {
                "documentId": input.document[i].id,
                "resourceType": "azurerm_firewall_network_rule_collection",
                "resourceName": tf_lib.get_resource_name(azureFirewallNetworkRule, name),
                "searchKey": sprintf("azurerm_firewall_network_rule_collection[%s].rule.destination_ports", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": sprintf("azurerm_firewall_network_rule_collection[%s].rule.destination_ports should be defined and not contain *", [name]),
                "keyActualValue": sprintf("azurerm_firewall_network_rule_collection[%s].rule.destination_ports is undefined or null or invalid source addresses", [name]),
                "searchLine": common_lib.build_search_line(["resource", "azurerm_firewall_network_rule_collection", name, "rule", "destination_ports"], []),
                "remediation": "update destination_ports should have valid destination_ports",
                "remediationType": "update",
       }
}

CxPolicy[result] {
        azureFirewallNetworkRule := input.document[i].resource.azurerm_firewall_network_rule_collection[name].rule[j]
	azureFirewallNetworkRule.destination_addresses[index] == "*"

        result := {
                "documentId": input.document[i].id,
                "resourceType": "azurerm_firewall_network_rule_collection",
                "resourceName": tf_lib.get_resource_name(azureFirewallNetworkRule, name),
                "searchKey": sprintf("azurerm_firewall_network_rule_collection[%s].rule.destination_addresses", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": sprintf("azurerm_firewall_network_rule_collection[%s].rule.destination_addresses should be defined and not contain Any", [name]),
                "keyActualValue": sprintf("azurerm_firewall_network_rule_collection[%s].rule.destination_addresses is undefined or null or invalid type", [name]),
                "searchLine": common_lib.build_search_line(["resource", "azurerm_firewall_network_rule_collection", name, "rule", "destination_addresses"], []),
                "remediation": "update destination_addresses should have valid destination_addresses",
                "remediationType": "update",
       }
}

CxPolicy[result] {
        azureFirewallNetworkRule := input.document[i].resource.azurerm_firewall_network_rule_collection[name].rule[j]
        azureFirewallNetworkRule.protocols[index] == "Any"

        result := {
                "documentId": input.document[i].id,
                "resourceType": "azurerm_firewall_network_rule_collection",
                "resourceName": tf_lib.get_resource_name(azureFirewallNetworkRule, name),
                "searchKey": sprintf("azurerm_firewall_network_rule_collection[%s].rule.protocols", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": sprintf("azurerm_firewall_network_rule_collection[%s].rule  protocol type should be defined and not contain Any", [name]),
                "keyActualValue": sprintf("azurerm_firewall_network_rule_collection[%s].rule - protocol type is undefined or has incorrect value", [name]),
                "searchLine": common_lib.build_search_line(["resource", "azurerm_firewall_network_rule_collection", name, "rule", "protocols"], []),
                "remediation": "update protocol should have valid type icmp,tcp,udp",
                "remediationType": "update",
       }
}

CxPolicy[result] {
        azureFirewallNetworkRule := input.document[i].resource.azurerm_firewall_network_rule_collection[name].rule[j]
        azureFirewallNetworkRule.source_addresses[index] == "*"

        result := {
                "documentId": input.document[i].id,
                "resourceType": "azurerm_firewall_network_rule_collection",
                "resourceName": tf_lib.get_resource_name(azureFirewallNetworkRule, name),
                "searchKey": sprintf("azurerm_firewall_network_rule_collection[%s].rule.source_addresses", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": sprintf("azurerm_firewall_network_rule_collection[%s].rule.source_addresses should be defined and not contain Any", [name]),
                "keyActualValue": sprintf("azurerm_firewall_network_rule_collection[%s].rule.source_addresses is undefined or null or invalid type", [name]),
                "searchLine": common_lib.build_search_line(["resource", "azurerm_firewall_network_rule_collection", name, "rule", "source_addresses"], []),
                "remediation": "update source_addresses should have valid source_addresses",
                "remediationType": "update",
       }
}
