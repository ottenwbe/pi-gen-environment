output "pi-builder-ip" {
  value = "${aws_instance.pi_builder_vm.public_ip}"
}