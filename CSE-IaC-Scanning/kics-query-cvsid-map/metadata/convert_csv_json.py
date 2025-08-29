import csv
import json
import datetime

schema = {
    "truncate_all": False,
    "truncate_rule_id": False,
    "rundate_key": "run_date",
    "rundate_val": datetime.datetime.now().strftime('%Y-%m-%d'),
    "dev_db": "csspgsp1_db",
    "email": "cse@CVSHealth.com",
    "tablename": "ciss_iac_rule",
    "schema": "cssapp",
    "data": []
}

def csv_to_json(csv_file, json_file, schema):
    
    with open(csv_file, 'r') as file:
        csv_reader = csv.DictReader(file)
        for row in csv_reader:
            rule_tracker_data = {
                    "primary_rule_id": row["primary_rule_id"],
                    "secondary_rule_id": row["secondary_rule_id"],
                    "rule_name": row["rule_name"],
                    "severity": row["severity"],
                    "category": row["category"],
                    "rule_type": row["rule_type"],
                    "cloud": row["cloud"],
                    "rule_detail_desc": row["rule_detail_desc"],
                    "resource_name": row["resource_name"],
                    "vendor_rule_id": row["vendor_rule_id"],
                    "terraform_resource_url": row["terraform_resource_url"]
            }
            schema["data"].append(rule_tracker_data)
    
    with open(json_file, 'w') as file:
        json.dump(schema, file, indent=4)

csv_to_json('./ciss_rules_tracker_tb.csv','./ciss_rules_tracker_tb.json', schema)


