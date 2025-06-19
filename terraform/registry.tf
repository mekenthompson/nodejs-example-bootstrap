# registry.tf
# Note: Package registries are not yet supported by the Terraform provider
# This is a placeholder for when support is added
locals {
  registry_setup_script = <<-EOT
    echo "========================================"
    echo "Package Registry Setup"
    echo "========================================"
    echo "Package registries must be created manually:"
    echo ""
    echo "1. Go to: https://buildkite.com/${var.org_slug}/packages"
    echo "2. Click 'New Registry'"
    echo "3. Name: ${var.registry_name}"
    echo "4. Configure OIDC for docker push (optional)"
    echo ""
    echo "Registry URL will be: ${var.registry_name}.buildkite.com"
    echo "========================================"
  EOT
}

resource "null_resource" "registry_instructions" {
  provisioner "local-exec" {
    command = "echo '${local.registry_setup_script}'"
  }
}