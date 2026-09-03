#!/usr/bin/env bash
set -euo pipefail

set --

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -a
source "$SCRIPT_DIR/../.env"
set +a

"$SCRIPT_DIR/check-aws-auth.sh"
source "$SCRIPT_DIR/create-bootstrap-role-permissions.sh"
"$SCRIPT_DIR/create-oidc-role-permissions.sh"