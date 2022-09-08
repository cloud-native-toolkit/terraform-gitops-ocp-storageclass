
resource local_file write_outputs {
  filename = "gitops-output.json"

  content = jsonencode({
    name        = module.gitops_storeclass.name
    branch      = module.gitops_storeclass.branch
    namespace   = module.gitops_storeclass.namespace
    server_name = module.gitops_storeclass.server_name
    layer       = module.gitops_storeclass.layer
    layer_dir   = module.gitops_storeclass.layer == "infrastructure" ? "1-infrastructure" : (module.gitops_storeclass.layer == "services" ? "2-services" : "3-applications")
    type        = module.gitops_storeclass.type
    storage_name = module.gitops_storeclass.storage_name
  })
}
