
# How to create a workload cluster

- Generate the workload cluster config

```bash
clusterctl generate cluster workload-cluster --flavor development \
  --kubernetes-version v1.31.0 \
  --control-plane-machine-count=3 \
  --worker-machine-count=3 \
  > workload-cluster.yaml
```

- Apply the workload cluster config

```bash
kubectl apply -f workload-cluster.yaml
```

- Install a CNI plugin

```bash
k apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml
```
