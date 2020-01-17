resource "aws_lb_target_group" "alb-target-group-eks" {
  name = format("%s-%s-%s", "alb-tg", var.aws-environment, var.project-name)
  port = 31742
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"
}

resource "aws_alb" "eks-alb" {
  name            = format("%s-%s-%s", "alb", var.aws-environment, var.project-name)
  subnets         = var.gt_subnet_ids
  security_groups = [var.sg-eks-worker, var.sg-eks-alb]
  ip_address_type = "ipv4"
  
  tags = {
     Name = format("%s-%s-%s", var.aws-environment, var.project-name, "alb"),
     format("%s%s-%s", "kubernetes.io/cluster/", var.aws-environment, var.project-name) = "owned"
  }
}

resource "aws_alb_listener" "eks-alb" {
  load_balancer_arn = aws_alb.eks-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group-eks.arn
  }
}