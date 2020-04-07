variable "api_uri" {
  type        = string
  description = "URI of installation API."
}

variable "auth_token" {
  type        = string
  description = "Authentication token."
}

variable "clusterid" {
  type        = string
  description = "ID of cluster."
}

# meta-variable to create a self-contained kubeconfig
variable "kubeconfig_embed" {
  type        = bool
  description = "Embeds client certs in kubeconfig if `true`. Set to `false` to write certs to disk."
}

# kubernetes API auth credentials

variable "key_description" {
  type        = string
  description = "String describing key's use."
}

variable "key_ttl" {
  type        = number
  description = "Key's TTL in hours."
}

variable "key_orgs" {
  type        = string
  description = "Comma separated list of organisations the key will belong to."
}

# dummy variable used to introduce inter-module dependency

variable "api_depends_on" {
  type        = any
  default     = null
  description = "Dummy variable."
}
