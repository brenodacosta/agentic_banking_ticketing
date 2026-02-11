#!/bin/bash
set -euo pipefail

APP_DIR="/opt/agentic_banking_ticketing"
ENV_FILE="/opt/agentic_banking_ticketing/runtime.env"

cd "$APP_DIR"

AWS_REGION="$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | sed -n 's/.*"region"[ ]*:[ ]*"\([^\"]*\)".*/\1/p')"

if [[ -f /etc/agentic-banking-ticketing/secrets.env ]]; then
  # shellcheck disable=SC1091
  source /etc/agentic-banking-ticketing/secrets.env
fi

DB_PASSWORD_SECRET_ARN="${DB_PASSWORD_SECRET_ARN:-}"
AI_KEY_SECRET_ARN="${AI_KEY_SECRET_ARN:-}"

DB_PASSWORD=""
AI_KEY=""

if [[ -n "$DB_PASSWORD_SECRET_ARN" ]]; then
  DB_PASSWORD="$(aws secretsmanager get-secret-value --region "$AWS_REGION" --secret-id "$DB_PASSWORD_SECRET_ARN" --query SecretString --output text)"
fi

if [[ -n "$AI_KEY_SECRET_ARN" ]]; then
  AI_KEY="$(aws secretsmanager get-secret-value --region "$AWS_REGION" --secret-id "$AI_KEY_SECRET_ARN" --query SecretString --output text)"
fi

cat > "$ENV_FILE" <<EOF
# App runtime env
# NOTE: set DB_HOST/DB_NAME/DB_USER appropriately for your app.
# DB_PASSWORD is fetched from Secrets Manager when DB_PASSWORD_SECRET_ARN is set.
DB_PASSWORD=${DB_PASSWORD}

# Gemini key fetched from Secrets Manager when AI_KEY_SECRET_ARN is set.
# Exporting both names to bridge any app-side naming mismatch.
AI_AGENTIC_API_KEY=${AI_KEY}
AI_AGENTIC_AI_API_KEY=${AI_KEY}
EOF

# Build and run the container (placeholder implementation).
docker build -t agentic-banking-ticketing:latest .

docker run -d --name agentic-banking-ticketing \
  --restart unless-stopped \
  --env-file "$ENV_FILE" \
  -p 8000:8000 \
  agentic-banking-ticketing:latest
