#!/usr/bin/env bash
# Shared ROBOT annotate wrapper (local robot or Docker).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ROBOT_DIR="${REPO_ROOT}/Robot"
ROBOT_IMAGE="${ROBOT_IMAGE:-obolibrary/robot}"

run_robot_annotate() {
  if command -v robot >/dev/null 2>&1; then
    robot annotate "$@"
    return
  fi

  if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: neither 'robot' nor 'docker' found in PATH" >&2
    exit 1
  fi

  docker run \
    -v "${ROBOT_DIR}:/work" \
    -w /work \
    -e 'ROBOT_JAVA_ARGS=' \
    -e 'JAVA_OPTS=' \
    --rm "${ROBOT_IMAGE}" \
    robot annotate "$@"
}

run_robot_annotate "$@"
