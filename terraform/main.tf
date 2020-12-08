provider "aws" {
    region = "eu-central-1"
    allowed_account_ids = [
        652129918095]
}

resource "aws_elastic_beanstalk_application" "logging-service" {
    name = "logging-service"
    description = "Simple REST service to showcase loggin"
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
}

data "archive_file" "dist_zip" {
    type = "zip"
    source_file = "${path.root}/../build/libs/logging-service-0.0.1-SNAPSHOT.jar"
    output_path = "${path.root}/logging-service.zip"
}

resource "aws_s3_bucket" "dist_bucket" {
    bucket = "logging-service-staging"
    acl = "private"
}

resource "aws_s3_bucket_object" "dist_item" {
    key = "dist-${uuid()}"
    bucket = aws_s3_bucket.dist_bucket.id
    source = "${path.root}/logging-service.zip"
}

resource "aws_elastic_beanstalk_application_version" "default" {
    name        = "logging-service-${uuid()}"
    application = aws_elastic_beanstalk_application.logging-service.name
    description = "application version created by terraform"
    bucket      = "${aws_s3_bucket.dist_bucket.id}"
    key         = "${aws_s3_bucket_object.dist_item.id}"
}

output "app_version" {
    value = aws_elastic_beanstalk_application_version.default.name
}

output "env_name" {
    value = aws_elastic_beanstalk_environment.logging-environment.name
}
