output "storage_name" {
  value       = var.sc_name
  description = "Name of the storage class created"
  depends_on  = [
    null_resource.create_yaml
  ]
}
