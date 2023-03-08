#!/bin/bash


DIR=$(dirname "$0")

pushd $DIR/../gcs_proxy_docker_config/

TAG="test-nginx-image"

docker build --rm -t $TAG .

IMAGE_ID=$(docker images -q $TAG)
echo $IMAGE_ID

docker run -p 0.0.0.0:80:80 $TAG

popd