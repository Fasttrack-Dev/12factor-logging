# 12 factor logging example

This example should help to experience the logging setup.
The example based on Infrastructure as Code and we provide examples for _Cloud Formation_ and _Terraform_.

## Getting started

First clone this project

```sh
git clone git@github.com:Fasttrack-Dev/12factor-logging.git
cd 12factor-logging
```

## Use Cloud Formation to deploy

### pre-requisites

It's necessary to have the following tools setup on the machine the script is executed.

- gradle
- java 8 or 11
- aws cli

setup the Parameters in the parameter store:

- `ssm:/dev/12factor/logging-service/hec-token`
- `ssm:/dev/12factor/logging-service/newrelic-license-key`

verify with the following commands, if the setup is correct:

```sh
aws ssm get-parameter --name /dev/12factor/logging-service/hec-token
aws ssm get-parameter --name /dev/12factor/logging-service/newrelic-license-key
```

### deployment

```sh
./pipeline
```

```console
Building binary
Using B252D3E2-7AD6-4BCA-8070-862121C2AFF2 as build version
...
{
    "EnvironmentName": "12factor-logging",
    ...
    "CNAME": "12factor-logging.*.elasticbeanstalk.com",
...
}
...
```

Verfiy the deployment with a the following simple `curl` from the command line. The host name value for the request, could be taken from the deployment output value "CNAME".

```sh
bash$ curl -iv -X POST 'http://12factor-logging.*.elasticbeanstalk.com/logs/info' --data "hallo" --header "Content-Type: text/plain"
```

the request should respond with HTTP 200 for ok. Now goto your Splunk Web Console and query for the `index="playroom-e"`

### Config

The most of the interesting file are in the [shell](./shell) or in the [ebs](./ebs) folder.

### Use your environment with eb cli (optional)

```sh
eb init -r eu-central-1

Select an application to use
1) logging-service-ns-ac
2) [ Create new Application ]
(default is 2): 1
Do you wish to continue with CodeCommit? (y/N) (default is n): n
```

## Terraform

### pre-requisites

For the use of terraform, the following needs be done before hand:

1. terraform version > v0.14.4
1. create a s3 bucket with the name `twelve-factor-terraform-state`
1. create a dynamodb_table with the name `twelve-factor-terraform-lock`

### verify that everything is ready for deployment

```sh
terraform init
```

Verify that you deploy in a clean env, no changes should appear.

```sh
terraform plan
```

```tf
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
...
```
