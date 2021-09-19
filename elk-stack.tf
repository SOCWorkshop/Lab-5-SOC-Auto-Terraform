resource "aws_instance" "elasticsearch" {
  ami           = "ami-09e67e426f25ce0d7" # us-west-1
  instance_type = "t2.micro"

  key_name = aws_key_pair.cloud9key.key_name

  associate_public_ip_address = true

  root_block_device = {
      volume_size = 30
  }

  tags = {
    Name = "Elasticsearch"
  }
}