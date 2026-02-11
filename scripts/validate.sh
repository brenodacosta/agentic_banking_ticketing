#!/bin/bash
set -euo pipefail

if ! docker ps --format '{{.Names}}' | grep -q '^agentic-banking-ticketing$'; then
  echo "container not running"
  exit 1
fi

curl -fsS http://127.0.0.1:8000/docs >/dev/null
