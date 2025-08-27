#!/bin/bash
# =============================================================================
#  Title: ./iac_scan_container_automation_cli.sh
#  Description: This script automates the process of scanning a container image for plan files for given day.
#  Usage: ./iac_scan_container_automation_cli.sh <scan_date>
#  Example: ./iac_scan_container_automation_cli.sh 20231001

: '
This script automates the process of scanning a container image for plan files for a given day.
It takes two arguments: scan_date and container_image.
The script will create a directory for the scan date, pull the container image,
run the scan, and save the results in the created directory.
'
# =============================================================================
# Workflow:
# Step 1: Create a directory for the scan date in format wp_<scan_date>
# Step 2: Get inside or cd (change directory) into the created directory wp_<scan_date> and pull JSON plan files from GCP Storage Account Path
# Step 3: Pull the container image from GCP Container Registry (If not already pulled)
# Step 4: Run the CISS scan using the pulled container image with mounting the 'wp_<scan_date>' as mount point
# Step 5: Save the scan results in the created directory wp_<scan_date>


echo -e "> Starting IAC scan automation script...\n"
echo -e "> Pre-requisite:\n  Ensure you have Docker installed and running. \n Perform gcloud auth login to authenticate your Google Cloud account.\n"

#read -p "> Have you completed 'gcloud auth login'? (yes/no): " auth_done
#if [ "$auth_done" != "yes" ]; then
#  echo "Please complete 'gcloud auth login' before proceeding."
#  exit 1
#fi
#
#read -p  "> Enter the scan date (YYYYMMDD): " scan_date
#if [ -z "$scan_date" ]; then
#  echo "Scan date is required. Please provide a valid date."
#  exit 1
#fi

# Get User Input for Scan Date so that script can be call ./iac_scan_container_automation_cli.sh 20250330

# Check if $1 is provided, if not, exit with an error message
if [ -z "$1" ]; then
  echo "Usage: ./iac_scan_container_automation_cli.sh <scan_date>"
  echo "Example: ./iac_scan_container_automation_cli.sh 20250330"
  exit 1
fi

# Assign the first argument to scan_date
scan_date="$1"
echo -e "> CISS Scanning for Date: $scan_date"

# Configure Logs

# Create a log folder if it doesn't exist
mkdir -p "ciss_scan_logs" || { echo "Failed to create log folder"; exit 1; }

# Define log file path
log_file="ciss_scan_logs/wp_$scan_date.txt"

# Redirect stdout and stderr to the log file
exec > >(tee -a "$log_file") 2>&1

# Log the start time and date
start_time=$(date +%s)
echo "Script started at: $(date)"

echo " > Starting IAC scan automation script for date: $scan_date"
# Step 1: Create a directory for the scan date in format wp_<scan_date>
# Implementation of the script starts here
echo "> Creating directory wp_$scan_date and changing into it..."
mkdir -p "wp_$scan_date"
cd "wp_$scan_date" || { echo "Failed to change directory to wp_$scan_date"; exit 1; }

# Create child directory inside wp_<scan_date> for plan files format wp_<scan_date>/scan/tfutCse
mkdir -p "scan/tfutCse" || { echo "Failed to create directory wp_$scan_date/scan/tfutCse"; exit 1; }

scan_path="$(pwd)/scan/tfutCse/"
echo "> Download directory: $scan_path"

# Step 2

# Step 2.1 : Downloading plan files from GCP Storage Account Path
echo "> Downloading plan files from GCP Storage... in scan directory wp_$scan_date/scan/tfutCse"
gsutil -m cp -r gs://csetest/review_plan_files/$scan_date/json/*.json $scan_path || { echo "Failed to download plan files"; exit 1; }

# Command to remove files with less than 500 KB size
find $scan_path -type f -size -500k -exec rm -f {} \; | tee /dev/tty | wc -l | awk '{print "Number of files removed with size less than 500 KB: " $1}'
# Count the number of plan files downloaded
plan_file_count=$(ls -1 $scan_path/*.json 2>/dev/null | wc -l)
echo "> $plan_file_count Plan JSON files getting scanned for CISS"

echo "> Plan files downloaded successfully."

# Step 2.2 : # Creating environment file in Workspace folder for the container image CISS scan

# Creating environment file in Workspace folder for the container image CISS scan
echo "> Creating environment file for the container image CISS scan..."
env_file_path="$(pwd)/.env"

cat <<EOL > "$env_file_path"
export APP_NM=CSE
export PIPELINE_NM=CSE
export SCAN_VERBOSE_LEVEL=INFO
export SCAN_RULE_SEVERITY=HIGH
export DIRECTORY=CSE/PC/UAT/USEAST1
EOL

echo "> Environment file created at $env_file_path"

# # Step 3 & Step 4 :

echo "> Running CISS scan container image on $scan_path..."
docker run --name "wp_$scan_date" -it -v $(pwd):/workspace quay-registry.aetna.com/cseiac/rhl9-x86_64-kics-snyk-opa:1.1.0 /apps/bin/iac_srv.sh  #TODO Uncomment this

echo "> CISS scan completed successfully."

# Step 5:

echo "Searching results in wp_$scan_date/scan/tfutCse directory..."
result_json_dir="$(pwd)/result_json"
mkdir -p "$result_json_dir"

found_path=$(find $(pwd)/scan/tfutCse/results/kics -type d -path "*/scan" 2>/dev/null)

if [ -n "$found_path" ]; then
  echo "> Path exists: $found_path"
  echo "> Searching for .json files in ACSE* folders..."

  find "$found_path" -type f -name "*.json" -path "*/ACSE*" -exec cp {} "$result_json_dir" \;

  echo "Copied .json files to $result_json_dir:"
  ls -l "$result_json_dir"

  # Upload the results to GCP Storage
  echo "> Uploading results to GCP Storage..."
  gsutil -m cp -r "$result_json_dir" gs://csetest/review_plan_files/$scan_date/ || { echo "Failed to upload results to GCP Storage"; exit 1; }

  # Check if the upload was successful then delete folder wp_<scan_date>
  if [ $? -eq 0 ]; then
    echo "> Results uploaded successfully to gs://csetest/review_plan_files/$scan_date/"
    echo "> Deleting local directory $(pwd)..."
    sudo rm -rf "$(pwd)"

    echo "> Removing container wp_$scan_date..."
    docker rm -f "wp_$scan_date" || { echo "Failed to remove container wp_$scan_date"; exit 1; }
    echo "> Container wp_$scan_date removed successfully."
  else
    echo "Failed to upload results to GCP Storage."
    exit 1
  fi
else
  echo "Scan result path `$(pwd)/scan/tfutCse/results/kics` does not exist."
  exit 1
fi

echo "> Scan results saved in gs://csetest/review_plan_files/$scan_date/$result_json_dir and uploaded to GCP Storage."
echo "> End of IAC Scan Automation Script"

# Log end time
end_time=$(date +%s)
echo "Script ended at: $(date)"

# Calculate and log time taken in minutes
time_taken=$(( (end_time - start_time) / 60 ))
echo "Time taken: $time_taken minutes"