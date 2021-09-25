resource "null_resource" "set_env" {
  provisioner "local-exec" {
    command = "cp ./file/config.cfg ~/.ssh/config; chmod 600 ~/.ssh/config"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ~/.ssh/config;  rm -rf ~/.ssh/known_hosts"
  }
}

resource "null_resource" "set_etc_host" {
  provisioner "local-exec" {
    command = "sudo cp /etc/hosts /etc/hosts.bak"
  }

  provisioner "local-exec" {
    command = <<EOT
      "echo ${aws_instance.elasticsearch.private_ip} elasticsearch | sudo tee -a /etc/hosts"
      "echo ${aws_instance.kibana.private_ip} kibana | sudo tee -a /etc/hosts"
      "echo ${aws_instance.server.private_ip} application | sudo tee -a /etc/hosts"
      "echo ${aws_instance.attack.private_ip} attacker | sudo tee -a /etc/hosts"
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sudo mv /etc/hosts.bak /etc/hosts"
  }
}