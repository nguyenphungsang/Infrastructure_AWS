//output.tf
output "bastion_host" {
  value = aws_instance.bastion_host.public_ip
}
output "private_master" {
  value = aws_instance.master.private_ip
}
output "private_node_1" {
  value = aws_instance.node_1.private_ip
}
output "private_node_2" {
  value = aws_instance.node_2.private_ip
}