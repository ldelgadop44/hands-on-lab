#Creating security group for EKS worker
resource "aws_security_group" "sg-eks-worker" {
    name        = format("%s-%s-%s", var.aws-environment, var.project-name, "worker-sg")
    description = "Security group for all nodes in the cluster"
    vpc_id      = var.vpc_id
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = format("%s-%s-%s", var.aws-environment, var.project-name, "worker-sg")
    }
}