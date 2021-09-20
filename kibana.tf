data "template_file" "kibana" {
 #template = file("~/environment/workspace/aws-infra/rll-prod/modules/single-service-cluster/user_data.yaml")
  template = file("./file/kibana.yml")
  vars = {
    elasticsearch = aws_instance.elasticsearch.private_ip
 }
}


# hhttps://www.elastic.co/guide/en/kibana/current/rpm.html
resource "aws_instance" "kibana" {
  # due to aws limitation, we can't use ubuntu and must use amazon ami which is based on centos   
  ami           = "ami-087c17d1fe0178315" # us-west-1
  instance_type = "t2.micro"

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

  provisioner "file" {
    content = data.template_file.kibana.rendered
    destination = "/tmp/kibana.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch",
      "sudo mv /tmp/file/kibana.repo /etc/yum.repos.d/kibana.repo",
      "sudo yum -y install --enablerepo=kibana kibana",
      "sudo mv /tmp/kibana.yml /etc/kibana/kibana.yml",
      "sudo service kibana start",
      "sudo service kibana enable"
    ]
  }

  tags = {
    Name = "Kibana"
  }
}