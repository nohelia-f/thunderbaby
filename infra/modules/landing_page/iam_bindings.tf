# resource "google_storage_bucket_iam_binding" "brianfogg_com_admin_binding" {
#   bucket = google_storage_bucket.wwwbrianfoggcom.name
#   role = "roles/storage.admin"
#   members = [
#     "serviceAccount:${google_service_account.brianfogg_com_github_action.email}",
#   ]
# }