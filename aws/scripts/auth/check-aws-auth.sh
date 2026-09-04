#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../logger.sh"

log_action "Checking if logged in to AWS."
if ! aws sts get-caller-identity >/dev/null; then
  log_error "Not logged in to AWS — see error above. Log in (e.g. 'aws login' or 'aws configure') and re-run."
  exit 1
fi
log_success "Logged in to AWS."