#Creating security group for EKS master
resource "aws_security_group" "sg-eks-master" {
    name        = format("%s-%s-%s", var.aws-environment, var.project-name, "master-sg")
    description = "Cluster communication with worker nodes"
    vpc_id      = var.vpc_id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = format("%s-%s-%s", var.aws-environment, var.project-name, "master-sg")
    }
}