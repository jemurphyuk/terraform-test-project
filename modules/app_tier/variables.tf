
variable "vpc_id" {
  description = "the vpc to launch resources to"
}

variable "name" {
  default = "james-murphy-eng53-nodejs-ami-master-initial"
  description = "instance name"
}

variable "sparta_name" {
  description = "starting name and group"
}

variable "ami_app" {
  default = "ami-0d6b9f7403b6f5fcc"
  description = "ami to run code on"
}

variable "user_data" {
  description = "user data to provide to the instance"
}
