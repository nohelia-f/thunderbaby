locals {
    primary_region = var.primary_region
    env = var.environment
    base_domain = "thunderbaby.club"
    project_id = var.project_id
    complete_url = "${local.env == "dev" ? local.env : ""}www.${local.base_domain}"
}

data "google_project" "project" {}