terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://ams3.digitaloceanspaces.com"
    }

    bucket  = "terraform-158f917c-2c81-44f6-82dc-7982eb077ee1"
    key     = "terraform.tfstate"
    profile = "rethinkdb"

    # Deactivate a few AWS-specific checks
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    region                      = "us-east-1"
  }


  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.49.1"
    }
  }
}

provider "digitalocean" {
  token = var.digitalocean_token
}
