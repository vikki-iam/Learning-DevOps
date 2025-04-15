terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
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
  cidr_block       = "10.0.0.0/16"
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
  vpc_id = aws_vpc.example.id

  route = []

  tags = {
    Name = "PVt-rt"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "main"
  }
}

resource "aws_eip" "eip" {
  #instance = aws_instance.web.id
  domain   = "vpc"
}



resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.Pub.id

  tags = {
    Name = "NGW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}