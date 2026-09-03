#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -a
source "$SCRIPT_DIR/../.env"
set +a

envsubst < "$SCRIPT_DIR/../ecr-repo-creation-template.template.json" \
  > "$SCRIPT_DIR/../ecr-repo-creation-template.json"

aws ecr create-repository-creation-template \
  --cli-input-json "file://$SCRIPT_DIR/../ecr-repo-creation-template.json"