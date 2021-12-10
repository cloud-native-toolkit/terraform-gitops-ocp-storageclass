module "gitops_storeclass" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  
  name="ibmc-vpc-block-test"
  provisioner_name="vpc.block.csi.ibm.io"

  parameter_list=[{key = "classVersion",value = "\"1\""},{key = "csi.storage.k8s.io/fstype", value = "ext4"}, {key="encrypted",value="\"false\""},{key="profile",value="10iops-tier"},{key="sizeRange",value="\"[10-2000]GiB\""}]

}

resource null_resource gitops_sc_output {
  provisioner "local-exec" {
    command = "echo -n 'ibmc-vpc-block-test' > git_sc_name"
  }

}
