resource "null_resource" "set_env" {
  provisioner "local-exec" {
    command = "mv ./file/config.cfg ~/.ssh/config"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ~/.ssh/config"
  }
}

resource "null_resource" "set_etc_host" {
  provisioner "local-exec" {
    command = "sudo cp /etc/hosts /etc/hosts.bak"
  }

  provisioner "local-exec" {
    command = <<EOT
      "sudo -- sh -c \"echo ${aws_instance.elasticsearch.public_ip} elasticsearch >> /etc/hosts\""
      "sudo -- sh -c \"echo ${aws_instance.kibana.public_ip} kibana >> /etc/hosts\""
      "sudo -- sh -c \"echo ${aws_instance.server.public_ip} application >> /etc/hosts\""
      "sudo -- sh -c \"echo ${aws_instance.attack.public_ip} attacker >> /etc/hosts\""
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sudo mv /etc/hosts.bak /etc/hosts"
  }
}