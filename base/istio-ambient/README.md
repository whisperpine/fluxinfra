# Istio in Ambient Mode

| Chart | HelmRelease | Namespace | Depends-on |
| - | - | - | - |
| base | istio-base | istio-system | |
| cni | istio-cni | kube-system | istio-base |
| istiod | istiod | istio-system | istio-base, istio-cni |
| ztunnel | istio-ztunnel | istio-system | istiod |
