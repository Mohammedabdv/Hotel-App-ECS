variable "private_subnet_ids" {
  type = list(string)
}

variable "RDS_SG_id" {
  type = string
}

variable "identifier" {
  type    = string
  default = "hotel-app-db"
}

variable "engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "8.0"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}
