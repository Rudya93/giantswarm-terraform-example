# kubeconfig and associated key pair files are output
# to this module's directory.

resource "local_file" "key_ca_cert" {
  content         = shell_script.k8s_key_pair.output["certificate_authority_data"]
  filename        = "${path.module}/ca.crt"
  file_permission = "0644"
}

resource "local_file" "key_client_key" {
  content         = shell_script.k8s_key_pair.output["client_key_data"]
  filename        = "${path.module}/client.key"
  file_permission = "0644"
}

resource "local_file" "key_client_cert" {
  content         = shell_script.k8s_key_pair.output["client_certificate_data"]
  filename        = "${path.module}/client.crt"
  file_permission = "0644"
}

resource "local_file" "kubeconfig" {
  depends_on      = [local_file.key_ca_cert, local_file.key_client_key, local_file.key_client_cert]
  filename        = "${path.module}/kubeconfig"
  file_permission = "0644"

  content         = <<-EOT
apiVersion: v1
clusters:
- cluster:
    certificate-authority: ca.crt
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
    client-certificate: client.crt
    client-key: client.key
EOT
}
