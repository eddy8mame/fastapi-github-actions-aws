#!/usr/bin/env bash
set -euo pipefail

set --

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/logger.sh"
set -a
source "$SCRIPT_DIR/../.env"
set +a

"$SCRIPT_DIR/auth/check-aws-auth.sh"
source "$SCRIPT_DIR/bootstrap/create-bootstrap-role-permissions.sh"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  
"$SCRIPT_DIR/ecr/create-ecr-repo-creation-template.sh"
"$SCRIPT_DIR/oidc/create-oidc-role-permissions.sh"