#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../logger.sh"
set -a
source "$SCRIPT_DIR/../../.env"
set +a

read -p "Delete ECR repository '${ECR_REPO_NAME}' and ALL images in it? (y/n) " confirm
if [ "$confirm" != "y" ]; then
    log_action "Skipping ECR repository deletion."
    exit 0
fi

log_action "Deleting ECR repository '${ECR_REPO_NAME}'."
if aws ecr delete-repository --repository-name "$ECR_REPO_NAME" --force >/dev/null; then
    log_success "Deleted ECR repository '${ECR_REPO_NAME}'."
else
    log_error "Failed to delete ECR repository — see error above."
    exit 1
fi