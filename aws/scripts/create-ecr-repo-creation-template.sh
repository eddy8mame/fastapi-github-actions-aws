#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -a
source "$SCRIPT_DIR/../.env"
set +a

echo "Checking if ECR repository creation template for prefix '${ECR_REPO_PREFIX}' exists..."
if aws ecr describe-repository-creation-templates \
  --query "repositoryCreationTemplates[?prefix=='${ECR_REPO_PREFIX}']" \
  --output text | grep -q .; then
  echo "Template exists."
else
envsubst < "$SCRIPT_DIR/../ecr-repo-creation-template.template.json" \
  > "$SCRIPT_DIR/../ecr-repo-creation-template.json"

aws ecr create-repository-creation-template \
  --cli-input-json "file://$SCRIPT_DIR/../ecr-repo-creation-template.json"
fi