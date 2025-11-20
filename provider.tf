terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.7.5"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

data "github_repository" "main" {
  full_name = "${var.github_owner}/${var.repository_name}"
}
