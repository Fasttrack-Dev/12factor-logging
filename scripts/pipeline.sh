#!/usr/bin/env bash

# build the application binary
echo "Building binary"
cd ..
./gradlew build

# package it
echo "Packaging binary and extensions"
rm -rf package.zip
zip -j package.zip build/libs/*.jar
cd ebs
# skip ebextensions for now
zip ../package.zip .ebextensions/*

# upload new version and sync configuration
echo "Uploading changes to Elastic Beanstalk"
cd ../terraform
terraform apply
version_with_quotes=$(terraform output app_version)
# cut quotes
app_version="${version_with_quotes%\"}"
app_version="${app_version#\"}"
echo "Created application version $app_version"

# deploy the lastest version
echo "Deploying version $app_version"
aws --region eu-central-1 elasticbeanstalk update-environment \
  --environment-name "logging-environment" \
  --version-label "$app_version"
