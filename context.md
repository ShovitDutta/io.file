# KICS Custom Rules Development Context

## Project Overview

This repository contains custom security rules for KICS (Keeping Infrastructure as Code Secure), an open-source static code analysis tool for Infrastructure as Code (IaC). The rules are specifically designed for CVS Health's security requirements.

The project consists of two main components:

1. **KICS Engine** - The core open-source scanning engine
2. **CSE-IaC-Scanning** - CVS Health's custom rules and CISS (IaC Scan) product

## Key Components

### 1. KICS Engine

- Located in the `kics` directory
- Open-source tool written in Go using Open Policy Agent (OPA)
- Supports scanning multiple IaC technologies (Terraform, Kubernetes, Ansible, CloudFormation, etc.)
- Uses Rego query language for defining security rules

### 2. CSE-IaC-Scanning Repository Structure

The CSE-IaC-Scanning repository contains:

- **CISS (Cloud Infrastructure Scanning Service)** - A packaged standalone executable for scanning Terraform plan files
- **Custom Rules** - Located in `CSE-PC-KICS-CUSTOMRULES/assets/queries/`
- **Built-in Rules** - Located in `CSE-PC-KICS-BUILTINRULES/`
- **Rule Testing Framework** - In the `RulesTesting` directory
- **Pipeline Scripts** - For CI/CD integration
- **Custom Rules CSV** - `custom_rules.csv` containing all custom rules metadata

### 3. Custom Rules Structure

Rules follow a specific directory structure:

```
CSE-PC-KICS-CUSTOMRULES/
  assets/
    queries/
      terraform/
        azure/
          service_name/
            rule_name/
              metadata.json     # Rule metadata
              query.rego       # Rego policy logic
              test/
                positive.json              # Example with issue
                negative.json              # Example without issue
                positive_expected_result.json  # Expected findings
        gcp/
          service_name/
            rule_name/
              # Same structure as Azure
```

### 4. Rule Metadata Format

Rules are documented in `custom_rules.csv` with fields:

- Primary_ID, Secondary_ID
- Rule_Name
- Severity (HIGH, MEDIUM, LOW, CRITICAL)
- Category (IAM Protection, Data Protection, Network Security, Governance)
- Rule_Type (custom)
- Cloud_Provider (azure, gcp)
- Description
- Service
- CVS_Rule_ID
- Terraform_URL

### 5. Rule Categories

- IAM Protection
- Data Protection
- Network Security
- Governance
- Cluster and Node Governance
- And others based on security domains

## Technologies Supported

- Terraform (primary focus for custom rules)
- Azure resources (extensive coverage)
- GCP resources (extensive coverage)
- Other IaC formats supported by KICS (Kubernetes, Ansible, CloudFormation, etc.)

## Services Covered

### Azure Services:

- Service Bus
- Data Bricks
- Search Service
- AI Services (Language, Speech, Translation, Computer Vision, Content Safety)
- AKS (Azure Kubernetes Service)
- And many others

### GCP Services:

- GKE (Google Kubernetes Engine)
- Cloud Composer
- Cloud Spanner
- Data Pipeline
- Dialog Flow
- Document AI
- Cloud DNS
- And others

## Rule Development Deep Dive

### Rule Structure

Each KICS rule consists of:

1. **metadata.json** - Contains rule metadata including ID, name, severity, category, description, and reference URL
2. **query.rego** - Contains the Rego policy logic that identifies security issues
3. **test/** - Directory containing test cases:
   - positive.json - Example with the security issue
   - negative.json - Example without the security issue
   - positive_expected_result.json - Expected findings from the positive test case

### Rego Query Structure

KICS queries are written in Rego and follow this pattern:

```rego
package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Rule description
CxPolicy[result] {
    # Match the resource type
    resource := input.document[i].resource.<provider>_<resource_type>[name]

    # Check for the security condition
    resource.attribute == <vulnerable_value>

    # Define the result structure
    result := {
        "documentId": input.document[i].id,
        "resourceType": "<provider>_<resource_type>",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("<provider>_<resource_type>[%s].<attribute>", [name]),
        "issueType": "IncorrectValue",  # or "MissingAttribute", "RedundantAttribute"
        "keyExpectedValue": sprintf("<provider>_<resource_type>[%s].<attribute> should be <correct_value>", [name]),
        "keyActualValue": sprintf("<provider>_<resource_type>[%s].<attribute> is <vulnerable_value>", [name]),
        "searchLine": common_lib.build_search_line(["resource", "<provider>_<resource_type>", name, "<attribute>"], []),
        "remediation": "description of how to fix the issue",
        "remediationType": "replacement"  # or "addition", "update"
    }
}
```

### Key Components Explained

#### Metadata Fields

- `id`: Unique identifier for the rule (UUID format for built-in, custom format for CVS)
- `queryName`: Descriptive name of the security issue
- `severity`: CRITICAL, HIGH, MEDIUM, LOW, INFO
- `category`: Security category (Access Control, Encryption, etc.)
- `descriptionText`: Detailed description of the vulnerability
- `descriptionUrl`: Link to official documentation
- `platform`: Target platform (Terraform, Kubernetes, etc.)
- `cloudProvider`: Target cloud provider (azure, gcp, aws)

#### Query Components

- `CxPolicy[result]`: Main policy function that returns results
- `input.document[i].resource.<provider>_<resource_type>[name]`: Path to match resources in the parsed IaC
- `searchKey`: Used by KICS to locate the exact position in the original file
- `searchLine`: Helps KICS identify the exact line number using JSON path
- `issueType`: Type of issue (IncorrectValue, MissingAttribute, RedundantAttribute)
- `remediation`: Description of how to fix the issue
- `remediationType`: Type of remediation (replacement, addition, update)

#### Libraries

KICS provides common libraries with helper functions:

- `data.generic.common`: Common utility functions
- `data.generic.terraform`: Terraform-specific functions
- Other platform-specific libraries

### Test Structure

Each rule must have test cases:

- **Positive tests**: Files that contain the security issue
- **Negative tests**: Files that follow security best practices
- **Expected results**: JSON file describing where issues should be found

### Rule Categories

1. **Access Control**: Identity and access management issues
2. **Data Protection**: Encryption and data security
3. **Network Security**: Firewall and network configuration issues
4. **Governance**: Compliance and tagging requirements
5. **Observability**: Logging and monitoring
6. **Resource Management**: Resource configuration and limits

## How KICS Works

1. Parses IaC files into an internal JSON representation
2. Applies Rego queries to identify security issues
3. Generates reports in various formats (JSON, HTML, PDF, etc.)

## CISS (Cloud Infrastructure Scanning Service)

- Packaged KICS with custom rules as a standalone executable
- Designed for CI/CD pipeline integration
- Scans Terraform plan files specifically
- Available as a standalone executable for easy deployment

## Testing Rules

### Running KICS with kics.exe

To scan IaC files with KICS using the standalone executable:

```
# Basic scan with built-in rules
kics.exe scan -p <path_to_scan> -o <output_path> --report-formats json

# Scan with custom rules
kics.exe scan -p <path_to_scan> -q <path_to_custom_queries> -o <output_path> --report-formats json

# Scan with built-in rules
kics.exe scan -p <path_to_scan> -q <path_to_builtin_queries> -o <output_path> --report-formats json
```

### Testing Custom Rules

1. **Positive Test**: Verify the rule detects the security issue

   - Run scan on positive.json test file
   - Confirm the expected vulnerability is detected
   - Check that the severity and details match expectations

2. **Negative Test**: Verify the rule doesn't produce false positives
   - Run scan on negative.json test file
   - Confirm no vulnerabilities are detected for this specific rule
   - Other unrelated issues may still be detected

### Exit Codes

KICS uses specific exit codes to indicate scan results:

- 0: No results found
- 20: INFO results found
- 30: LOW results found
- 40: MEDIUM results found
- 50: HIGH results found
- 60: CRITICAL results found
- 70: Remediation error
- 126: Engine error
- 130: Signal interrupt

## Environment Verification

The environment has been verified with the following setup:

- KICS executable (kics.exe) is available and functional
- Basic scan functionality tested with sample Terraform files
- Custom rules are available in the CSE-IaC-Scanning repository
- Scans can be run with both built-in and custom rules
- Rule testing framework works correctly for both positive and negative test cases

## Essential Files for Context (Read These First!)

When starting a new chat session, these are the most important files to understand the project context:

### 1. Project Structure and Overview

- `.\CSE-IaC-Scanning\README.md` - Main project overview and CISS product documentation
- `.\kics\README.md` - KICS engine documentation
- `.\kics\docs\getting-started.md` - How to install and run KICS
- `.\kics\docs\commands.md` - KICS CLI commands and options

### 2. Custom Rules Documentation

- `.\CSE-IaC-Scanning\custom_rules.csv` - Complete list of all custom rules with metadata
- `.\CSE-IaC-Scanning\CSE-PC-KICS-CUSTOMRULES\assets\queries\terraform\azure\service_bus_namespace_have_local_auth_enabled\metadata.json` - Example of custom rule metadata
- `.\CSE-IaC-Scanning\CSE-PC-KICS-CUSTOMRULES\assets\queries\terraform\azure\service_bus_namespace_have_local_auth_enabled\query.rego` - Example of custom rule implementation

### 3. Built-in Rules Documentation

- `.\CSE-IaC-Scanning\CSE-PC-KICS-BUILTINRULES\assets\queries\terraform\azure\aks_rbac_disabled\metadata.json` - Example of built-in rule metadata
- `.\CSE-IaC-Scanning\CSE-PC-KICS-BUILTINRULES\assets\queries\terraform\azure\aks_rbac_disabled\query.rego` - Example of built-in rule implementation

### 4. Rule Creation and Testing Guides

- `.\kics\docs\creating-queries.md` - Official guide for creating KICS queries
- `.\kics\docs\queries.md` - Detailed information about KICS queries
- `.\kics\docs\platforms.md` - Supported platforms and technologies

### 5. Test Examples

- `.\CSE-IaC-Scanning\CSE-PC-KICS-CUSTOMRULES\assets\queries\terraform\azure\service_bus_namespace_have_local_auth_enabled\test\positive.json` - Positive test case example
- `.\CSE-IaC-Scanning\CSE-PC-KICS-CUSTOMRULES\assets\queries\terraform\azure\service_bus_namespace_have_local_auth_enabled\test\negative.json` - Negative test case example

### 6. Library Functions

- `.\kics\assets\libraries\common.rego` - Common utility functions
- `.\kics\assets\libraries\terraform.rego` - Terraform-specific functions

Reading these files will provide complete context about:

- How the project is structured
- How custom rules are organized and formatted
- How to create new rules following established patterns
- How to test rules properly
- What libraries are available for use in rules
- How the KICS engine works internally

## Your Role

You are acting as a Cloud Security Engineer and development copilot to:

1. Create new custom KICS rules following established patterns
2. Modify existing rules as needed
3. Test rules with appropriate positive/negative test cases
4. Ensure rules align with CVS security standards
5. Help with CISS deployment and integration

When asked, you will implement specific security rules or modifications based on requirements, following the established patterns in the repository.