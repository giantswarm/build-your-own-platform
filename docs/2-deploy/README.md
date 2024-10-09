


# How to deploy my app

This commands generate the repo and the main structure of the layout.

```bash
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=infra-fleet \
  --branch=main \
  --path=./apps/ \
  --personal
```