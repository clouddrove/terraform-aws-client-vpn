output "key" {
  value       = module.vpn.key
  description = "A mapping of tags to assign to the key."
  sensitive   = true
}

output "cert" {
  value       = module.vpn.cert
  description = "A mapping of tags to assign to the certificate."
  sensitive   = true
}

output "tags" {
  value       = module.vpc.tags
  description = "A mapping of tags to assign to the resource."
}

output "sg_id" {
  value       = module.vpn.sg_id
  description = "The ID of the SG for Client VPN."
}

output "vpn_id" {
  value       = module.vpn.vpn_id
  description = "The ID of the Client VPN endpoint."
}

output "vpn_arn" {
  value       = module.vpn.vpn_arn
  description = "The ARN of the Client VPN endpoint."
}

output "vpn_dns_name" {
  value       = module.vpn.vpn_dns_name
  description = "VPN DNS name"
}
