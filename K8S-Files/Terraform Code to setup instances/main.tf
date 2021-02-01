provider "aws" {
  region  = "${var.region}"
  shared_credentials_file = "${var.credentials}"

}

resource "aws_instance" "master" {
  ami = "${var.ami}"
  instance_type = "${var.master_instance_type}"
  security_groups = [ "${var.sg}" ]
  key_name = "${var.key}"
  user_data = file("${var.user_data}")
 
   tags = {
    Name = "master"
  }

}

resource "aws_instance" "nodes" {
  count = "${var.number_of_nodes}"
  ami = "${var.ami}"
  instance_type = "${var.node_instance_type}"
  #instance_type = "${var.master_instance_type}"
  security_groups = [ "${var.sg}" ]
  key_name = "${var.key}"
  user_data = file("${var.user_data}")
 
   tags = {
    Name = "node-${count.index+1}"
  }
}
  

output "node_ips" {
  value = "${aws_instance.nodes.*.public_ip}"
}

output "master_ip" {
  value = "${aws_instance.master.*.public_ip}"
}

