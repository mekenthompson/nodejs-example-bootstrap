# 🧰 Node.js Example – Buildkite Org Bootstrapper

[![Add to Buildkite](https://buildkite.com/button.svg)](https://buildkite.com/new?import_repo=https://github.com/mekenthompson/nodejs-example-bootstrap)

**This repo bootstraps a complete Buildkite org from scratch—by running a Buildkite pipeline.**

It’s a pipeline that deploys pipelines. In one go, it wires up:

- ✅ A `nodejs-example` pipeline that builds, tests, and packages a Node app
- 🧪 Test Analytics setup (with token provisioning)
- 📦 A Package Registry for Docker images
- 💻 A hosted agent cluster (Linux or macOS—your call)
- 🔐 Optional OIDC auth for pushing to the registry

The whole thing runs from an interactive Buildkite pipeline and uses Terraform under the hood.

---

## ✨ What You Get

| Resource                    | Purpose                                                   |
|-----------------------------|-----------------------------------------------------------|
| **Cluster + Hosted Queue**  | Zero-infra compute for every pipeline job                 |
| **`<org>/<registry>`**      | Stores Docker images with SBOM & SLSA provenance          |
| **`nodejs-example` pipeline** | First-class CI/CD with test splitting and image publish  |
| **Test Analytics Token**    | Enables flaky test detection and per-step timing insights |

---

## 🚀 Quick Start

1. **Fork** this repo to your GitHub org.
2. In Buildkite, click **“New pipeline → GitHub → nodejs-example-bootstrap”**
   - Set the **YAML steps path** to `.buildkite/bootstrap.yml`
3. Kick off the first build—this will run the **interactive bootstrap pipeline**.
   It’ll prompt you to fill in:
   - **Buildkite org slug** (default: `bootstrap-example`)
   - **Registry name** (default: `bootstrap-example`)
   - **Hosted agent shape** (`LINUX_AMD64_2X4` etc.)
   - **Org-level API token** (needs `write_pipelines`, `write_organizations`, etc.)
4. Click **“Unblock”** to run the Terraform `plan`, then confirm **“Apply”**
5. Once applied, it’ll trigger build #2: the brand-new `nodejs-example` pipeline.

⏱️ _Total setup time: ~5 minutes_

---

## 🔧 Prerequisites

- A Buildkite organisation (with owner access)
- Org-level **GraphQL + REST API token**  
  _(Scopes: `write_pipelines`, `read_pipelines`, `write_organizations`)_
- No DockerHub login required—the image stays inside Buildkite

---

## 🏗️ Repo Layout

```text
.
├── app/                     # Node.js app with Express + Jest tests
│   ├── Dockerfile
│   ├── package.json
│   └── …
├── .buildkite/
│   ├── bootstrap.yml        # Bootstrap pipeline for provisioning infra
│   └── pipeline.yml         # App pipeline (build → test → package)
└── terraform/
    ├── provider.tf
    ├── cluster.tf
    ├── registry.tf
    ├── analytics_token.tf
    └── pipeline.tf