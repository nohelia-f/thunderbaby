terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.56.0"
    }
  }
  backend "gcs" {
    bucket  = "thunderbaby-tf-state"
    prefix  = "prod/state"
  }
}

locals {
  primary_region = "us-central1"
  project_id     = "thunderbaby"
}

provider "google" {
  project     = local.project_id
  region      = local.primary_region
}

module "landing_page" {
  source                     = "../../modules/landing_page"
  environment                = "prod"
  primary_region             = local.primary_region
  project_id                 = local.project_id
  # Bump this number to force a revision
  cloud_run_redeploy_trigger = 20
}

# Adding Nohelia to account
resource "google_project_iam_binding" "project" {
  project = local.project_id
  role    = "roles/editor"

  members = [
    "user:nohe.noeh@gmail.com",
  ]
}