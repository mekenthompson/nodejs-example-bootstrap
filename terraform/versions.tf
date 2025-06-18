terraform {
  required_version = ">= 1.3.0"
  required_providers {
    buildkite = {
      source  = "buildkite/buildkite"
      version = "~> 1.7"
    }
  }
}
