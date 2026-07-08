# Changelog

All notable changes to the PBPK Ontology (PBPKO) are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

When preparing a release, add entries under `[Unreleased]`, then move them into
a new version section with the release date before tagging.

## [Unreleased]

## [1.3.2] - 2026-02-16

### Added

- New PBPK ontology terms.

## [1.3.1] - 2025-10-19

### Fixed

- Updated definitions for `PBPKO_00387`.
- Updated license metadata in ontology annotations.

## [1.3.0] - 2025-09-12

### Added

- Imported `GO:metabolic process` to replace the custom metabolism term.

### Changed

- Renamed and reorganized blood flow parameter under the suggested hierarchy.
- Renamed lifestage subclasses by appending the word *lifestage* for clarity.
- Renamed *race* to *assigned race* and placed it under *parameter*.
- Renamed *reference human* to *reference human dataset* and moved it under *data set*.
- Renamed *distribution* to *distribution process*.
- Renamed *protein binding* to *protein binding mediated distribution process*.

### Moved

- Relocated *human serum albumin* under *material entity*.
- Relocated *transporter* under *material entity*.

### Fixed

- Standardized definitions to proper format.
- Converted plural labels to singular form for consistency.

## [1.2.0] - 2025-05-22

### Changed

- Imported the OBI ontology and linked PBPKO classes to BFO and OBI.
- Extracted and merged selected terms from the SBO ontology due to import issues via URL.
- Moved `parameter` under `generically dependent continuant` as a subclass of `data item`.
- Moved `compartment` and `physiologically based pharmacokinetic model` under `generically dependent continuant` as subclasses of `data representation model`.
- Restructured all class definitions using genus-differentia format.
- Created new parent classes to group related terms (for example, *fraction of volume of compartment* for volume-fraction parameters).
- Clarified ambiguous labels (for example, *apparent permeability cerebellum to rest of brain*).
- Replaced outdated references and changed `skos:exactMatch` to `skos:closeMatch` where appropriate.

### Removed

- Removed unclear terms and properties pending re-integration: `enzyme`, `transporter`, `alpha acid glycoprotein`, `apical transporter`, `basolateral transporter`, `has_enzyme`, and `has_transporter`.

## [1.1.0] - 2025-02-04

### Added

- Integration with Basic Formal Ontology (BFO) and the Relation Ontology (RO) following OBO guidelines.
- Object properties to formally represent relationships in the ontology.
- Definitions for all terms following OBO naming conventions.
- SKOS mappings and imports from existing OBO Foundry ontologies where relevant.
- Comprehensive documentation at https://insilicovida-research-lab.github.io/pbpko/.

### Changed

- Redefined and reclassified classes under the BFO hierarchy with appropriate restrictions.
- Redefined labels with clear abbreviations following OBO naming conventions.
- Reviewed Uberon compartment mappings; redefined labels and added SKOS annotations where PBPKO compartments differ from Uberon.

### Fixed

- Corrected URI pattern from `http://purl.obolibrary.org/obo/pbpko/PKPBO_00328` to `http://purl.obolibrary.org/obo/PKPBO_00328`.

## [1.0.3] - 2025-02-04

### Changed

- Patch release; no separately documented ontology changes.

## [1.0.2] - 2025-02-04

### Changed

- Patch release; no separately documented ontology changes.

## [1.0.1] - 2024-10-09

### Changed

- Updated ontology annotations and vocabulary templates.
- Updated clearance terms and naming conventions.

## [1.0.0] - 2024-07-15

### Added

- Initial public release of the PBPK Ontology (PBPKO).

[Unreleased]: https://github.com/InSilicoVida-Research-Lab/pbpko/compare/v1.3.2...HEAD
[1.3.2]: https://github.com/InSilicoVida-Research-Lab/pbpko/compare/v1.3.1...v1.3.2
[1.3.1]: https://github.com/InSilicoVida-Research-Lab/pbpko/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/InSilicoVida-Research-Lab/pbpko/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/InSilicoVida-Research-Lab/pbpko/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/InSilicoVida-Research-Lab/pbpko/compare/v1.0.3...v1.1.0
[1.0.3]: https://github.com/InSilicoVida-Research-Lab/pbpko/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/InSilicoVida-Research-Lab/pbpko/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/InSilicoVida-Research-Lab/pbpko/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/InSilicoVida-Research-Lab/pbpko/releases/tag/v1.0.0
