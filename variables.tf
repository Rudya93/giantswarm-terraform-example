# giant swarm API access
variable "api_uri" {
  type        = string
  description = "URI of installation API."
}

variable "auth_token" {
  type        = string
  description = "Authentication token."
}

# tenant cluster configuration
variable "organisation" {
  type        = string
  description = "Cluster owner."
}

variable "release_ver" {
  type        = string
  description = "Giant Swarm release to deploy."
}

variable "cluster_name" {
  type        = string
  description = "Cluster name."
}

variable "master_zone" {
  type        = string
  description = "Availability zone to deploy the master node in."
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

# tenant cluster authentication
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
