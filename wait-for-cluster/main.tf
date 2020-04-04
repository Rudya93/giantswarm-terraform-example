resource "null_resource" "cluster_status" {
  # introduce the dependency on the nodepool module
  depends_on       = [var.nodepoolid]

  provisioner "local-exec" {
    command = "until [ `curl -sH \"Authorization: giantswarm ${var.auth_token}\" ${var.api_uri}/v5/clusters/${var.clusterid}/nodepools/${var.nodepoolid}/ | jq .status.nodes_ready` -gt 0 ; do sleep 30 ; done"
  }
}
