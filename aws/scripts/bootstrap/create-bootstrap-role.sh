#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../logger.sh"
set -a
source "$SCRIPT_DIR/../../.env"
set +a

log_action "Creating ${BOOTSTRAP_ROLE_NAME} role."

envsubst < "$SCRIPT_DIR/../../roles/bootstrap/policy-templates/bootstrap-trust-policy-template.json" \
  > "$SCRIPT_DIR/../../roles/bootstrap/policies/bootstrap-trust-policy.json"

if aws iam create-role --role-name "$BOOTSTRAP_ROLE_NAME" \
  --assume-role-policy-document "file://$SCRIPT_DIR/../../roles/bootstrap/policies/bootstrap-trust-policy.json" >/dev/null; then
  log_success "Created ${BOOTSTRAP_ROLE_NAME} role."
else
  log_error "Failed to create ${BOOTSTRAP_ROLE_NAME} role — see error above."
  exit 1
fi