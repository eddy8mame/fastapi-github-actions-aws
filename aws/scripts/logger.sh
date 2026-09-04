#!/usr/bin/env bash

RESET='\033[0m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[1;31m'

log_action()  { echo -e "${BLUE}$1${RESET}"; }
log_success() { echo -e "${GREEN}$1${RESET}"; }
log_error()   { echo -e "${RED}$1${RESET}"; }