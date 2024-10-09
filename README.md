# build-your-own-platform

Guide to build a PoC platform from scratch


# Bring up the platform

## Prerequisites

- Docker
- Kind

## First spin up the cluster

```bash
kind create cluster --name platform --config cluster-config.yaml
```

