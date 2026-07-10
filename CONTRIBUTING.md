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
    * [How to write a great issue?](#great-issues)
    * [How to create a great pull/merge request?](#great-pulls)

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

PBPKO follows the **standard ODK model**: seed classes and properties from TSV templates, then edit logical axioms and refinements in Protege on the edit file.

| What you change | Where to edit |
|-----------------|---------------|
| New PBPKO **class** (label, definition, parent) | [`src/templates/pbpko-vocab.tsv`](src/templates/pbpko-vocab.tsv) |
| New PBPKO **object property** | [`src/templates/pbpko-properties.tsv`](src/templates/pbpko-properties.tsv) |
| **Logical axioms** (`has_X some Y`), ad hoc refinements | [`src/ontology/pbpko-edit.owl`](src/ontology/pbpko-edit.owl) in **Protégé** |
| Ontology **metadata** (title, license, creators) | [`src/ontology/pbpko-edit.owl`](src/ontology/pbpko-edit.owl) |
| External **structural** parent | [`src/ontology/imports/*_terms.txt`](src/ontology/imports/) + `make refresh-imports` |
| Cross-ontology **xrefs** (annotation only) | [`src/mappings/pbpko-sssom.sssom.tsv`](src/mappings/pbpko-sssom.sssom.tsv) |

**Process**:

1. Clone the repository (if you are not an official team member, create a fork first)
2. Create a new branch in git, for example `git checkout -b issue123`
3. Make your edit (TSV and/or Protege — see table above)
4. Rebuild and test from `src/ontology/`:
   ```bash
   cd src/ontology
   sh run.sh make recreate-vocab-from-template   # after TSV edits only
   sh run.sh make test IMP=false PAT=false MIR=false
   ```
5. Commit changes to branch (TSV edits + generated `components/pbpko-vocab.owl` if templates changed; `pbpko-edit.owl` if Protege edits)
6. Push changes upstream
7. Create pull request

**Do not edit** release artefacts (`pbpko.owl`, `pbpko-base.owl`), import modules (`imports/*_import.owl`), or the legacy reference file (`orginal pbpk owl/pbpko.owl`).

<a id="protege-editing"></a>

### Editing in Protege (standard ODK workflow)

For **logical axioms** and other OWL-level refinements, open the ODK edit file in Protege:

1. Open [`src/ontology/pbpko-edit.owl`](src/ontology/pbpko-edit.owl) in [Protégé 5.5+](https://protege.stanford.edu/)
2. The vocab component loads automatically as an import — class and property labels are visible
3. Add or edit **existential restrictions** (e.g. `has_compartment some liver compartment`) on PBPKO classes in the **Class hierarchy** or **Class assertions** view
4. Logical axioms live in the section marked `# --- seeded logical axioms (edit below in Protege) ---`
5. **Save as OWL Functional Syntax** (File → Save as → OWL Functional Syntax) to keep git diffs readable
6. Run QC:
   ```bash
   cd src/ontology
   sh run.sh make test IMP=false PAT=false MIR=false
   ```
7. Commit `pbpko-edit.owl` — no template rebuild needed for axiom-only edits

**Bulk new classes or properties** should still be added via TSV templates, then rebuilt with `make recreate-vocab-from-template`.

**One-time axiom seed** from the legacy monolith (does not overwrite existing axioms unless `--force`):

```bash
python3 src/scripts/extract_pbpko_from_original.py --seed-edit-axioms
```

Regenerate TSV templates from legacy file (audit only; does not touch edit-file axioms):

```bash
python3 src/scripts/extract_pbpko_from_original.py
```

## Best Practices

<a id="great-issues"></a>

### How to write great issues?

Please refer to the [OBO Academy term request guide](https://oboacademy.github.io/obook/howto/term-request/).

<a id="great-pulls"></a>

### How to create a great pull/merge request?

Please refer to the [OBO Academy best practices](https://oboacademy.github.io/obook/howto/github-create-pull-request/)
