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
    //    additional_settings = [
    //        {
    //            namespace   = "aws:elasticbeanstalk:application"
    //            name        = "Application Healthcheck URL"
    //            value       = "/actuator/health"
    //        }
    //    ]

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "IamInstanceProfile"
        value = "aws-elasticbeanstalk-ec2-role"
    }

}
