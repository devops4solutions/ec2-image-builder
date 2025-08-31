
data "aws_imagebuilder_image" "rhel" {
  arn = "arn:aws:imagebuilder:us-east-1:aws:image/red-hat-enterprise-linux-rhel-for-aws-e9ca/2025.6.24"
}

data "aws_imagebuilder_component" "update_linux" {
  arn = "arn:aws:imagebuilder:us-east-1:aws:component/update-linux/x.x.x"
}

# IAM Role for Image Builder EC2 instances
resource "aws_iam_role" "image_builder_instance_role" {
  name = "EC2ImageBuilderInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach necessary managed policies for SSM and ECR (optional)
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.image_builder_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_attach" {
  role       = aws_iam_role.image_builder_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.image_builder_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Instance profile for Image Builder instances
resource "aws_iam_instance_profile" "image_builder_instance_profile" {
  name = "EC2ImageBuilderInstanceProfile"
  role = aws_iam_role.image_builder_instance_role.name
}

# Infrastructure configuration
resource "aws_imagebuilder_infrastructure_configuration" "infra_config" {
  name                 = "rhel-stig-infra"
  instance_types       = ["t2.medium"]
  instance_profile_name = aws_iam_instance_profile.image_builder_instance_profile.name
  terminate_instance_on_failure = false
  subnet_id = data.aws_subnets.private_subnet.ids[0]
  security_group_ids = [aws_security_group.sg.id]
  key_pair         = "shared"

}

# Image Builder recipe with the STIG hardening component
resource "aws_imagebuilder_image_recipe" "stig_recipe" {
  name         = "rhel-stig-hardening-recipe"
  version      = "1.0.0"
  parent_image = data.aws_imagebuilder_image.rhel.arn


  component {
    component_arn = data.aws_imagebuilder_component.update_linux.arn

  }
   /* component {
    component_arn = aws_imagebuilder_component.ssm_install.arn
    
  }*/
   component {
    component_arn = aws_imagebuilder_component.node_install.arn
    
  }

  component {
    component_arn = aws_imagebuilder_component.aws_install.arn
    
  }
  component {
    component_arn = aws_imagebuilder_component.stig_hardening.arn
    
  }

}

# Image Builder pipeline
resource "aws_imagebuilder_image_pipeline" "stig_pipeline" {
  name                              = "rhel-stig-hardening-pipeline"
  image_recipe_arn                  = aws_imagebuilder_image_recipe.stig_recipe.arn
  infrastructure_configuration_arn  = aws_imagebuilder_infrastructure_configuration.infra_config.arn
  distribution_configuration_arn = aws_imagebuilder_distribution_configuration.rhel_distribution.arn
  # Optional: schedule daily build - comment out if not needed
 /* schedule {
    schedule_expression = "cron(0 0 * * ? *)"
  }*/
}

