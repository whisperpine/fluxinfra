<!-- markdownlint-disable MD033 -->
<h1 align="center">Fluxinfra</h1>

<div align="center">

[![Flux](https://img.shields.io/badge/Flux-5468FF?logo=flux&logoColor=white)](https://github.com/fluxcd/flux2)
[![GitHub License](https://img.shields.io/github/license/whisperpine/fluxinfra)](https://github.com/whisperpine/fluxinfra/blob/main/LICENSE)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/whisperpine/fluxinfra)](https://github.com/whisperpine/fluxinfra/commits/main/)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/whisperpine/fluxinfra/checks.yml?logo=github&label=checks)](https://github.com/whisperpine/fluxinfra/actions/workflows/checks.yml)
[![GitHub Release](https://img.shields.io/github/v/release/whisperpine/fluxinfra?logo=github)](https://github.com/whisperpine/fluxinfra/releases)

FluxCD GitRepository source used to manage infrastructure
shared across kubernetes clusters.

</div>

## Background

GitOps workflows rely on declarative infrastructure and continuous
reconciliation. [Flux](https://fluxcd.io/) is a popular CNCF project that
enables this model by syncing Kubernetes clusters with version-controlled
configuration.

The goal of this project is to create a reproducible and declarative *infra-level*
deployment (e.g. observablity, service mesh) shared across multiple clusters,
leveraging Git as the single source of truth.
(Application-level services can also be deployed by this approach, but it would
be better to use dedicated repositories.)

This repository is also my personal playground for exploring best practices in
GitOps and cloud-native infrastructure management. It demonstrates how to manage
a full Kubernetes stack end-to-end using Flux. While it's tailored for my use
cases, it may help you get started.

## Kustomizations

Kustomizations in this repository can generally be used in combination, but some
of the kustomizations conflict with certain ones. Refer to the table below to
get an exhaustive list of kustomizations as well as avoid conflicts.

| Kustomization | Depends on | Conflicts with |
| - | - | - |
| [gateway-api](./overlays/gateway-api/) | | |
| [istio-ambient](./overlays/istio-ambient/) | (gateway-api) | istio-sidecar |
| [istio-sidecar](./overlays/istio-sidecar/) | (gateway-api) | istio-ambient |
| [grafana-prometheus](./overlays/grafana-prometheus/) | otel-lgtm | |
| [otel-lgtm](./overlays/otel-lgtm/) | | grafana-prometheus |

Items surrounded by parentheses are "soft dependencies", meaning they're a
perfect match but not necessary.

## Prerequisites

- Commonly used Kubernetes commands (e.g. `flux`, `helm`, `kubectl`) are installed.
- A Kubernetes cluster that has already [flux bootstrap](https://fluxcd.io/flux/installation/bootstrap/).
  (Check bootstrap status by running `flux check`).

## Getting Started

### Flux Bootstrap

Make sure your current working directory is what created by `flux bootstrap`.
The file structure looks like:

```txt
my-dev-k8s
└── flux-system
    ├── gotk-components.yaml
    ├── gotk-sync.yaml
    └── kustomization.yaml
```

### Add the GitRepository

Run the following conmmands to create flux configurations for this repo:

```sh
mkdir -p fluxinfra

flux create source git fluxinfra \
  --url=https://github.com/whisperpine/fluxinfra \
  --branch=main \
  --export >fluxinfra/git-repo-fluxinfra.yaml
```

Now the file structure should be something like:

```txt
my-dev-k8s
├── flux-system
│   ├── gotk-components.yaml
│   ├── gotk-sync.yaml
│   └── kustomization.yaml
└── fluxinfra
    └── git-repo-fluxinfra.yaml
```

Commit changes, push to remote repository, and wait for the reconciliation of flux.

```sh
# Run this command and the "READY" column should be "True".
flux get source git fluxinfra
```

### Add Kustomizations

When you've already added the fluxinfra GitRepository resource to your
kubernetes cluster by the steps mentioned above, you can then add any one or
multiple the kustomizations under [./overlays](./overlays/) directory as needed.

Run the following command to create a flux kustomization (here we use
[gateway-api](./overlays/gateway-api/kustomization.yaml) as an example):

```sh
flux create kustomization gateway-api \
  --source=GitRepository/fluxinfra \
  --path="./overlays/gateway-api" \
  --interval=1m \
  --prune=true \
  --wait=true \
  --export >fluxinfra/kks-gateway-api.yaml
```

Commit changes, push to remote repository, and wait for the reconciliation of flux.

```sh
# Run this command and the "READY" column should be "True".
flux get ks gateway-api
```

## Renovate

Dependencies, including chart versions in HelmRelease resources, are
automatically updated by [Renovate](https://github.com/renovatebot/renovate).

Chart versions are precisely configured (e.g. `"1.28.0"`, not `"1.*"`) for safety
and reproducibility, while they are kept up-to-date without hassle by Pull
Requests created by Renovate.

Refer to [Automated Dependency Updates for Flux - Renovate Docs](https://docs.renovatebot.com/modules/manager/flux/).
