output "externaldns_helm_metadata" {
  description = "Metadata Block outlining ststus of the deployed release"
  value       = helm_release.external_dns.metadata
}