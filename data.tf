
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


data "aws_imagebuilder_image" "rhel" {
  arn = "arn:aws:imagebuilder:us-east-1:aws:image/red-hat-enterprise-linux-rhel-for-aws-e9ca/2025.6.24"
}

data "aws_imagebuilder_component" "update_linux" {
  arn = "arn:aws:imagebuilder:us-east-1:aws:component/update-linux/x.x.x"
}
