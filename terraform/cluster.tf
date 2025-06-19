# cluster.tf
resource "buildkite_cluster" "nodejs" {
  name        = "nodejs-cluster"
  description = "Cluster for Node.js example with hosted agents"
  emoji       = ":node:"
  color       = "#83CD29"
}

resource "buildkite_cluster_queue" "default" {
  cluster_id  = buildkite_cluster.nodejs.id
  key         = "default"
  description = "Default queue for ${var.queue_shape}"
}

# Create cluster agent token for self-hosted agents (if needed)
resource "buildkite_cluster_agent_token" "default" {
  cluster_id  = buildkite_cluster.nodejs.id
  description = "Default agent token"
}