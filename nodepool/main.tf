provider "restapi" {
  version              = "= 1.12.0"

  uri                  = var.api_uri
  write_returns_object = true     # write ops always return a JSON blob
  update_method        = "PATCH"  # default method is PUT, so we need to change this
  headers              = { "Authorization" = "giantswarm ${var.auth_token}" }
}

resource "restapi_object" "nodepool" {
  path         = "/v5/clusters/${var.clusterid}/nodepools/"
  create_path  = "/v5/clusters/${var.clusterid}/nodepools/"
  read_path    = "/v5/clusters/${var.clusterid}/nodepools/{id}/"
  update_path  = "/v5/clusters/${var.clusterid}/nodepools/{id}/"
  destroy_path = "/v5/clusters/${var.clusterid}/nodepools/{id}/"
  data         = <<EOF
{
  "name": "${var.nodepool_name}",
  "availability_zones": {
    "number": ${var.az_count}
  },
  "scaling": {
    "min": ${var.min_workers},
    "max": ${var.max_workers}
  }
}
EOF
}

output "nodepoolid" {
  value = jsondecode(restapi_object.nodepool.api_response).id
}
