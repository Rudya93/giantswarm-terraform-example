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

variable "nodepool_name"{
  type        = string
  description = "Nodepool name."
}

variable "az_count" {
  type        = number
  description = "Number of availability zones to deploy workers into."
}

variable "min_workers" {
  type        = number
  description = "Minimum number of worker nodes."
}

variable "max_workers" {
  type        = number
  description = "Maximum number of worker nodes."
}
