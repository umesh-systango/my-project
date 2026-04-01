from fastapi import FastAPI
import requests

app = FastAPI()

GITHUB_TOKEN = "PASTE_YOUR_TOKEN_HERE"
REPO = "your-username/your-repo"

@app.get("/trigger-pipeline")
def trigger_pipeline():
    url = f"https://api.github.com/repos/{REPO}/actions/workflows/node-pipeline.yml/dispatches"
    
    headers = {
        "Authorization": f"Bearer {GITHUB_TOKEN}",
        "Accept": "application/vnd.github+json"
    }

    data = {
        "ref": "main"
    }

    response = requests.post(url, json=data, headers=headers)

    if response.status_code == 204:
        return {"message": "Pipeline triggered successfully"}
    else:
        return {"error": response.text}
