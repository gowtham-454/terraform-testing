terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }

  }
}
provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}



# provider "vault" {
#   address = "http://100.25.216.11:8200"
#   skip_child_token = true

#   auth_login {
#     path = "auth/approle/login"

#     parameters = {
#       role_id = "YOUR_ROLE_ID"
#       secret_id = "YOUR_SECRET_ID"
#     }
#   }
# }