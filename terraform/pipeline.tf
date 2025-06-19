# pipeline.tf
resource "buildkite_pipeline" "nodejs_example" {
  name        = "nodejs-example"
  repository  = "https://github.com/${var.org_slug}/nodejs-example-bootstrap.git"
  description = "Example Node.js pipeline"
  
  default_branch = "main"
  cluster_id     = buildkite_cluster.nodejs.id
  
  # Use YAML steps to avoid interpolation issues
  steps = file("${path.module}/pipeline-steps.yml")
}

# Set up pipeline schedule (optional)
resource "buildkite_pipeline_schedule" "nightly" {
  pipeline_id = buildkite_pipeline.nodejs_example.id
  label       = "Nightly Build"
  cronline    = "0 0 * * *"
  message     = "Scheduled nightly build"
  branch      = "main"
  enabled     = true
}