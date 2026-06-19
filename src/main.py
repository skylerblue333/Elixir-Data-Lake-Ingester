"""
Elixir-Data-Lake-Ingester: Batch ingestion service that validates and stores data lake records
"""
import time
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Elixir-Data-Lake-Ingester", version="3.0.0")

from typing import List

class Record(BaseModel):
    id: str
    source: str
    payload: dict

@app.post("/api/v1/ingest")
def ingest_records(records: List[Record]):
    valid = [r for r in records if r.id and r.source]
    invalid = len(records) - len(valid)
    return {"ingested": len(valid), "rejected": invalid, "status": "complete"}


@app.get("/health")
def health():
    return {"status": "healthy", "service": "Elixir-Data-Lake-Ingester", "timestamp": int(time.time())}
