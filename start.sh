#!/bin/sh
set -e

ENVIRONMENT=development

# The ENVIRONMENT can be passed as an argument
if [ ! -z "$1" ]; then
    ENVIRONMENT="$1"
fi

# development
start_development() {
    # Check dot env file
    if [ ! -e .env ]; then
        echo "Warning: The '.env' file not exists!"
        echo "Using '.env-example'..."
        cp .env-example .env
    fi

    docker compose \
        up -d \
        --force-recreate \
        --remove-orphans #\
    # --build # uncomment this line to force build
}

# main
start_development
