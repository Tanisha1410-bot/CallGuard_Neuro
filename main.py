import os
import requests
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

NOTION_TOKEN = os.getenv("NOTION_TOKEN")
DATABASE_ID = os.getenv("NOTION_DATABASE_ID")

# Pydantic model for incoming request
class CallLog(BaseModel):
    title: str = Field(..., example="Potential Scam Alert")
    caller_id: str = Field(..., example="+91 98765 43210")
    status: str = Field(..., example="Scam")
    threat_score: int = Field(..., ge=0, le=100, example=85)

app = FastAPI(title="CallGuard AI Backend")

# Global CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def health_check():
    return {"status": "online", "message": "CallGuard AI Server is active"}

@app.post("/api/logs/add")
async def add_call_log(log: CallLog):
    if not NOTION_TOKEN or not DATABASE_ID:
        raise HTTPException(status_code=500, detail="Notion credentials missing in backend")

    notion_url = "https://api.notion.com/v1/pages"
    
    headers = {
        "Authorization": f"Bearer {NOTION_TOKEN}",
        "Notion-Version": "2022-06-28",
        "Content-Type": "application/json"
    }

    # Mapping snake_case input to Notion's exact Column names and Types
    payload = {
        "parent": {"database_id": DATABASE_ID},
        "properties": {
            "Title": {
                "title": [
                    {
                        "text": {
                            "content": log.title
                        }
                    }
                ]
            },
            "Caller Id": {
                "rich_text": [
                    {
                        "text": {
                            "content": log.caller_id
                        }
                    }
                ]
            },
            "Status": {
                "select": {
                    "name": log.status
                }
            },
            "Threat Score": {
                "number": log.threat_score
            }
        }
    }

    try:
        response = requests.post(notion_url, headers=headers, json=payload)
        
        if response.status_code != 200:
            error_data = response.json()
            raise HTTPException(
                status_code=response.status_code, 
                detail=f"Notion API Error: {error_data.get('message', 'Unknown Error')}"
            )
            
        return {
            "status": "success",
            "message": "Call log successfully synced to Notion",
            "data": response.json()
        }
        
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=500, detail=f"Request failed: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)