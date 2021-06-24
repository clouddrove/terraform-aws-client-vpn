# terraform-aws-client-vpn

[![Lint Status](https://github.com/DNXLabs/terraform-aws-client-vpn/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-client-vpn/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-client-vpn)](https://github.com/DNXLabs/terraform-aws-client-vpn/blob/master/LICENSE)

This terraform module installs a client vpn.

The following resources will be created:
 - VPN Endpoint - Provides an AWS Client VPN endpoint for OpenVPN clients.
 - Provides network associations for AWS Client VPN endpoints
 - Generate AWS Certificate Manager(ACM) certificates

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |
| aws | >= 3.1.15 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.1.15 |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | Additional attributes (e.g. `1`). | `list(any)` | `[]` | no |
| cidr\_block | Client VPN CIDR | `string` | `""` | no |
| delimiter | Delimiter to be used between `organization`, `environment`, `name` and `attributes`. | `string` | `"-"` | no |
| enabled | Client VPN Name | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | `[]` | no |
| logs\_retention | Retention in days for CloudWatch Log Group | `number` | `365` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| name | Client VPN Name | `string` | `""` | no |
| network\_cidr | Client Network CIDR | `list` | `[]` | no |
| organization\_name | Name of organization to use in private certificate | `string` | `"clouddrove.com"` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-client-vpn"` | no |
| route\_cidr | Client Route CIDR | `list` | `[]` | no |
| route\_subnet\_ids | Client Route Subnet Ids | `list` | `[]` | no |
| subnet\_ids | Subnet ID to associate clients | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| cert | A mapping of tags to assign to the certificate. |
| key | A mapping of tags to assign to the key. |

<!--- END_TF_DOCS --->

## Author

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License
Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-client-vpn/blob/master/LICENSE) for full details.
