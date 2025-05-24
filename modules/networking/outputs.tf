output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_a_id" {
  description = "ID of the public subnet in AZ A"
  value       = aws_subnet.public_a.id
}

output "public_subnet_b_id" {
  description = "ID of the public subnet in AZ B"
  value       = aws_subnet.public_b.id
}

output "private_subnet_a_id" {
  description = "ID of the private subnet in AZ A"
  value       = aws_subnet.private_a.id
}

output "private_subnet_b_id" {
  description = "ID of the private subnet in AZ B"
  value       = aws_subnet.private_b.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
} 