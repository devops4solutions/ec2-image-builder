resource "aws_security_group" "sg" {
  name        = "ami-sg"
  description = "ami security group"
  vpc_id      = var.vpc_id  # Pass your VPC ID as a variable

  # Inbound rules (Ingress)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.selected.cidr_block] # # Allow SSH from anywhere (modify as needed)
  }

  # Outbound rules (Egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "shared-sg"
  }
}
