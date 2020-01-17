#Creando VPC para alojar todos los recursos del cluster
resource "aws_vpc" "eks-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
     Name = format("%s-%s-%s", "vpc", var.aws-environment, var.project-name),
     format("%s%s-%s", "kubernetes.io/cluster/", var.aws-environment, var.project-name) = "shared"
  }
}