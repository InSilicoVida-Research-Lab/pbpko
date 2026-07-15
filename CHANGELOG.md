# Changelog

All notable changes to the PBPK Ontology are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Conventional Commits](https://www.conventionalcommits.org/).

## [Unreleased]

### Added

- ODK modular editing workflow with slim imports and SSSOM mappings.

### Changed

- Migrated from legacy monolithic release to ODK-based build pipeline.
## [2026-07-15] - 2026-07-15

### Changed

- add Zenodo DOI for v2026-07-13 ODK release

### Fixed

- **ci**: use working-directory for metadata validation step
- **metadata**: align ontology metadata with repository and release QC

### Ontology diff

See [release-diff.md](src/ontology/reports/release-diff.md) for the ROBOT diff against the previous release.

## [2026-07-13] - 2026-07-13

### Added

- **ci**: add Husky, changelog automation, and OBO release workflow

### Changed

- remove remaining pre-ODK legacy files
- remove legacy Robot tree and pre-ODK release scripts
- add correct Zenodo DOIs for PBPKO citation
- fix gh-pages deploy and update PBPKO documentation
- add Zenodo metadata for automated archival
- **ontology**: edit-file-only authoring and add 27 terms from pbpko_11_07
- **ci**: enhance release testing and update example terms
- commit release artefacts to repo instead of artifacts only
- sync ontology metadata from annotation.ttl [skip ci]
- fix modified date sed for typed literals in annotation.ttl"
- add OBO metadata sync workflow and annotation.ttl integration
- remove outdated documentation configuration file

### Fixed

- **ci**: avoid PURL wget failure during ODK release build
- **ci**: allow CI to commit root mappings release artefact
- **purl**: correct example term, add base/full artefacts and release tests

### Ontology diff

See [release-diff.md](src/ontology/reports/release-diff.md) for the ROBOT diff against the previous release.

## [1.4.0] - legacy semver release

See [GitHub releases](https://github.com/InSilicoVida-Research-Lab/pbpko/releases) for
historical semver releases (v1.0.0 through v1.4.0). Date-based releases (`vYYYY-MM-DD`)
begin with the first ODK automated release.

[2026-07-13]: https://github.com/InSilicoVida-Research-Lab/pbpko/releases/tag/v2026-07-13

[Unreleased]: https://github.com/InSilicoVida-Research-Lab/pbpko/compare/v2026-07-15...HEAD
[2026-07-15]: https://github.com/InSilicoVida-Research-Lab/pbpko/releases/tag/v2026-07-15
[1.4.0]: https://github.com/InSilicoVida-Research-Lab/pbpko/releases/tag/v1.4.0
