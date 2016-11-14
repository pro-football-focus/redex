#!/bin/bash
source settings.sh

# Kill any running project containers
./stop.sh && \

# Run the containers
docker-compose -f containers.yml -p ${PROJECT_NAME} up -d --remove-orphans >/dev/null && \

# View the container logs
docker-compose -f containers.yml -p ${PROJECT_NAME} logs -f