resource "google_service_account" "landing_gcs_proxy_cloud_run_user" {
  account_id   = "${local.env}-gcs-proxy-cloud-run-user"
  display_name = "${local.env} GCS Proxy Cloud Run User"
}

# resource "google_service_account" "brianfogg_com_github_action" {
#   account_id   = "brianfogg-com-github-action"
#   display_name = "brianfogg.com Github Action bucket writer"
# }