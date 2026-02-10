# Agentic Banking Ticketing (Phases 1–4)

Personal project to turn raw incident writeups into:

- A concise incident summary
- A draft Jira ticket (title + description)

Phase 1–3 focus on the API, containerization, and CI/CD. Phase 4 adds an internal-only EKS deployment scaffold (Terraform + Kubernetes manifests).

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

Phase 4 is intentionally “practice-cluster” infrastructure:

- Internal-only Kubernetes Services (`ClusterIP`)
- No Ingress, no public LoadBalancers
- Access intended via `kubectl port-forward`
- No secrets committed to git / Terraform state (LLM key is injected manually)

### Terraform (EKS)

Terraform lives in `infra/terraform` and provisions:

- A VPC (public + private subnets, single NAT)
- An EKS cluster
- A single managed node group

Defaults are set for the current blueprint:

- Region: `us-east-1`
- Node type: `t3.medium`
- Kubernetes version: `1.29`

Deploy:

```bash
cd infra/terraform
terraform init
terraform apply
```

Configure kubeconfig:

```bash
aws eks update-kubeconfig \
  --region $(terraform output -raw region) \
  --name $(terraform output -raw cluster_name)
```

Sandbox note (Whizlabs / training accounts):

- Many training sandboxes explicitly deny EKS and IAM actions (for example `eks:CreateCluster`, `eks:ListClusters`, IAM policy attachment/tagging).
- In those environments you can still use Terraform for `fmt/validate/plan`, but `apply` may be blocked by policy.
- If your sandbox denies EKS actions, use the local Kubernetes path below to keep iterating on manifests and the app.

### Kubernetes manifests

Kustomize manifests live in `infra/k8s` and deploy:

- Namespace `genai-platform`
- PostgreSQL (StatefulSet + PVC + Service)
- GenAI app (Deployment + Service)
- NetworkPolicy restricting Postgres ingress to the app pods (enforcement depends on your CNI/policy engine)

Apply:

```bash
kubectl apply -k infra/k8s
```

Inject the AI key (no secrets stored in manifests):

```bash
kubectl -n genai-platform set env deployment/genai-app AI_AGENTIC_API_KEY="$AI_AGENTIC_API_KEY"
```

Access (port-forward):

```bash
kubectl -n genai-platform port-forward deployment/genai-app 8000:8000
```

Then call:

```bash
curl -s http://localhost:8000/api/incident \
  -H 'Content-Type: application/json' \
  -d '{"description":"EKS test incident"}'
```

Notes:

- Postgres is configured with `POSTGRES_HOST_AUTH_METHOD=trust` in Phase 4 to avoid storing a DB password.
- NetworkPolicy is only enforced on EKS if you install a NetworkPolicy-capable CNI/policy engine (for example Calico).

### Local Kubernetes (kind/minikube) fallback

If your AWS sandbox blocks EKS, you can still test Phase 4 manifests locally.

Prereqs: `kubectl` and either `minikube` (recommended) or `kind`.

Using `minikube`:

```bash
minikube start
kubectl apply -k infra/k8s/overlays/minikube
kubectl -n genai-platform set env deployment/genai-app AI_AGENTIC_API_KEY="$AI_AGENTIC_API_KEY"
kubectl -n genai-platform port-forward deployment/genai-app 8000:8000
```

Using `kind` (note: PVC provisioning may require extra setup):

```bash
kind create cluster --name genai-platform
kubectl apply -k infra/k8s/overlays/kind
kubectl -n genai-platform set env deployment/genai-app AI_AGENTIC_API_KEY="$AI_AGENTIC_API_KEY"
kubectl -n genai-platform port-forward deployment/genai-app 8000:8000
```

Important: the default Deployment image is `ghcr.io/brenodacosta/agentic_banking_ticketing:latest` with `imagePullPolicy: Always` (it pulls from GHCR).

Local overlays already exist:

- `infra/k8s/overlays/minikube` pins the Postgres PVC to the typical minikube StorageClass (`standard`).
- `infra/k8s/overlays/kind` is a placeholder entrypoint (kind often needs an extra PV provisioner for PVCs).

If you hit `ImagePullBackOff`, it usually means the local environment can’t reach GHCR.

## Project layout

- `app/`: FastAPI app + LangGraph workflow
- `infra/k8s/`: Kustomize base for app + Postgres (internal-only)
- `infra/terraform/`: Terraform modules to provision VPC + EKS + node group
