#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -a
source "$SCRIPT_DIR/../.env"
set +a

envsubst < "$SCRIPT_DIR/../roles/bootstrap/bootstrap-trust-policy.template.json" \
  > "$SCRIPT_DIR/../roles/bootstrap/bootstrap-trust-policy.json"

aws iam create-role --role-name "$BOOTSTRAP_ROLE_NAME" \
  --assume-role-policy-document "file://$SCRIPT_DIR/../roles/bootstrap/bootstrap-trust-policy.json"