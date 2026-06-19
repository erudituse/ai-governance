#!/usr/bin/env node
/*
 * install.js — copy the AI governance kit into your project.
 *
 * Run from inside YOUR project:   node /path/to/this-kit/install.js
 *   or name the target directly:  node install.js /path/to/your/project
 *
 * Zero dependencies. Same command on Windows, macOS, and Linux — it only uses
 * Node's built-in `fs`, and Node already ships with Claude Code, so it's on
 * every user's machine. It never overwrites an existing root CLAUDE.md (that
 * holds your project's Part 2).
 */
'use strict';
const fs = require('fs');
const path = require('path');

const SOURCE = __dirname;                                       // the kit
const TARGET = path.resolve(process.argv[2] || process.cwd()); // your project

function die(msg) { console.error('\n✗ ' + msg + '\n'); process.exit(1); }
function say(msg) { console.log(msg); }

if (SOURCE === TARGET) {
  die('Target is the kit itself. Run this from YOUR project directory, or pass its path:\n' +
      '    node "' + path.join(SOURCE, 'install.js') + '" /path/to/your/project');
}
if (!fs.existsSync(TARGET) || !fs.statSync(TARGET).isDirectory()) {
  die('Target is not a directory: ' + TARGET);
}

say('\nInstalling AI governance kit');
say('  from: ' + SOURCE);
say('  into: ' + TARGET + '\n');

const written = [];
const skipped = [];

// 1. governance docs (kit-owned — refreshed on reinstall)
copyDir(path.join(SOURCE, 'docs', 'governance'), path.join(TARGET, 'docs', 'governance'));
written.push('docs/governance/  (guides, templates, checks)');

// 2. agent-side enforcement (kit-owned)
copyFile(path.join(SOURCE, '.claude', 'settings.json'), path.join(TARGET, '.claude', 'settings.json'));
copyDir(path.join(SOURCE, '.claude', 'hooks'), path.join(TARGET, '.claude', 'hooks'));
written.push('.claude/settings.json + .claude/hooks/  (governance hooks)');

// 3. root CLAUDE.md — NEVER clobber the user's (it carries their Part 2)
const rootClaude = path.join(TARGET, 'CLAUDE.md');
const templateClaude = path.join(SOURCE, 'docs', 'governance', 'CLAUDE.md');
if (fs.existsSync(rootClaude)) {
  skipped.push('CLAUDE.md already exists at your repo root — left untouched. ' +
               'Merge the template (docs/governance/CLAUDE.md) into it by hand if you want its policy.');
} else {
  copyFile(templateClaude, rootClaude);
  written.push('CLAUDE.md  (root policy — now FILL IN PART 2)');
}

// 4. .gitignore — append our block once (idempotent via a marker line)
const MARKER = '# Claude Code: governance hooks ship with the repo; ignore only local state';
const giPath = path.join(TARGET, '.gitignore');
const giBlock = '\n' + [
  MARKER,
  '.claude/settings.local.json',
  '.claude/*.lock',
  '.claude/projects/',
  '.claude/plans/',
  '.claude/todos/',
  '.claude/shell-snapshots/',
].join('\n') + '\n';
const gi = fs.existsSync(giPath) ? fs.readFileSync(giPath, 'utf8') : '';
if (gi.includes(MARKER)) {
  skipped.push('.gitignore already has the governance block — left as-is.');
} else {
  fs.writeFileSync(giPath, gi + giBlock);
  written.push('.gitignore  (+ governance block)');
}

// ---------- report ----------
say('Copied:');
written.forEach((w) => say('  ✓ ' + w));
if (skipped.length) {
  say('\nSkipped (nothing of yours was overwritten):');
  skipped.forEach((s) => say('  • ' + s));
}

say('\nNext steps:');
say('  1. Fill in Part 2 of CLAUDE.md — project name, tech stack, and the two switches');
say('     (Contributors: solo|team, Assurance tier: base|audit) in §2.1.');
say('  2. Open Claude Code in this repo. The hooks load automatically: a governance');
say('     checklist is injected each session, and source edits are blocked until a story');
say('     exists. Read docs/governance/00-operating-model.md first for the why.');
say('  3. (Optional) Wire CI gates — see docs/governance/checks/README.md.');

say('\nNote: the hooks need `bash` + `jq`. Native on macOS/Linux; on Windows use Git Bash');
say('or WSL. If `jq` is missing the hooks fail OPEN (safe, but enforcement is off) — install');
say('jq to activate them.\n');

// ---------- helpers ----------
function copyDir(src, dest) {
  if (!fs.existsSync(src)) die('Missing in kit: ' + src);
  fs.mkdirSync(dest, { recursive: true });
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    if (entry.name === '.DS_Store') continue;   // macOS cruft — never ship it
    const s = path.join(src, entry.name);
    const d = path.join(dest, entry.name);
    if (entry.isDirectory()) copyDir(s, d);
    else fs.copyFileSync(s, d);
  }
}
function copyFile(src, dest) {
  if (!fs.existsSync(src)) die('Missing in kit: ' + src);
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.copyFileSync(src, dest);
}
