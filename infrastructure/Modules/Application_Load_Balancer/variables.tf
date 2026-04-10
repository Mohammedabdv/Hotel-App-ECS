variable "vpc_id" {
  type = string
}

variable "target_type" {
  description = "Use ip for ECS tasks"
  type        = string
  default     = "ip"
}

variable "load_balancer_name" {
  type    = string
  default = "my-app-alb"
}
variable "load_balancer_type" {
  type    = string
  default = "application"
}

variable "alb_sg" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}
