#Tabla de enrutamiento para la subred de aplicación
resource "aws_route_table" "rt-application" {
  count = var.subnet-count
  vpc_id = aws_vpc.eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat_gateway.*.id[count.index]
  }
  tags = {
    Name = format("%s-%s-%s","rt-application", var.aws-environment, var.project-name)
  }
}

#Tabla de enrutamiento para la subred de base de datos
resource "aws_route_table" "rt-database" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = format("%s-%s-%s","rt-database", var.aws-environment, var.project-name)
  }
}

#Tabla de enrutamiento para la subred de Gateway
resource "aws_route_table" "rt-gateway" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = format("%s-%s-%s","rt-gateway", var.aws-environment, var.project-name)
  }
}

#Asociando tabla de enrutamiento a la subred de aplicación
resource "aws_route_table_association" "rt-association-application" {
    count = var.subnet-count

    subnet_id      = aws_subnet.subnet-application.*.id[count.index]
    route_table_id = aws_route_table.rt-application.*.id[count.index]
}

#Asociando tabla de enrutamiento a la subred de base de datos
resource "aws_route_table_association" "rt-association-database" {
    count = var.subnet-count

    subnet_id      = aws_subnet.subnet-database.*.id[count.index]
    route_table_id = aws_route_table.rt-database.id
}

#Asociando tabla de enrutamiento a la subred de gateway
resource "aws_route_table_association" "rt-association-gateway" {
    count = var.subnet-count

    subnet_id = aws_subnet.subnet-gateway.*.id[count.index]
    route_table_id = aws_route_table.rt-gateway.id
}