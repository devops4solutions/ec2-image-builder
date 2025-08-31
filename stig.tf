resource "aws_imagebuilder_component" "stig_hardening" {
  name                = "stig-build-linux-custom"
  platform            = "Linux"
  version             = "1.0.0"
  description         = "Custom STIG component with defaults for Level, InstallPackages, and SetDoDConsentBanner"
  data                = file("${path.module}/files/stig.yml")
  supported_os_versions = [
    "Amazon Linux 2",
    "Amazon Linux 2023",
    "Red Hat Enterprise Linux 7",
    "Red Hat Enterprise Linux 8",
    "Red Hat Enterprise Linux 9",
    "Ubuntu 18.04",
    "Ubuntu 20.04",
    "Ubuntu 22.04",
    "Ubuntu 24.04"
  ]
  tags = {
    Environment = "Hardening"
  }
}

resource "aws_imagebuilder_component" "ssm_install" {
  name                = "ssm-install"
  platform            = "Linux"
  version             = "1.0.0"
  description         = "SSM Installation"
  data                = file("${path.module}/files/ssm-agent.yml")

}

resource "aws_imagebuilder_component" "node_install" {
  name                = "node-install"
  platform            = "Linux"
  version             = "1.0.0"
  description         = "Node Installation"
  data                = file("${path.module}/files/node.yml")

}

resource "aws_imagebuilder_component" "aws_install" {
  name                = "aws-install"
  platform            = "Linux"
  version             = "1.0.0"
  description         = "AWS Installation"
  data                = file("${path.module}/files/aws_cli.yaml")

}