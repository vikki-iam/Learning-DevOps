import json
import requests

project_id = '114'
trigger_token = 'glptt-fdaf5aac10c1934823ea5b6b990e75d3b99c15b3'
ref = 'Revert'

url = f"http://base.neshinc.com/api/v4/projects/{project_id}/trigger/pipeline"
payload = {
    'token': trigger_token,
    'ref': ref
}

try:
    response = requests.post(url, data=payload)
    
    print("Status Code:", response.status_code)
    print("Response Text:", response.text)

    if response.status_code in [200, 201]:
        print("✅ Pipeline triggered successfully.")
        print("Pipeline Info:", response.json())
    else:
        print("❌ Failed to trigger pipeline.")
        print("Response:", response.text)

except Exception as e:
    print("🚨 Error during pipeline trigger:", str(e))

