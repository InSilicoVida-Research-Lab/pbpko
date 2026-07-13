# Archived ROBOT template seeds (read-only)

These TSV files were used during the ODK migration to seed `components/pbpko-vocab.owl`.
PBPKO now uses **edit-file-only** authoring in `src/ontology/pbpko-edit.owl`.

Do not edit these files to change the ontology.

For a current spreadsheet view, run from `src/ontology/`:

```bash
sh run.sh make export-term-views
```

That writes `pbpko-vocab-view.tsv` and `pbpko-properties-view.tsv` in this directory's parent (`src/templates/`).
