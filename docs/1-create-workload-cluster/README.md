
# How to create a workload cluster

- Generate the workload cluster config

```bash
clusterctl generate cluster dev --flavor development \
  --kubernetes-version v1.31.0 \
  --control-plane-machine-count=1 \
  --worker-machine-count=1 \
  > workload-cluster.yaml
```

- Apply the workload cluster config

```bash
kubectl apply -f workload-cluster.yaml
```

- Wait for the workload cluster to be ready

```bash
kubectl wait --for=condition=Ready cluster/dev --timeout=15m
```

- Get the kubeconfig for the workload cluster

```bash
clusterctl get kubeconfig dev > /tmp/dev.kubeconfig
```

- Install a CNI plugin

```bash
kubectl apply --kubeconfig=/tmp/dev.kubeconfig -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml
```
