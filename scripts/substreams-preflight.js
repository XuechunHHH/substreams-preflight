#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

const REQUIRED_INTENT_FIELDS = ['chain', 'target', 'data', 'destination', 'range'];

function readJson(file) {
    try {
        return JSON.parse(fs.readFileSync(file, 'utf8'));
    } catch (error) {
        throw new Error(`cannot read intent "${file}": ${error.message}`);
    }
}

function validateIntent(file) {
    const intent = readJson(file);

    for (const field of REQUIRED_INTENT_FIELDS) {
        if (typeof intent[field] !== 'string' || !intent[field].trim()) {
            throw new Error(`intent.${field} is required`);
        }
    }

    const chain = intent.chain.trim().toLowerCase().split(/[-_\s]/)[0];
    if (!['ethereum', 'evm', 'solana'].includes(chain)) {
        throw new Error(`unsupported chain "${intent.chain}"; supported: Ethereum/EVM or Solana`);
    }
}

function protoFiles(projectDir, manifest) {
    const protobuf = manifest.protobuf || {};
    const files = protobuf.files || [];
    const importPaths = protobuf.importPaths || ['.'];
    const found = [];

    for (const file of files) {
        for (const importPath of importPaths) {
            const candidate = path.resolve(projectDir, importPath, file);
            if (fs.existsSync(candidate)) {
                found.push(candidate);
                break;
            }
        }
    }

    return found;
}

function messageBody(proto, name) {
    const match = proto.match(new RegExp(`message\\s+${name}\\s*\\{([\\s\\S]*?)\\}`, 'm'));
    return match && match[1].replace(/\/\/.*$/gm, '');
}

function hasField(body, type, name, tag, repeated = false) {
    const prefix = repeated ? 'repeated\\s+' : '(?:optional\\s+)?';
    return new RegExp(`${prefix}${type}\\s+${name}\\s*=\\s*${tag}\\s*;`).test(body || '');
}

function validateGraphOut(projectDir) {
    const manifestPath = path.join(projectDir, 'substreams.yaml');
    if (!fs.existsSync(manifestPath)) {
        throw new Error(`manifest not found: ${manifestPath}`);
    }

    const manifest = yaml.load(fs.readFileSync(manifestPath, 'utf8')) || {};
    const modules = manifest.modules || [];
    const graphOut = modules.some(module =>
        module.output && module.output.type === 'proto:sf.substreams.sink.entity.v1.EntityChanges'
    );

    if (!graphOut) {
        return;
    }

    const proto = protoFiles(projectDir, manifest)
        .map(file => fs.readFileSync(file, 'utf8'))
        .join('\n');

    if (!/package\s+sf\.substreams\.sink\.entity\.v1\s*;/.test(proto)) {
        throw new Error('graph_out requires package sf.substreams.sink.entity.v1');
    }
    if (!hasField(messageBody(proto, 'EntityChanges'), 'EntityChange', 'entity_changes', 5, true)) {
        throw new Error('EntityChanges.entity_changes must be repeated EntityChange field 5');
    }
    if (!hasField(messageBody(proto, 'Field'), 'Value', 'new_value', 3)) {
        throw new Error('Field.new_value must be Value field 3');
    }
}

function parseArgs(args) {
    const options = {};

    for (let i = 0; i < args.length; i += 2) {
        const key = args[i];
        const value = args[i + 1];
        if (!['--intent', '--project'].includes(key) || !value) {
            throw new Error('usage: substreams-preflight --intent <intent.json> --project <project-dir>');
        }
        options[key.slice(2)] = value;
    }

    if (!options.intent || !options.project) {
        throw new Error('usage: substreams-preflight --intent <intent.json> --project <project-dir>');
    }

    return options;
}

function main(args = process.argv.slice(2)) {
    const options = parseArgs(args);
    validateIntent(options.intent);
    validateGraphOut(options.project);
    console.log('✓ Substreams preflight passed');
}

if (require.main === module) {
    try {
        main();
    } catch (error) {
        console.error(`✗ ${error.message}`);
        process.exitCode = 1;
    }
}

module.exports = { main, validateGraphOut, validateIntent };
