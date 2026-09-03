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
  echo "aws iam get-role failed — see error above. Creating ${OIDC_ROLE_NAME} role and permissions policy..."
  "$SCRIPT_DIR/create-oidc-role.sh"
  "$SCRIPT_DIR/attach-oidc-role-permissions-policy.sh"
fi
echo "Successfully created or verified ${OIDC_ROLE_NAME} role and attached permissions policy."