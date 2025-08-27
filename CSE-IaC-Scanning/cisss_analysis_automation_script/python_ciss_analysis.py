""" Script for Listing CISS Scan Results Folder and read results scan files"""


import json
import os


def list_directorties_path(root_dir):
    """
    List all directories in the given root directory.

    Args:
        root_dir (str): The root directory to list directories from.

    Returns:
        list: A list of directory paths.
    """
    dir_list = []
    for item in os.listdir(root_dir):
        item_path = os.path.join(root_dir, item)
        if os.path.isdir(item_path):
            dir_list.append(item_path)
    return dir_list

def list_and_process_scan_files(scan_folder_path):
    """
    List and process scan files in the given scan folder.

    Args:
        scan_folder_path (str): The path of the scan folder.

    Returns:
        dict: A dictionary containing the scan results.
    """
    scan_result = {} #Final

    # scan_result = []

    for file_name in os.listdir(scan_folder_path):
        file_path = os.path.join(scan_folder_path, file_name)
        if os.path.isfile(file_path):
            # print("Processing file:", file_path)

            # scan_result_dict = {} # Temporary dictionary to hold scan results for each file
            
            with open(file_path, 'r') as file:
                file_content = file.read()
                scan_result_json = json.loads(file_content)
            
            # processing scan reasult with iterting "queries" key in each JSON file
            if 'queries' in scan_result_json and scan_result_json['queries']:
                for query in scan_result_json['queries']:
                    # get query details
                    query_name = query.get('query_name').strip()
                    query_id = query.get('description_id')
                    query_severity = query.get('severity')
                    severity_count = len(query.get('files'))

                    # Create data strutcure as {"query_name": {"query_id": query_id, "severity": query_severity, "severity_count": severity_count}}
                    
                    if query_name not in scan_result:
                        scan_result[query_name.strip()] = {}
                        scan_result[query_name.strip()]["query_id"] = query_id
                        scan_result[query_name.strip()]["severity"] = query_severity
                        scan_result[query_name.strip()]["severity_count"] = severity_count
                    elif query_name in scan_result:
                        scan_result[query_name.strip()]["severity_count"] += severity_count     
    return scan_result

def process_ciss_result_scanning(root_dir):
    """
    Process CISS scan results from the given root directory.
    
    Args:
        root_dir (str): The root directory containing CISS scan results.
    """
    print(f"Scanning CISS results in: {root_dir}")
    scan_folder_path_list = list_directorties_path(root_dir)
    
    # Consolidate implementation
    consolidated_scan_result = {}
    # Ietarete through each scan folder
    for scan_folder_path in scan_folder_path_list:
        # If 'TEST' is not in Scan Folder path
        # if "20250424" in scan_folder_path:
        
        print("Running CISS scan in:", scan_folder_path)
        # Itearte through each file in the scan folder
        scan_result  = list_and_process_scan_files(scan_folder_path)
        date_folder = os.path.basename(scan_folder_path)

        # TO DO Consolidate implementation
        consolidated_scan_result[date_folder]=scan_result
    
    # Write the consolidated scan results to a JSON file
    with open('ciss_scan_results_23_24.json', 'w') as json_file:
        json.dump(consolidated_scan_result, json_file, indent=4)
        print("CISS scan results saved to ciss_scan_results.json")

            


if __name__ == "__main__":
    # Get the current working directory
    current_directory = os.getcwd()

    process_ciss_result_scanning(current_directory)