module "gitops_storeclass" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  
  name="ibmc-vpc-block-10iops-tier-test"
  provisioner_name="vpc.block.csi.ibm.io"

  parameter_list={"parameters":[{"classVersion":"'1'","csi.storage.k8s.io/fstype":"ext4","encrypted":"'false'","profile":"10iops-tier","sizeRange":"'[10-2000]GiB'"}]}
}

resource null_resource gitops_sc_output {
  provisioner "local-exec" {
    command = "echo -n 'ibmc-vpc-block-test' > git_sc_name"
  }

}
