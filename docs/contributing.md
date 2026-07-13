# Contributing to PBPKO

Thank you for contributing to the Physiologically Based Pharmacokinetic Ontology.

The full contributor guide lives in the repository:
[CONTRIBUTING.md](https://github.com/InSilicoVida-Research-Lab/pbpko/blob/main/CONTRIBUTING.md).

## Quick start

PBPKO uses **edit-file-only** authoring in Protégé. All native terms and logical axioms
are edited in a single file:

[`src/ontology/pbpko-edit.owl`](https://github.com/InSilicoVida-Research-Lab/pbpko/blob/main/src/ontology/pbpko-edit.owl)

| Change | Where |
|--------|-------|
| New class, label, definition, parent | `pbpko-edit.owl` (Protégé) |
| Object property | `pbpko-edit.owl` (Protégé) |
| Logical axioms (`has_X some Y`) | `pbpko-edit.owl` (Protégé) |
| Structural foreign parent | `src/ontology/imports/<source>_terms.txt` + `make refresh-imports` |
| Cross-ontology xref (annotation only) | `src/mappings/pbpko-sssom.sssom.tsv` |

**Do not edit** release files at repo root (`pbpko.owl`, `imports/*.owl`), archived TSV
seeds (`src/templates/archive/`), or the legacy reference monolith (`orginal pbpk owl/`).

## Quality control

From `src/ontology/`:

```bash
sh run.sh make test IMP=false PAT=false MIR=false
```

## Commit messages

This repository uses [Conventional Commits](https://www.conventionalcommits.org/) with
[commitlint](https://commitlint.js.org/). Allowed types include `feat`, `fix`, `term`,
`refactor`, `docs`, `ci`, and `chore`.

Examples:

```
term: add menstrual plasma compartment
fix(import): add GO excretion term to go_terms.txt
docs: update import policy for edit-file workflow
chore(release): 2026-07-13
```

## Requesting terms

Open an issue: <https://github.com/InSilicoVida-Research-Lab/pbpko/issues/new/choose>

Before requesting, search existing terms in [OLS](https://www.ebi.ac.uk/ols4/ontologies/pbpko).

## Releases

Release managers trigger dated OBO releases with:

```bash
git commit --allow-empty -m "chore(release): YYYY-MM-DD"
git push origin main
```

See [Release workflow](odk-workflows/ReleaseWorkflow.md) and
[CONTRIBUTING.md — Cutting a release](https://github.com/InSilicoVida-Research-Lab/pbpko/blob/main/CONTRIBUTING.md#cutting-a-release).

## Further reading

- [Import policy](import-policy.md)
- [ODK Editors Workflow](odk-workflows/EditorsWorkflow.md)
- [OBO Academy — contributing to ontologies](https://oboacademy.github.io/obook/lesson/contributing-to-obo-ontologies)
