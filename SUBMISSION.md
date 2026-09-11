# ETHOnline 2026 Submission Draft

## Project

**Substreams Preflight**

Preflight validation for AI-generated Substreams projects. It records a concrete intent contract, rejects incomplete or unsupported requests, and catches canonical The Graph `EntityChanges` wire errors before build or deployment.

## Track

The Graph — Best AI Tooling or AI Use Case with The Graph

Pool: **Continuity**

## Links

- Repository: https://github.com/XuechunHHH/substreams-preflight
- Published package: https://substreams.dev/packages/substreams-preflight-demo-xh/v0.1.0
- Demo video: https://youtu.be/fbZ5ezZKsOs

## Problem

An AI-generated Substreams project can compile and stream successfully while still being incompatible with a downstream Graph sink. Protobuf field numbers are part of the wire contract: changing `EntityChanges.entity_changes` from tag `5` to `1`, or `Field.new_value` from tag `3` to `2`, still passes normal build and graph validation but can silently produce no downstream entities.

Agent instructions also do not mechanically prevent an agent from inventing missing requirements or claiming support for an unsupported chain.

## Solution

`substreams-preflight` adds one reusable command before build:

```bash
npm run preflight -- --intent substreams.intent.json --project .
```

It:

1. validates that chain, target, requested data, destination, and range are explicit;
2. rejects unsupported chains rather than allowing a fabricated scaffold;
3. detects the two reproduced canonical `EntityChanges` wire-tag failures.

The existing `substreams-dev` skill now tells the coding agent to create the intent contract and run preflight before `substreams build`.

## Live proof

The repository preserves the exact natural-language prompt and generated demo project under `demo/usdc-transfers-graph-out`.

The generated package:

- decodes Ethereum mainnet USDC `Transfer` events;
- emits typed transfer records;
- produces canonical `UsdcTransfer` `EntityChanges`;
- passed preflight, Rust tests, and `substreams build`;
- processed the requested 101-block live range;
- is published as `substreams-preflight-demo-xh@v0.1.0`;
- successfully streams live Ethereum data when invoked from the public registry.

## Continuity disclosure

This project extends the open-source `streamingfast/substreams-skills` repository. The upstream history and Apache-2.0 license are preserved. Work added during ETHOnline includes the executable preflight validator, its tests, skill integration, empirical failure fixtures, one-prompt demo package, registry publication, and submission materials.
