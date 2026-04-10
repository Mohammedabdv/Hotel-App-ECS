variable "vpc_id" {
  type = string
}

variable "ALB_SG" {
  type    = string
  default = "alb-sg"
}

variable "ECS_SG" {
  type    = string
  default = "ecs-sg"
}

variable "RDS_SG" {
  type    = string
  default = "rds-sg"
}
