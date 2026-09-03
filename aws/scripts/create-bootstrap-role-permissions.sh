#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -a
source "$SCRIPT_DIR/../.env"
set +a

echo "Checking if AWS IAM ${BOOTSTRAP_ROLE_NAME} role exists..."
if aws iam get-role --role-name "$BOOTSTRAP_ROLE_NAME" >/dev/null; then
  echo "${BOOTSTRAP_ROLE_NAME} role exists."
else
  echo "aws iam get-role failed — see error above. Creating ${BOOTSTRAP_ROLE_NAME} role..."
  "$SCRIPT_DIR/create-bootstrap-role.sh"
fi

echo "Checking if ${BOOTSTRAP_ROLE_POLICY_NAME} policy is attached to ${BOOTSTRAP_ROLE_NAME} role..."
if aws iam get-role-policy --role-name "$BOOTSTRAP_ROLE_NAME" --policy-name "$BOOTSTRAP_ROLE_POLICY_NAME" >/dev/null; then
  echo "Policy is attached."
else
  echo "aws iam get-role-policy failed — see error above. Attaching ${BOOTSTRAP_ROLE_POLICY_NAME} policy..."
  "$SCRIPT_DIR/attach-bootstrap-permissions-policy.sh"
fi

echo "Assuming ${BOOTSTRAP_ROLE_NAME} role..."
CREDS=$(aws sts assume-role \
  --role-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:role/${BOOTSTRAP_ROLE_NAME}" \
  --role-session-name "bootstrap-session" \
  --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
  --output text)

export AWS_ACCESS_KEY_ID=$(echo "$CREDS" | cut -f1)
export AWS_SECRET_ACCESS_KEY=$(echo "$CREDS" | cut -f2)
export AWS_SESSION_TOKEN=$(echo "$CREDS" | cut -f3)