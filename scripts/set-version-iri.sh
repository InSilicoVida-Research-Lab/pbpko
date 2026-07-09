#!/usr/bin/env bash
set -euo pipefail

# Set OBO-compliant dated version IRI and publish an immutable release snapshot.
# VERSION_DATE can be overridden for testing (defaults to UTC today).

VERSION_DATE="${VERSION_DATE:-$(date -u +%Y-%m-%d)}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION_IRI="http://purl.obolibrary.org/obo/pbpko/releases/${VERSION_DATE}/pbpko.owl"
ONTOLOGY_IRI="http://purl.obolibrary.org/obo/pbpko.owl"
OWL_FILE="${REPO_ROOT}/Robot/ontologies/pbpko.owl"
RELEASE_DIR="${REPO_ROOT}/releases/${VERSION_DATE}"
RELEASE_FILE="${RELEASE_DIR}/pbpko.owl"

echo "Setting ontology version IRI to ${VERSION_IRI}"

docker run -v "${REPO_ROOT}/Robot:/work" -w /work \
  -e 'ROBOT_JAVA_ARGS=' -e 'JAVA_OPTS=' \
  --rm obolibrary/robot \
  robot annotate \
  --input /work/ontologies/pbpko.owl \
  --ontology-iri "${ONTOLOGY_IRI}" \
  --version-iri "${VERSION_IRI}" \
  --annotation "owl:versionInfo=${VERSION_DATE}" \
  --output /work/ontologies/pbpko.owl

sed -i "s|<term:modified rdf:datatype=\"http://www.w3.org/2001/XMLSchema#date\">[^<]*</term:modified>|<term:modified rdf:datatype=\"http://www.w3.org/2001/XMLSchema#date\">${VERSION_DATE}</term:modified>|" "${OWL_FILE}"

mkdir -p "${RELEASE_DIR}"
cp "${OWL_FILE}" "${RELEASE_FILE}"

echo "Published immutable release snapshot at releases/${VERSION_DATE}/pbpko.owl"
