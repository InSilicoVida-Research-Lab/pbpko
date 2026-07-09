#!/usr/bin/env bash
set -euo pipefail

# Prepare an OBO dated release: version IRI + versionInfo + annotation.ttl merge.
# dcterms:modified comes from annotation.ttl (content change date), not release date.
# VERSION_DATE can be overridden for testing (defaults to UTC today).

VERSION_DATE="${VERSION_DATE:-$(date -u +%Y-%m-%d)}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ONTOLOGY_IRI="http://purl.obolibrary.org/obo/pbpko.owl"
VERSION_IRI="http://purl.obolibrary.org/obo/pbpko/releases/${VERSION_DATE}/pbpko.owl"
OWL_FILE="${REPO_ROOT}/Robot/ontologies/pbpko.owl"
RELEASE_DIR="${REPO_ROOT}/releases/${VERSION_DATE}"
RELEASE_FILE="${RELEASE_DIR}/pbpko.owl"
GITHUB_ASSET="${REPO_ROOT}/pbpko-release.owl"
INPUT="/work/ontologies/pbpko.owl"
ANNOTATION_FILE="/work/annotations/annotation.ttl"
OUTPUT="/work/ontologies/pbpko.owl"

echo "Setting ontology version IRI to ${VERSION_IRI}"
echo "Merging annotations from annotation.ttl (dcterms:modified unchanged by release date)"

bash "${REPO_ROOT}/scripts/robot-annotate.sh" \
  --input "${INPUT}" \
  --remove-annotations \
  --ontology-iri "${ONTOLOGY_IRI}" \
  --version-iri "${VERSION_IRI}" \
  --annotation owl:versionInfo "${VERSION_DATE}" \
  --annotation-file "${ANNOTATION_FILE}" \
  --output "${OUTPUT}"

bash "${REPO_ROOT}/scripts/clean-owl-orphans.sh" "${OWL_FILE}"

mkdir -p "${RELEASE_DIR}"
cp "${OWL_FILE}" "${RELEASE_FILE}"
cp "${OWL_FILE}" "${GITHUB_ASSET}"
echo "${VERSION_DATE}" > "${REPO_ROOT}/.release-version-date"

echo "Published immutable release snapshot at releases/${VERSION_DATE}/pbpko.owl"
echo "GitHub release asset prepared at pbpko-release.owl"
