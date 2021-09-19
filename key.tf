# generate private key
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "cloud9key" {
  key_name   = "cloud9key"      
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ${pathexpand("~/.ssh/id_rsa")}"
  }
}