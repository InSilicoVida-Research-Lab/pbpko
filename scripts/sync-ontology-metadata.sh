#!/usr/bin/env bash
# Sync ontology metadata: bump dcterms:modified on content changes, merge annotation.ttl.
# Usage:
#   bash scripts/sync-ontology-metadata.sh            # apply changes
#   bash scripts/sync-ontology-metadata.sh --check    # exit 1 if sync would change files
set -euo pipefail

CHECK_ONLY=false
if [[ "${1:-}" == "--check" ]]; then
  CHECK_ONLY=true
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OWL_FILE="${REPO_ROOT}/Robot/ontologies/pbpko.owl"
BEFORE_SHA="${BEFORE_SHA:-}"
AFTER_SHA="${AFTER_SHA:-HEAD}"

strip_ontology_body_hash() {
  python3 - "$1" <<'PY'
import hashlib
import re
import sys
from pathlib import Path

text = Path(sys.argv[1]).read_text(encoding="utf-8")
stripped = re.sub(
    r"<owl:Ontology\b[^>]*>.*?</owl:Ontology>",
    '<owl:Ontology rdf:about="http://purl.obolibrary.org/obo/pbpko.owl"></owl:Ontology>',
    text,
    count=1,
    flags=re.DOTALL,
)
print(hashlib.sha256(stripped.encode("utf-8")).hexdigest())
PY
}

ontology_content_changed() {
  local before_ref="$1"
  local after_ref="$2"
  local before_file after_file

  if [[ -z "${before_ref}" || "${before_ref}" == "0000000000000000000000000000000000000000" ]]; then
    return 0
  fi

  before_file="$(mktemp)"
  after_file="$(mktemp)"
  trap 'rm -f "${before_file}" "${after_file}"' RETURN

  if ! git show "${before_ref}:Robot/ontologies/pbpko.owl" > "${before_file}" 2>/dev/null; then
    return 0
  fi

  if ! git show "${after_ref}:Robot/ontologies/pbpko.owl" > "${after_file}" 2>/dev/null; then
    cp "${OWL_FILE}" "${after_file}"
  fi

  [[ "$(strip_ontology_body_hash "${before_file}")" != "$(strip_ontology_body_hash "${after_file}")" ]]
}

if [[ -z "${BEFORE_SHA}" ]]; then
  if git rev-parse HEAD~1 >/dev/null 2>&1; then
    BEFORE_SHA="$(git rev-parse HEAD~1)"
  else
    BEFORE_SHA=""
  fi
fi

if ontology_content_changed "${BEFORE_SHA}" "${AFTER_SHA}"; then
  MODIFIED_DATE="$(git log -1 --format=%cs "${AFTER_SHA}" 2>/dev/null || date -u +%Y-%m-%d)"
  echo "Ontology content changed; setting dcterms:modified to ${MODIFIED_DATE}"
  bash "${REPO_ROOT}/scripts/update-modified-date.sh" "${MODIFIED_DATE}"
else
  echo "No ontology content change detected; keeping dcterms:modified in annotation.ttl"
fi

bash "${REPO_ROOT}/scripts/apply-annotations.sh"

if [[ "${CHECK_ONLY}" == true ]]; then
  if [[ -n "$(git status --porcelain -- Robot/ontologies/pbpko.owl Robot/annotations/annotation.ttl)" ]]; then
    echo "ERROR: ontology metadata is out of sync with annotation.ttl" >&2
    git --no-pager diff -- Robot/ontologies/pbpko.owl Robot/annotations/annotation.ttl >&2 || true
    exit 1
  fi
  echo "Ontology metadata is in sync."
fi
