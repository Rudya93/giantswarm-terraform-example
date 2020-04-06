provider "shell" {}

# Terraform expects all resources to have delete methods, but
# there is no way to delete a tenant cluster key pair. To work
# around this we have to craft a manual curl in order to create
# and retrieve the key pair. On deletion the resource will
# always be deleted but nothing will actually happen - this
# still satisfies Terraform.

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
