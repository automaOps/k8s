output "instance_public_ips" {
  value = aws_instance.rke2_nodes[*].public_ip
}

output "instance_names" {
  value = aws_instance.rke2_nodes[*].tags["Name"]
}