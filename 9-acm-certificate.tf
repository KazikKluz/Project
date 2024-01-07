resource "aws_acm_certificate" "acm_cert" {
  domain_name = "throughone.click"
  #domain_name       = "*.throughone.click"
  validation_method = "DNS"

  tags = {
    Environment = "dev"
  }
  // a  certificate will always exist
  lifecycle {
    create_before_destroy = true
  }
}

output "acm_certificate_id" {
  value = aws_acm_certificate.acm_cert.id
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.acm_cert.arn
}