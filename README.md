# Terraform deployment

## pre-requisites
1. terraform version > v0.14.4
1. create a s3 bucket with the name `twelve-factor-terraform-state`
1. create a dynamodb_table with the name `twelve-factor-terraform-lock`

## verify that everything is ready for deployment

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
## Deployment

```sh
cd scripts
./pipeline
```
## Use your environment with eb cli (optional)

```sh
eb init -r eu-central-1

Select an application to use
1) logging-service-ns-ac
2) [ Create new Application ]
(default is 2): 1
Do you wish to continue with CodeCommit? (y/N) (default is n): n
```
