
data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "public_subnet" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*public*"] # This matches all subnets with a Name tag
  }
}

data "aws_subnets" "private_subnet" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*private*"] # This matches all subnets with a Name tag
  }
}