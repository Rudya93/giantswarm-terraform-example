provider "shell" {}

resource "shell_script" "k8s_key_pair" {
  environment = {
    DATA = <<-EOT
{
  "description": "${var.key_description}",
  "ttl_hours": ${var.key_ttl},
  "certificate_organizations": "${var.key_orgs}"
}
EOT
}

  depends_on = [var.clusterid]

  lifecycle_commands {
    create   = <<SCRIPT
      curl -X POST -H "Content-Type: application/json" -H "Authorization: giantswarm ${var.auth_token}" -d "$DATA" "${var.api_uri}/v4/clusters/${var.clusterid}/key-pairs/"
    SCRIPT

    delete   = <<SCRIPT
      echo "cannot destroy key pairs"
    SCRIPT
  }
}

data "http" "cluster_details" {
  url             = "${var.api_uri}/v5/clusters/${var.clusterid}/"

  request_headers = {
    Authorization = "giantswarm ${var.auth_token}"
  }
}

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

# output tenant cluster kubernetes API address
output "k8s_api_uri" {
  value = jsondecode(data.http.cluster_details.body).api_endpoint
}

# tenant cluster CA certificate
output "key_ca_cert" {
  value = shell_script.k8s_key_pair.output["certificate_authority_data"]
}

# tenant cluster client private key
output "key_client_key" {
  value = shell_script.k8s_key_pair.output["client_key_data"]
}

# tenant cluster client certificate
output "key_client_cert" {
  value = shell_script.k8s_key_pair.output["client_certificate_data"]
}
