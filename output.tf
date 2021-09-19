output "elasticsearch-ip" {
  value = aws_instance.elasticsearch.public_ip
}