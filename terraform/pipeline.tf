resource "buildkite_pipeline" "node" {
  name       = "nodejs-example"
  repository = "https://github.com/your-org/nodejs-example-bootstrap.git"
  steps      = file("${path.module}/../.buildkite/pipeline.yml")

  environment = {
    REGISTRY_SLUG             = var.registry_name
    QUEUE_KEY                 = buildkite_cluster_queue.default.key
    # The analytics token will be replaced by the null_resource output once provider supports it
    BUILDKITE_ANALYTICS_TOKEN = "TO_BE_REPLACED"
  }
}
