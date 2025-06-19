# team.tf
# Create a team for the project
resource "buildkite_team" "nodejs" {
  name                 = "Node.js Team"
  description          = "Team responsible for Node.js example"
  privacy              = "VISIBLE"  # Must be uppercase: "VISIBLE" or "SECRET"
  default_team         = false
  default_member_role  = "MEMBER"   # Must be uppercase: "MEMBER" or "MAINTAINER"
}

# Associate team with pipeline
resource "buildkite_pipeline_team" "nodejs" {
  pipeline_id = buildkite_pipeline.nodejs_example.id
  team_id     = buildkite_team.nodejs.id
  
  access_level = "MANAGE_BUILD_AND_READ"  # Must be uppercase
}