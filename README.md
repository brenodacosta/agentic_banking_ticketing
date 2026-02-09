# Agentic Banking Ticketing (Phase 1-2)

Phase 1 implements a single LangGraph workflow:

- Input: raw incident text
- Output: `incident_summary`, `jira_title`, `jira_description`, `logs`

## Architecture (Phase 1)

Linear graph:

`summarize_incident` → `draft_jira_ticket` → END

- FastAPI exposes `POST /api/incident`
- LangChain provides a summarization chain
- LangGraph orchestrates multi-step stateful execution

## Quickstart

### 1) Create env

Export your Gemini key as an environment variable:

```bash
export AI_AGENTIC_API_KEY="..."
```

Required env vars:
- `AI_AGENTIC_API_KEY`
- `GENAI_MODEL` (also accepts `GEMINI_MODEL`)
- `LLM_TEMPERATURE`
- `APP_ENV` (`dev`/`staging`/`prod`)

If you maintain a local `.env` for non-secret config, you can export it like:

```bash
set -a
source .env
set +a
```

### 2) Install deps

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 3) Run API

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
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

### 4) Call endpoint

```bash
curl -s http://localhost:8000/api/incident \
  -H 'Content-Type: application/json' \
  -d '{"description":"Payments API latency spiked to 5s p95 after a deploy. Customers saw timeouts. Rolled back. Suspected DB connection pool exhaustion."}' | jq
```

## Project layout

- `app/main.py`: FastAPI entrypoint
- `app/api/routes.py`: HTTP routes
- `app/core/llm.py`: LLM factory
- `app/chains/incident_summarizer.py`: LangChain chain
- `app/workflows/state.py`: workflow state
- `app/workflows/incident_workflow.py`: LangGraph workflow
- `infra/`: placeholders for later phases
