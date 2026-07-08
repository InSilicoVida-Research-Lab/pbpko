module.exports = {
  branches: ['main'],
  tagFormat: 'v${version}',
  plugins: [
    '@semantic-release/commit-analyzer',
    [
      '@semantic-release/exec',
      {
        prepareCmd: 'bash scripts/set-version-iri.sh',
      },
    ],
    '@semantic-release/release-notes-generator',
    [
      '@semantic-release/git',
      {
        assets: [
          'Robot/ontologies/pbpko.owl',
        ],
        message:
          'chore(release): set ontology version IRI for ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}',
      },
    ],
    [
      '@semantic-release/github',
      {
        assets: [{ path: 'Robot/ontologies/pbpko.owl', label: 'pbpko.owl' }],
      },
    ],
  ],
};
