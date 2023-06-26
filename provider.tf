//provider.tf
provider "aws" {
  profile = "default"
  region  = var.AWS_REGION
}