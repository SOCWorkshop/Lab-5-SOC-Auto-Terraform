resource "null_resource" "generate_ssh_key" {
    provisioner "local-exec" {
        command = "ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa"
    }
}

resource "aws_key_pair" "cloud9key" {
  key_name   = "cloud9key"
  public_key = file(pathexpand("~/.ssh/id_rsa"))
  depends_on = [
     null_resource.generate_ssh_key
  ]
}