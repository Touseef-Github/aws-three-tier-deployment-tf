data "aws_availability_zones" "available" {}


resource "aws_vpc" "VPC" {
  cidr_block           = var.VpcCIDR
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.EnvironmentName
  }
}

resource "aws_internet_gateway" "InternetGateway" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = var.EnvironmentName
  }
}

resource "aws_subnet" "PublicSubnet1" {
  vpc_id                  = aws_vpc.VPC.id
  availability_zone       = element(data.aws_availability_zones.available.names, 0)
  cidr_block              = var.PublicSubnet1CIDR
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.EnvironmentName} Public Subnet (AZ1)"
  }
}

resource "aws_subnet" "PublicSubnet2" {
  vpc_id                  = aws_vpc.VPC.id
  availability_zone       = element(data.aws_availability_zones.available.names, 1)
  cidr_block              = var.PublicSubnet2CIDR
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.EnvironmentName} Public Subnet (AZ2)"
  }
}

resource "aws_subnet" "PrivateSubnet1" {
  vpc_id                  = aws_vpc.VPC.id
  availability_zone       = element(data.aws_availability_zones.available.names, 0)
  cidr_block              = var.PrivateSubnet1CIDR
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.EnvironmentName} Private Subnet (AZ1)"
  }
}

resource "aws_subnet" "PrivateSubnet2" {
  vpc_id                  = aws_vpc.VPC.id
  availability_zone       = element(data.aws_availability_zones.available.names, 1)
  cidr_block              = var.PrivateSubnet2CIDR
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.EnvironmentName} Private Subnet (AZ2)"
  }
}

resource "aws_subnet" "PrivateSubnet3" {
  vpc_id                  = aws_vpc.VPC.id
  availability_zone       = element(data.aws_availability_zones.available.names, 3)
  cidr_block              = var.PrivateSubnet3CIDR
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.EnvironmentName} Private Subnet (AZ1)"
  }
}

resource "aws_subnet" "PrivateSubnet4" {
  vpc_id                  = aws_vpc.VPC.id
  availability_zone       = element(data.aws_availability_zones.available.names, 4)
  cidr_block              = var.PrivateSubnet4CIDR
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.EnvironmentName} Private Subnet (AZ2)"
  }
}

resource "aws_eip" "NatGateway1EIP" {
  domain   = "vpc"
  tags = {
    Name = "NAT-Gateway1-EIP"
  }
}

resource "aws_eip" "NatGateway2EIP" {
  domain   = "vpc"
  tags = {
    Name = "NAT-Gateway2-EIP"
  }
}

resource "aws_nat_gateway" "NatGateway1" {
  allocation_id = aws_eip.NatGateway1EIP.id
  subnet_id     = aws_subnet.PublicSubnet1.id
  tags = {
    Name = "NAT-Gateway1-Private-AZ-1"
  }
}

resource "aws_nat_gateway" "NatGateway2" {
  allocation_id = aws_eip.NatGateway2EIP.id
  subnet_id     = aws_subnet.PublicSubnet2.id
  tags = {
    Name = "NAT-Gateway2-Private-AZ-2"
  }
}

resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "${var.EnvironmentName} Public Routes"
  }
}

resource "aws_route" "DefaultPublicRoute" {
  route_table_id         = aws_route_table.PublicRouteTable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.InternetGateway.id
}

resource "aws_route_table_association" "PublicSubnet1RouteTableAssociation" {
  subnet_id      = aws_subnet.PublicSubnet1.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "PublicSubnet2RouteTableAssociation" {
  subnet_id      = aws_subnet.PublicSubnet2.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table" "PrivateRouteTable1" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "${var.EnvironmentName} Private Routes (AZ1)"
  }
}

resource "aws_route_table" "PrivateRouteTable2" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "${var.EnvironmentName} Private Routes (AZ2)"
  }
}

resource "aws_route_table" "PrivateRouteTable3" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "${var.EnvironmentName} Private Routes (AZ1)"
  }
}

resource "aws_route_table" "PrivateRouteTable4" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "${var.EnvironmentName} Private Routes (AZ2)"
  }
}

resource "aws_route" "DefaultPrivateRoute1" {
  route_table_id         = aws_route_table.PrivateRouteTable1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.NatGateway1.id
}

resource "aws_route" "DefaultPrivateRoute2" {
  route_table_id         = aws_route_table.PrivateRouteTable2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.NatGateway2.id
}

resource "aws_route" "DefaultPrivateRoute3" {
  route_table_id         = aws_route_table.PrivateRouteTable3.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.NatGateway1.id
}

resource "aws_route" "DefaultPrivateRoute4" {
  route_table_id         = aws_route_table.PrivateRouteTable4.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.NatGateway2.id
}

resource "aws_route_table_association" "PrivateSubnet1RouteTableAssociation" {
  subnet_id      = aws_subnet.PrivateSubnet1.id
  route_table_id = aws_route_table.PrivateRouteTable1.id
}

resource "aws_route_table_association" "PrivateSubnet2RouteTableAssociation" {
  subnet_id      = aws_subnet.PrivateSubnet2.id
  route_table_id = aws_route_table.PrivateRouteTable2.id
}

resource "aws_route_table_association" "PrivateSubnet3RouteTableAssociation" {
  subnet_id      = aws_subnet.PrivateSubnet3.id
  route_table_id = aws_route_table.PrivateRouteTable3.id
}

resource "aws_route_table_association" "PrivateSubnet4RouteTableAssociation" {
  subnet_id      = aws_subnet.PrivateSubnet4.id
  route_table_id = aws_route_table.PrivateRouteTable4.id
}

# resource "aws_security_group" "NoIngressSecurityGroup" {
#   name        = "no-ingress-sg"
#   description = "Security group with no ingress rule"
#   vpc_id      = aws_vpc.VPC.id
# }


######################################
