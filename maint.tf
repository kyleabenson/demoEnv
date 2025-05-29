# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "google_project_service" "enable_apis" {
  for_each = toset([
    "artifactregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "cloudbilling.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "secretmanager.googleapis.com",
    "apphub.googleapis.com",
    "run.googleapis.com",
  ])

  service = each.key

  disable_on_destroy = false
}

resource "google_logging_project_bucket_config" "basic" {
    project    = var.gcp_project_id
    location  = "global"
    retention_days = 30
    enable_analytics = true
    bucket_id = "_Default"
}

resource "google_folder" "folder" {
  provider         = google-beta
  display_name     = "my-folder"
  parent           = "organizations/123456789"
  deletion_protection = false
}
resource "time_sleep" "wait_60s" {
  depends_on = [google_folder.folder]
  create_duration = "60s"
}
resource "google_resource_manager_capability" "capability" {
  provider         = google-beta
  value            = true
  parent           = "${google_folder.folder.name}"
  capability_name  = "app-management"
  depends_on = [time_sleep.wait_60s]
}