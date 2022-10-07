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
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "attributes" {
  type        = list(any)
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `organization`, `environment`, `name` and `attributes`."
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
