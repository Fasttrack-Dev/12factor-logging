#!/usr/bin/env bash

# build the application binary
cd ..
./gradlew build

# package it
rm -rf package.zip
zip -j package.zip build/libs/*.jar
cd ebs
# skip ebextensions for now
# zip ../package.zip .ebextensions/*

# upload new version and sync configuration
cd ../terraform
terraform apply
version_with_quotes=$(terraform output app_version)
# cut quotes
app_version="${version_with_quotes%\"}"
app_version="${app_version#\"}"
echo "Created application version $app_version"

# deploy the lastest version
aws --region eu-central-1 elasticbeanstalk update-environment \
  --environment-name "logging-environment" \
  --version-label "$app_version"
