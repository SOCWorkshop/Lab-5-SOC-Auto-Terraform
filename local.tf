resource "null_resource" "set_env" {
  provisioner "local-exec" {
    command = "cp ./file/config.cfg ~/.ssh/config"
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
      "sudo -- sh -c \"echo ${aws_instance.elasticsearch.private_ip} elasticsearch >> /etc/hosts\""
      "sudo -- sh -c \"echo ${aws_instance.kibana.private_ip} kibana >> /etc/hosts\""
      "sudo -- sh -c \"echo ${aws_instance.server.private_ip} application >> /etc/hosts\""
      "sudo -- sh -c \"echo ${aws_instance.attack.private_ip} attacker >> /etc/hosts\""
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sudo mv /etc/hosts.bak /etc/hosts"
  }
}