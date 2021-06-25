module "labels" {
  source  = "clouddrove/labels/aws"
  version = "0.15.0"

  enabled     = var.enabled
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}

resource "tls_private_key" "ca" {
  count     = var.enabled ? 1 : 0
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
  count           = var.enabled ? 1 : 0
  key_algorithm   = "RSA"
  private_key_pem = join("", tls_private_key.ca.*.private_key_pem)

  subject {
    common_name  = format("%s-ca", module.labels.id)
    organization = var.organization_name
  }

  dns_names = ["clouddrove.com"]

  validity_period_hours = 87600
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}

resource "aws_acm_certificate" "ca" {
  count            = var.enabled ? 1 : 0
  private_key      = join("", tls_private_key.ca.*.private_key_pem)
  certificate_body = join("", tls_self_signed_cert.ca.*.cert_pem)
}

resource "tls_private_key" "root" {
  count     = var.enabled ? 1 : 0
  algorithm = "RSA"
}

resource "tls_cert_request" "root" {
  count           = var.enabled ? 1 : 0
  key_algorithm   = "RSA"
  private_key_pem = join("", tls_private_key.root.*.private_key_pem)

  subject {
    common_name  = format("%s-client", module.labels.id)
    organization = var.organization_name
  }

  dns_names = ["clouddrove.com"]
}

resource "tls_locally_signed_cert" "root" {
  count              = var.enabled ? 1 : 0
  cert_request_pem   = join("", tls_cert_request.root.*.cert_request_pem)
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = join("", tls_private_key.ca.*.private_key_pem)
  ca_cert_pem        = join("", tls_self_signed_cert.ca.*.cert_pem)

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}

resource "aws_acm_certificate" "root" {
  count             = var.enabled ? 1 : 0
  private_key       = join("", tls_private_key.root.*.private_key_pem)
  certificate_body  = join("", tls_locally_signed_cert.root.*.cert_pem)
  certificate_chain = join("", tls_self_signed_cert.ca.*.cert_pem)
}

resource "tls_private_key" "server" {
  count     = var.enabled ? 1 : 0
  algorithm = "RSA"
}

resource "tls_cert_request" "server" {
  count           = var.enabled ? 1 : 0
  key_algorithm   = "RSA"
  private_key_pem = join("", tls_private_key.server.*.private_key_pem)

  subject {
    common_name  = format("%s-server", module.labels.id)
    organization = var.organization_name
  }

  dns_names = ["clouddrove.com"]
}

resource "tls_locally_signed_cert" "server" {
  count              = var.enabled ? 1 : 0
  cert_request_pem   = join("", tls_cert_request.server.*.cert_request_pem)
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = join("", tls_private_key.ca.*.private_key_pem)
  ca_cert_pem        = join("", tls_self_signed_cert.ca.*.cert_pem)

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "server" {
  count             = var.enabled ? 1 : 0
  private_key       = join("", tls_private_key.server.*.private_key_pem)
  certificate_body  = join("", tls_locally_signed_cert.server.*.cert_pem)
  certificate_chain = join("", tls_self_signed_cert.ca.*.cert_pem)
}

resource "aws_ec2_client_vpn_endpoint" "default" {
  count                  = var.enabled ? 1 : 0
  description            = module.labels.id
  server_certificate_arn = join("", aws_acm_certificate.server.*.arn)
  client_cidr_block      = var.cidr_block

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = join("", aws_acm_certificate.root.*.arn)
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = join("", aws_cloudwatch_log_group.vpn.*.name)
    cloudwatch_log_stream = join("", aws_cloudwatch_log_stream.vpn.*.name)
  }

  tags = module.labels.tags
}

resource "aws_ec2_client_vpn_network_association" "default" {
  count                  = length(var.subnet_ids)
  client_vpn_endpoint_id = join("", aws_ec2_client_vpn_endpoint.default.*.id)
  subnet_id              = element(var.subnet_ids, count.index)
}
resource "aws_cloudwatch_log_group" "vpn" {
  count             = var.enabled ? 1 : 0
  name              = format("/aws/vpn/%s/logs", module.labels.id)
  retention_in_days = var.logs_retention

  tags = module.labels.tags
}

resource "aws_cloudwatch_log_stream" "vpn" {
  count          = var.enabled ? 1 : 0
  name           = format("%s-usage", module.labels.id)
  log_group_name = join("", aws_cloudwatch_log_group.vpn.*.name)
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth" {
  count                  = length(var.network_cidr)
  client_vpn_endpoint_id = join("", aws_ec2_client_vpn_endpoint.default.*.id)
  target_network_cidr    = element(var.network_cidr, count.index)
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "vpn_route" {
  count                  = length(var.route_cidr)
  client_vpn_endpoint_id = join("", aws_ec2_client_vpn_endpoint.default.*.id)
  destination_cidr_block = element(var.route_cidr, count.index)
  target_vpc_subnet_id   = element(var.route_subnet_ids, count.index)
}