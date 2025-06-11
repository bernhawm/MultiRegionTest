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