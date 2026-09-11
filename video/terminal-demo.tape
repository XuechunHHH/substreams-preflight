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
Set TypingSpeed 8ms
Set CursorBlink false

Type `clear`
Enter
Sleep 1s

Type `sed -n '1p' demo/usdc-transfers-graph-out/PROMPT.md`
Enter
Sleep 6s

Type `PROJECT=demo/usdc-transfers-graph-out`
Enter
Type `INTENT="$PROJECT/substreams.intent.json"`
Enter
Type `BAD="$(mktemp -d)/project"`
Enter
Type `cp -R "$PROJECT" "$BAD"`
Enter
Type `perl -0pi -e 's/entity_changes = 5/entity_changes = 1/' "$BAD/proto/entity.proto"`
Enter
Sleep 1s
Type `npm run preflight -- --intent "$INTENT" --project "$BAD"`
Enter
Sleep 7s

Type `clear`
Enter
Sleep 1s
Type `jq '{chain, range, target, destination}' "$INTENT"`
Enter
Sleep 6s
Type `grep -R -n -E 'entity_changes = 5|new_value = 3' "$PROJECT/proto"`
Enter
Sleep 5s
Type `npm run preflight -- --intent "$INTENT" --project "$PROJECT"`
Enter
Sleep 5s
Type `npm run test:preflight`
Enter
Sleep 6s

Type `clear`
Enter
Sleep 1s
Type `. ./.substreams.env`
Enter
Type `PKG=substreams-preflight-demo-xh@v0.1.0`
Enter
Type `substreams info "$PKG" | grep -E '^(Package name:|Version:|Name: graph_out$|Output Type: proto:sf|Network:)'`
Enter
Sleep 7s
Type `substreams run "$PKG" graph_out -s 18000000 -t +1 -o jsonl 2>/dev/null | jq '{module: .["@module"], block: .["@block"], type: .["@type"], entity_count: (.["@data"].entityChanges | length), entity: .["@data"].entityChanges[0].entity}'`
Enter
Sleep 12s

Type `printf '\nPublic package: %s\n' "$PKG"`
Enter
Sleep 5s
