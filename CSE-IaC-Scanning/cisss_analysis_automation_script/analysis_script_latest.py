"""
analysis_script.py : Script for analys CISS Scan data downloaded from GCP Storage
Workflow:
1. Download the CISS Scan data from GCP Storage.
2. Downloaded/Extracted result should contain date based(yyyyMMdd) folder structure.
3. For each date folder, read the CISS Scan data JSON files.
4. Iterate through each JSON file and extract the required fields.
"""

import os
import json
import time
import pandas as pd

def process_scan_results(scan_results_path):
    """
    Process the scan results to extract required fields.
    :param scan_results_path: Directory path containing list date based folders with scan results.
    :return: List of processed scan results.
    """
    processed_results = {}

    # Iterate through each date folder in the scan results directory
    for date_folder in os.listdir(scan_results_path):
        date_folder_path = os.path.join(scan_results_path, date_folder)

        if os.path.isdir(date_folder_path):
            # Iterate through each JSON file in the date folder
            folder_key = date_folder  # Use the folder name as the key
            processed_results[folder_key] = {}
            total_counter = 0

            # Iterate through each JSON file in the "result_json" directory
            for file_name in os.listdir(date_folder_path):
                if file_name.endswith(".json"):
                    file_path = os.path.join(date_folder_path, file_name)
                    cloud = "azure" if "azure" in file_name.lower() else "aws" if "aws" in file_name.lower() else "gcp"
                    # Read and parse the JSON file
                    with open(file_path, 'r') as json_file:
                        try:
                            data = json.load(json_file)
                            severity_counters = data.get("severity_counters", {})
                            file_total_counter = data.get("total_counter", 0)
                            total_counter += file_total_counter
                            queries = data.get("queries", [])

                            # Iterate Severity Counters
                            for severity, count in severity_counters.items():
                                if severity not in processed_results[folder_key]:
                                    processed_results[folder_key][severity] = {"count": 0, "queries": {}}
                                processed_results[folder_key][severity]["count"] += count

                            # Process queries
                            for query in queries:
                                query_name = query.get("query_name", "Unknown").strip()
                                query_severity = query.get("severity", "Unknown")
                                query_description_id = query.get("description_id", "Unknown")
                                query_count = len(query.get("files", []))
                                query_name = f"{cloud}/{query_description_id}/{query_name}"
                                if query_severity in processed_results[folder_key]:
                                    if query_name not in processed_results[folder_key][query_severity]["queries"]:
                                        processed_results[folder_key][query_severity]["queries"][query_name] = 0
                                    processed_results[folder_key][query_severity]["queries"][query_name] += query_count

                        except json.JSONDecodeError:
                            print(f"Error decoding JSON in file: {file_path}")
                            continue

            # Recalculate severity counts to match the sum of query counts
            for severity, details in processed_results[folder_key].items():
                recalculated_count = sum(details["queries"].values())
                details["count"] = recalculated_count

    return processed_results


def convert_json_to_excel(json_file, output_file):
    """
    Convert JSON data to an Excel file.
    :param json_data: JSON data to convert.
    :param output_file: Path to the output Excel file.
    """
    # Load the JSON data
    with open(json_file, 'r') as file:
        data = json.load(file)

    # List to store flattened data
    flattened_data = []

    # Iterate through each day and severity
    for day, severities in data.items():
        for severity, details in severities.items():
            for query_name, query_count in details["queries"].items():
                flattened_data.append({
                    "date": day,  # Add the date as the first column
                    "query_name": query_name,
                    "query_count": query_count,
                    "severity": severity
                })

    # Convert to a DataFrame for better visualization or further processing
    df = pd.DataFrame(flattened_data)

    # Save the flattened data to a CSV file (optional)
    df.to_excel(output_file, index=False)



if __name__ == "__main__":
    # Define the path to the scan results directory
    scan_results_path = r'C:\Users\C842034\Saurabh\CVS_Work\CVS_IAC\ContainerAutomation\scan_result'  # Update this path as needed
    result_json_path = r"C:\Users\C842034\Saurabh\CVS_Work\CVS_IAC\ContainerAutomation\scan_result\scan_result.json"
    excel_path = r"C:\Users\C842034\Saurabh\CVS_Work\CVS_IAC\ContainerAutomation\scan_result\scan_result.xlsx"

    # Check if the directory exists
    if not os.path.exists(scan_results_path):
        print(f"Directory {scan_results_path} does not exist.")
        exit(1)

    # Start processing the scan results
    result = process_scan_results(scan_results_path)

    if result:
        # Save the final result to a JSON file
        with open(result_json_path, "w") as output_file:
            json.dump(result, output_file, indent=4)
        print("Scan results processed and saved to scan_result.json.")

        # Convert the JSON data to an Excel file
        print("Converting JSON data to Excel...")
        convert_json_to_excel(result_json_path, excel_path)