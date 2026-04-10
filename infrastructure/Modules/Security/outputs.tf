output "ALB_SG_id" {
  value = aws_security_group.ALB_SG.id
}

output "ECS_SG_id" {
  value = aws_security_group.ECS_SG.id
}

output "RDS_SG_id" {
  value = aws_security_group.RDS_SG.id
}
