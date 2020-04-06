provider "restapi" {
  version              = "= 1.12.0"

  uri                  = var.api_uri
  write_returns_object = true     # write ops always return a JSON blob
  update_method        = "PATCH"  # default method is PUT, so we need to change this
  headers              = { "Authorization" = "giantswarm ${var.auth_token}" }
}

resource "restapi_object" "cluster" {
  # explicitly declare the API endpoint path for each operation
  path         = "/v5/clusters/"
  create_path  = "/v5/clusters/"
  read_path    = "/v5/clusters/{id}/"
  update_path  = "/v5/clusters/{id}/"
  destroy_path = "/v4/clusters/{id}/"
  data         = <<EOF
{
  "owner": "${var.organisation}",
  "release_version": "${var.release_ver}",
  "name": "${var.cluster_name}",
  "master": {
    "availability_zone": "${var.master_zone}"
  }
}
EOF
}

output "clusterid" {
  value = jsondecode(restapi_object.cluster.api_response).id
}
