#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../logger.sh"
set -a
source "$SCRIPT_DIR/../../.env"
set +a

read -p "Delete ${BOOTSTRAP_ROLE_NAME} role and its policy? (y/n) " confirm
if [ "$confirm" != "y" ]; then
    log_action "Skipping ${BOOTSTRAP_ROLE_NAME} role deletion."
    exit 0
fi

log_action "Deleting ${BOOTSTRAP_ROLE_POLICY_NAME} policy from ${BOOTSTRAP_ROLE_NAME} role."
if aws iam delete-role-policy --role-name "$BOOTSTRAP_ROLE_NAME" --policy-name "$BOOTSTRAP_ROLE_POLICY_NAME" >/dev/null 2>&1; then
    log_success "Deleted ${BOOTSTRAP_ROLE_POLICY_NAME} policy."
else
    log_error "Failed to delete ${BOOTSTRAP_ROLE_POLICY_NAME} policy — see error above, or it may not exist."
fi

log_action "Deleting ${BOOTSTRAP_ROLE_NAME} role."
if aws iam delete-role --role-name "$BOOTSTRAP_ROLE_NAME" >/dev/null; then
    log_success "Deleted ${BOOTSTRAP_ROLE_NAME} role."
else
    log_error "Failed to delete ${BOOTSTRAP_ROLE_NAME} role — see error above."
    exit 1
fi