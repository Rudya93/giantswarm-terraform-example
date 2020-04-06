# Creating Giant Swarm clusters with Terraform

## Prerequisites

### Restapi provider

Get the [restapi](https://github.com/Mastercard/terraform-provider-restapi) provider:

```bash
RESTAPI_VERSION="1.12.0"
wget https://github.com/Mastercard/terraform-provider-restapi/releases/download/v${RESTAPI_VERSION}/terraform-provider-restapi_v${RESTAPI_VERSION}-linux-amd64
mkdir -p ~/.terraform.d/plugins/
chmod +x terraform-provider-restapi_v${RESTAPI_VERSION}-linux-amd64
mv terraform-provider-restapi_v${RESTAPI_VERSION}-linux-amd64 ~/.terraform.d/plugins/terraform-provider-restapi_v${RESTAPI_VERSION}
```

### Shell script provider

Get the [shell_script](https://github.com/scottwinkler/terraform-provider-shell) provider:

```bash
SHELL_PROVIDER_VERSION="1.2.0"
wget https://github.com/scottwinkler/terraform-provider-shell/releases/download/v${SHELL_PROVIDER_VERSION}/terraform-provider-shell_v${SHELL_PROVIDER_VERSION}_linux_amd64.tar.gz
tar -zxvf terraform-provider-shell_v${SHELL_PROVIDER_VERSION}_linux_amd64.tar.gz
chmod -x terraform-provider-shell
mv terraform-provider-shell ~/.terraform.d/plugins/terraform-provider-shell_v${SHELL_PROVIDER_VERSION}
```

Note: only required if you wish to use the `tenant-cluster-auth` module.

### Authentication

Create a file containing your Giant Swarm user credentials:

```json
{
"email": "me@mycorp.com",
"password_base64": "AfSeZ1Xds3jzF5xQMQ=="
}
```

Use this to obtain an auth token:

```bash
INSTALLATION_URI="https://api.something.com"
curl -X POST -d @credentials.json https://${INSTALLATION_URI}/v4/auth-tokens/
```

This token must then be provided to Terraform (as the `auth_token` variable).

## Configuration

Copy the vars file:

```bash
cp terraform.tfvars{.example,}
```

Then update `terraform.tfvars` to match your requirements.

## Running

Initialise the provider:

```bash
$ terraform init
Initializing modules...
- cluster in cluster
- nodepool in nodepool
- tenant-cluster-auth in tenant-cluster-auth
- wait-for-cluster in wait-for-cluster

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "local" (hashicorp/local) 1.4.0...
- Downloading plugin for provider "http" (hashicorp/http) 1.2.0...
- Downloading plugin for provider "null" (hashicorp/null) 2.1.2...

* provider.http: version = "~> 1.2"
* provider.local: version = "~> 1.4"
* provider.null: version = "~> 2.1"
* provider.shell: version = "~> 1.2"

Terraform has been successfully initialized!
```

You're now ready!

## Notes

The example will wait until the Giant Swarm API has registered nodepool nodes as ready. This allows further resources to be applied which depend on the new cluster being accessible - these can be created against the tenant cluster Kubernetes API using the generated credentials in `tenant-cluster-auth`.
