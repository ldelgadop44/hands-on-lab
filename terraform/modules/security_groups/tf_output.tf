output "sg-eks-master" {
  value = aws_security_group.sg-eks-master.id
}

output "sg-eks-worker" {
  value = aws_security_group.sg-eks-worker.id
}

output "sg-eks-alb" {
  value = aws_security_group.sg-eks-alb.id
}