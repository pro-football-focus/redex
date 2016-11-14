#!/bin/bash
source settings.sh

# Run the mix tests in the application container
docker-compose -f containers.yml -p ${PROJECT_NAME} run -e "MIX_ENV=test" --rm app mix deps.get --only test && \
docker-compose -f containers.yml -p ${PROJECT_NAME} run -e "MIX_ENV=test" --rm app mix test

# Kill any linked containers started during tests
./stop.sh