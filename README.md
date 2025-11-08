# Fluxinfra

[![Flux](https://img.shields.io/badge/Flux-5468FF?logo=flux&logoColor=white)](https://github.com/fluxcd/flux2)
[![GitHub License](https://img.shields.io/github/license/whisperpine/fluxinfra)](https://github.com/whisperpine/fluxinfra/blob/main/LICENSE)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/whisperpine/fluxinfra)](https://github.com/whisperpine/fluxinfra/commits/main/)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/whisperpine/fluxinfra/checks.yml?logo=github&label=checks)](https://github.com/whisperpine/fluxinfra/actions/workflows/checks.yml)
[![GitHub Release](https://img.shields.io/github/v/release/whisperpine/fluxinfra?logo=github)](https://github.com/whisperpine/fluxinfra/releases)

FluxCD GitRepository source used to manage infrastructure
shared across kubernetes clusters.

## Prerequisites

- Commonly used Kubernetes commands (e.g. `flux`, `helm`, `kubectl`) are installed.
- A Kubernetes cluster that has already [flux bootstrap](https://fluxcd.io/flux/installation/bootstrap/).
  (Check bootstrap status by running `flux check`).
