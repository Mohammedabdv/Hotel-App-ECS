variable "ecs_task_execution_role_arn" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "rds_address" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ECS_SG_id" {
  type = string
}

variable "alb_target_group_arn" {
  type = string
}

variable "secret_arn" {
  type = string
}


variable "ecs_cluster_name" {
  type    = string
  default = "my-app-cluster"
}

variable "ecs_task_definition_name" {
  type    = string
  default = "my-app-task"
}

variable "task_cpu" {
  type    = string
  default = "256"
}

variable "task_memory" {
  type    = string
  default = "512"
}

variable "desired_count" {
  description = "Always keep the specified number of Tasks running"
  type        = number
  default     = 2
}

variable "ecs_service_name" {
  type    = string
  default = "my-app-service"
}



