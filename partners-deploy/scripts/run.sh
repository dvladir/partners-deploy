#!/bin/bash
my_dir="$(dirname "$0")"

$my_dir/create-dummy-image.sh dvladir:partners-api

echo "RUN"
docker-compose up -d