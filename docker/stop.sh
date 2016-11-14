#!/bin/bash
source settings.sh

# Kill any running project containers
docker-compose -f containers.yml -p ${PROJECT_NAME} kill >/dev/null && \
docker-compose -f containers.yml -p ${PROJECT_NAME} rm -fv >/dev/null