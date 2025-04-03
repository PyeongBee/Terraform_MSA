output "main_vpc_id" {
  description = "The ID of VPC"
  value       = aws_vpc.main.id
}

output "this_vpc_cidr_block" {
  description = "The CIDR IP Range Block of VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "The List of Public Subnet ID of VPC"
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "The List of Private Subnet ID of VPC"
  value       = aws_subnet.private.*.id
}

output "this_internet_gateway_id" {
  description = "The ID of Internet Gateway of VPC"
  value       = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  description = "The ID of Route Table for Public Subnet"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "The ID of Route Table for Private Subnet"
  value       = aws_route_table.private.id
}

output "this_nat_gateway_id" {
  description = "The ID of NAT Gateway of VPC"
  value       = aws_nat_gateway.nat.id
}

output "admin_security_group_id" {
  description = "The ID of Security Group for Admin access"
  value       = aws_security_group.admin.id
}

output "private_instances_security_group_id" {
  description = "The ID of Security Group for Private Instances access"
  value       = aws_security_group.private_instances-sg.id
}

output "rds_security_group_id" {
  description = "The ID of Security Group for RDS access"
  value       = aws_security_group.private_database-sg.id
}


