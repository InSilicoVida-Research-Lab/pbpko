# PBPK Ontology (PBPKO)

The **Physiologically Based Pharmacokinetic Ontology (PBPKO)** provides a dedicated
vocabulary for describing PBPK models, compartments, parameters, processes, and related
pharmacokinetic concepts. It supports consistent reporting and automation in pharmaceutical
and environmental life-science applications.

## Quick links

| Resource | URL |
|----------|-----|
| Documentation (this site) | <https://insilicovida-research-lab.github.io/pbpko/> |
| GitHub repository | <https://github.com/InSilicoVida-Research-Lab/pbpko> |
| OBO Foundry PURL | <http://purl.obolibrary.org/obo/pbpko.owl> |
| OLS browser | <https://www.ebi.ac.uk/ols4/ontologies/pbpko> |
| OntoBee | <http://www.ontobee.org/ontology/PBPKO> |
| Issue tracker | <https://github.com/InSilicoVida-Research-Lab/pbpko/issues> |

## Release artefacts

Current releases are built with the [Ontology Development Kit (ODK)](https://github.com/INCATools/ontology-development-kit)
and published at the repository root:

| File | Purpose |
|------|---------|
| [`pbpko.owl`](https://github.com/InSilicoVida-Research-Lab/pbpko/blob/main/pbpko.owl) | Primary release (full ontology with slim imports) |
| [`pbpko.obo`](https://github.com/InSilicoVida-Research-Lab/pbpko/blob/main/pbpko.obo) | OBO-format release |
| [`pbpko-base.owl`](https://github.com/InSilicoVida-Research-Lab/pbpko/blob/main/pbpko-base.owl) | Native PBPKO terms only — **best for review** |
| [`pbpko-full.owl`](https://github.com/InSilicoVida-Research-Lab/pbpko/blob/main/pbpko-full.owl) | Full artefact variant |
| [`mappings/pbpko-sssom.sssom.tsv`](https://github.com/InSilicoVida-Research-Lab/pbpko/blob/main/mappings/pbpko-sssom.sssom.tsv) | Cross-ontology SSSOM mappings |

Dated versions are tagged `vYYYY-MM-DD` (OBO convention) and resolve via PURL under `/releases/`.

## Architecture (ODK migration)

PBPKO follows modern OBO modular practice:

- **Edit file** — all native PBPKO classes, properties, labels, definitions, parents, and
  logical axioms are authored in
  [`src/ontology/pbpko-edit.owl`](https://github.com/InSilicoVida-Research-Lab/pbpko/blob/main/src/ontology/pbpko-edit.owl)
  using Protégé.
- **Slim imports** — only required foreign terms are extracted into per-source modules
  (`obi`, `go`, `bfo`, `ro`, `iao`), not full upstream ontologies.
- **SSSOM mappings** — annotation-only cross-references to UBERON, FMA, BTO, SBO, and others
  live in the mappings file, not as imports.
- **Automated QC and release** — GitHub Actions runs ROBOT validation, commits release artefacts,
  and publishes dated GitHub/Zenodo releases.

See [Import policy](import-policy.md) and [Import inventory](import-inventory.md) for details.

## Editing workflow

1. Edit [`pbpko-edit.owl`](https://github.com/InSilicoVida-Research-Lab/pbpko/blob/main/src/ontology/pbpko-edit.owl) in Protégé.
2. Run QC from `src/ontology/`:
   ```bash
   cd src/ontology
   sh run.sh make test IMP=false PAT=false MIR=false
   ```
3. Open a pull request against `main`.

Optional spreadsheet views (read-only exports):

```bash
cd src/ontology
sh run.sh make export-term-views
```

Full contributor guide: [Contributing](contributing.md) and the
[ODK editors workflow](odk-workflows/EditorsWorkflow.md).

## Licence

PBPKO is released under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
