# homolog Environment

This directory contains the **Helm values for the homolog (integration) environment**.

It represents the first GitOps-controlled environment of the platform.

---

## Purpose

The `homolog` environment is used to:

- Validate deployments end-to-end
- Test CI → GitOps → Argo CD integration
- Simulate real corporate promotion flows before production

---

## Structure

```txt
homolog/
└─ values/
   ├─ auth-service.values.yaml
   └─ product-service.values.yaml