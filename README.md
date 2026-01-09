# microservices-gitops

This repository represents the **GitOps layer (Repo 2)** of a didactic, corporate-inspired microservices platform built with **Kubernetes, Helm, and Argo CD**.

It does **not** contain application code.  
Instead, it defines the **desired state** of the platform: how services are deployed, configured, and promoted across environments.

---

## Repository Responsibility

This repository is responsible for:

- Helm charts (base library + service wrappers)
- Environment-specific configuration (values)
- GitOps workflow integration with Argo CD
- Acting as the **single source of truth** for deployments

---

## Relationship with Repo 1 (microservices-ci)

| Repo | Responsibility |
|----|---------------|
| **Repo 1 – microservices-ci** | Application code, CI pipelines, Docker image build & push to ECR |
| **Repo 2 – microservices-gitops** | Deployment configuration, environments, and GitOps state |

### Deployment Flow (Option A – chosen)

1. A commit is pushed to Repo 1
2. GitHub Actions:
   - Builds the Docker image
   - Tags it with a short SHA (`sha-xxxxxxxx`)
   - Pushes it to AWS ECR
3. The CI pipeline opens a **Pull Request to this repository**, updating:
   - `environments/homolog/values/<service>.values.yaml → image.tag`
4. The PR is reviewed and merged
5. Argo CD detects the change and **synchronizes the cluster automatically**

✅ CI does **not** deploy to Kubernetes  
✅ Argo CD is the only component applying changes to the cluster

---

## Repository Structure

```txt
charts/
  ├─ platform-lib/          # Helm library chart (shared templates)
  └─ services/              # Wrapper charts (auth-service, product-service)

environments/
  └─ homolog/               # Environment-specific values

clusters/
  ├─ management/            # Argo CD cluster (documentation / future manifests)
  └─ application/           # Workload cluster (documentation / future manifests)
