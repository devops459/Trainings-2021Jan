variable region {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable credentials {
    type        = string
	#TO DO - Update the following with your aws config file location
    default     = "<LOCATION OF CREDENTAILS FILE>"
}

variable key {
    type        = string
	#TO DO : Update your aws key name which can be used to connect with instances
    default = "<KEY NAME>"
}

variable ami {
    type = string
    default = "ami-0b2045146eb00b617"
}

variable master_instance_type {
    type = string
    default = "t2.medium"
}

variable node_instance_type {
    type = string
    default = "t2.micro"
}

variable sg {
    type = string
    default = "allowall"
}

variable user_data {
    type = string
    default = "install-k8s-binaries.sh"
}

variable number_of_nodes {
    default = "2"
}


