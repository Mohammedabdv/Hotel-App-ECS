# ─── ECS Cluster ──────────────────────────────────────────────
# Create an ECS Cluster to run and manage containers
resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights" # Enable advanced monitoring feature
    value = "enabled"
  }
}

# ─── CloudWatch Log Group ─────────────────────────────────────
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/my-app"
  retention_in_days = 7
}

# ─── ECS Task Definition ──────────────────────────────────────
# Blueprint that defines how the container should run on Fargate
resource "aws_ecs_task_definition" "app" {
  family                   = var.ecs_task_definition_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc" # Fargate requires awsvpc network mode
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  execution_role_arn = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([{
    name      = "my-app-container"
    image     = "${var.repository_url}:latest"
    essential = true


    environment = [
      { name = "APP_ENV", value = "production" },
      { name = "APP_URL", value = "http://${var.alb_dns_name}" },
      { name = "DB_CONNECTION", value = "mysql" },
      { name = "DB_HOST", value = var.rds_address },
      { name = "DB_PORT", value = "3306" },
      { name = "DB_DATABASE", value = "hotel_app" },
    ]

    secrets = [
      {
        name      = "APP_KEY"
        valueFrom = "${var.secret_arn}:APP_KEY::"
      },
      {
        name      = "DB_USERNAME"
        valueFrom = "${var.secret_arn}:DB_USERNAME::"
      },
      {
        name      = "DB_PASSWORD"
        valueFrom = "${var.secret_arn}:DB_PASSWORD::"
      }
    ]

    portMappings = [{ containerPort = 80, hostPort = 80, protocol = "tcp" }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
        awslogs-region        = "us-east-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}


# ─── ECS Service ──────────────────────────────────────────────
# Manages running Tasks inside the Cluster and keeps them running
resource "aws_ecs_service" "app_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ECS_SG_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "my-app-container"
    container_port   = 80
  }

}
