output "Administrator_Password" {
value = "${rsadecrypt(aws_instance.this.password_data, file("${module.ssh_key_pair.private_key_filename}"))}"
}