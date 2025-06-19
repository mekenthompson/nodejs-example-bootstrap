# test_suite.tf
resource "buildkite_test_suite" "nodejs" {
  name           = "nodejs-tests"
  default_branch = "main"
  team_owner_id  = buildkite_team.nodejs.id
}

# Create test suite team access
resource "buildkite_test_suite_team" "nodejs" {
  test_suite_id = buildkite_test_suite.nodejs.id
  team_id       = buildkite_team.nodejs.id
  access_level  = "MANAGE_AND_READ"  # Must be uppercase: "MANAGE_AND_READ" or "READ_ONLY"
}