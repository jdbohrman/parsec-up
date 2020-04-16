output "Administrator_Password" {
    value = rsadecrypt(aws_instance.this.password_data, module.ssh_key_pair.private_key)
}

output "public_subnet_ids" {
    value = "${module.subnets.public_subnet_ids}"
}
output "private_subnet_ids" {
    value = "${module.subnets.private_subnet_ids}"
}
