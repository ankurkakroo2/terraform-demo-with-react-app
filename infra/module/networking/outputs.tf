output "subnet_1" {
  value = aws_default_subnet.default_subnet_a
}

output "subnet_2" {
  value = aws_default_subnet.default_subnet_b
}

output "vpc_id" {
  value = aws_default_vpc.default_vpc.id
}
