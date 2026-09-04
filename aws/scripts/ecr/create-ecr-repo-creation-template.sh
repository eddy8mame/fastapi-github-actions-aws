#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../logger.sh"
set -a
source "$SCRIPT_DIR/../../.env"
set +a

log_action "Checking if ECR repository creation template for prefix '${ECR_REPO_PREFIX}' exists."
if aws ecr describe-repository-creation-templates \
  --query "repositoryCreationTemplates[?prefix=='${ECR_REPO_PREFIX}']" \
  --output text | grep -q .; then
  log_success "Template exists."
else
  log_error "No matching template found. Creating template."

  envsubst < "$SCRIPT_DIR/../../ecr-repo-creation-template.template.json" \
    > "$SCRIPT_DIR/../../ecr-repo-creation-template.json"

  if aws ecr create-repository-creation-template \
    --cli-input-json "file://$SCRIPT_DIR/../../ecr-repo-creation-template.json" >/dev/null; then
    log_success "Created ECR repository creation template for prefix '${ECR_REPO_PREFIX}'."
  else
    log_error "Failed to create ECR repository creation template — see error above."
    exit 1
  fi
fi