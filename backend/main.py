from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
import json

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/v1/events")
async def receive_events(request: Request):
    data = await request.json()
    print("Received event:")
    print(json.dumps(data, indent=4))
    return {"status": "received"}

