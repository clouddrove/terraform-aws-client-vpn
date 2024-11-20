## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| active\_directory\_id | The ID of AWS AD to be used with directory-service-authentication authentication type. | `string` | `""` | no |
| algorithm | Name of the algorithm to use when generating the private key. Currently-supported values are: RSA, ECDSA, ED25519. | `string` | `"RSA"` | no |
| authentication\_type | The type of client authentication to be used. | `string` | `"certificate-authentication"` | no |
| authorize\_all\_groups | Indicates whether the authorization rule grants access to all clients. One of access\_group\_id or authorize\_all\_groups must be set. | `bool` | `true` | no |
| certificate\_enabled | n/a | `bool` | `true` | no |
| cidr\_block | Client VPN CIDR | `string` | `""` | no |
| connection\_logging | Connection logging is a feature of AWS client VPN that enables you to capture connection logs for your client VPN endpoint. Before you enable, you must have a CloudWatch Logs log group in your account. | `bool` | `true` | no |
| dns\_names | List of DNS names for which a certificate is being requested. | `list(any)` | <pre>[<br>  "clouddrove.com"<br>]</pre> | no |
| dns\_servers | (Optional) Information about the DNS servers to be used for DNS resolution. A Client VPN endpoint can have up to two DNS servers. If no DNS server is specified, the DNS address of the connecting device is used. | `list(string)` | `null` | no |
| enable\_security\_group | create for security group module this value is enable 'true' | `bool` | `true` | no |
| enabled | Client VPN Name | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| group\_ids | The ID of the group to which the authorization rule grants access. | `list(any)` | `[]` | no |
| is\_ca\_certificate | Is the generated certificate representing a Certificate Authority (CA). | `bool` | `true` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| logs\_retention | Retention in days for CloudWatch Log Group | `number` | `365` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| name | Client VPN Name | `string` | `""` | no |
| network\_cidr | Client Network CIDR | `list(any)` | `[]` | no |
| organization\_name | Name of organization to use in private certificate | `string` | `"clouddrove.com"` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-client-vpn"` | no |
| route\_cidr | Client Route CIDR | `list(any)` | `[]` | no |
| route\_subnet\_ids | Client Route Subnet Ids | `list(any)` | `[]` | no |
| rsa\_bits | When algorithm is RSA, the size of the generated RSA key, in bits (default: 2048). | `number` | `2048` | no |
| saml\_arn | The ARN of the IAM SAML identity provider. | `string` | `""` | no |
| security\_group\_egress | List of maps of egress rules to set on the default security group | `list(map(string))` | <pre>[<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| security\_group\_ids | The IDs of one or more security groups to apply to the target network. You must also specify the ID of the VPC that contains the security groups. | `list(any)` | `[]` | no |
| security\_group\_ingress | List of maps of ingress rules to set on the default security group | `list(map(string))` | <pre>[<br>  {<br>    "from_port": 0,<br>    "protocol": -1,<br>    "self": true,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| self\_saml\_arn | The ARN of the IAM SAML identity provider for the self service portal. | `string` | `""` | no |
| self\_service\_portal | Optionally specify whether the VPC Client self-service portal is enabled or disabled. Default is disabled | `string` | `"disabled"` | no |
| session\_timeout\_hours | The maximum session duration is a trigger by which end-users are required to re-authenticate prior to establishing a VPN session. Default value is 24 - Valid values: 8 \| 10 \| 12 \| 24 | `number` | `24` | no |
| split\_tunnel\_enable | Indicates whether split-tunnel is enabled on VPN endpoint. | `bool` | `false` | no |
| subnet\_ids | Subnet ID to associate clients | `list(string)` | `[]` | no |
| target\_network\_cidr | List of CIDR ranges from which access is allowed | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| validity\_period\_hours | Number of hours, after initial issuing, that the certificate will remain valid for. | `number` | `87600` | no |
| vpc\_id | The ID of the VPC to associate with the Client VPN endpoint. If no security group IDs are specified in the request, the default security group for the VPC is applied. | `string` | `""` | no |
| vpn\_port | The port number for the Client VPN endpoint. Valid values are 443 and 1194. Default value is 443. | `number` | `443` | no |

## Outputs

| Name | Description |
|------|-------------|
| cert | A mapping of tags to assign to the certificate. |
| key | A mapping of tags to assign to the key. |
| sg\_id | The ID of the SG for Client VPN. |
| tags | A mapping of tags to assign to the resource. |
| vpn\_arn | The ARN of the Client VPN endpoint. |
| vpn\_dns\_name | VPN DNS name |
| vpn\_id | The ID of the Client VPN endpoint. |

