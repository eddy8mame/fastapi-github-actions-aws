#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../logger.sh"
set -a
source "$SCRIPT_DIR/../../.env"
set +a

read -p "Delete ECR repository creation template for prefix '${ECR_REPO_PREFIX}'? (y/n) " confirm
if [ "$confirm" != "y" ]; then
    log_action "Skipping ECR repository creation template deletion."
    exit 0
fi

log_action "Deleting ECR repository creation template for prefix '${ECR_REPO_PREFIX}'."
if aws ecr delete-repository-creation-template --prefix "$ECR_REPO_PREFIX" >/dev/null; then
    log_success "Deleted ECR repository creation template."
else
    log_error "Failed to delete ECR repository creation template — see error above."
    exit 1
fi