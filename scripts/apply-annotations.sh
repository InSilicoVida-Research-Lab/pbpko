#!/usr/bin/env bash
# Merge annotation.ttl into the development ontology (no version IRI change).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ONTOLOGY_IRI="http://purl.obolibrary.org/obo/pbpko.owl"
OWL_FILE="${REPO_ROOT}/Robot/ontologies/pbpko.owl"
INPUT="/work/ontologies/pbpko.owl"
ANNOTATION_FILE="/work/annotations/annotation.ttl"
OUTPUT="/work/ontologies/pbpko.owl"

VERSION_IRI="$(grep -oP 'owl:versionIRI rdf:resource="\K[^"]+' "${OWL_FILE}")"
VERSION_INFO="$(grep -oP '<owl:versionInfo>\K[^<]+' "${OWL_FILE}")"

if [[ -z "${VERSION_IRI}" || -z "${VERSION_INFO}" ]]; then
  echo "ERROR: could not read versionIRI/versionInfo from ${OWL_FILE}" >&2
  exit 1
fi

echo "Applying annotations from annotation.ttl to ${ONTOLOGY_IRI}"
echo "Preserving versionIRI=${VERSION_IRI} and versionInfo=${VERSION_INFO}"

bash "${REPO_ROOT}/scripts/robot-annotate.sh" \
  --input "${INPUT}" \
  --remove-annotations \
  --ontology-iri "${ONTOLOGY_IRI}" \
  --version-iri "${VERSION_IRI}" \
  --annotation owl:versionInfo "${VERSION_INFO}" \
  --annotation-file "${ANNOTATION_FILE}" \
  --output "${OUTPUT}"

bash "${REPO_ROOT}/scripts/clean-owl-orphans.sh" "${OWL_FILE}"

echo "Updated Robot/ontologies/pbpko.owl with annotation.ttl metadata."
