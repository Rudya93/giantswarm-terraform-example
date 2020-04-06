resource "null_resource" "cluster_status" {
  # introduce the dependency on the nodepool module
  depends_on       = [var.nodepoolid]

  provisioner "local-exec" {
    # this uses some regex lookahead magic to work; it could potentially be brittle
    # depending on the version of grep available to you locally.
    command = "until [ `curl -sH \"Authorization: giantswarm ${var.auth_token}\" ${var.api_uri}/v5/clusters/${var.clusterid}/nodepools/${var.nodepoolid}/ | grep -oP '(?<=\"nodes_ready\":)[^}]*'` -gt 0 ] ; do sleep 30 ; done"
    # using jq is more robust, but may not be available to you locally. if you can
    # use jq instead of grep then this is recommended.
    # command = "until [ `curl -sH \"Authorization: giantswarm ${var.auth_token}\" ${var.api_uri}/v5/clusters/${var.clusterid}/nodepools/${var.nodepoolid}/ | jq .status.nodes_ready` -gt 0 ; do sleep 30 ; done"
  }
}

output "pause" {
  value      = {}

  depends_on = [null_resource.cluster_status]
}
