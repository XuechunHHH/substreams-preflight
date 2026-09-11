Output video/terminal-frames/

Require npm
Require substreams
Require jq

Set Shell zsh
Set FontFamily "Menlo"
Set FontSize 22
Set Width 1600
Set Height 900
Set Theme "Catppuccin Mocha"
Set Padding 28
Set Framerate 30
Set TypingSpeed 6ms
Set CursorBlink false

Env PROJECT "demo/usdc-transfers-graph-out"
Env INTENT "demo/usdc-transfers-graph-out/substreams.intent.json"
Env PKG "substreams-preflight-demo-xh@v0.1.0"

Hide
Type `note(){ case "$1" in files) t='Generated project files:';; question) t='QUESTION: Will ordinary build validation catch this?';; blocked) t='ANSWER: BLOCKED BEFORE BUILD - no silent data loss.';; valid) t='RESULT: intent complete, wire contract canonical, tests green.';; built) t='RESULT: typed USDC records flow into canonical Graph EntityChanges.';; esac; printf '\033[1A\033[2K\r\n%s\n' "$t"; }`
Enter
Type `clear; printf '\033[1;31mTHE PACKAGE BUILDS. THE DATA STILL DISAPPEARS.\033[0m\n\nOne wrong protobuf field number can silently erase Graph entities.\n'`
Enter
Sleep 250ms
Show
Sleep 7s

Hide
Type `clear; printf '\033[1;36mCHAPTER 1/6 - THE PROMISE: ONE PROMPT\033[0m\n\n'`
Enter
Sleep 250ms
Show
Sleep 2s
Type `sed -n '1p' "$PROJECT/PROMPT.md"`
Enter
Sleep 9s
Hide
Type `note files`
Enter
Sleep 250ms
Show
Type `find "$PROJECT" -maxdepth 2 -type f -not -path '*/target/*' | sed "s#$PROJECT/##" | sort`
Enter
Sleep 7s

Hide
Type `clear; printf '\033[1;36mCHAPTER 2/6 - THE CONTRACT: NO GUESSING\033[0m\n\nThe agent records exactly what must be built.\n'`
Enter
Sleep 250ms
Show
Sleep 2s
Type `jq . "$INTENT"`
Enter
Sleep 8s
Type `grep -n -E 'name:|network:|type:' "$PROJECT/substreams.yaml"`
Enter
Sleep 8s

Hide
Type `clear; printf '\033[1;33mCHAPTER 3/6 - THE TWIST: ONE NUMBER BREAKS THE SINK\033[0m\n\n'`
Enter
Sleep 250ms
Show
Sleep 2s
Type `BAD="$(mktemp -d)/project"`
Enter
Type `cp -R "$PROJECT" "$BAD"`
Enter
Type `grep -n 'entity_changes' "$PROJECT/proto/entity.proto"`
Enter
Sleep 4s
Type `perl -0pi -e 's/entity_changes = 5/entity_changes = 1/' "$BAD/proto/entity.proto"`
Enter
Type `grep -n 'entity_changes' "$BAD/proto/entity.proto"`
Enter
Sleep 4s
Hide
Type `note question`
Enter
Sleep 250ms
Show
Sleep 2s
Type `npm run preflight -- --intent "$INTENT" --project "$BAD"`
Enter
Sleep 9s
Hide
Type `note blocked`
Enter
Sleep 250ms
Show
Sleep 4s

Hide
Type `clear; printf '\033[1;36mCHAPTER 4/6 - THE GUARDRAIL: VERIFY, THEN BUILD\033[0m\n\n'`
Enter
Sleep 250ms
Show
Sleep 2s
Type `grep -R -n -E 'entity_changes = 5|new_value = 3' "$PROJECT/proto"`
Enter
Sleep 6s
Type `npm run preflight -- --intent "$INTENT" --project "$PROJECT"`
Enter
Sleep 6s
Type `npm run test:preflight`
Enter
Sleep 7s
Type `sed -n '130,152p' skills/substreams-dev/SKILL.md`
Enter
Sleep 8s
Hide
Type `note valid`
Enter
Sleep 250ms
Show
Sleep 3s

Hide
Type `clear; printf '\033[1;36mCHAPTER 5/6 - THE PAYOFF: A REAL SUBSTREAMS PACKAGE\033[0m\n\n'`
Enter
Sleep 250ms
Show
Sleep 2s
Type `(cd "$PROJECT" && substreams build)`
Enter
Sleep 10s
Type `substreams info "$PROJECT/substreams.yaml" | grep -E '^(Package name:|Version:|Name: map_usdc_transfers$|Name: graph_out$|Output Type:|Network:)'`
Enter
Sleep 8s
Hide
Type `note built`
Enter
Sleep 250ms
Show
Sleep 3s

Hide
Type `clear; printf '\033[1;36mCHAPTER 6/6 - THE PROOF: PUBLIC AND LIVE\033[0m\n\nThe final test uses the published registry package on Ethereum mainnet.\n'`
Enter
Sleep 250ms
Show
Sleep 3s
Type `. ./.substreams.env`
Enter
Type `substreams info "$PKG" | grep -E '^(Package name:|Version:|Name: graph_out$|Output Type: proto:sf|Network:)'`
Enter
Sleep 9s
Type `substreams run "$PKG" graph_out -s 18000000 -t +1 -o jsonl 2>/dev/null | jq '{module: .["@module"], block: .["@block"], type: .["@type"], entity_count: (.["@data"].entityChanges | length), entity: .["@data"].entityChanges[0].entity}'`
Enter
Sleep 12s
Hide
Type `clear; printf '\033[1;32mONE PROMPT -> VALIDATED -> BUILT -> PUBLISHED -> LIVE\033[0m\n\nPackage: %s\nRepo: github.com/XuechunHHH/substreams-preflight\n' "$PKG"`
Enter
Sleep 250ms
Show
Sleep 10s
