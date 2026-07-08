module.exports = {
  // Enforce Conventional Commits:
  //   <type>(<scope>): <subject>
  //   <type>(<scope>)!: <subject>   // for breaking changes
  //   BREAKING CHANGE: <description>
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Keep enforcement strict but aligned with conventional-commits.
    'type-enum': [
      2,
      'always',
      [
        'feat',
        'fix',
        'docs',
        'style',
        'refactor',
        'perf',
        'test',
        'build',
        'ci',
        'chore',
        'revert',
      ],
    ],
  },
};

