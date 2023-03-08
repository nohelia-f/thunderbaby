locals {
  image_tag_name            = "nginx-gcs-proxy"
  image_tag                 = "latest"
  gcs_proxy_image           = "${local.primary_region}-docker.pkg.dev/${local.project_id}/${google_artifact_registry_repository.primary.name}/${local.image_tag_name}:latest"
  domain_mapping_sub_domain = "cloud-run-server"
}

resource "google_cloud_run_v2_service" "landing_page" {
  name     = "${local.env}-landing-page"
  location = local.primary_region
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.landing_gcs_proxy_cloud_run_user.email

    containers {
      image = local.gcs_proxy_image

      ports {
        name = "http1"
        container_port = 80
      }

      # Bump this number to force a revision
      env {
        name = "re-deploy-trigger"
        value = var.cloud_run_redeploy_trigger
      }
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "all_users_invoker" {
  project = google_cloud_run_v2_service.landing_page.project
  location = google_cloud_run_v2_service.landing_page.location
  name = google_cloud_run_v2_service.landing_page.name
  role = "roles/run.invoker"
  member = "allUsers"
}

resource "google_cloud_run_domain_mapping" "www" {
  location = local.primary_region
  name     = local.complete_url

  metadata {
    namespace = data.google_project.project.project_id
  }

  spec {
    route_name = google_cloud_run_v2_service.landing_page.name
  }
}

# resource "google_cloud_run_domain_mapping" "base" {
#   location = local.primary_region
#   name     = "${local.base_domain}"

#   metadata {
#     namespace = data.google_project.project.project_id
#   }

#   spec {
#     route_name = google_cloud_run_v2_service.landing_page.name
#   }
# }