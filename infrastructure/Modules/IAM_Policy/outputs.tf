output "ecs_task_execution_role_arn" {
  description = "Used by ECS Task Definition to pull images, send logs & read secrets"
  value       = aws_iam_role.ecs_task_execution_role.arn
}
