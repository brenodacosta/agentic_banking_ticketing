# Phase 4 - Kubernetes manifests

These manifests deploy:

- Namespace `genai-platform`
- PostgreSQL (StatefulSet + PVC + Service)
- GenAI app (Deployment + Service)

## Apply

```bash
kubectl apply -k infra/k8s
```

## Local clusters (minikube / kind)

If you can't create EKS in a restricted AWS sandbox, you can still test these manifests locally.

### Minikube (recommended)

Minikube usually includes a default StorageClass (`standard`), so the Postgres PVC binds automatically.

```bash
minikube start
kubectl apply -k infra/k8s/overlays/minikube
```

### kind

kind does not include a default dynamic PV provisioner. If you apply the base manifests as-is,
the Postgres PVC may stay `Pending`.

Create a cluster:

```bash
kind create cluster --name genai-platform
kubectl apply -k infra/k8s/overlays/kind
```

If Postgres PVC is `Pending`, install a provisioner (one common choice is `local-path-provisioner`)
or switch to minikube.

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

## Quick debugging

Check pod status:

```bash
kubectl -n genai-platform get pods -o wide
```

If you see `ImagePullBackOff` (can happen if your environment can't reach GHCR):

```bash
kubectl -n genai-platform describe pod -l app=genai-app
```

If you see Postgres PVC stuck `Pending`:

```bash
kubectl -n genai-platform get pvc
kubectl get storageclass
```

## Notes

- `postgres-statefulset.yaml` uses `POSTGRES_HOST_AUTH_METHOD=trust` to avoid storing a DB password in Phase 4.
- For production, replace with a Secret/Secrets Manager + IRSA (Phase 5).

## Exposure & safety (Phase 4 / practice)

- Nothing is exposed publicly by these manifests: both `genai-app` and `postgres` Services are `ClusterIP`.
- Access is intended via `kubectl port-forward` only.
- `networkpolicy-postgres.yaml` restricts Postgres ingress to pods labeled `app=genai-app`.
  On EKS, NetworkPolicy is only enforced if you install a NetworkPolicy-capable CNI/policy engine (for example Calico).
