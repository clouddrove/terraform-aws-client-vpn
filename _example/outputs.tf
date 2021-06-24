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
