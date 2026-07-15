# OBO versioning maintainer checklist

After merging ODK migration work, complete these steps outside this repository.

## 1. Update OBO Foundry PURL configuration

Open a pull request to [OBOFoundry/purl.obolibrary.org](https://github.com/OBOFoundry/purl.obolibrary.org).

Use [`src/metadata/pbpko.yml`](https://github.com/InSilicoVida-Research-Lab/pbpko/blob/main/src/metadata/pbpko.yml) as the source for `config/pbpko.yml` in that repository.

**Remove** any old entries that point at:

- `Robot/ontologies/pbpko.owl`
- `releases/YYYY-MM-DD/pbpko.owl` on the `releases/` branch path

**Use** the ODK layout instead:

- Latest: `main/pbpko.owl`
- Dated: git tag `vYYYY-MM-DD` → root `pbpko.owl` (see `prefix: /releases/` in `src/metadata/pbpko.yml`)

## 2. Verify PURL resolution

After the PURL PR is merged and deployed, verify these URLs return HTTP 200:

- http://purl.obolibrary.org/obo/pbpko.owl
- http://purl.obolibrary.org/obo/pbpko/releases/2026-07-13/pbpko.owl (after first ODK dated tag exists)

## 3. Re-run the OBO Foundry dashboard check

Confirm principle 4 (Versioning) passes:

- version IRI present
- dated format (`YYYY-MM-DD`)
- version IRI resolves

## 4. On each future release

1. Merge releasable commits (`fix:` / `feat:` / `term:`) to `main`.
2. Trigger release: `git commit --allow-empty -m "chore(release): YYYY-MM-DD"` and push to `main`.
3. The Release workflow builds artefacts with ODK (setting `owl:versionIRI`, `owl:versionInfo`, and `dcterms:modified`), updates `CHANGELOG.md`, creates tag `vYYYY-MM-DD`, validates release metadata, and publishes a GitHub Release.
4. Confirm the new dated PURL resolves (tag-based rule in `src/metadata/pbpko.yml`).
5. Submit updated [`src/metadata/pbpko.md`](../src/metadata/pbpko.md) to [OBOFoundry/OBOFoundry.github.io](https://github.com/OBOFoundry/OBOFoundry.github.io) when registry fields change (license, products, contact, CI).
6. Zenodo archives the GitHub Release if integration is enabled.

## 5. Optional cleanup

- Old semver GitHub tags (`v1.3.2`, etc.) can remain for history.
- Zenodo will continue to archive GitHub releases; cite using the Zenodo DOI and the OBO version IRI for the specific ontology snapshot.
