# Official PBPKO releases

This directory stores immutable OBO-style release snapshots.

Each official release is published at:

```
http://purl.obolibrary.org/obo/pbpko/releases/YYYY-MM-DD/pbpko.owl
```

and corresponds to:

```
releases/YYYY-MM-DD/pbpko.owl
```

## Rules

- Never modify files under `releases/` after publication.
- The development ontology lives at `Robot/ontologies/pbpko.owl` on `main`.
- New releases are created by the release workflow, which:
  1. sets the dated `owl:versionIRI` and `owl:versionInfo`
  2. copies the annotated ontology into `releases/YYYY-MM-DD/pbpko.owl`

## Backfill

Historical snapshots were generated from git tags using:

```bash
python scripts/backfill-releases.py
```
