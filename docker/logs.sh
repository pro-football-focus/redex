#!/bin/bash
source settings.sh

# View the container logs
docker-compose -f containers.yml -p ${PROJECT_NAME} logs -f