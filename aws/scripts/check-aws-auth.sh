#!/usr/bin/env bash
set -euo pipefail

echo "Checking if logged in to AWS..."
if ! aws sts get-caller-identity >/dev/null; then
  echo "Not logged in to AWS — see error above. Log in (e.g. 'aws sso login' or 'aws configure') and re-run."
  exit 1
fi
echo "Successfully authenticated."