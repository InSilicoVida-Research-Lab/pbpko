# PBPKO Import Policy

## Principles

1. **Edit file** — [`src/ontology/pbpko-edit.owl`](../src/ontology/pbpko-edit.owl) is the **sole authoring source** for all native PBPKO classes, object properties, labels, definitions, parents, metadata, and logical axioms (edited in Protégé)
2. **TSV views are export-only** — run `make export-term-views` to generate `pbpko-vocab-view.tsv` / `pbpko-properties-view.tsv` for spreadsheet review; legacy seeds live in [`src/templates/archive/`](../src/templates/archive/)
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
sh run.sh make refresh-imports     # regenerate import modules (requires network)
sh run.sh make export-term-views   # export read-only TSV views from edit file
sh run.sh make prepare_release     # full release pipeline
sh run.sh make test                # QC on edit and base artifacts
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
