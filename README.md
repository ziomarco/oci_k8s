# OCI Experiments 01: K8s cluster on ARM

This repo will contain my terraform experiments for creating a fully working K8s cluster using only OCI always free tier.

.tfvars file is treated like a secret, so `git-crypt` will be needed

# Notes

Please run tf apply with lb.tf commented out, then relaunch it a second time. (for_each dependencies...)