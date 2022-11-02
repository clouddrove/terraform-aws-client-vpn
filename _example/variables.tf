
variable "security_group_ids" {
  type    = list(any)
  default = ["",""]

}

variable "saml_arn" {
  type        = string
  default     = ""
  description = "saml_arn that is being used"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "vpc id that is being used"
}

variable "group_ids" {
  type        = string
  default     = ""
  description = "group that is being used"
}