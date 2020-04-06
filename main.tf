module "cluster" {
  source       = "./cluster"

  api_uri      = var.api_uri
  auth_token   = var.auth_token
  organisation = var.organisation
  release_ver  = var.release_ver
  cluster_name = var.cluster_name
  master_zone  = var.master_zone
}

module "nodepool" {
  source        = "./nodepool"

  api_uri       = var.api_uri
  auth_token    = var.auth_token
  nodepool_name = var.nodepool_name
  az_count      = var.az_count
  min_workers   = var.min_workers
  max_workers   = var.max_workers

  # node pools are attached to a cluster, so we
  # need to pass the new cluster ID.
  clusterid     = module.cluster.clusterid
}

module "wait-for-cluster" {
  source     = "./wait-for-cluster"

  api_uri    = var.api_uri
  auth_token = var.auth_token

  # the wait module references the nodepool ID
  # in order to create the correct dependency
  # graph. the cluster ID is needed to poll for
  # the cluster status.
  clusterid  = module.cluster.clusterid
  nodepoolid = module.nodepool.nodepoolid
}

module "tenant-cluster-auth" {
  source          = "./tenant-cluster-auth"

  api_uri         = var.api_uri
  auth_token      = var.auth_token

  clusterid       = module.cluster.clusterid

  key_description = var.key_description
  key_ttl         = var.key_ttl
  key_orgs        = var.key_orgs

  api_depends_on  = [module.wait-for-cluster.pause]
}

output "clusterid" {
  value = module.cluster.clusterid
}

output "nodepoolid" {
  value = module.nodepool.nodepoolid
}

output "k8s_api_uri" {
  value = module.tenant-cluster-auth.k8s_api_uri
}
