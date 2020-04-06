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
