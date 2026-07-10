#!/usr/bin/env node
/**
 * Generate a Keep a Changelog section from conventional commits since the previous tag.
 *
 * Usage: node scripts/generate-changelog.js <YYYY-MM-DD> [previous-tag]
 *
 * Writes the new release section to stdout and updates CHANGELOG.md in the repo root.
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const VERSION = process.argv[2];
const PREV_TAG_ARG = process.argv[3];

if (!VERSION || !/^\d{4}-\d{2}-\d{2}$/.test(VERSION)) {
  console.error('Usage: node scripts/generate-changelog.js <YYYY-MM-DD> [previous-tag]');
  process.exit(1);
}

const REPO_ROOT = path.resolve(__dirname, '..');
const CHANGELOG_PATH = path.join(REPO_ROOT, 'CHANGELOG.md');
const RELEASE_DIFF_PATH = path.join(
  REPO_ROOT,
  'src/ontology/reports/release-diff.md'
);

const SKIP_PATTERNS = [
  /^chore\(release\):/,
  /^chore\(release-artifacts\):/,
  /^chore: release v/,
  /^chore: refresh release artefacts/,
  /^Merge /,
  /^Revert "/,
];

function run(cmd) {
  return execSync(cmd, { cwd: REPO_ROOT, encoding: 'utf8' }).trim();
}

function resolvePreviousTag() {
  if (PREV_TAG_ARG) {
    return PREV_TAG_ARG;
  }
  const dateTags = run("git tag -l 'v20*' --sort=-version:refname");
  if (dateTags) {
    return dateTags.split('\n')[0];
  }
  const semverTags = run("git tag -l 'v*' --sort=-version:refname");
  if (semverTags) {
    return semverTags.split('\n')[0];
  }
  return null;
}

function parseCommit(line) {
  const match = line.match(/^(\w+)(?:\(([^)]+)\))?!?:\s*(.+)$/);
  if (!match) {
    return null;
  }
  return { type: match[1], scope: match[2], subject: match[3] };
}

function formatEntry(commit) {
  const scope = commit.scope ? `**${commit.scope}**: ` : '';
  return `- ${scope}${commit.subject}`;
}

function collectCommits(prevTag) {
  const range = prevTag ? `${prevTag}..HEAD` : 'HEAD';
  let log;
  try {
    log = run(`git log ${range} --pretty=format:%s --no-merges`);
  } catch {
    return [];
  }
  if (!log) {
    return [];
  }

  return log
    .split('\n')
    .filter((line) => line && !SKIP_PATTERNS.some((p) => p.test(line)))
    .map(parseCommit)
    .filter(Boolean);
}

function groupCommits(commits) {
  const groups = {
    Added: [],
    Changed: [],
    Fixed: [],
    Deprecated: [],
    Removed: [],
    Other: [],
  };

  for (const commit of commits) {
    const entry = formatEntry(commit);
    switch (commit.type) {
      case 'feat':
      case 'term':
        groups.Added.push(entry);
        break;
      case 'fix':
        groups.Fixed.push(entry);
        break;
      case 'refactor':
      case 'perf':
      case 'style':
      case 'chore':
      case 'ci':
      case 'build':
        groups.Changed.push(entry);
        break;
      case 'docs':
        groups.Changed.push(entry);
        break;
      default:
        groups.Other.push(entry);
    }
  }

  return groups;
}

function renderSection(version, groups) {
  const lines = [`## [${version}] - ${version}`, ''];

  for (const [heading, entries] of Object.entries(groups)) {
    if (entries.length === 0) {
      continue;
    }
    lines.push(`### ${heading}`, '', ...entries, '');
  }

  if (fs.existsSync(RELEASE_DIFF_PATH)) {
    const diffStat = fs.statSync(RELEASE_DIFF_PATH);
    if (diffStat.size > 0) {
      lines.push(
        '### Ontology diff',
        '',
        'See [release-diff.md](src/ontology/reports/release-diff.md) for the ROBOT diff against the previous release.',
        ''
      );
    }
  }

  return lines.join('\n');
}

function updateChangelog(version, section) {
  let content = fs.readFileSync(CHANGELOG_PATH, 'utf8');
  const unreleasedHeader = '## [Unreleased]';
  const unreleasedIdx = content.indexOf(unreleasedHeader);

  if (unreleasedIdx === -1) {
    throw new Error('CHANGELOG.md must contain an ## [Unreleased] section');
  }

  const nextSectionMatch = content.slice(unreleasedIdx + unreleasedHeader.length).match(/\n## /);
  const unreleasedEnd =
    nextSectionMatch && nextSectionMatch.index !== undefined
      ? unreleasedIdx + unreleasedHeader.length + nextSectionMatch.index
      : content.length;

  const before = content.slice(0, unreleasedEnd).trimEnd();
  const after = content.slice(unreleasedEnd).trimStart();

  const tagName = `v${version}`;
  const prevTag = resolvePreviousTag();
  const compareFrom = prevTag || 'v1.4.0';

  const bodyWithoutFooter = [before, '', section, '', after]
    .filter(Boolean)
    .join('\n')
    .replace(/\n\[(Unreleased|[\d.]+)\]:[^\n]*/g, '')
    .trimEnd();

  const footer = [
    `[Unreleased]: https://github.com/InSilicoVida-Research-Lab/pbpko/compare/${tagName}...HEAD`,
    `[${version}]: https://github.com/InSilicoVida-Research-Lab/pbpko/releases/tag/${tagName}`,
  ];

  if (compareFrom && compareFrom !== tagName) {
    const legacyLink = content.match(/^\[1\.4\.0\]:[^\n]*/m);
    if (legacyLink) {
      footer.push(legacyLink[0]);
    }
  }

  fs.writeFileSync(CHANGELOG_PATH, `${bodyWithoutFooter}\n\n${footer.join('\n')}\n`, 'utf8');
}

function main() {
  const prevTag = resolvePreviousTag();
  const commits = collectCommits(prevTag);
  const groups = groupCommits(commits);
  const section = renderSection(VERSION, groups);

  console.log(section);
  updateChangelog(VERSION, section);

  if (prevTag) {
    console.error(`Changelog updated for ${VERSION} (commits since ${prevTag})`);
  } else {
    console.error(`Changelog updated for ${VERSION} (no previous tag found)`);
  }
}

main();
