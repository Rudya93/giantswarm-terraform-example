resource "local_file" "kubeconfig_embed" {
  filename        = "${path.module}/kubeconfig"
  file_permission = "0644"

  content         = <<-EOT
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${base64encode(shell_script.k8s_key_pair.output["certificate_authority_data"])}
    server: ${jsondecode(data.http.cluster_details.body).api_endpoint}
  name: giantswarm-${var.clusterid}
contexts:
- context:
    cluster: giantswarm-${var.clusterid}
    user: giantswarm-${var.clusterid}-user
  name: giantswarm-${var.clusterid}
current-context: giantswarm-${var.clusterid}
kind: Config
preferences: {}
users:
- name: giantswarm-${var.clusterid}-user
  user:
    client-certificate-data: ${base64encode(shell_script.k8s_key_pair.output["client_certificate_data"])}
    client-key-data: ${base64encode(shell_script.k8s_key_pair.output["client_key_data"])}
EOT
}
