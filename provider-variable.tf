# AWS Provider
provider "aws" {
  profile = "rprofile"
  region  = "ap-south-1"
}

# Get default VPC of account
data "aws_vpc" "selected" {
  default = true
}

# Get live availability zones list
data "aws_availability_zones" "available" {
  state = "available"
}

# Get the list of subnet ids in selected VPC
data "aws_subnet_ids" "example" {
  vpc_id = data.aws_vpc.selected.id
}