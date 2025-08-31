resource "aws_imagebuilder_distribution_configuration" "rhel_distribution" {
  name = "rhel-stig-distribution"
  distribution {
    region = "us-east-1" # Region where you’re building AMI

    ami_distribution_configuration {
      name = "rhel-stig-{{ imagebuilder:buildDate }}"
      description = "RHEL STIG hardened AMI built on {{ imagebuilder:buildDate }}"

     /* launch_permission {
        user_ids = ["xxxxxx"] # Target AWS Account ID
      }*/
    }
  }
}
