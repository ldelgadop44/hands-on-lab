#Creating security group for Application Load Balancer
resource "aws_security_group" "sg-eks-alb" {
  name        = format("%s-%s-%s", var.aws-environment, var.project-name, "sg-alb")
  description = "Security group allowing public traffic for the eks load balancer."
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
     Name = format("%s-%s-%s", var.aws-environment, var.project-name, "sg-alb"),
     format("%s%s-%s", "kubernetes.io/cluster/", var.aws-environment, var.project-name) = "owned"
  }
}

#Creating rule to ALB security group for allow public traffic in port 80
resource "aws_security_group_rule" "eks-alb-public-http" {
  description       = "Allow eks load balancer to communicate with public traffic."
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.sg-eks-alb.id
  to_port           = 80
  type              = "ingress"
}