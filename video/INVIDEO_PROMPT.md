# InVideo prompt

Upload `substreams-preflight-terminal.mp4`, then paste everything below into InVideo:

---

Create a polished 16:9, 1080p software demo titled “Substreams Preflight: Catch Silent Schema Failures Before Runtime.”

Use my uploaded terminal recording as the primary footage. Keep every command and result readable. Do not replace, crop, blur, or cover the terminal with stock footage. Add only restrained title cards, captions, subtle zooms, and simple developer/Web3 graphics between terminal sections.

Style: clean dark technical aesthetic, professional and credible, no hype. Use a calm neutral English voice. Keep background music very quiet. Target 90–120 seconds.

Narration:

“AI-generated Substreams can build and run while still being incompatible with The Graph sink. Protobuf accepts valid but incorrect field numbers, so a wrong tag can silently decode as missing data.

This demo starts from a recorded prompt for an Ethereum USDC transfers package. I create a disposable broken copy and change the canonical EntityChanges tag from field five to field one. The preflight validator rejects it immediately, before generation or deployment can create a silent failure.

The intent file records the chain, target data, destination, and block range. Preflight also verifies The Graph’s canonical wire contract: EntityChanges dot entity_changes must be repeated field five, and Field dot new_value must be field three. The real project passes, and the automated checks cover unsupported intent and both schema tags.

Finally, this is not a mocked local result. The package substreams-preflight-demo-xh version zero point one point zero is public in the Substreams registry. A live one-block Ethereum mainnet run invokes graph_out, returns the canonical EntityChanges type, and emits thirteen UsdcTransfer entities.

Substreams Preflight makes AI-generated packages safer by capturing intent, rejecting unsupported requests, and enforcing sink compatibility before runtime.”

Editing sequence:

1. Open with a three-second title card: “Substreams Preflight” and subtitle “Preflight validation for AI-generated Substreams.”
2. During the broken-copy command, caption: “Wrong protobuf tag: entity_changes = 1.”
3. Highlight the rejection line with a subtle red outline and caption: “Caught before runtime.”
4. During the valid project, caption: “Intent complete · canonical tags verified · tests pass.”
5. During registry information, caption: “Published package: substreams-preflight-demo-xh@v0.1.0.”
6. During the live output, highlight “graph_out,” “EntityChanges,” “entity_count: 13,” and “UsdcTransfer.”
7. End with a clean card:
   “github.com/XuechunHHH/substreams-preflight”
   “substreams-preflight-demo-xh@v0.1.0”
   “Built for ETHOnline 2026 · extending streamingfast/substreams-skills”

Do not invent metrics, interfaces, testimonials, or additional product features.

---
