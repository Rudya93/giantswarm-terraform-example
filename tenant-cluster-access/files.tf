# kubeconfig and associated key pair files are output
# to this module's directory.

resource "local_file" "key_ca_cert" {
  count           = var.kubeconfig_embed ? 0 : 1

  content         = shell_script.k8s_key_pair.output["certificate_authority_data"]
  filename        = "${path.module}/ca.crt"
  file_permission = "0644"
}

resource "local_file" "key_client_key" {
  count           = var.kubeconfig_embed ? 0 : 1

  content         = shell_script.k8s_key_pair.output["client_key_data"]
  filename        = "${path.module}/client.key"
  file_permission = "0644"
}

resource "local_file" "key_client_cert" {
  count           = var.kubeconfig_embed ? 0 : 1

  content         = shell_script.k8s_key_pair.output["client_certificate_data"]
  filename        = "${path.module}/client.crt"
  file_permission = "0644"
}

resource "local_file" "kubeconfig" {
  count           = var.kubeconfig_embed ? 0 : 1

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

resource "local_file" "kubeconfig_embed" {
  count           = var.kubeconfig_embed ? 1 : 0

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
