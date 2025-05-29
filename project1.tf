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
      image = "ghcr.io/kyleabenson/apprepo:main"
      depends_on = ["collector"]
    #   env {
    #     name = "OTEL_SERVICE_NAME"
    #     value = "myapp"
    #     name ="OTEL_TRACES_EXPORTER"
    #     value = "otlp"
    #     name = "OTEL_EXPORTER_OTLP_ENDPOINT"
    #     value = "http://localhost:4317"
    #   }
    }
    # containers {
    #   name = "collector"
    #   image = "us-docker.pkg.dev/cloud-ops-agents-artifacts/google-cloud-opentelemetry-collector/otelcol-google:0.126.0"
    #   args = "--config=/etc/otelcol-google/config.yaml"
    #   startup_probe {
    #     http_get {
    #       port = 13133
    #       path = "/"
    #     timeoutSeconds = 30
    #     periodSeconds = 30
    #     }
    #   }
    # }
    # volumes {
    #   name = "config"
    #   secret{
    #     secret = google_secret_manager_secret.secret.secret_id
    #     items {
    #         key = "latest"
    #         path = "config.yaml"
    #     }
    #   }
    # }
  }
}