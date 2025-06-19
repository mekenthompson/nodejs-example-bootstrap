# provider.tf
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    buildkite = {
      source  = "buildkite/buildkite"
      version = "~> 1.0"
    }
  }
}

provider "buildkite" {
  api_token    = var.buildkite_api_token
  organization = var.org_slug
}