from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"

def test_ingest():
    r = client.post("/api/v1/ingest", json=[
        {"id": "1", "source": "s3", "payload": {"key": "val"}},
        {"id": "2", "source": "kafka", "payload": {"key": "val2"}}
    ])
    assert r.status_code == 200
    assert r.json()["ingested"] == 2

