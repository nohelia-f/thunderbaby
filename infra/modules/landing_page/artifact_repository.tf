resource "google_artifact_registry_repository" "primary" {
  location      = local.primary_region
  repository_id = "${local.env}-primary"
  description   = "primary"
  format        = "DOCKER"
}