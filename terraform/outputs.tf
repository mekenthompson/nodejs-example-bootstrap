# outputs.tf
output "cluster_id" {
  value = buildkite_cluster.nodejs.id
}

output "cluster_uuid" {
  value = buildkite_cluster.nodejs.uuid
}

output "agent_token" {
  value     = buildkite_cluster_agent_token.default.token
  sensitive = true
}

output "pipeline_id" {
  value = buildkite_pipeline.nodejs_example.id
}

output "pipeline_url" {
  value = "https://buildkite.com/${var.org_slug}/${buildkite_pipeline.nodejs_example.slug}"
}

output "pipeline_badge_url" {
  value = buildkite_pipeline.nodejs_example.badge_url
}

output "test_suite_id" {
  value = buildkite_test_suite.nodejs.id
}

output "test_suite_slug" {
  value = buildkite_test_suite.nodejs.slug
}

output "test_suite_url" {
  value = "https://buildkite.com/${var.org_slug}/analytics/suites/${buildkite_test_suite.nodejs.slug}"
}

output "next_steps" {
  value = <<-EOT
    ========== Buildkite Infrastructure Created! ==========
    
    Resources created:
    ✓ Cluster: ${buildkite_cluster.nodejs.name}
    ✓ Queue: default (${var.queue_shape})
    ✓ Pipeline: ${buildkite_pipeline.nodejs_example.name}
    ✓ Test Suite: ${buildkite_test_suite.nodejs.name}
    ✓ Team: ${buildkite_team.nodejs.name}
    
    Next steps:
    
    1. Configure hosted agents:
       - Go to: https://buildkite.com/${var.org_slug}/clusters
       - Find 'nodejs-cluster'
       - Add hosted agents with shape: ${var.queue_shape}
    
    2. Create package registry (manual step):
       - Go to: https://buildkite.com/${var.org_slug}/packages
       - Create registry named: ${var.registry_name}
    
    3. View your pipeline:
       https://buildkite.com/${var.org_slug}/${buildkite_pipeline.nodejs_example.slug}
    
    4. Configure test collection in your pipeline
    
    5. Push code to trigger builds!
    
    Agent Token (for self-hosted agents): See terraform output agent_token
    =====================================================
  EOT
}