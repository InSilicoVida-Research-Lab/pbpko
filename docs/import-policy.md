# PBPKO Import Policy

## Principles

1. **Edit file is metadata + imports only** — [`src/ontology/pbpko-edit.owl`](../src/ontology/pbpko-edit.owl)
2. **PBPKO-native terms live in ROBOT templates** — generated into `src/ontology/components/pbpko-vocab.owl`:
   - [`src/templates/pbpko-vocab.tsv`](../src/templates/pbpko-vocab.tsv) — classes and annotations
   - [`src/templates/pbpko-properties.tsv`](../src/templates/pbpko-properties.tsv) — object properties
   - [`src/templates/pbpko-axioms.tsv`](../src/templates/pbpko-axioms.tsv) — existential restrictions (`has_X some Y`)
3. **Foreign terms live in slim import modules** — one module per source ontology, generated from seed lists via ODK SLME/BOT
4. **Cross-references use SSSOM mappings** — not imports — for annotation-only links (UBERON, FMA, BTO, SBO, GO xrefs)
5. **Reviewers should browse the base artifact** — [`pbpko-base.owl`](../pbpko-base.owl) (~580 PBPKO classes)

## Import vs map decision tree

```
Is the foreign term used as rdfs:subClassOf / rdfs:subPropertyOf in PBPKO?
├── YES → add to src/ontology/imports/<source>_terms.txt, run make refresh-imports
└── NO  → add to src/mappings/pbpko-sssom.sssom.tsv (skos:exactMatch or skos:closeMatch)
```

## Current import modules (5)

| Module | Seed file | Source |
|---|---|---|
| `obi_import.owl` | `obi_terms.txt` | OBI (1 term: data representation model) |
| `go_import.owl` | `go_terms.txt` | GO (4 ADME process terms) |
| `bfo_import.owl` | `bfo_terms.txt` | BFO (3 terms) |
| `ro_import.owl` | `ro_terms.txt` | RO (3 annotation properties) |
| `iao_import.owl` | `iao_terms.txt` | IAO (12 annotation properties + 2 classes) |

OBCS is **not imported** — no PBPKO structural axioms reference OBCS terms; statistical evaluation terms are native PBPKO classes.

UBERON, FMA, BTO, SBO are **mapped only** via [`src/mappings/pbpko-sssom.sssom.tsv`](../src/mappings/pbpko-sssom.sssom.tsv).

## Build commands (ODK)

From `src/ontology/` (under `target/pbpko/`):

```bash
cd target/pbpko/src/ontology
sh run.sh make refresh-imports          # regenerate import modules (requires network)
sh run.sh make recreate-vocab-from-template  # rebuild vocab component from TSV templates
sh run.sh make prepare_release          # full release pipeline
sh run.sh make test                     # QC on edit and base artifacts
```

## Adding a new external term

1. Decide import vs map (see decision tree above)
2. If import: add IRI to `src/ontology/imports/<source>_terms.txt`, run `sh run.sh make refresh-imports`
3. If map: add row to `src/mappings/pbpko-sssom.sssom.tsv`
4. Run `sh run.sh make prepare_release`
5. Update [`import-inventory.md`](import-inventory.md)

## Release artifacts

| File | Purpose |
|---|---|
| `pbpko.owl` | Full release with imports merged |
| `pbpko-base.owl` | Native PBPKO terms only — **use for review** |
| `imports/*_import.owl` | Slim per-source modules |
| `mappings/pbpko-sssom.sssom.tsv` | Cross-ontology mappings |

See also [`src/ontology/README-editors.md`](../src/ontology/README-editors.md) and [`odk-workflows/`](odk-workflows/).
