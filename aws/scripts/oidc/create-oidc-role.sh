#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../logger.sh"
set -a
source "$SCRIPT_DIR/../../.env"
set +a

log_action "Creating ${OIDC_ROLE_NAME} role."

envsubst < "$SCRIPT_DIR/../../roles/oidc/policy-templates/oidc-trust-policy-template.json" \
  > "$SCRIPT_DIR/../../roles/oidc/policies/oidc-trust-policy.json"

if aws iam create-role --role-name "$OIDC_ROLE_NAME" \
  --assume-role-policy-document "file://$SCRIPT_DIR/../../roles/oidc/policies/oidc-trust-policy.json" >/dev/null; then
  log_success "Created ${OIDC_ROLE_NAME} role."
else
  log_error "Failed to create ${OIDC_ROLE_NAME} role — see error above."
  exit 1
fi