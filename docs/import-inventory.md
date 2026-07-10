# PBPKO Import Inventory

Foreign IRI usage audit for modular import refactor. Generated during the 2026 import architecture migration.

## Structural imports (seed-based modules)

| IRI | Source | Usage | Module |
|---|---|---|---|
| OBI:0000658 | OBI | subClassOf parent (compartment, PBPK model) | obi_import.owl |
| GO:0008150 | GO | subClassOf parent (biological processes) | go_import.owl |
| GO:0008152 | GO | subClassOf parent (metabolic processes) | go_import.owl |
| GO:0007588 | GO | subClassOf parent (excretion) | go_import.owl |
| GO:0009987 | GO | subClassOf parent (cellular process) | go_import.owl |
| BFO:0000040 | BFO | subClassOf parent (material entity) | bfo_import.owl |
| BFO:0000029 | BFO | referenced class (site) | bfo_import.owl |
| BFO:0000051 | BFO | subPropertyOf parent (has_part) | bfo_import.owl |
| IAO:0000027 | IAO | referenced class (data item) | iao_import.owl |
| IAO:0000100 | IAO | referenced class (data set) | iao_import.owl |
| IAO:0000111–0000425 | IAO | annotation properties (12) | iao_import.owl |
| RO:0002161, 0002171, 0002175 | RO | annotation properties (3) | ro_import.owl |
| OBCS:0000030, 0000259–0000261 | OBCS | evaluation/statistical terms | **Not imported** — no structural use; native PBPKO terms used instead |

## Mapping only (SSSOM, not imported)

| Source | Count | Usage |
|---|---|---|
| UBERON | 47 IRIs | skos:closeMatch on PBPKO compartment terms |
| SBO | 0000025, 0000027, 0000290, 0000005 | skos:exactMatch/closeMatch on parameters |
| VT | VT:0004020 | skos:closeMatch |
| FMA / BTO | recovered from historical release | skos:closeMatch on compartments |
| GO (annotation) | e.g. GO:0008015 | skos:exactMatch in `src/templates/pbpko-vocab.tsv` |

## Removed (legacy merge artifacts)

- UBPROP:* annotation properties (from merged UBERON extract)
- Inlined foreign class declarations: SBO:0000027, GO:0007588, GO:0008152, BFO:0000029
- Full OBI and RO owl:imports (replaced by slim modules)

## Legacy PBPKO term ID fixes

| Old IRI | New ID | Label |
|---|---|---|
| ...#OWLClass_6a86eddf... | PBPKO:00652 | absorption rate constant (ka) |
| ...#OWLClass_91922c71... | PBPKO:00653 | glomerulus compartment |

## ODK template seed (2026-07-10)

Native terms are authored in ROBOT templates under `src/templates/`:

| Template | Content | Build role |
|---|---|---|
| `pbpko-vocab.tsv` | 831 PBPKO classes with annotations and subclass parents | Compiled into component |
| `pbpko-properties.tsv` | 8 PBPKO object properties (`PBPKO_10001`–`10009`) | Compiled into component |
| `pbpko-axioms.tsv` | 3,877 existential restrictions (seed record) | **Not in build** — axioms in edit file |

Logical axioms are edited in Protege on [`pbpko-edit.owl`](../src/ontology/pbpko-edit.owl) (standard ODK workflow).

Regenerate TSV from legacy: `python3 src/scripts/extract_pbpko_from_original.py`  
One-time axiom seed into edit file: `python3 src/scripts/extract_pbpko_from_original.py --seed-edit-axioms`
