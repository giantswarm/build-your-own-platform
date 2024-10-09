
# How to create a platform (a.k.a. management cluster) in your local

- Install kind and kubectl
- Create a cluster with kind using the parameters in `cluster-config.yaml`
- Install clusterctl
- Set the feature gates in environment variables like `export CLUSTER_TOPOLOGY=true`
- Initialize the main controllers with `clusterctl init`
- Initialize the infrastructure providers with `clusterctl init --infrastructure docker`
