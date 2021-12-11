
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}

variable "name" {
  type        = string
  description = "The name of the storage class to create"
}

variable "provisioner_name" {
  type        = string
  description = "The name of the storage provisioner"
}

variable "vol_binding_mode" {
  type        = string
  description = "Volume binding mode for the storage class"
  default     = "WaitForFirstConsumer"
}

variable "isdefault" {
  type        = string
  description = "Set to default storage class"
  default     = "false"
}

variable "allow_expansion" {
  type        = string
  description = "Allow expansion of the volume"
  default     = "true"
}

variable "reclaim_policy" {
  type        = string
  description = "Reclaim policy for the storage class"
  default     = "Delete"
}

variable "parameter_list" {
  description = "optional parameters when defining the class, see ReadMe for sample syntax"
  type        = list(object({
    key = string
    value = string
  }))

  default = []
  
}
