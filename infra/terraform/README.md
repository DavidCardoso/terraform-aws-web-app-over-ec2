# Infrastruture as Code

Creates all the related infrastructure on AWS using Terraform.

## Resources

- [ ] Route53 records
- [ ] ACM certificates (SSL)
- [ ] VPC, subnets, security groups, etc.
- [ ] EC2 -> ELB

## Environment variables

Must be configured at [Terraform Cloud console](https://app.terraform.io) > Workspaces > Variable sets.

## Usage

### Logging in to the cloud backend

Terraform CLI expects a `~/.terraformrc` file to authenticate.

> See [https://www.terraform.io/cli/config/config-file#credentials](https://www.terraform.io/cli/config/config-file#credentials)

> Verify if the backend is set properly. If not, the state will be saved locally.

<!-- TODO: add more instructions about the TF Cloud login -->

### Examples

To run this example you need to execute:

```bash
# start the terraform inside the workingdir/ directory
cd workingdir
terraform init

# set the right environment (avoid using default environment)
terraform workspace list
terraform workspace new ${ENVIRONMENT}
terraform workspace select ${ENVIRONMENT}

# check
terraform validate

# see changes
terraform plan

# execute the changes
terraform apply
```


