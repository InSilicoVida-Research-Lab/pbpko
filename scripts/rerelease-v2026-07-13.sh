#!/usr/bin/env bash
# Re-release PBPKO as v2026-07-13 after metadata fixes on main.
# Run from repository root after authenticating with GitHub (SSH or HTTPS).

set -euo pipefail

VERSION="2026-07-13"
TAG="v${VERSION}"
BRANCH="main"

echo "==> Fetching latest ${BRANCH}"
git fetch origin "${BRANCH}"
git checkout "${BRANCH}"
git pull --ff-only origin "${BRANCH}"

echo "==> Pushing metadata fix commit(s) on ${BRANCH}"
git push origin "${BRANCH}"

echo "==> Waiting 90s for CI to finish refreshing release artefacts (optional)"
sleep 90
git pull --ff-only origin "${BRANCH}" || true

echo "==> Removing existing tag ${TAG} (local and remote)"
git tag -d "${TAG}" 2>/dev/null || true
git push origin ":refs/tags/${TAG}"

echo "==> Triggering Release workflow"
git commit --allow-empty -m "chore(release): ${VERSION}"
git push origin "${BRANCH}"

echo "==> Done. Monitor workflows at:"
echo "    https://github.com/InSilicoVida-Research-Lab/pbpko/actions"
echo "    https://github.com/InSilicoVida-Research-Lab/pbpko/releases/tag/${TAG}"
