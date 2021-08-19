#!/bin/bash
my_dir="$(dirname "$0")"

$my_dir/create-dummy-image.sh dvladir:partners-api
$my_dir/create-dummy-image.sh dvladir:partners-ui

echo "RUN"
docker-compose up -d