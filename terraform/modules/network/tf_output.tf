#Devolviendo el id del VPC para otros módulos
output "vpc_id" {
  value = aws_vpc.eks-vpc.id
}

#Devolviendo el los id's de la subred de aplicación para otros módulos
output "app_subnet_ids" {
  value = aws_subnet.subnet-application.*.id
}

#Devolviendo el los id's de la subred de gateway para otros módulos
output "gt_subnet_ids" {
  value = aws_subnet.subnet-gateway.*.id
}