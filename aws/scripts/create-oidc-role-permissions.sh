#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -a
source "$SCRIPT_DIR/../.env"
set +a

echo "Checking if AWS IAM ${OIDC_ROLE_NAME} role exists..."
if aws iam get-role --role-name "$OIDC_ROLE_NAME" >/dev/null; then
  echo "${OIDC_ROLE_NAME} role exists."
else
  echo "aws iam get-role failed — see error above. Creating ${OIDC_ROLE_NAME} role..."
  "$SCRIPT_DIR/create-oidc-role.sh"
fi

echo "Checking if ${OIDC_ROLE_POLICY_NAME} policy is attached to ${OIDC_ROLE_NAME} role..."
if aws iam get-role-policy --role-name "$OIDC_ROLE_NAME" --policy-name "$OIDC_ROLE_POLICY_NAME" >/dev/null; then
  echo "Policy is attached."
else
  echo "aws iam get-role-policy failed — see error above. Attaching ${OIDC_ROLE_POLICY_NAME} policy..."
  "$SCRIPT_DIR/attach-oidc-role-permissions-policy.sh"
  echo "Waiting for policy propagation..."
  sleep 10
fi