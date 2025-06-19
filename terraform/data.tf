# data.tf
# Get organization information
data "buildkite_organization" "current" {
  # Organization is determined by provider config
}

# Get the default team (if it exists)
data "buildkite_team" "default" {
  slug = "everyone"
}