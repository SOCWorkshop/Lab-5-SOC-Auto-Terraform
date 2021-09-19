output "elasticsearch-ip" {
  value = "${aws_instance.elasticsearch.0.public_ip}"
}