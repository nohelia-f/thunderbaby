resource "google_storage_bucket" "landing_page" {
  name          = "${local.env}-${local.project_id}-landing-page"
  location      = "US"
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_binding" "landing_page_all_users_read" {
  bucket = google_storage_bucket.landing_page.name
  role = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}