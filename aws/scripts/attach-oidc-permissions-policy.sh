#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -a
source "$SCRIPT_DIR/../.env"
set +a

envsubst < "$SCRIPT_DIR/../roles/oidc/oidc-permissions-policy-template.json" \
  > "$SCRIPT_DIR/../roles/oidc/oidc-permissions-policy.json"

aws iam put-role-policy --role-name "$OIDC_ROLE_NAME" \
  --policy-name "$OIDC_ROLE_POLICY_NAME" \
  --policy-document "file://$SCRIPT_DIR/../roles/oidc/oidc-permissions-policy.json"