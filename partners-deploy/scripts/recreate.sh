#!/bin/bash
echo "RECREATE $1"
docker-compose up --force-recreate --no-deps -d $1