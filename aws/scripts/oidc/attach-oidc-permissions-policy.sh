#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../logger.sh"
set -a
source "$SCRIPT_DIR/../../.env"
set +a

log_action "Attaching ${OIDC_ROLE_POLICY_NAME} permissions policy to ${OIDC_ROLE_NAME} role."

envsubst < "$SCRIPT_DIR/../../roles/oidc/policy-templates/oidc-permissions-policy-template.json" \
  > "$SCRIPT_DIR/../../roles/oidc/policies/oidc-permissions-policy.json"

if aws iam put-role-policy --role-name "$OIDC_ROLE_NAME" \
  --policy-name "$OIDC_ROLE_POLICY_NAME" \
  --policy-document "file://$SCRIPT_DIR/../../roles/oidc/policies/oidc-permissions-policy.json" >/dev/null; then
  log_success "Attached ${OIDC_ROLE_POLICY_NAME} permissions policy to ${OIDC_ROLE_NAME} role."
else
  log_error "Failed to attach ${OIDC_ROLE_POLICY_NAME} permissions policy — see error above."
  exit 1
fi