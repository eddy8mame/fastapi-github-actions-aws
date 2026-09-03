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
  echo "No matching template found. Creating..."
  "$SCRIPT_DIR/create-ecr-repo-creation-template.sh"
fi