# How to provision infrastructure using Crossplane

## Prerequisites

- [Crossplane](https://crossplane.io/docs/v1.4/getting-started/install-configure.html) installed

## Steps

- Install with helm the crossplane controllers and the AWs provider

```bash
helm install crossplane \
crossplane-stable/crossplane \
--namespace crossplane-system \
--create-namespace \
--set provider.packages='{xpkg.upbound.io/crossplane-contrib/provider-aws:v0.39.0}'
```

- Create a secret with the AWS credentials

```bash
kubectl create secret \
generic aws-secret \
-n crossplane-system \
--from-file=creds=./aws-credentials.txt
```

- Create a provider config

```bash
kubectl apply -f crossplane/provider-config.yaml
```
