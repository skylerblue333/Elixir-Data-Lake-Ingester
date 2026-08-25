# Sky Data Lake Ingester (Elixir)

**Status: engineering beta.** This repository is a focused Elixir ingestion primitive. It accepts bounded source/payload pairs, computes SHA-256 metadata, deduplicates identical source+payload events, and maintains a bounded in-memory catalog for deterministic processing tests.

## Implemented

- real Elixir 1.17 project with no third-party runtime dependencies
- source validation (1–64 safe characters)
- payload limit of 256 KiB
- maximum 10,000 in-memory events
- SHA-256 payload metadata
- deterministic duplicate detection using source + payload digest
- ExUnit tests
- `mix format --check-formatted`
- warnings-as-errors compilation
- escript packaging
- non-root container and CI smoke execution

## Build and test

```bash
mix format --check-formatted
mix compile --warnings-as-errors
mix test
mix escript.build
./sky_data_lake
```

## Boundaries

This does not claim to be a durable data lake, Kafka replacement, object-store writer, ETL platform, distributed ingestion cluster, schema registry, stream processor, or production deployment. State is process-local and in memory. There is no S3/GCS/Azure adapter, persistence, authentication/RBAC, tenant isolation, retry queue, backpressure protocol, replication, HA, encryption-at-rest control, or external observability integration.

The intended SKYCOIN4444 role is a small ingestion-validation/deduplication primitive or reference component. Production integration should connect validated events to a durable queue/object store and add schema governance, authorization, retries, observability, and operational controls.

## License

See `LICENSE`.
