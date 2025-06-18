locals {
  token_mut = <<EOF
mutation Token($uuid: ID!) {
  testAnalyticsCreateToken(input:{pipelineUuid:$uuid}){ token }
}
EOF
}

resource "null_resource" "analytics" {
  provisioner "local-exec" {
    command = "echo '{}' > token.json"
  }
}
