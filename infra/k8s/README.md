# Phase 4 - Kubernetes manifests

These manifests deploy:

- Namespace `genai-platform`
- PostgreSQL (StatefulSet + PVC + Service)
- GenAI app (Deployment + Service)

## Apply

```bash
kubectl apply -f infra/k8s/base/namespace.yaml
kubectl apply -f infra/k8s/base/
```

## Inject AI key (no secrets stored)

```bash
kubectl -n genai-platform set env deployment/genai-app AI_AGENTIC_API_KEY="$AI_AGENTIC_API_KEY"
```

## Access

Port-forward:

```bash
kubectl -n genai-platform port-forward deployment/genai-app 8000:8000
```

Then call:

```bash
curl -s http://localhost:8000/api/incident \
  -H 'Content-Type: application/json' \
  -d '{"description":"EKS test incident"}'
```

## Notes

- `postgres-statefulset.yaml` uses `POSTGRES_HOST_AUTH_METHOD=trust` to avoid storing a DB password in Phase 4.
- For production, replace with a Secret/Secrets Manager + IRSA (Phase 5).

## Exposure & safety (Phase 4 / practice)

- Nothing is exposed publicly by these manifests: both `genai-app` and `postgres` Services are `ClusterIP`.
- Access is intended via `kubectl port-forward` only.
- `networkpolicy-postgres.yaml` restricts Postgres ingress to pods labeled `app=genai-app`.
  On EKS, NetworkPolicy is only enforced if you install a NetworkPolicy-capable CNI/policy engine (for example Calico).
