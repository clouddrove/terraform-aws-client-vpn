output "key" {
  value       = join("", tls_private_key.server[*].private_key_pem)
  description = "A mapping of tags to assign to the key."
  sensitive   = true
}

output "cert" {
  value       = join("", tls_locally_signed_cert.root[*].cert_pem)
  description = "A mapping of tags to assign to the certificate."
  sensitive   = true
}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}

output "sg_id" {
  value       = join("", aws_security_group.this[*].id)
  description = "The ID of the SG for Client VPN."
}

output "vpn_id" {
  value       = join("", aws_ec2_client_vpn_endpoint.default[*].id)
  description = "The ID of the Client VPN endpoint."
}

output "vpn_arn" {
  value       = join("", aws_ec2_client_vpn_endpoint.default[*].arn)
  description = "The ARN of the Client VPN endpoint."
}

output "vpn_dns_name" {
  value       = join("", aws_ec2_client_vpn_endpoint.default[*].dns_name)
  description = "VPN DNS name"
}
