provider "aws" {
  region = "us-east-1"
}


# VPC

resource "aws_vpc" "us-vpc" {
  cidr_block           = "10.0.0.0/22"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-us-vpc"
  }
}


# SUBNETS PÚBLICAS 

resource "aws_subnet" "us-sub-pub-1a" {
  vpc_id                  = aws_vpc.us-vpc.id
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-1a"
  }
}

resource "aws_subnet" "us-sub-pub-1b" {
  vpc_id                  = aws_vpc.us-vpc.id
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-1b"
  }
}


# SUBNETS PRIVADAS 

resource "aws_subnet" "us-sub-priv-1a" {
  vpc_id                  = aws_vpc.us-vpc.id
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-subnet-1a"
  }
}

resource "aws_subnet" "us-sub-priv-1b" {
  vpc_id                  = aws_vpc.us-vpc.id
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-subnet-1b"
  }
}


# INTERNET GATEWAY

resource "aws_internet_gateway" "us-igw" {
  vpc_id = aws_vpc.us-vpc.id

  tags = {
    Name = "${var.project_name}-us-igw"
  }
}


# EIP + NAT GATEWAY (em subnet pública 1a)

resource "aws_eip" "us-nat-eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-us-nat-eip"
  }
}

resource "aws_nat_gateway" "us-natgw" {
  allocation_id = aws_eip.us-nat-eip.id
  subnet_id     = aws_subnet.us-sub-pub-1a.id

  tags = {
    Name = "${var.project_name}-us-natgw"
  }

  depends_on = [aws_internet_gateway.us-igw]
}


# ROUTE TABLES


# Rota pública (para subnets públicas)
resource "aws_route_table" "us-public-rt" {
  vpc_id = aws_vpc.us-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.us-igw.id
  }

  tags = {
    Name = "${var.project_name}-us-public-rt"
  }
}

# Associação das subnets públicas
resource "aws_route_table_association" "us-pub-1a-assoc" {
  subnet_id      = aws_subnet.us-sub-pub-1a.id
  route_table_id = aws_route_table.us-public-rt.id
}

resource "aws_route_table_association" "us-pub-1b-assoc" {
  subnet_id      = aws_subnet.us-sub-pub-1b.id
  route_table_id = aws_route_table.us-public-rt.id
}

# Rota privada (para subnets privadas via NAT)
resource "aws_route_table" "us-private-rt" {
  vpc_id = aws_vpc.us-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.us-natgw.id
  }

  tags = {
    Name = "${var.project_name}-us-private-rt"
  }
}

# Associação das subnets privadas
resource "aws_route_table_association" "us-priv-1a-assoc" {
  subnet_id      = aws_subnet.us-sub-priv-1a.id
  route_table_id = aws_route_table.us-private-rt.id
}

resource "aws_route_table_association" "us-priv-1b-assoc" {
  subnet_id      = aws_subnet.us-sub-priv-1b.id
  route_table_id = aws_route_table.us-private-rt.id
}
