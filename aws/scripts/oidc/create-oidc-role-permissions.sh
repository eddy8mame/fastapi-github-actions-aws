#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../logger.sh"
set -a
source "$SCRIPT_DIR/../../.env"
set +a

log_action "Checking if ${OIDC_ROLE_NAME} role exists."
if aws iam get-role --role-name "$OIDC_ROLE_NAME" >/dev/null; then
  log_success "${OIDC_ROLE_NAME} role exists."
else
  log_error "${OIDC_ROLE_NAME} role not found — see error above. Creating ${OIDC_ROLE_NAME} role."
  "$SCRIPT_DIR/create-oidc-role.sh"
fi

log_action "Checking if ${OIDC_ROLE_POLICY_NAME} permissions policy is attached to ${OIDC_ROLE_NAME} role."
if aws iam get-role-policy --role-name "$OIDC_ROLE_NAME" --policy-name "$OIDC_ROLE_POLICY_NAME" >/dev/null; then
  log_success "${OIDC_ROLE_POLICY_NAME} permissions policy is attached to ${OIDC_ROLE_NAME} role."
else
  log_error "${OIDC_ROLE_POLICY_NAME} permissions policy not found — see error above. Attaching policy."
  "$SCRIPT_DIR/attach-oidc-permissions-policy.sh"
  log_action "Waiting for policy propagation."
  sleep 10
fi