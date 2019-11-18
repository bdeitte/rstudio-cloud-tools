# RStudio Cloud tools

This repository contains tools and utilities to deploy RStudio proffesional products to cloud environments.

## AWS CloudFormation

Deploys a RStudio Team on EC2 instances.

Try it out: [![AWS Cloudformation](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?templateURL=https://rstudio-cloud-tools-temp.s3.amazonaws.com/rstudio-team.yml&stackName=RStudioTeam)

Note: To try on AWS, you should have:

- An AWS key pair created
- Permission to create EC2 Instances and Security Groups
- A target VPC and subnet created

The inputs required during deployment are:

|Input Parameter|Description |
|---|---|
| Stack name | Name of the stack. |
| Deploy to VPC | VPC to deploy the cluster into.|
| Deploy to Subnet | Subnet to deploy the cluster into. Must be in the selected VPC.|
| AWS keypair | AWS key pair to use to SSH to the VMs. SSH username for the VMs are centos (has sudo privilege). SSH into machines for changing configuration, reviewing logs, etc. |

Once the deployment is successful, you will find the URL to RStudio Products UI in the output section of the deployment.
