# AMI Update process

1. Change version of product on `Makefile`
2. Build `AMIs`: `make rsp`
3. Update cloudformation and AMIs table with the output of: `make parse-rsp-manifest`
4. Update CloudFormation template on S3