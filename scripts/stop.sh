#!/bin/bash
set -euo pipefail

if docker ps --format '{{.Names}}' | grep -q '^agentic-banking-ticketing$'; then
  docker stop agentic-banking-ticketing
fi

if docker ps -a --format '{{.Names}}' | grep -q '^agentic-banking-ticketing$'; then
  docker rm agentic-banking-ticketing
fi
