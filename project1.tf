resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service"
  location = "us-central1"
  deletion_protection = false
  invoker_iam_disabled = true
  ingress = "INGRESS_TRAFFIC_ALL"
  template {
    containers {
      name = "backend"
      ports {
        container_port = 8000
      }
      image = "us-west1-docker.pkg.dev/kb-workspace/apprun-repo/apprun:latest"
      depends_on = ["collector"]
      env {
        name = "OTEL_SERVICE_NAME"
        value = "backend"
      }
      env {
        name ="OTEL_TRACES_EXPORTER"
        value = "otlp"
      }
      env {
        name ="OTEL_METRICS_EXPORTER"
        value = "otlp"
      }
      env {
        name = "OTEL_EXPORTER_OTLP_ENDPOINT"
        value = "http://localhost:4317"
      }
    }
    containers {
      name = "collector"
      image = "us-docker.pkg.dev/cloud-ops-agents-artifacts/google-cloud-opentelemetry-collector/otelcol-google:0.126.0"
      args = ["--config=/etc/otelcol-google/config.yaml"]
      startup_probe {
        http_get {
          port = 13133
          path = "/"
        }
      }
      volume_mounts {
        mount_path = "/etc/otelcol-google"
        name = "config_bucket"
      }
    }
    volumes {
      name = "config_bucket"
      gcs {
        bucket = google_storage_bucket.default.name
        read_only = true
      }
    }
  }
}

resource "random_id" "bucket" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name = "my-bucket-${random_id.bucket.hex}"
  location = "US"
  storage_class = "STANDARD"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "default" {
 name         = "config.yaml"
 source       = "config.yaml"
 content_type = "text/plain"
 bucket       = google_storage_bucket.default.id
}