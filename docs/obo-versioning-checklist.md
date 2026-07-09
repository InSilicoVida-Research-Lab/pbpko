# OBO versioning maintainer checklist

After merging the `obo-versioning` branch, complete these steps outside this repository.

## 1. Update OBO Foundry PURL configuration

Open a pull request to [OBOFoundry/purl.obolibrary.org](https://github.com/OBOFoundry/purl.obolibrary.org).

Use [config/pbpko-purl.yml](../config/pbpko-purl.yml) as the source for `config/pbpko.yml` in that repository.

**Remove** any old semver-based entries such as:

```yaml
- exact: /releases/v1.3.1/pbpko.owl
```

**Keep/add** the dated `/releases/YYYY-MM-DD/pbpko.owl` entries and the generic:

```yaml
- prefix: /releases/
  replacement: https://raw.githubusercontent.com/InSilicoVida-Research-Lab/pbpko/releases/
```

After each new ontology release, add one more `exact` entry for the new date (unless the prefix rule alone is sufficient and tested).

## 2. Verify PURL resolution

After the PURL PR is merged and deployed, verify these URLs return HTTP 200:

- http://purl.obolibrary.org/obo/pbpko.owl
- http://purl.obolibrary.org/obo/pbpko/releases/2026-02-16/pbpko.owl

## 3. Re-run the OBO Foundry dashboard check

Confirm principle 4 (Versioning) passes:

- version IRI present
- dated format (`YYYY-MM-DD`)
- version IRI resolves

## 4. On each future release

1. Merge releasable commits (`fix:` / `feat:`) to `main`.
2. Let the Release workflow run (sets dated version IRI, `versionInfo`, merges `annotation.ttl`).
3. When ontology **content** changes, run `bash scripts/update-modified-date.sh` before release so `dcterms:modified` in `annotation.ttl` is current.
4. Add a new `exact` PURL entry for the release date in `OBOFoundry/purl.obolibrary.org`.
5. Add a dated section to `CHANGELOG.md` if not already done before release.

See [release-annotations-plan.md](release-annotations-plan.md) for metadata workflow details.

## 5. Optional cleanup

- Old semver GitHub tags (`v1.3.2`, etc.) can remain for history.
- Zenodo will continue to archive GitHub releases; cite using the Zenodo DOI and the OBO version IRI for the specific ontology snapshot.
