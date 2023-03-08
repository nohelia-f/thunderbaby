resource "google_monitoring_notification_channel" "brian_email" {
  display_name = "${local.env} Brian email notification Channel"
  type         = "email"
  labels = {
    email_address = "fogg4444@gmail.com"
  }
}

resource "google_monitoring_notification_channel" "nohe_email" {
  display_name = "${local.env} Nohelia email notification Channel"
  type         = "email"
  labels = {
    email_address = "nohe.noeh@gmail.com"
  }
}

resource "google_monitoring_uptime_check_config" "landing_page" {
  display_name = "${local.env}-${local.base_domain}-uptime-check"
  timeout      = "60s"

  http_check {
    path = "/"
    use_ssl = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = local.complete_url
      project_id = data.google_project.project.project_id
    }
  }
}

resource "google_monitoring_alert_policy" "landing_page" {
  display_name = "${local.env} ${local.base_domain} Uptime Alert Policy"
  notification_channels = [
    google_monitoring_notification_channel.brian_email.id,
    google_monitoring_notification_channel.nohe_email.id,
  ]
  combiner       = "OR"
  conditions {
    display_name = "Uptime check failure: ${google_monitoring_uptime_check_config.landing_page.display_name}"
    condition_threshold {
      aggregations {
        alignment_period     = "1200s"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = [ "resource.label.*" ]
      }
      comparison      = "COMPARISON_GT"
      duration        = "60s"
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.check_id=\"${google_monitoring_uptime_check_config.landing_page.uptime_check_id}\" AND resource.type=\"uptime_url\""
      threshold_value = 1
      trigger {
        count = 1
      }
    }
  }
}