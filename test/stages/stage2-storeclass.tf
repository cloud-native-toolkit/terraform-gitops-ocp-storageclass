module "gitops_storeclass" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = module.gitops_namespace.name
  cluster_ingress_hostname = module.dev_cluster.platform.ingress
  cluster_type = module.dev_cluster.platform.type_code
  tls_secret_name = module.dev_cluster.platform.tls_secret
  kubeseal_cert = module.argocd-bootstrap.sealed_secrets_cert
  
  sc_name="ibmc-vpc-block-10iops-test"
  sc_provisioner_name="vpc.block.csi.ibm.io"

}

resource null_resource gitops_sc_output {
  provisioner "local-exec" {
    command = "echo -n '${module.gitops_storeclass.storage_name}' > git_sc_name"
  }

}
