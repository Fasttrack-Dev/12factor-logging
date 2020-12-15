provider "aws" {
    region = "eu-central-1"
    allowed_account_ids = [
        652129918095]
}

resource "aws_elastic_beanstalk_application" "logging-service" {
    name = "logging-service"
    description = "Simple REST service to showcase logging to Splunk"
}

data "aws_ssm_parameter" "splunk_host" {
    name = "/dev/12factor/logging-service/splunk-host"
}

data "aws_ssm_parameter" "splunk_forwarder_download" {
    name = "/dev/12factor/logging-service/splunk-forwarder-download"
}

data "aws_ssm_parameter" "newrelic_license_key" {
    name = "/dev/12factor/logging-service/newrelic-license-key"
}

resource "aws_elastic_beanstalk_environment" "logging-environment" {
    name = "logging-environment"
    application = aws_elastic_beanstalk_application.logging-service.name
    solution_stack_name = "64bit Amazon Linux 2 v3.1.3 running Corretto 8"

    # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "IamInstanceProfile"
        value = "aws-elasticbeanstalk-ec2-role"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application"
        name = "Application Healthcheck URL"
        value = "/actuator/health"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "SERVER_PORT"
        value = "5000"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "SPLUNK_FORWARDER_RPM_DOWNLOAD_URL"
        value = data.aws_ssm_parameter.splunk_forwarder_download.value
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "SPLUNK_SERVER_HOST"
        value = data.aws_ssm_parameter.splunk_host.value
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "ENVIRONMENT_NAME"
        value = "logging-environment"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "NEWRELIC_LICENSE_KEY"
        value = data.aws_ssm_parameter.newrelic_license_key.value
    }
}

resource "aws_s3_bucket" "dist_bucket" {
    bucket = "logging-service-staging"
    acl = "private"
}

resource "aws_s3_bucket_object" "dist_item" {
    key = "dist-${uuid()}"
    bucket = aws_s3_bucket.dist_bucket.id
    source = "${path.root}/../package.zip"
}

resource "aws_elastic_beanstalk_application_version" "default" {
    name        = "logging-service-${uuid()}"
    application = aws_elastic_beanstalk_application.logging-service.name
    description = "application version created by terraform"
    bucket      = aws_s3_bucket.dist_bucket.id
    key         = aws_s3_bucket_object.dist_item.id
}

output "app_version" {
    value = aws_elastic_beanstalk_application_version.default.name
}

output "env_name" {
    value = aws_elastic_beanstalk_environment.logging-environment.name
}
