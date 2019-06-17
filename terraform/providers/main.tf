provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  #access_key = "my-access-key"
  #secret_key = "my-secret-key"
}

provider "github"{}
provider "google"{}

resource "aws_s3_bucket" "b" {
}

