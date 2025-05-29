variable "gcp_folder_id" {
  type        = string
  description = "The GCP folder ID to apply this config to."
}

variable "gcp_project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "gcp_project_id2" {
  type        = string
  description = "GCP Project ID"
}

variable "gcp_region" {
  type        = string
  default     = "us-central1"
  description = "Region"
}

# Default value passed in
variable "gcp_zone" {
  type        = string
  description = "Zone to create resources in."
  default     = "us-central1-c"
}