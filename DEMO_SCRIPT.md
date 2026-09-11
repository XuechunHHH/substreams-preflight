# ETHOnline Demo Script (2–4 minutes)

Run from the repository root. Keep `.substreams.env` local and never show its contents.

## 0:00–0:30 — The silent failure

Say:

> AI-generated Substreams can build and run while still being incompatible with The Graph sink. Protobuf accepts any valid field number, but Graph `EntityChanges` requires `entity_changes = 5` and `new_value = 3`. Wrong tags can silently decode as missing data.

Create a disposable broken copy and run preflight:

```bash
BAD_PROJECT="$(mktemp -d)/usdc-transfers-graph-out"
cp -R demo/usdc-transfers-graph-out "$BAD_PROJECT"
perl -0pi -e 's/entity_changes = 5/entity_changes = 1/' "$BAD_PROJECT/proto/entity.proto"

npm run preflight -- \
  --intent demo/usdc-transfers-graph-out/substreams.intent.json \
  --project "$BAD_PROJECT"
```

Point out the rejection:

```text
✗ EntityChanges.entity_changes must be repeated EntityChange field 5
```

## 0:30–1:20 — Intent and wire-contract validation

Show the recorded intent:

```bash
sed -n '1,120p' demo/usdc-transfers-graph-out/substreams.intent.json
```

Say:

> The intent contract records the chain, target, requested data, destination, and block range before generation. Preflight rejects missing fields and unsupported chains instead of letting the agent guess.

Run the current validator checks:

```bash
npm run validate
npm run test:preflight
```

Say:

> The tests cover unsupported intent and both canonical Graph tags: `EntityChanges.entity_changes = 5` and `Field.new_value = 3`.

Validate the real project:

```bash
npm run preflight -- \
  --intent demo/usdc-transfers-graph-out/substreams.intent.json \
  --project demo/usdc-transfers-graph-out
```

Expected:

```text
✓ Substreams preflight passed
```

## 1:20–2:40 — Build and live Ethereum proof

Build the preflighted package:

```bash
cd demo/usdc-transfers-graph-out
substreams build
cd ../..
```

Load the local credential and run the published registry package:

```bash
. ./.substreams.env
substreams info substreams-preflight-demo-xh@v0.1.0
substreams run substreams-preflight-demo-xh@v0.1.0 graph_out \
  -s 18000000 \
  -t +1 \
  -o jsonl
```

Point to the emitted `EntityChanges`, then say:

> This `graph_out` pipeline was generated from the recorded prompt, passed preflight, was published to the Substreams registry, and is now emitting live Ethereum data from the published package.

## 2:40–3:00 — Close

Say:

> `substreams-preflight` is reusable validation for AI-generated Substreams: capture intent, reject unsupported or incomplete requests, and enforce The Graph’s canonical wire tags.

Continuity attribution: built during ETHOnline 2026 as an extension of [`streamingfast/substreams-skills`](https://github.com/streamingfast/substreams-skills); the upstream skills and history are preserved.
