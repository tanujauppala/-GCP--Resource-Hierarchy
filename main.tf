terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }

  required_version = ">= 1.3.0"
}
provider "google" {

  project     = "sharp-harbor-466005-p5"
  region      = "us-central1"
}
locals {
  data = yamldecode(file("projects.yaml"))
}
resource "google_project" "projects" {
  for_each = { for project in local.data.projects : project.projectId => project }

  name       = each.value.name
  project_id = each.value.projectId
  labels     = each.value.labels
  deletion_policy = var.delete_policy # Controls deletion behavior. Set variable 'delete_policy' to delete to allow deletion, or by default it will be prevent.

}
resource "google_project_iam_member" "projects_viewer" {
  for_each = { for project in local.data.projects : project.projectId => project }

  project = each.value.projectId
  role    = "roles/viewer"
  member  = "user:tanujagcp@gmail.com"
}
