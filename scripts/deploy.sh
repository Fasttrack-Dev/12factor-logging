#!/usr/bin/env bash

aws --region eu-central-1 elasticbeanstalk update-environment \
  --environment-name $(terraform output env_name) \
  --version-label $(terraform output app_version)
