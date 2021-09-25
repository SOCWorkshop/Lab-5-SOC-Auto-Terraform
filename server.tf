resource "aws_instance" "server" {
  # due to aws limitation, we can't use ubuntu and must use amazon ami which is based on centos   
  ami           = "ami-087c17d1fe0178315" # us-west-1
  instance_type = "m5.large"

  key_name = aws_key_pair.cloud9key.key_name

  associate_public_ip_address = true

  root_block_device {
    volume_size = 30
  }

  vpc_security_group_ids = [aws_security_group.allow_access_to_system.id]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = tls_private_key.pk.private_key_pem
  }

  # the user is SOC , password is SocWorkshop1  
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y docker",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo chkconfig docker on",
      "sudo yum install -y git",
      "sudo curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/SOCWorkshop/Lab5-Application.git",
      "cd /home/ec2-user/Lab5-Application; echo ELASTICSEARCH=${aws_instance.elasticsearch.private_ip} > .env",
      "cd /home/ec2-user/Lab5-Application; echo KIBANA=${aws_instance.kibana.private_ip} > .env",
      "cd /home/ec2-user/Lab5-Application; docker-compose pull",
      "cd /home/ec2-user/Lab5-Application; docker-compose up -d"
    ]

  }

  tags = {
    Name = "Application-Server"
  }
}