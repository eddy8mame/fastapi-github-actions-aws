#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../logger.sh"
set -a
source "$SCRIPT_DIR/../../.env"
set +a

log_action "Checking if ${BOOTSTRAP_ROLE_NAME} role exists."
if aws iam get-role --role-name "$BOOTSTRAP_ROLE_NAME" >/dev/null; then
  log_success "${BOOTSTRAP_ROLE_NAME} role exists."
else
  log_error "${BOOTSTRAP_ROLE_NAME} role not found — see error above. Creating ${BOOTSTRAP_ROLE_NAME} role."
  "$SCRIPT_DIR/create-bootstrap-role.sh"
fi

log_action "Checking if ${BOOTSTRAP_ROLE_POLICY_NAME} permissions policy is attached to ${BOOTSTRAP_ROLE_NAME} role."
if aws iam get-role-policy --role-name "$BOOTSTRAP_ROLE_NAME" --policy-name "$BOOTSTRAP_ROLE_POLICY_NAME" >/dev/null; then
  log_success "${BOOTSTRAP_ROLE_POLICY_NAME} permissions policy is attached to ${BOOTSTRAP_ROLE_NAME} role."
else
  log_error "${BOOTSTRAP_ROLE_POLICY_NAME} permissions policy not found — see error above. Attaching policy."
  "$SCRIPT_DIR/attach-bootstrap-permissions-policy.sh"
  log_action "Waiting for policy propagation."
  sleep 10
fi

log_action "Assuming ${BOOTSTRAP_ROLE_NAME} role."
CREDS=$(aws sts assume-role \
  --role-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:role/${BOOTSTRAP_ROLE_NAME}" \
  --role-session-name "bootstrap-session" \
  --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
  --output text)

export AWS_ACCESS_KEY_ID=$(echo "$CREDS" | cut -f1)
export AWS_SECRET_ACCESS_KEY=$(echo "$CREDS" | cut -f2)
export AWS_SESSION_TOKEN=$(echo "$CREDS" | cut -f3)
log_success "Assumed ${BOOTSTRAP_ROLE_NAME} role."