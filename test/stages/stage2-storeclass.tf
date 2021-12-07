module "gitops_storeclass" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  
  name="ibmc-vpc-block-10iops-tier-test"
  provisioner_name="vpc.block.csi.ibm.io"

}

resource null_resource gitops_sc_output {
  provisioner "local-exec" {
    command = "echo -n 'ibmc-vpc-block-10iops-tier-test' > git_sc_name"
  }

}
