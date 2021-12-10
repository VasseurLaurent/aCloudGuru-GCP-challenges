## Description

On this challenge I have deployed :
  - One custom VCP with 2 subnets and 2 cloud NAT
  - One jumpstation reachable from internet on the port 22
  - Two instances templates : frontend and backend
  - Two instances groups (frontend and backend) , deployed on a dedicated subnets, public for frontend and private for backends
  - Firewall rules :
      - Allow ICMP within the VPC
      - Allow SSH from the jumpstation to the VPC
      - Allow HTTP/HTTPS from outside to frontend instances (just firewall rules, not reachable because it needs a loabalancer)
      - Allow HTTP/HTTPS from frontend to backend (only)

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.allow-ssh-from-jumpstation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow-ssh-from-jumpstation-ingress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow-ssh-to-jumpstation-from-outside](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allowfrontendtobackend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.frontend-ingress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.internet-access-from-machines](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.internet-ping-from-machines](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.internet-ping-from-machines-ingress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_instance.machine](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_instance_template.template-back](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template) | resource |
| [google_compute_instance_template.template-front](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template) | resource |
| [google_compute_network.vpc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_region_autoscaler.autoscaler-back](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_autoscaler) | resource |
| [google_compute_region_autoscaler.autoscaler-front](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_autoscaler) | resource |
| [google_compute_region_instance_group_manager.manager-back](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager) | resource |
| [google_compute_region_instance_group_manager.manager-front](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager) | resource |
| [google_compute_router.router-private](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router.router-public](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.nat-private](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_router_nat.nat-public](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_subnetwork.private](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.public](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_target_pool.target-back](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_pool) | resource |
| [google_compute_target_pool.target-front](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_pool) | resource |
| [google_service_account.sa-backend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.sa-front](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_client_openid_userinfo.me](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_openid_userinfo) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
