
# How to create a platform (a.k.a. management cluster) in your local

## Prerequisites

- Install kind and kubectl
- Install clusterctl

## Create kind management cluster

- Create a cluster with kind using the parameters in `cluster-config.yaml`
- Set the feature gates in environment variables like `export CLUSTER_TOPOLOGY=true`
- Initialize the main controllers with `clusterctl init`
- Initialize the infrastructure providers with `clusterctl init --infrastructure docker`

## Setup access management

After creating a Teleport cluster, you can install the Teleport agent in the management cluster to access the Teleport cluster. In the UI you can obtain the Teleport configuration file.

```sh
export TELEPORT_AUTH_TOKEN=<auth-token>
envsubst < teleport-config.yaml > /tmp/teleport-config.yaml
helm install teleport-agent teleport/teleport-kube-agent -f /tmp/teleport-config.yaml --version 16.4.3 \
--create-namespace --namespace teleport
```
