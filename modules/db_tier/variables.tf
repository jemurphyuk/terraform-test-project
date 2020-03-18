variable "name" {
  default = "james-murphy-eng53-mongodb-ami-v2-mongo"
  description = "instance name for db"
}

variable "ami-db" {
  default = "ami-058bcc004919e51e6"
  description = "ami for database"
}


variable "vpc_id" {
  description = "the vpc to launch resources to"
}

variable "sparta_name" {
  description = "starting name and group"
}
