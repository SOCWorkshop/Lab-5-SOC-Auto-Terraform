output "elasticsearch-ip" {
  value = aws_instance.elasticsearch.public_ip
}

output "kibana-ip" {
  value = aws_instance.kibana.public_ip
}