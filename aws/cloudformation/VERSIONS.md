# CloudFormation Product Versions

The CloudFormation templates provided here is intended to be easily
customisable to different RStudio product versions by simply changing the AMIs
([list here](https://github.com/rstudio/rstudio-cloud-tools/master/aws/images/AMIs.md)).

While RStudio products integrations work between multiple product versions
we provide versioned CloudFormation templates that have been validated to work together.

| CF Bundle Version | RSP Version | RSC Version | RSPM Version | Link |
| --- | --- | --- | --- | --- |
| latest (1.1.0) | 1.2.5042-1 | 1.8.2-10 | 1.1.4-3 | [Launch on AWS](https://console.aws.amazon.com/cloudformation/home?#/stacks/new?templateURL=https://rstudio-cloud-tools.s3.amazonaws.com/rstudio-standalone.yml&stackName=RStudioTeam) |
| 1.1.0 | 1.2.5042-1 | 1.8.2-10 | 1.1.4-3 | [Launch on AWS](https://console.aws.amazon.com/cloudformation/home?#/stacks/new?templateURL=https://rstudio-cloud-tools.s3.amazonaws.com/cloudformation/rstudio-standalone-1.1.0.yml&stackName=RStudioTeam-1-1-0) |
| 1.0.0 | 1.2.5033-1 | 1.7.8-7 | 1.1.0.1-17 | [Launch on AWS](https://console.aws.amazon.com/cloudformation/home?#/stacks/new?templateURL=https://rstudio-cloud-tools.s3.amazonaws.com/cloudformation/rstudio-standalone-1.0.0.yml&stackName=RStudioTeam-1-0-0) |
