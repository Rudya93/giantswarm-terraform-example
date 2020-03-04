module "cluster" {
  source  = "./cluster"

  api_uri      = var.api_uri
  auth_token   = var.auth_token
  organisation = var.organisation
  release_ver  = var.release_ver
  cluster_name = var.cluster_name
  master_zone  = var.master_zone
}

module "nodepool" {
  source    = "./nodepool"

  api_uri       = var.api_uri
  auth_token    = var.auth_token
  nodepool_name = var.nodepool_name
  az_count      = var.az_count
  min_workers   = var.min_workers
  max_workers   = var.max_workers

  clusterid     = module.cluster.clusterid
}

output "clusterid" {
  value = module.cluster.clusterid
}

output "nodepoolid" {
  value = module.nodepool.nodepoolid
}
