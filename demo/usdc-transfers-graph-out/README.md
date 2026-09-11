# substreams_preflight_demo_xh

Ethereum mainnet USDC transfers as typed records and canonical The Graph `EntityChanges`.

## Overview

This package decodes ERC-20 `Transfer` events emitted by the USDC contract from block 18,000,000 onward. It emits raw token amounts as decimal strings and performs no RPC enrichment.

## Modules

| Module | Kind | Output | Description |
|---|---|---|---|
| `map_usdc_transfers` | map | `demo.usdc.v1.UsdcTransfers` | Decodes typed USDC transfer records. |
| `graph_out` | map | `sf.substreams.sink.entity.v1.EntityChanges` | Creates `UsdcTransfer` entities with ID `{tx_hash}-{log_index}`. |

## Prerequisites

- Substreams CLI
- Rust with the `wasm32-unknown-unknown` target
- `buf` and `protoc`
- The Graph Market authentication for live runs

## Quick Start

From the repository root:

```bash
npm run preflight -- \
  --intent demo/usdc-transfers-graph-out/substreams.intent.json \
  --project demo/usdc-transfers-graph-out

cd demo/usdc-transfers-graph-out
substreams build
substreams auth
. ./.substreams.env
substreams run ./substreams.yaml graph_out \
  --start-block 18000000 \
  --stop-block 18000101 \
  --output jsonl
```

The stop block is exclusive, so this command processes blocks 18,000,000 through 18,000,100.
