resource "null_resource" "cluster_status" {
  depends_on       = [var.nodepoolid]

  provisioner "local-exec" {
    command = "until curl -sH \"Authorization: giantswarm ${var.auth_token}\" ${var.api_uri}/v5/clusters/${var.clusterid}/ | grep -m 1 \"Created\" ; do sleep 30 ; done"
  }
}
