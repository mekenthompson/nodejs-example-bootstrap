provider "buildkite" {
  api_token    = var.buildkite_api_token
  organization = var.org_slug
}
