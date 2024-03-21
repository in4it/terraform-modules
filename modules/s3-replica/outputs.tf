output "source_bucket_arn" {
  value = local.source_bucket_arn
}
output "source_bucket_name" {
  value = local.source_bucket_name
}
output "source_bucket_regional_domain_name" {
  value = local.source_bucket_regional_domain
}

output "destination_bucket_arn" {
  value = module.destination.bucket_arn
}
output "destination_bucket_name" {
  value = module.destination.bucket_name
}
output "destination_bucket_regional_domain_name" {
  value = module.destination.bucket_regional_domain_name
}
