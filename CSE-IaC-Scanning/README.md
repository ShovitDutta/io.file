# CISS (IaC Scan)

# Overview

CISS is a Infrastructure as Code(IaC) Scan product that offers scanning terraform plan files. CISS uses the KICS engine for scanning terraform plan files. CISS is available and packaged as a docker image. CI/CD pipeline can leverage the CISS product for continuous scanning of terraform plan files.

So, What is KICS?

Keeping Infrastructure as Code Secure (KICS) is an open source solution for static code analysis of Infrastructure as Code.

KICS is 100% open source security tool is written in Golang using Open Policy Agent (OPA).

There are 1000+ ready to use queries (security rules) that covers wide range of vulnerability check for AWS, GCP, Azure and other provider. 

KICS supports scanning multiple technologies such as Terraform, Kubernetes, Ansible, Cloud Formation, Azure Resource Manager, Google Deployment Manager, Docker, Helm, CICD, Open API, CDK etc 

# High Level Architecture

KICS has a pluggable architecture with extensible pipeline of parsing IaC language which allows an easy integration of new IaC languages and queries. Refer https://docs.kics.io/latest/architecture/

# Install KICS

# Option # 1
Build from Sources

1/ Download and install Go 1.16 or higher from https://golang.org/dl/.

2/ Clone the repo: git clone https://github.com/Checkmarx/kics.git

3/ Build Binaries:
cd kics
go mod vendor
make build

or
cd kics

go mod vendor

LINUX/MAC: go build -o ./bin/kics cmd/console/main.go

WINDOWS: go build -o ./bin/kics.exe cmd/console/main.go (make sure to create the bin folder)

4/ Kick a scan:

./bin/kics scan -p "path-of-your-project-to-scan" -o ./results --report-formats json

for custom queries :

You can provide your own path to the queries directory with -q CLI option (see CLI Options section below), otherwise the default directory will be used The default ./assets/queries is built-in in the image. You can use this to provide a path to your own custom queries. 

e.g ./bin/kics scan -q "paths to directory with queries (default [./assets/queries])"

Note that the ./assets/queries is the default path of the queries in the KICS docker image as referenced in the docs https://docs.kics.io/latest/commands/#scan_command_options


# Option # 2
KICS is available as a Docker image.

To scan a directory/file on your host you have to mount it as a volume to the container and specify the path on the container filesystem with the -p KICS parameter (see Scan Command Options section below)

docker pull checkmarx/kics:latest

docker run -t -v "{path_to_host_folder_to_scan}":/path checkmarx/kics scan -p /path -o "/path/"
