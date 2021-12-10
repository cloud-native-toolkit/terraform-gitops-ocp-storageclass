locals {
  name          = "ocpstorageclass"
  namespace     = "default"
  bin_dir       = module.setup_clis.bin_dir
  yaml_dir     = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"

  parmlist = jsonencode(var.parameter_list)

  layer = "infrastructure"
  application_branch = "main"
  layer_config = var.gitops_config[local.layer]
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${var.name}' '${local.yaml_dir}' ${var.isdefault} ${var.provisioner_name} ${var.vol_binding_mode} ${var.allow_expansion} ${var.reclaim_policy} ${local.parmlist}"

    environment = {
      BIN_DIR = local.bin_dir
    }
  }
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml]

  provisioner "local-exec" {
    command = "${local.bin_dir}/igc gitops-module '${local.name}' -n '${local.namespace}' --contentDir '${local.yaml_dir}' --serverName '${var.server_name}' -l '${local.layer}' --debug"

    environment = {
      GIT_CREDENTIALS = yamlencode(var.git_credentials)
      GITOPS_CONFIG   = yamlencode(var.gitops_config)
    }
  }
}

