import json
import pandas as pd
import os

# File paths
current_dir = os.path.dirname(os.path.abspath(__file__))
json_file = os.path.join(current_dir, 'ciss_scan_results_23_24.json')
excel_file = os.path.join(current_dir, 'ciss_scan_results_23_24.xlsx')

# Read JSON file
with open(json_file, 'r') as f:
    data = json.load(f)

# Create a list to store the data
rows = []

# Process the JSON data
for date, queries in data.items():
    for query_name, details in queries.items():
        rows.append({
            'date': date,
            'query': query_name,
            'query_id': details.get('query_id', ''),
            'severity': details.get('severity', ''),
            'severity_count': details.get('severity_count', 0)
        })

# Create DataFrame
df = pd.DataFrame(rows)

# Save to Excel
df.to_excel(excel_file, index=False)
print(f"Excel file created successfully: {excel_file}")