output "zookeeper_connect_string" {
  value = aws_msk_cluster.example.zookeeper_connect_string
}

output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = aws_msk_cluster.example.bootstrap_brokers_tls
}

output "subnet_cidrs" {
  description = "Subnet CIDRs"
  value       = aws_subnet.main.cidr_block
  
}
output "msk_cluster_arn" {
  description = "MSK Cluster ARN"
  value       = aws_msk_cluster.example.arn
  
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = aws_subnet.main[*].id
}

output "msk_security_group_ids" {
  description = "List of security group IDs for the MSK cluster"
  value       = aws_security_group.sg[*].id
  
}