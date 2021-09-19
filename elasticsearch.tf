# https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html
resource "aws_instance" "elasticsearch" {
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

  provisioner "file" {
    source      = "./file"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch",
      "sudo mv /tmp/file/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo",
      "sudo yum -y install --enablerepo=elasticsearch elasticsearch",
      "sudo mv /tmp/file/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml",
      "sudo service elasticsearch start"
    ]
  }

  tags = {
    Name = "Elasticsearch"
  }
}