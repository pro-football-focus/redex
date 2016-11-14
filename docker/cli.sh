#!/bin/bash
source settings.sh

# Start a bash session with our application container
docker exec -it ${PROJECT_NAME}_app_1 bash