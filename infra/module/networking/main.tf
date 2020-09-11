# Using default VPC for demo purposes. You should create new VPC and subnets
resource "aws_default_vpc" "default_vpc" {
}

# Providing a reference to our default subnets
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "us-east-1a"
}

# Providing a reference to our default subnets
resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "us-east-1b"
}
