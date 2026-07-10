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

**Process**:

1. Clone the repository (if you are not an official team member, create a fork first)
2. Create a new branch in git, for example `git checkout -b issue123`
3. **Add or edit native PBPKO classes** in [`src/templates/pbpko-vocab.tsv`](src/templates/pbpko-vocab.tsv)
   - For **object properties**, edit [`src/templates/pbpko-properties.tsv`](src/templates/pbpko-properties.tsv)
   - For **logical restrictions** (e.g. `has_compartment some liver`), add rows to [`src/templates/pbpko-axioms.tsv`](src/templates/pbpko-axioms.tsv)
   - For **ontology metadata** (title, license, creators), edit [`src/ontology/pbpko-edit.owl`](src/ontology/pbpko-edit.owl)
   - For **external structural parents**, add IRIs to [`src/ontology/imports/*_terms.txt`](src/ontology/imports/) and run `sh run.sh make refresh-imports`
   - For **cross-ontology xrefs**, add rows to [`src/mappings/pbpko-sssom.sssom.tsv`](src/mappings/pbpko-sssom.sssom.tsv)
4. Rebuild the vocab component from `src/ontology/`:
   ```bash
   cd src/ontology
   sh run.sh make recreate-vocab-from-template
   sh run.sh make test IMP=false PAT=false MIR=false
   ```
5. Commit changes to branch (include both TSV edits and generated `components/pbpko-vocab.owl`)
6. Push changes upstream
7. Create pull request

**Do not edit** release artefacts (`pbpko.owl`, `pbpko-base.owl`), import modules (`imports/*_import.owl`), or the legacy reference file (`orginal pbpk owl/pbpko.owl`).

To regenerate all templates from the legacy Protege file (audit only):
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