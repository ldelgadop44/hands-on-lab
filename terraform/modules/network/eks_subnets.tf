#Obteniendo zonas de disponibilidad
data "aws_availability_zones" "available" {}

#Creando subred de gateway
resource "aws_subnet" "subnet-gateway" {
  count = var.subnet-count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.1${count.index}.0/24"
  vpc_id            = aws_vpc.eks-vpc.id
  tags = {
      Name = format("%s-%s-%s", "gt", var.aws-environment, var.project-name)
  }
}

#Creando subred de aplicación
resource "aws_subnet" "subnet-application" {
  count = var.subnet-count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.2${count.index}.0/24"
  vpc_id            = aws_vpc.eks-vpc.id
  tags = {
      Name = format("%s-%s-%s", "app", var.aws-environment, var.project-name)
  }
}

#Creando subred de base de datos
resource "aws_subnet" "subnet-database" {
  count = var.subnet-count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.3${count.index}.0/24"
  vpc_id            = aws_vpc.eks-vpc.id  
  tags = {
      Name = format("%s-%s-%s", "db", var.aws-environment, var.project-name)
  }
}