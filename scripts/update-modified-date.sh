#!/usr/bin/env bash
# Update dcterms:modified in annotation.ttl when ontology content changes.
# Usage: bash scripts/update-modified-date.sh [YYYY-MM-DD]
set -euo pipefail

MODIFIED_DATE="${1:-$(date -u +%Y-%m-%d)}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ANNOTATION_FILE="${REPO_ROOT}/Robot/annotations/annotation.ttl"

if ! [[ "${MODIFIED_DATE}" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "ERROR: date must be YYYY-MM-DD, got: ${MODIFIED_DATE}" >&2
  exit 1
fi

# Replace the full typed literal (avoid duplicating ^^xsd:date on repeated runs).
sed -i "s|dcterms:modified \"[^\"]*\"\\^\\^xsd:date|dcterms:modified \"${MODIFIED_DATE}\"^^xsd:date|" \
  "${ANNOTATION_FILE}"

echo "Set dcterms:modified to ${MODIFIED_DATE} in Robot/annotations/annotation.ttl"
