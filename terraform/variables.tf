variable "region" {
    type = string
    default = "us-central1"
    description = ""
}

variable "zone" {
    type = string
    default = "us-central1-a"
    description = ""
}

variable "project" {
    type = map(string)
    description = "General settings"
    default = {
            name = "terraform-darknet-demo" 
            machine_type = "f1-micro"
    }
}

variable "project_instance" {
    type = string
    default = "darknet-instance"
    description = ""
}

variable "machine_type" {
    type = string
    default = "f1-micro"
    description = ""
}

variable "network_cidr" {
    default = "10.20.0.0/16"
    type = string
    description = ""
}

variable "network_name" {
    type = string
    default = "darknet-demo-network"
    description = ""
}

variable "network_subnet" {
    type = string
    default = "darknet-demo-subnet"
    description = ""
}



