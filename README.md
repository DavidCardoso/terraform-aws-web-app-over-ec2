# App over AWS EC2

<!-- TODO: Update status badge links -->

- [App over AWS EC2](#app-over-aws-ec2)
  - [Requisites](#requisites)
  - [Environment variables](#environment-variables)
    - [For the app (and local setup)](#for-the-app-and-local-setup)
    - [For the infrastructure (_i.e._, Terraform)](#for-the-infrastructure-ie-terraform)
  - [Local development](#local-development)
  - [Terraform](#terraform)
  - [Useful commands](#useful-commands)
    - [Accessing the `app` container](#accessing-the-app-container)
    - [Seeing logs](#seeing-logs)
    - [Running a specific command inside the container](#running-a-specific-command-inside-the-container)
  - [Contributors](#contributors)

## Requisites

-   [Docker](https://docs.docker.com/get-docker/): for local development
-   [Hashicorp Terraform](https://www.terraform.io/): for infra as code management

## Environment variables

### For the app (and local setup)

See [.env-example](/.env-example)

### For the infrastructure (_i.e._, Terraform)

See [infra/terraform/.auto.tfvars](/infra/terraform/.auto.tfvars)

## Local development

```shell
# run locally in dev mode
# local files are mounted inside the container
./start.sh

# optionally, you can edit the .env file as needed
# create the .env file
cp .env-example .env
vim .env
```

> By default, the app will be available on `http://localhost:8080`

> See more about the docker configs in [infra/docker/development/](/infra/docker/development/) folder

## Terraform

See more in [infra/terraform/README.md](/infra/terraform/README.md)

## Useful commands

### Accessing the `app` container

```shell
docker compose exec app /bin/bash
```

### Seeing logs

```shell
docker compose logs app

# or
docker compose logs --tail=all -f | grep app
```

### Running a specific command inside the container

```shell
docker compose exec app pwd
# /srv/app # check the default working dir in `docker-compose.yml` file
```

## Contributors

-   [@DavidCardoso](https://github.com/DavidCardoso)
