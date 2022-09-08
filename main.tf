locals {
  name          = "ocpstorageclass"
  namespace     = "default"
  bin_dir       = module.setup_clis.bin_dir
  yaml_dir     = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"

  paramlist = jsonencode(var.parameter_list)

  layer = "infrastructure"
  type = "base"
  application_branch = "main"
  layer_config = var.gitops_config[local.layer]
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${var.name}' '${local.yaml_dir}' ${var.isdefault} ${var.provisioner_name} ${var.vol_binding_mode} ${var.allow_expansion} ${var.reclaim_policy} '${local.paramlist}'"

    environment = {
      BIN_DIR = local.bin_dir
    }
  }
}


resource gitops_module module {
  depends_on = [null_resource.create_yaml]

  name = local.name
  namespace = local.namespace
  content_dir = local.yaml_dir
  server_name = var.server_name
  layer = local.layer
  type = local.type
  branch = local.application_branch
  config = yamlencode(var.gitops_config)
  credentials = yamlencode(var.git_credentials)
}
