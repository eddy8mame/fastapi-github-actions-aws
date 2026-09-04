#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../logger.sh"

"$SCRIPT_DIR/../auth/check-aws-auth.sh"
"$SCRIPT_DIR/teardown-oidc-role.sh"
"$SCRIPT_DIR/teardown-ecr-repo.sh"
"$SCRIPT_DIR/teardown-ecr-repo-template.sh"
"$SCRIPT_DIR/teardown-bootstrap-role.sh"