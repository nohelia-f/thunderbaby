#!/bin/bash

echo "Build container"

DIR=$(dirname "$0")

# ENV="dev"
ENV="prod"

REPO_BASE="us-central1-docker.pkg.dev"
SUB_DIR_REPO="thunderbaby/$ENV-primary"
IMAGE_NAME="nginx-gcs-proxy"
TAG="latest"

# Auth docker to allow pushing
gcloud auth configure-docker $REPO_BASE

pushd $DIR/gcs_proxy_docker_image/

    docker buildx build \
        --platform linux/amd64 \
        --push \
        -t "$REPO_BASE/$SUB_DIR_REPO/$IMAGE_NAME:$TAG" .

popd