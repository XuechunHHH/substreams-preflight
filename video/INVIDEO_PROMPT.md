# InVideo prompt

Upload `substreams-preflight-terminal.mp4`, then paste everything below into InVideo:

---

Create a story-driven 16:9, 1080p software demo titled “The Package Built. The Data Disappeared.”

The story is about finding and preventing a silent compatibility bug in AI-generated Substreams. Use my uploaded terminal recording as the evidence and chronological backbone. Preserve the six chapter headings, commands, and results at readable size. Do not replace or cover important terminal footage with generic stock video.

Final duration must be between 2:30 and 3:15. Never produce a video under 2:00 or over 4:00.

Visual style: clean dark developer aesthetic with cyan chapter titles, amber tension, red failure, and green proof. Add restrained animated arrows for this flow:

`ONE PROMPT → INTENT → PREFLIGHT → BUILD → REGISTRY → LIVE ETHEREUM DATA`

Use a calm, confident English narrator. Keep music subtle: curious at the opening, tense during the injected bug, then resolved during the live proof.

## Voiceover

“At first, everything looked successful. An AI generated a Substreams package. The protobuf was valid. The project could build. But when The Graph sink consumed the output, entities could silently disappear.

The culprit was not a dramatic crash. It was one number.

Our story starts with a single natural-language prompt: build an Ethereum mainnet pipeline that decodes USDC Transfer events, produces typed records, and sends canonical EntityChanges to graph_out. The prompt creates a real project with Rust code, protobuf definitions, a Substreams manifest, tests, and a recorded intent contract.

That intent contract matters. Before generation moves forward, it captures the chain, target, requested data, destination, and block range. The agent is no longer allowed to guess.

Now we reproduce the invisible failure. The canonical EntityChanges schema requires entity_changes to use protobuf field five. In a disposable copy, we change only that tag from five to one. The schema still looks reasonable, and ordinary protobuf validation accepts the number. But the downstream Graph sink expects the canonical wire contract.

This is the turning point. Substreams Preflight checks both the recorded intent and the sink contract. It rejects the broken copy before build and explains the exact problem: EntityChanges dot entity_changes must be repeated field five. A silent runtime failure becomes an immediate, actionable error.

Next, the real project earns its green light. The validator confirms entity_changes field five and new_value field three. The regression checks pass. The same guardrail is embedded directly in the reusable Substreams development skill, so future AI-generated packages run it before building.

Then the generated project builds into a real Substreams package. Its module graph shows typed USDC transfers flowing into graph_out as canonical EntityChanges on Ethereum mainnet.

The final proof happens outside the local workspace. Version zero point one point zero is published in the public Substreams registry. We run graph_out directly from that published package against Ethereum block eighteen million. It returns the canonical EntityChanges type and emits thirteen UsdcTransfer entities.

One prompt became a validated, built, published, and live pipeline. The lesson is simple: compilation proves that code is valid. Preflight proves that the data contract is right.”

## Editing plan

1. Opening hook: show the terminal’s red “THE PACKAGE BUILDS. THE DATA STILL DISAPPEARS.” card. Add a brief glitch/data-vanish effect, then stop all effects before commands begin.
2. Chapter 1 — One Prompt: emphasize the prompt and generated file list. Caption: “One request creates a complete project.”
3. Chapter 2 — No Guessing: animate a compact checklist for chain, target, data, destination, and range while keeping the intent JSON visible.
4. Chapter 3 — One Number: zoom gently from `entity_changes = 5` to `entity_changes = 1`. Use amber for the change, then red when preflight rejects it. Caption: “Valid protobuf. Wrong wire contract.”
5. Chapter 4 — The Guardrail: highlight the canonical tags, passing preflight, tests, and the reusable SKILL integration. Caption: “Fail early, before build or deployment.”
6. Chapter 5 — The Build: retain the actual successful build output and module metadata. Draw a simple arrow from `map_usdc_transfers` to `graph_out`.
7. Chapter 6 — Public and Live: highlight the public package name, mainnet network, `graph_out`, canonical EntityChanges type, block `18000000`, `entity_count: 13`, and `UsdcTransfer`.
8. End card:
   “ONE PROMPT → VALIDATED → BUILT → PUBLISHED → LIVE”
   “github.com/XuechunHHH/substreams-preflight”
   “substreams-preflight-demo-xh@v0.1.0”
   “Built for ETHOnline 2026 · extending streamingfast/substreams-skills”

Do not invent interfaces, metrics, testimonials, or product capabilities. The terminal footage is the source of truth.

---
