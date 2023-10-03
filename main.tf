##-----------------------------------------------------------------------------
## Labels module callled that will be used for naming and tags.
##-----------------------------------------------------------------------------
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "1.3.0"

  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}

resource "tls_private_key" "ca" {
  count     = var.enabled ? 1 : 0
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

##-----------------------------------------------------------------------------
## tls_self_signed_cert (Resource) Creates a self-signed TLS certificate in PEM (RFC 1421) format.
##-----------------------------------------------------------------------------
resource "tls_self_signed_cert" "ca" {
  count           = var.enabled ? 1 : 0
  private_key_pem = join("", tls_private_key.ca[*].private_key_pem)

  subject {

    common_name  = format("%s-ca", module.labels.id)
    organization = var.organization_name
  }

  dns_names = var.dns_names

  validity_period_hours = var.validity_period_hours
  is_ca_certificate     = var.is_ca_certificate

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}

##-----------------------------------------------------------------------------
## aws_acm_certificate. The ACM certificate resource allows requesting and management of certificates from the Amazon Certificate Manager..
##-----------------------------------------------------------------------------
resource "aws_acm_certificate" "ca" {
  count            = var.enabled ? 1 : 0
  private_key      = join("", tls_private_key.ca[*].private_key_pem)
  certificate_body = join("", tls_self_signed_cert.ca[*].cert_pem)

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_private_key" "root" {
  count     = var.enabled ? 1 : 0
  algorithm = var.algorithm
}

##-----------------------------------------------------------------------------
## Generates a Certificate Signing Request (CSR) in PEM format, which is the typical format used to request a certificate from a certificate authority.
##-----------------------------------------------------------------------------
resource "tls_cert_request" "root" {
  count           = var.enabled ? 1 : 0
  private_key_pem = join("", tls_private_key.server[*].private_key_pem)

  subject {
    common_name  = format("%s-client", module.labels.id)
    organization = var.organization_name
  }
  dns_names = var.dns_names
}

##-----------------------------------------------------------------------------
## Generates a Certificate Signing Request (CSR) in PEM format, which is the typical format used to request a certificate from a certificate authority.
##-----------------------------------------------------------------------------
resource "tls_locally_signed_cert" "root" {
  count                 = var.enabled ? 1 : 0
  cert_request_pem      = join("", tls_cert_request.root[*].cert_request_pem)
  ca_private_key_pem    = join("", tls_private_key.ca[*].private_key_pem)
  ca_cert_pem           = join("", tls_self_signed_cert.ca[*].cert_pem)
  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}

##-----------------------------------------------------------------------------
## aws_acm_certificate. The ACM certificate resource allows requesting and management of certificates from the Amazon Certificate Manager..
##-----------------------------------------------------------------------------
resource "aws_acm_certificate" "root" {
  count             = var.enabled && var.certificate_enabled ? 1 : 0
  private_key       = join("", tls_private_key.server[*].private_key_pem)
  certificate_body  = join("", tls_locally_signed_cert.root[*].cert_pem)
  certificate_chain = join("", tls_self_signed_cert.ca[*].cert_pem)

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_private_key" "server" {
  count     = var.enabled ? 1 : 0
  algorithm = var.algorithm
}

##-----------------------------------------------------------------------------
## Generates a Certificate Signing Request (CSR) in PEM format, which is the typical format used to request a certificate from a certificate authority.
##-----------------------------------------------------------------------------
resource "tls_cert_request" "server" {
  count           = var.enabled ? 1 : 0
  private_key_pem = join("", tls_private_key.server[*].private_key_pem)

  subject {
    common_name  = format("%s-server", module.labels.id)
    organization = var.organization_name
  }

  dns_names = var.dns_names
}

##-----------------------------------------------------------------------------
## Generates a Certificate Signing Request (CSR) in PEM format, which is the typical format used to request a certificate from a certificate authority.
##-----------------------------------------------------------------------------
resource "tls_locally_signed_cert" "server" {
  count = var.enabled ? 1 : 0

  cert_request_pem      = join("", tls_cert_request.server[*].cert_request_pem)
  ca_private_key_pem    = join("", tls_private_key.ca[*].private_key_pem)
  ca_cert_pem           = join("", tls_self_signed_cert.ca[*].cert_pem)
  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

##-----------------------------------------------------------------------------
## aws_acm_certificate. The ACM certificate resource allows requesting and management of certificates from the Amazon Certificate Manager..
##-----------------------------------------------------------------------------
resource "aws_acm_certificate" "server" {
  count             = var.enabled ? 1 : 0
  private_key       = join("", tls_private_key.server[*].private_key_pem)
  certificate_body  = join("", tls_locally_signed_cert.server[*].cert_pem)
  certificate_chain = join("", tls_self_signed_cert.ca[*].cert_pem)

  lifecycle {
    create_before_destroy = true
  }
}

##-----------------------------------------------------------------------------
## aws_ec2_client_vpn_endpoint. Provides an AWS Client VPN endpoint for OpenVPN clients.
##-----------------------------------------------------------------------------
resource "aws_ec2_client_vpn_endpoint" "default" {
  count                  = var.enabled ? 1 : 0
  description            = module.labels.id
  server_certificate_arn = join("", aws_acm_certificate.server[*].arn)
  client_cidr_block      = var.cidr_block
  split_tunnel           = var.split_tunnel_enable
  vpc_id                 = var.vpc_id
  session_timeout_hours  = var.session_timeout_hours
  security_group_ids     = concat([aws_security_group.this[0].id], var.security_group_ids)
  vpn_port               = var.vpn_port
  self_service_portal    = var.self_service_portal

  authentication_options {
    type                           = var.authentication_type
    saml_provider_arn              = var.saml_arn
    self_service_saml_provider_arn = var.self_saml_arn
    root_certificate_chain_arn     = join("", aws_acm_certificate.root[*].arn)
  }

  connection_log_options {
    enabled               = var.Connection_logging
    cloudwatch_log_group  = join("", aws_cloudwatch_log_group.vpn[*].name)
    cloudwatch_log_stream = join("", aws_cloudwatch_log_stream.vpn[*].name)
  }

  tags = module.labels.tags
  lifecycle {
    ignore_changes = [
      authentication_options
    ]
  }
}

##-----------------------------------------------------------------------------
## aws_security_group. Provides a security group resource.
##-----------------------------------------------------------------------------
#tfsec:ignore:aws-ec2-no-public-egress-sgr
#tfsec:ignore:aws-ec2-add-description-to-security-group
#tfsec:ignore:aws-ec2-add-description-to-security-group-rule
resource "aws_security_group" "this" {
  count       = var.enabled && var.enable_security_group ? 1 : 0
  name_prefix = var.name
  vpc_id      = var.vpc_id
  tags        = module.labels.tags

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      self        = lookup(ingress.value, "self", true)
      from_port   = lookup(ingress.value, "from_port", 0)
      to_port     = lookup(ingress.value, "to_port", 0)
      protocol    = lookup(ingress.value, "protocol", "-1")
      description = lookup(ingress.value, "description", "")
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      cidr_blocks = compact(split(",", lookup(egress.value, "cidr_blocks", "0.0.0.0/0")))
      from_port   = lookup(egress.value, "from_port", 0)
      to_port     = lookup(egress.value, "to_port", 0)
      protocol    = lookup(egress.value, "protocol", "-1")
    }
  }
}

##-----------------------------------------------------------------------------
## Provides network associations for AWS Client VPN endpoints.
##-----------------------------------------------------------------------------
resource "aws_ec2_client_vpn_network_association" "default" {
  count                  = var.enabled ? length(var.subnet_ids) : 0
  client_vpn_endpoint_id = join("", aws_ec2_client_vpn_endpoint.default[*].id)
  subnet_id              = element(var.subnet_ids, count.index)
}

##-----------------------------------------------------------------------------
## aws_cloudwatch_log_group Provides a CloudWatch Log Group resource.
##-----------------------------------------------------------------------------
#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "vpn" {
  count             = var.enabled ? 1 : 0
  name              = format("/aws/vpn/%s/logs", module.labels.id)
  retention_in_days = var.logs_retention
  tags              = module.labels.tags
}

##-----------------------------------------------------------------------------
## A log stream is a sequence of log events that share the same source. Each separate source of logs in CloudWatch Logs makes up a separate log stream.
##-----------------------------------------------------------------------------
resource "aws_cloudwatch_log_stream" "vpn" {
  count          = var.enabled ? 1 : 0
  name           = format("%s-usage", module.labels.id)
  log_group_name = join("", aws_cloudwatch_log_group.vpn[*].name)
}

##-----------------------------------------------------------------------------
## Provides authorization rules for AWS Client VPN endpoints.
##-----------------------------------------------------------------------------
resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth" {
  count                  = var.enabled ? length(var.network_cidr) : 0
  client_vpn_endpoint_id = join("", aws_ec2_client_vpn_endpoint.default[*].id)
  target_network_cidr    = element(var.network_cidr, count.index)
  authorize_all_groups   = var.authorize_all_groups
}

##-----------------------------------------------------------------------------
## Provides authorization rules for AWS Client VPN endpoints.
##-----------------------------------------------------------------------------
resource "aws_ec2_client_vpn_authorization_rule" "vpn_group_auth" {
  count                  = var.enabled ? length(var.group_ids) : 0
  client_vpn_endpoint_id = join("", aws_ec2_client_vpn_endpoint.default[*].id)
  target_network_cidr    = element(var.target_network_cidr, count.index)
  access_group_id        = element(var.group_ids, count.index)
}

##-----------------------------------------------------------------------------
## Provides additional routes for AWS Client VPN endpoints.
##-----------------------------------------------------------------------------
resource "aws_ec2_client_vpn_route" "vpn_route" {
  count                  = var.enabled ? length(var.route_cidr) : 0
  client_vpn_endpoint_id = join("", aws_ec2_client_vpn_endpoint.default[*].id)
  destination_cidr_block = element(var.route_cidr, count.index)
  target_vpc_subnet_id   = element(var.route_subnet_ids, count.index)
  depends_on             = [aws_ec2_client_vpn_network_association.default]
}
