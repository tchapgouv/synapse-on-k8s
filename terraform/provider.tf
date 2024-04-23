terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.42.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.45.0"
    }
  }
}

# inspired by https://breadnet.co.uk/terraform-ovh-openstack/
# and https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs
# Configure the OpenStack Provider
provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/v3/" # Authentication URL
  domain_name = "default"                        # Domain name - Always at 'default' for OVHcloud
}

provider "aws" {
  region = lower(var.global_region)
  # kics-scan ignore-line
  access_key = ovh_cloud_project_user_s3_credential.s3_admin_cred.access_key_id
  secret_key = ovh_cloud_project_user_s3_credential.s3_admin_cred.secret_access_key

  #OVH implementation has no STS service
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  # the gra region is unknown to AWS hence skipping is needed.
  skip_region_validation = true
  endpoints {
    s3 = "https://${var.s3_media_repo_endpoint}"
  }
}
