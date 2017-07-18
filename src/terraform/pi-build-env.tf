/* Setup the aws provider */
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

/* Define the vpc */
resource "aws_vpc" "pi_builder_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    name = "pi-builder vpc"
  }
}

/** key for deployment of jumpbox and nat */
resource "aws_key_pair" "pi_builder_key" {
  key_name = "pi-builder"
  public_key = "${file("../ssh/pi-builder")}"
}


/** pi-build-vm instance */
resource "aws_instance" "pi_builder_vm" {
  ami = "${lookup(var.amis, var.region)}"
  availability_zone = "${var.default_az}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.pi_builder_subnet.id}"

  root_block_device {
    delete_on_termination = true
    iops = 0
    volume_size = 50
    volume_type = "gp2"
  }

  vpc_security_group_ids = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.http.id}"]
  key_name = "${aws_key_pair.pi_builder_key.key_name}"

  provisioner "remote-exec" {
    connection {
      user = "ubuntu"
      host = "${aws_instance.pi_builder_vm.public_dns}"
      timeout = "25m"
      private_key = "${file("../ssh/pi-builder.ppk")}"
    }
    inline = [
      "sudo apt update",
      "sudo apt -y install quilt qemu-user-static debootstrap pxz zip bsdtar",
      "git clone quilt qemu-user-static debootstrap pxz zip bsdtar",
      "cd pi-gen",
      "echo \"IMG_NAME=chiipi\" > config",
      "sudo ./build.sh",
    ]
  }

  tags = {
    name = "pi-builder vm"
  }
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.pi_builder_vm.id}"
  vpc = true
}

resource "aws_security_group" "ssh" {
  name = "ssh"
  description = "SSH access to instances from the internet"
  vpc_id = "${aws_vpc.pi_builder_vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags {
    name = "ssh sg"
  }
}

resource "aws_security_group" "http" {

  name = "http"
  description = "Outbound http(s) connections."
  vpc_id = "${aws_vpc.pi_builder_vpc.id}"

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags {
    name = "http sg"
  }
}

/** internet access */
resource "aws_internet_gateway" "pi_builder_gateway" {
  vpc_id = "${aws_vpc.pi_builder_vpc.id}"
}


/** public subnet for the nat instance and the jumpbox */
resource "aws_subnet" "pi_builder_subnet" {
  vpc_id = "${aws_vpc.pi_builder_vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${var.default_az}"
  map_public_ip_on_launch = true
  depends_on = [
    "aws_internet_gateway.pi_builder_gateway"]

  tags {
    name = "pi-builder subnet"
  }
}

resource "aws_route_table" "pi_builder_rt" {
  vpc_id = "${aws_vpc.pi_builder_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.pi_builder_gateway.id}"
  }

  tags {
    name = "pi-builder rt"
  }
}

resource "aws_route_table_association" "pi_builder_rta" {
  subnet_id = "${aws_subnet.pi_builder_subnet.id}"
  route_table_id = "${aws_route_table.pi_builder_rt.id}"
}
