data "template_file" "elasticsearch-nginx" {
 #template = file("~/environment/workspace/aws-infra/rll-prod/modules/single-service-cluster/user_data.yaml")
  template = file("./file/nginx.conf")
  vars = {
    port = "9200"
 }
}

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

  provisioner "file" {
    content = data.template_file.kibana_nginx.rendered
    destination = "/tmp/elasticsearch.conf"
  }

  # the user is SOC , password is SocWorkshop1  
  provisioner "remote-exec" {
    inline = [
      "sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch",
      "sudo mv /tmp/file/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo",
      "sudo yum -y install --enablerepo=elasticsearch elasticsearch",
      "sudo mv /tmp/file/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml",
      "sudo service elasticsearch start",
      "sudo systemctl enable elasticsearch",
      "sudo amazon-linux-extras install -y nginx1",
      "sudo systemctl enable nginx",
      "sudo mv /tmp/elasticsearch.conf /etc/nginx/conf.d/elasticsearch.conf",
      "sudo mv /tmp/file/htpassword.users /etc/nginx/htpasswd.users",
      "sudo service nginx restart",
      "sudo rm -rf /tmp/file"
    ]
  }

  tags = {
    Name = "Elasticsearch"
  }
}