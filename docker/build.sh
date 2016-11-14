#!/bin/bash
source settings.sh

# Kill any running project containers
./stop.sh && \

# Build the containers with the most up-to-date code
docker-compose -f containers.yml -p ${PROJECT_NAME} build