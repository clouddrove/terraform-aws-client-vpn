variable "name" {
  type        = string
  default     = ""
  description = "Client VPN Name"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Client VPN Name"
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-client-vpn"
  description = "Terraform current module repo"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`,`application`."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

variable "cidr_block" {
  type        = string
  default     = ""
  description = "Client VPN CIDR"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnet ID to associate clients"
}

variable "organization_name" {
  type        = string
  default     = "clouddrove.com"
  description = "Name of organization to use in private certificate"
}

variable "logs_retention" {
  type        = number
  default     = 365
  description = "Retention in days for CloudWatch Log Group"
}

variable "route_cidr" {
  type        = list(any)
  default     = []
  description = "Client Route CIDR"
}

variable "route_subnet_ids" {
  type        = list(any)
  default     = []
  description = "Client Route Subnet Ids"
}

variable "network_cidr" {
  type        = list(any)
  default     = []
  description = "Client Network CIDR"
}

variable "split_tunnel_enable" {
  type        = bool
  default     = false
  description = "Indicates whether split-tunnel is enabled on VPN endpoint."
}

variable "dns_names" {
  type        = list(any)
  default     = ["clouddrove.com"]
  description = "List of DNS names for which a certificate is being requested."
}

variable "authentication_type" {
  type        = string
  default     = "certificate-authentication"
  description = "The type of client authentication to be used. "
}

variable "saml_arn" {
  type        = string
  default     = ""
  description = "The ARN of the IAM SAML identity provider. "
}

variable "self_saml_arn" {
  type        = string
  default     = ""
  description = "The ARN of the IAM SAML identity provider for the self service portal. "
}

variable "security_group_ids" {
  type        = list(any)
  default     = []
  description = "The IDs of one or more security groups to apply to the target network. You must also specify the ID of the VPC that contains the security groups."
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The ID of the VPC to associate with the Client VPN endpoint. If no security group IDs are specified in the request, the default security group for the VPC is applied."
}

variable "group_ids" {
  type        = list(any)
  default     = []
  description = "The ID of the group to which the authorization rule grants access."
}

variable "session_timeout_hours" {
  type        = number
  default     = 24
  description = "The maximum session duration is a trigger by which end-users are required to re-authenticate prior to establishing a VPN session. Default value is 24 - Valid values: 8 | 10 | 12 | 24"
}

variable "certificate_enabled" {
  type    = bool
  default = true
}

variable "Connection_logging" {
  type        = bool
  default     = true
  description = "Connection logging is a feature of AWS client VPN that enables you to capture connection logs for your client VPN endpoint. Before you enable, you must have a CloudWatch Logs log group in your account."
}

variable "vpn_port" {
  type        = number
  default     = 443
  description = "The port number for the Client VPN endpoint. Valid values are 443 and 1194. Default value is 443."
}

variable "self_service_portal" {
  type        = string
  default     = "disabled"
  description = "Optionally specify whether the VPC Client self-service portal is enabled or disabled. Default is disabled"
}

variable "rsa_bits" {
  type        = number
  default     = 2048
  description = "When algorithm is RSA, the size of the generated RSA key, in bits (default: 2048)."
}

variable "algorithm" {
  type        = string
  default     = "RSA"
  description = "Name of the algorithm to use when generating the private key. Currently-supported values are: RSA, ECDSA, ED25519."
}

variable "validity_period_hours" {
  type        = number
  default     = 87600
  description = "Number of hours, after initial issuing, that the certificate will remain valid for."
}

variable "is_ca_certificate" {
  type        = bool
  default     = true
  description = "Is the generated certificate representing a Certificate Authority (CA)."
}

variable "authorize_all_groups" {
  type        = bool
  default     = true
  description = "Indicates whether the authorization rule grants access to all clients. One of access_group_id or authorize_all_groups must be set."
}

variable "target_network_cidr" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of CIDR ranges from which access is allowed"
}

variable "security_group_ingress" {
  type = list(map(string))
  default = [
    {
      from_port = 0
      protocol  = -1
      self      = true
      to_port   = 0
    }
  ]
  description = "List of maps of ingress rules to set on the default security group"
}

variable "security_group_egress" {
  type = list(map(string))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  description = "List of maps of egress rules to set on the default security group"
}

variable "enable_security_group" {
  type        = bool
  default     = true
  description = "create for security group module this value is enable 'true'"
}
