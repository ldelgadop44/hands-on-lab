#Internet Gateway permite configurar la salida a internet desde las subredes previamente creadas
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id  = aws_vpc.eks-vpc.id
    tags    = {
        Name = format("%s-%s-%s","ig",var.aws-environment, var.project-name)
    }    
}

#las IP's Elásticas permiten establecer comunicación entre NAT gateway e Internet
resource "aws_eip" "eip_nat_gateway" {
    count   = var.subnet-count
    vpc     = true
    tags    = {
        Name = format("%s-%s-%s","eip-nat-gw", var.aws-environment, var.project-name)
    }
}

#Nat gateway permite controlar el ingreso desde internet a las instancias en la subred de aplicación
resource "aws_nat_gateway" "eks_nat_gateway" {
    count           = var.subnet-count
    allocation_id   = aws_eip.eip_nat_gateway.*.id[count.index]
    subnet_id       = aws_subnet.subnet-gateway.*.id[count.index]
    tags            = {
        Name = format("%s-%s-%s","nat-gw", var.aws-environment, var.project-name)
    }
    depends_on = [
        aws_internet_gateway.internet_gateway
    ]
}
