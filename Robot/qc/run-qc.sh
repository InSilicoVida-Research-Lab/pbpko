#!/usr/bin/env bash
# Run standard OBO QC checks for PBPKO.
# Usage (from repository root): Robot/qc/run-qc.sh
# Usage (from Robot/):          ./qc/run-qc.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROBOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROBOT_DIR}"

ONTOLOGY="${ONTOLOGY:-ontologies/pbpko.owl}"
REPORTS_DIR="${REPORTS_DIR:-reports}"
PROFILE="${PROFILE:-qc/profile.txt}"
BASE_IRI="${BASE_IRI:-http://purl.obolibrary.org/obo/PBPKO_}"
ROBOT_IMAGE="${ROBOT_IMAGE:-obolibrary/odkfull:v1.6}"
ROBOT_JAVA_ARGS="${ROBOT_JAVA_ARGS:--Xmx6G}"
SKIP_FULL_REASON="${SKIP_FULL_REASON:-false}"

SPARQL_QUERIES=(
  sparql/ontology-metadata-violation.sparql
  sparql/owldef-self-reference-violation.sparql
  sparql/iri-range-violation.sparql
  sparql/label-with-iri-violation.sparql
  sparql/multiple-replaced_by-violation.sparql
  sparql/pbpko-id-format-violation.sparql
)

mkdir -p "${REPORTS_DIR}"

run_robot() {
  if command -v robot >/dev/null 2>&1; then
    command robot "$@"
    return
  fi
  if ! command -v docker >/dev/null 2>&1; then
    echo "[qc] ERROR: neither 'robot' nor 'docker' found in PATH" >&2
    exit 1
  fi
  docker run \
    -v "${ROBOT_DIR}:/work" \
    -w /work \
    -e "ROBOT_JAVA_ARGS=${ROBOT_JAVA_ARGS}" \
    -e "JAVA_OPTS=" \
    --rm \
    "${ROBOT_IMAGE}" \
    robot "$@"
}

log() {
  echo "[qc] $*"
}

QC_LOG="${REPORTS_DIR}/qc.log"
: > "${QC_LOG}"

run_step() {
  local name="$1"
  shift
  log "Running ${name}..."
  if "$@" >> "${QC_LOG}" 2>&1; then
    log "${name}: PASS"
    return 0
  else
    log "${name}: FAIL (see ${QC_LOG})"
    return 1
  fi
}

FAILED=0

run_step "validate-profile" \
  run_robot validate-profile --profile DL -i "${ONTOLOGY}" \
  || FAILED=1

run_step "report" \
  run_robot report \
    -i "${ONTOLOGY}" \
    --base-iri "${BASE_IRI}" \
    --profile "${PROFILE}" \
    --fail-on ERROR \
    -o "${REPORTS_DIR}/robot_report.tsv" \
  || FAILED=1

run_step "verify" \
  run_robot verify \
    -i "${ONTOLOGY}" \
    -q "${SPARQL_QUERIES[@]}" \
    -O "${REPORTS_DIR}/verify" \
  || FAILED=1

if [[ "${SKIP_FULL_REASON}" != "true" ]]; then
  run_step "reason" \
    run_robot reason \
      -i "${ONTOLOGY}" \
      -r ELK \
      -e none \
      -o "${REPORTS_DIR}/reasoned.owl" \
    || FAILED=1
else
  log "Skipping reason (SKIP_FULL_REASON=true)"
fi

if [[ "${FAILED}" -ne 0 ]]; then
  log "QC failed. Last 30 lines of ${QC_LOG}:"
  tail -30 "${QC_LOG}" || true
  exit 1
fi

log "All QC checks passed."
log "Reports written to ${REPORTS_DIR}/"
