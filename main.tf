provider "aws" {
  region = "us-east-1"
}

# Create the VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create the Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create the public subnet in AZ-a
resource "aws_subnet" "public_subnet_az_a" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# Create the public subnet in AZ-b
resource "aws_subnet" "public_subnet_az_b" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

# Create the private subnet in AZ-a
resource "aws_subnet" "private_subnet_az_a" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
}

# Create the private subnet in AZ-b
resource "aws_subnet" "private_subnet_az_b" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
}

# Create the NAT Gateway in AZ-a
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_subnet_az_a.id
}

# Create the EIP for the NAT Gateway
resource "aws_eip" "my_eip" {
  vpc = true
}

# Create the route tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }

  tags = {
    Name = "private"
  }
}

# Associate the subnets with the route tables
resource "aws_route_table_association" "public_subnet_az_a_association" {
  subnet_id      = aws_subnet.public_subnet_az_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_az_b_association" {
  subnet_id      = aws_subnet.public_subnet_az_b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_az_a_association" {
  subnet_id      = aws_subnet.private_subnet_az_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_az_b_association" {
  subnet_id      = aws_subnet.private_subnet_az_b.id
  route_table_id = aws_route_table.private_route_table.id
}
