resource "null_resource" "set_env" {
    provisioner "local-exec" {
        command = "mv ./file/config.cfg ~/.ssh/config"
    }
    provisioner "local-exec" {
        when    = destroy
        command = "rm -rf ~/.ssh/config"
    }
}