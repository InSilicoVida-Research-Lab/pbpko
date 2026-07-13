# Contributing to PBPK Ontology

:+1: First of all: Thank you for taking the time to contribute!

The following is a set of guidelines for contributing to PBPKO.
These guidelines are not strict rules. Use your best judgment, and feel free to propose
changes to this document in a pull request.

## Table Of Contents

- [Guidelines for Contributions and Requests](#contributions)
    * [Reporting problems with the ontology](#reporting-bugs)
    * [Requesting new terms](#requesting-terms)
    * [Adding new terms by yourself](#adding-terms)
    * [Editing in Protege (standard ODK workflow)](#protege-editing)
- [Best practices](#best-practices)
    * [Commit message conventions](#commit-messages)
    * [How to write a great issue?](#great-issues)
    * [How to create a great pull/merge request?](#great-pulls)
- [Cutting a release](#cutting-a-release)

<a id="contributions"></a>

## Guidelines for Contributions and Requests

<a id="reporting-bugs"></a>

### Reporting problems with the ontology

Please use our [Issue Tracker](https://github.com/InSilicoVida-Research-Lab/pbpko/issues/) for reporting problems with the ontology.
To learn how to write a good issue [see here](#great-issues).

<a id="requesting-terms"></a>

### Requesting new terms

Before you write a new request, please consider the following:

- **Does the term already exist?** Before submitting suggestions for new ontology terms, check whether the term exist,
either as a primary term or a synonym term. You can search for your term using [OLS](http://www.ebi.ac.uk/ols/ontologies/pbpko).
- **Can you provide a definition for the term?** It should be very clear what the term means, and you should be
able to provide a concise definition, ideally with a scientific reference.
- **Is the ontology in scope for the term?** Sometimes, it is hard to tell whether a term "belongs" in
and ontology. A rule of thumb is "if a similar term already exists, the new term is probably in scope."
It can be very helpful to mention a very similar concept as part of the term request!

#### Who can request a term?

Anyone can request new terms. However, there is not guarantee that your term will be added automatically. Since this is a
community resource, it is often necessary to do at least some of the work of adding the term yourself, see below.

#### How to write a new term request

Request a new term _via_ the GitHub [Issue Tracker](https://github.com/InSilicoVida-Research-Lab/pbpko/issues/).

It is important to remember that it takes a lot of time for curators to process issues submitted to the tracker.
To make this work easier, please always use issue templates if they are available (https://github.com/InSilicoVida-Research-Lab/pbpko/issues/new/choose).

For how to write a good term request, please read the [best practices carefully](#great-issues).

<a id="adding-terms"></a>

### How to add a new term

If you have never edited this ontology before, first follow a [general tutorial](https://oboacademy.github.io/obook/lesson/contributing-to-obo-ontologies)

PBPKO uses **edit-file-only** authoring in Protégé: all native classes, properties, labels, definitions, parents, and logical axioms live in a single edit file.

| What you change | Where to edit |
|-----------------|---------------|
| New PBPKO **class** (label, definition, parent) | [`src/ontology/pbpko-edit.owl`](src/ontology/pbpko-edit.owl) in **Protégé** |
| New PBPKO **object property** | [`src/ontology/pbpko-edit.owl`](src/ontology/pbpko-edit.owl) in **Protégé** |
| **Logical axioms** (`has_X some Y`), ad hoc refinements | [`src/ontology/pbpko-edit.owl`](src/ontology/pbpko-edit.owl) in **Protégé** |
| Ontology **metadata** (title, license, creators) | [`src/ontology/pbpko-edit.owl`](src/ontology/pbpko-edit.owl) |
| External **structural** parent | [`src/ontology/imports/*_terms.txt`](src/ontology/imports/) + `make refresh-imports` |
| Cross-ontology **xrefs** (annotation only) | [`src/mappings/pbpko-sssom.sssom.tsv`](src/mappings/pbpko-sssom.sssom.tsv) |
| **Spreadsheet view** (read-only export) | `make export-term-views` → `src/templates/pbpko-vocab-view.tsv` |

**Process**:

1. Clone the repository (if you are not an official team member, create a fork first)
2. Create a new branch in git, for example `git checkout -b issue123`
3. Edit [`src/ontology/pbpko-edit.owl`](src/ontology/pbpko-edit.owl) in Protégé (see below)
4. Run QC from `src/ontology/`:
   ```bash
   cd src/ontology
   sh run.sh make test IMP=false PAT=false MIR=false
   ```
5. Commit `pbpko-edit.owl` (and import/mapping files if changed)
6. Push changes upstream
7. Create pull request

Optional — refresh spreadsheet views for reviewers:

```bash
cd src/ontology
sh run.sh make export-term-views
```

**Do not edit** release artefacts (`pbpko.owl`, `pbpko-base.owl`), import modules at repo root (`imports/*_import.owl`), archived TSV seeds (`src/templates/archive/`), or the legacy reference file (`orginal pbpk owl/pbpko.owl`).

<a id="protege-editing"></a>

### Editing in Protege (edit-file-only ODK workflow)

Open the ODK edit file in Protégé — it contains **all** native PBPKO terms and axioms:

1. Open [`src/ontology/pbpko-edit.owl`](src/ontology/pbpko-edit.owl) in [Protégé 5.5+](https://protege.stanford.edu/)
2. Slim import modules (BFO, GO, OBI, RO, IAO) load automatically — foreign parents are visible
3. Add or edit **classes**, **properties**, **labels**, **definitions**, and **parents** in the Class/Object Property hierarchy
4. Add or edit **existential restrictions** (e.g. `has_compartment some liver compartment`) on PBPKO classes
5. **Save as OWL Functional Syntax** (File → Save as → OWL Functional Syntax) to keep git diffs readable
6. Run QC:
   ```bash
   cd src/ontology
   sh run.sh make test IMP=false PAT=false MIR=false
   ```
7. Commit `pbpko-edit.owl`

To export a read-only TSV for spreadsheet review:

```bash
cd src/ontology
sh run.sh make export-term-views
```

Legacy monolith extraction (audit / one-time seed from old files):

```bash
python3 src/scripts/extract_pbpko_from_original.py --seed-edit-axioms
```

## Best Practices

<a id="commit-messages"></a>

### Commit message conventions

PBPKO uses [Conventional Commits](https://www.conventionalcommits.org/) enforced locally via
[Husky](https://typicode.github.io/husky/) and in CI on pull requests.

After cloning, install commit hooks once:

```bash
npm install
```

Format:

```
<type>(<optional-scope>): <description>
```

| Type | Use for |
|------|---------|
| `term` | New or updated PBPKO class or property |
| `feat` | New feature (imports, components, tooling) |
| `fix` | Bug fix (definitions, axioms, QC) |
| `docs` | Documentation only |
| `chore` | Maintenance (not ontology content) |
| `ci` | CI/CD workflow changes |

Examples:

```
term: add PBPKO_01501 gastric emptying subclass
fix(term): correct definition for PBPKO_00554
feat(imports): refresh OBI slim import
docs: update import policy
chore(release): 2026-07-10
```

The last example triggers an [automated GitHub Release](docs/odk-workflows/ReleaseWorkflow.md)
with OBO/OWL assets. Only release managers should use `chore(release): YYYY-MM-DD`.

<a id="great-issues"></a>

### How to write great issues?

Please refer to the [OBO Academy term request guide](https://oboacademy.github.io/obook/howto/term-request/).

<a id="great-pulls"></a>

### How to create a great pull/merge request?

Please refer to the [OBO Academy best practices](https://oboacademy.github.io/obook/howto/github-create-pull-request/)

<a id="cutting-a-release"></a>

## Cutting a release

Release managers follow the [Release Workflow](docs/odk-workflows/ReleaseWorkflow.md). In brief:

1. Merge all ontology changes and wait for CI to refresh root release artefacts.
2. Trigger a date-based release (OBO Foundry convention):

   ```bash
   git commit --allow-empty -m "chore(release): 2026-07-10"
   git push origin main
   ```

3. GitHub Actions builds `pbpko.owl` / `pbpko.obo`, updates [`CHANGELOG.md`](CHANGELOG.md),
   tags `v2026-07-10`, and publishes a GitHub Release with OBO assets.

Legacy semver tags (`v1.0.0`–`v1.4.0`) remain on GitHub; new releases use `vYYYY-MM-DD`.
