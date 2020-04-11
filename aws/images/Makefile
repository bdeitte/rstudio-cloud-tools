SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

RSP_VERSION ?= 1.2.5033-1
RSC_VERSION ?= 1.8.2-10
RSPM_VERSION ?= 1.1.4-3

DATE ?= $(shell date +"%Y/%m/%d")

all: help


.PHONY: rsp
rsp:  ## Build RSP AMIs
	PACKER_LOG=1 RSP_VERSION=$(RSP_VERSION) \
	packer build --only=amazon-ebs rsp.json >> rsp.log 2>&1


.PHONY: parse-rsp-manifest
parse-rsp-manifest:  ## Parse the rsp-manifest.json and print the CloudFormation AMIs text
	@echo "CloudFormation:"
	@cat rsp-manifest.json | jq -r '.builds[0].artifact_id' |  awk -v RS=',' '1' | awk -F':' 'NF > 1 {print "  "$$1":\n    AMI: "$$2}' | (echo "RSPRegionMap:"; cat -;)
	@echo ""
	@echo "MD Table:"
	@cat rsp-manifest.json | jq -r '.builds[0].artifact_id' |  awk -v RS=',' '1' | awk -F':' 'NF > 1 {print "| $(RSP_VERSION) | "$$1" | "$$2" | $(DATE) |"}'


.PHONY: rsc
rsc:  ## Build RSC AMIs
	PACKER_LOG=1 RSC_VERSION=$(RSC_VERSION) \
	packer build --only=amazon-ebs rsc.json >> rsc.log 2>&1


.PHONY: parse-rsc-manifest
parse-rsc-manifest:  ## Parse the rsc-manifest.json and print the CloudFormation AMIs text
	@echo "CloudFormation:"
	@cat rsc-manifest.json | jq -r '.builds[0].artifact_id' |  awk -v RS=',' '1' | awk -F':' 'NF > 1 {print "  "$$1":\n    AMI: "$$2}' | (echo "RSCRegionMap:"; cat -;)
	@echo ""
	@echo "MD Table:"
	@cat rsc-manifest.json | jq -r '.builds[0].artifact_id' |  awk -v RS=',' '1' | awk -F':' 'NF > 1 {print "| $(RSC_VERSION) | "$$1" | "$$2" | $(DATE) |"}'


.PHONY: rspm
rspm:  ## Build RSPM AMIs
	PACKER_LOG=1 RSPM_VERSION=$(RSPM_VERSION) \
	packer build --only=amazon-ebs rspm.json >> rspm.log 2>&1


.PHONY: parse-rspm-manifest
parse-rspm-manifest:  ## Parse the rspm-manifest.json and print the CloudFormation AMIs text
	@echo "CloudFormation:"
	@cat rspm-manifest.json | jq -r '.builds[0].artifact_id' |  awk -v RS=',' '1' | awk -F':' 'NF > 1 {print "  "$$1":\n    AMI: "$$2}' | (echo "RSPMRegionMap:"; cat -;)
	@echo ""
	@echo "MD Table:"
	@cat rspm-manifest.json | jq -r '.builds[0].artifact_id' |  awk -v RS=',' '1' | awk -F':' 'NF > 1 {print "| $(RSPM_VERSION) | "$$1" | "$$2" | $(DATE) |"}'


.PHONY: clean
clean:  ## Clean build files
	@rm -rf *.log *-manifest.json


.PHONY: help
help:  ## Show this help menu
	@grep -E '^[0-9a-zA-Z_-]+:.*?##.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##"; OFS="\t\t"}; {printf "\033[36m%-30s\033[0m %s\n", $$1, ($$2==""?"":$$2)}'
