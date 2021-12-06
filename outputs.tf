output "storage_name" {
  value       = var.name
  description = "Name of the storage class created"
  depends_on  = [
    null_resource.create_yaml
  ]
}
