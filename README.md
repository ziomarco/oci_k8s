# OCI Experiments 01: K8s cluster on ARM

This repo will contain my terraform experiments for creating a fully working K8s cluster using only OCI always free tier.

.tfvars file is treated like a secret, so `git-crypt` will be needed

# Requirements

Needed `ansible` and `terraform` installed on your computer.
- A registered zone on AWS Route53 (if you don't have it delete domain.tf)
- A valid AWS CLI profile (needed only for domains)
- A valid OCI account with [API Keys configured](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#Required_Keys_and_OCIDs)

# Usage
- Launch terraform script with `terraform apply`
- Launch ansible playbook after created your `hosts` file
- Launch rancher on master node with following command
```
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  rancher/rancher:latest \
  --acme-domain <REPLACE-HERE-YOUR-DOMAIN>
```
- Create new RKE cluster manually :)