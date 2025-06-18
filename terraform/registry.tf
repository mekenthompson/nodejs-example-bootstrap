locals {
  mutation = <<EOF
mutation RegistryCreate($org: ID!, $name: String!) {
  registryCreate(input:{organizationID:$org, name:$name}) { registry { id slug } }
}
EOF
}

data "buildkite_organization" "this" {
  slug = var.org_slug
}

resource "null_resource" "registry" {
  provisioner "local-exec" {
    command = <<BASH
curl -s -H "Authorization: Bearer ${var.buildkite_api_token}" \
     -X POST https://graphql.buildkite.com/v1 \
     -d "{"query":"${local.mutation}","variables":{"org":"${data.buildkite_organization.this.id}","name":"${var.registry_name}"}}"
BASH
  }
  triggers = {
    always = timestamp()
  }
}
