# ec2-image-builder
Infrastructure-as-Code setup for building secure, reusable Amazon Machine Images (AMIs) with AWS EC2 Image Builder.

This repository provides:

✅ Automated pipelines to create, test, and distribute AMIs across multiple AWS accounts/regions.

✅ Integration with Terraform / CloudFormation / Ansible (customize per your setup).

✅ Example recipes, components, and pipelines for installing common software (e.g., Nginx, Node.js, security agents).

✅ Support for STIG-compliant / hardened images (customizable policies).

Use case: Build golden images for Dev, Test, and Prod environments—ensuring consistency, security, and compliance across your AWS Organization.