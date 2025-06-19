# variables.tf
variable "buildkite_api_token" {
  type        = string
  sensitive   = true
  description = "Buildkite API token with GraphQL access"
}

variable "org_slug" {
  type        = string
  description = "Buildkite organization slug"
  default     = "bootstrap-example"
}

variable "registry_name" {
  type        = string
  description = "Name for the package registry"
  default     = "bootstrap-registry"
}

variable "queue_shape" {
  type        = string
  description = "Hosted agent shape"
  default     = "LINUX_AMD64_2X4"
}