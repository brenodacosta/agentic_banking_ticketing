# Agentic Banking Ticketing (Phases 1–4)

Personal project to turn raw incident writeups into:

- A concise incident summary
- A draft Jira ticket (title + description)

Phase 1–3 focus on the API, containerization, and CI/CD. Phase 4 provisions production-style AWS infrastructure using Terraform (EC2 Auto Scaling + ALB + RDS MySQL + S3 + Secrets Manager + CodeDeploy/CodePipeline).

## Architecture (Phase 1)

Workflow graph:

`summarize_incident` → `draft_jira_ticket` → END

Runtime:

- FastAPI exposes `POST /api/incident`
- LangGraph orchestrates the multi-step workflow
- LangChain provides the LLM chain(s)

## Configuration

The only required secret is your Gemini key:

```bash
export AI_AGENTIC_API_KEY="..."
```

Phase 4 infrastructure also creates a Secrets Manager secret named `${name}/app/AI_AGENTIC_AI_API_KEY`. The CodeDeploy runtime scripts export both `AI_AGENTIC_API_KEY` and `AI_AGENTIC_AI_API_KEY` to bridge any naming mismatch.

Other env vars:

- `GENAI_MODEL` (also accepts `GEMINI_MODEL`)
- `LLM_TEMPERATURE`
- `APP_ENV` (`dev`/`staging`/`prod`)

If you maintain a local `.env` for non-secret config, you can export it like:

```bash
set -a
source .env
set +a
```

## Quickstart (local)

### 1) Install deps

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 2) Run API

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 3) Call endpoint

```bash
curl -s http://localhost:8000/api/incident \
  -H 'Content-Type: application/json' \
  -d '{"description":"Payments API latency spiked to 5s p95 after a deploy. Customers saw timeouts. Rolled back. Suspected DB connection pool exhaustion."}' | jq
```

## Docker (Phase 2)

### Build

```bash
docker build -t genai-platform:dev .
```

### Run

```bash
docker run --rm -p 8000:8000 \
  --env-file .env \
  -e AI_AGENTIC_API_KEY="$AI_AGENTIC_API_KEY" \
  genai-platform:dev
```

Keep secrets out of `.env` (inject them at runtime via `-e` or your orchestrator).

## CI/CD (Phase 3)

- PRs run: `ruff`, `mypy`, `pytest`, and Alembic script sanity checks.
- Pushes to `main` (and version tags like `v0.3.1`) build and publish the Docker image to GHCR.
- Optional LLM guardrail tests run on same-repo PRs if you set the repository secret `AI_AGENTIC_API_KEY`.

For a more production-like entrypoint later:

`uvicorn app.main:app --proxy-headers --forwarded-allow-ips="*"`

## Infrastructure (Phase 4: Terraform + Kubernetes)

Phase 4 originally targeted EKS/Kubernetes, but Whizlabs-style sandboxes often explicitly deny EKS/IAM actions. The infrastructure has been refactored to an EC2-based deployment model:

- VPC (public + private subnets)
- Application Load Balancer (HTTP :80 → targets :8000)
- EC2 Auto Scaling Group (instances run the app via Docker)
- RDS MySQL (private subnets) for persistence
- S3 artifacts bucket (CodePipeline artifact store + S3 source)
- Secrets Manager for the DB password and Gemini key
- CodeDeploy + CodePipeline for automated deployments

Terraform lives in `infra/terraform`. For the exact apply + deployment steps, see `infra/terraform/README.md`.

## Project layout

- `app/`: FastAPI app + LangGraph workflow
- `infra/terraform/`: Terraform modules to provision VPC + ALB + ASG + RDS + CodeDeploy + CodePipeline
- `appspec.yml`, `scripts/`: CodeDeploy application spec and lifecycle hook scripts (used in the deployment bundle)
