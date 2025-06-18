resource "buildkite_cluster" "hosted" {
  name        = "bk-hosted"
  description = "Hosted agents provisioned by bootstrap"
}

resource "buildkite_cluster_queue" "default" {
  cluster_id  = buildkite_cluster.hosted.id
  key         = "demo"
  description = "Hosted queue for example app"
  hosted_agents = {
    instance_shape = var.queue_shape
  }
}
