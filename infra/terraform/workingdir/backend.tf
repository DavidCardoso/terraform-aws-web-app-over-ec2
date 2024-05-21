# See https://www.terraform.io/cli/config/config-file#credentials
terraform {
  # Defaults to local for simplifity
  backend "local" {}

  # TODO: improve state management
  # Example for Terraform Cloud:
  #   backend "remote" {
  #     hostname     = "app.terraform.io"
  #     organization = "davidcardoso"

  #     workspaces {
  #       prefix = "app-" # local workspace name will be appended automatically
  #     }
  #   }
}
