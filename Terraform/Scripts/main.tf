terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
    # azurerm = {
    #   source = "hashicorp/azurerm"
    #   version = "4.26.0"
    # }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

resource "aws_vpc" "VPC" {
  cidr_block = "10.0.0.0/16"
  #instance_tenancy = "default"

  tags = {
    Name = "MyVpc"
  }
}

resource "aws_subnet" "Pub" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Pub-Sub"
  }
}

resource "aws_subnet" "Pvt" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Pvt-Sub"
  }
}

resource "aws_route_table" "Pub-RT" {
  vpc_id = aws_vpc.VPC.id

  #   route = []

  tags = {
    Name = "PUB-rt"
  }
}

resource "aws_route_table" "Pvt-RT" {
  vpc_id = aws_vpc.VPC.id

  route = []

  tags = {
    Name = "PVt-rt"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_eip" "eip" {
  #instance = aws_instance.web.id
  domain = "vpc"
}



resource "aws_nat_gateway" "vignesh" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.Pub.id

  tags = {
    Name = "NGW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}


resource "aws_route_table_association" "pub" {
  subnet_id      = aws_subnet.Pub.id
  route_table_id = aws_route_table.Pub-RT.id
}

resource "aws_route_table_association" "pvt" {
  subnet_id      = aws_subnet.Pvt.id
  route_table_id = aws_route_table.Pvt-RT.id
}

resource "aws_route" "Pub" {
  route_table_id            = aws_route_table.Pub-RT.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "Pvt" {
  route_table_id            = aws_route_table.Pvt-RT.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.vignesh.id
}