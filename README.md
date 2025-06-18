# Node.js Example ‑ **Buildkite Org Bootstrap**

[![Add to Buildkite](https://buildkite.com/button.svg)](https://buildkite.com/new?import_repo=https://github.com/your‑org/nodejs‑example‑bootstrap)

This repository **bootstraps a brand‑new Buildkite organisation** using an _interactive_ Buildkite pipeline.  
In one click it provisions:

* A Buildkite **cluster** with a **hosted‑agent queue** (Linux _or_ macOS shape of your choice)
* A private **Package Registry**
* A pipeline‑scoped **Test Engine** (Analytics) token
* This **Node.js demo pipeline** pre‑wired to:
  * build a Docker image
  * split & report Jest tests via Test Engine
  * push the image to the Package Registry via OIDC (no long‑lived secrets)

All the heavy lifting is done by **Terraform**, executed from inside Buildkite.

---

## ✨ What you get

| Resource                | Purpose                                             |
|-------------------------|-----------------------------------------------------|
| **Cluster + Hosted queue** | Zero‑infra compute for every pipeline job          |
| **`<org>/<registry>`**  | Stores Docker images + SBOM & provenance            |
| **`nodejs-example` pipeline** | Green build → test (parallel) → package on first run |
| **Analytics token**     | Enables flaky‑test detection & timing insights      |

---

## 🚀 Quick‑start

1. **Fork** this repo into your GitHub organisation.
2. In Buildkite, click **“New pipeline → GitHub → nodejs-example-bootstrap”**.  
   Make sure the pipeline **YAML steps** path is `.buildkite/bootstrap.yml`.
3. **First build starts** and shows an **Interactive Block**.  
   Fill out:
   * **Buildkite organisation slug** (e.g. `acme-corp`)
   * **Registry name** (default `acme-internal`)
   * **Hosted‑agent shape** (`LINUX_AMD64_2X4` etc.)
   * **Org‑level API token** with _write_ scope
4. Click **“Unblock”** → Terraform `plan` runs.  
   Review, then hit **“Apply”**.
5. Terraform provisions everything, then triggers build #2: your new `nodejs-example` pipeline.

_Total time: ≈ 5 minutes._

---

## 🔧 Prerequisites

* Buildkite organisation (owner access)
* Org‑level **GraphQL/REST API token** (`write_pipelines`, `read_pipelines`, `write_organizations`)
* DockerHub (or other) login on the agents is **NOT** required—images stay inside Buildkite

---

## 🗂 Repository layout

```
.
├── app/                   # Simple Express API + Jest tests
│   ├── Dockerfile
│   ├── package.json
│   └── …
├── .buildkite/
│   ├── bootstrap.yml      # Interactive Terraform deploy pipeline
│   └── pipeline.yml       # App build → test → package
└── terraform/
    ├── provider.tf
    ├── cluster.tf
    ├── registry.tf
    ├── analytics_token.tf
    └── pipeline.tf
```

---

## 🏃 How it works (high‑level)

1. **Bootstrap pipeline** runs on Buildkite’s default hosted queue.
2. **Block step** collects config; values become env vars.
3. **Terraform `plan` → `apply`** creates Buildkite resources via:
   * official Terraform provider for cluster/queue + pipeline
   * one‑off GraphQL calls for registries & analytics token
4. Buildkite **automatically triggers** the new `nodejs-example` pipeline.
5. **Test Engine** uploads timing & flaky data; **Package Registry** stores the image.

---

## 🧹 Cleaning up

To delete everything:

1. Re‑run the **bootstrap pipeline**; at the `plan` step choose `terraform destroy` instead, or  
2. Run `terraform destroy` locally with the same variables/API token.

---

## 📄 License

MIT — see `LICENSE`.

---

### Inspired by <https://github.com/buildkite/nodejs-example>
