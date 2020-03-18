variable "vpc_id" {
  default = "vpc-0f357d1ab1ae30af1"
}

variable "sparta_name" {
  default = "james-murphy-eng53"
}

variable "name" {
  default = "james-murphy-eng53-mongodb-ami-v2-mongo"
  description = "instance name for db"
}

variable "ami-db" {
  default = "ami-058bcc004919e51e6"
  description = "ami for database"
}
