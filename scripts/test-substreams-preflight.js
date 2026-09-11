const assert = require('assert');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { main } = require('./substreams-preflight');

const entityProto = (entityTag = 5, newValueTag = 3) => `
syntax = "proto3";
package sf.substreams.sink.entity.v1;
message EntityChanges { repeated EntityChange entity_changes = ${entityTag}; }
message EntityChange {}
message Value {}
message Field { Value new_value = ${newValueTag}; }
`;

const root = fs.mkdtempSync(path.join(os.tmpdir(), 'substreams-preflight-'));
const project = path.join(root, 'project');
const intent = path.join(root, 'intent.json');
fs.mkdirSync(path.join(project, 'proto'), { recursive: true });
fs.writeFileSync(path.join(project, 'substreams.yaml'), `
protobuf:
  files: [entity.proto]
  importPaths: [./proto]
modules:
  - name: graph_out
    output:
      type: proto:sf.substreams.sink.entity.v1.EntityChanges
`);
fs.writeFileSync(intent, JSON.stringify({
    chain: 'ethereum-mainnet',
    target: 'ERC-721',
    data: 'mints',
    destination: 'The Graph',
    range: '18000000-18000100'
}));

function expectFailure(fn, pattern) {
    assert.throws(fn, pattern);
}

fs.writeFileSync(path.join(project, 'proto/entity.proto'), entityProto());
main(['--intent', intent, '--project', project]);

fs.writeFileSync(path.join(project, 'proto/entity.proto'), entityProto(1));
expectFailure(() => main(['--intent', intent, '--project', project]), /entity_changes/);

fs.writeFileSync(path.join(project, 'proto/entity.proto'), entityProto(5, 2));
expectFailure(() => main(['--intent', intent, '--project', project]), /new_value/);

fs.writeFileSync(intent, JSON.stringify({
    chain: 'aptos-mainnet',
    target: '0x1::coin::TransferEvent',
    data: 'transfers',
    destination: 'run',
    range: 'latest'
}));
expectFailure(() => main(['--intent', intent, '--project', project]), /unsupported chain/);

fs.rmSync(root, { recursive: true, force: true });
console.log('✓ preflight tests passed');
